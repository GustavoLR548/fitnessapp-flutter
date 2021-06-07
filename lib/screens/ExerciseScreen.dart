import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter/material.dart';

const walking = 2.0;
const running = 10.0;

class ExerciseScreen extends StatefulWidget {
  final String exerciseName;

  ExerciseScreen(this.exerciseName);
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool _isStart = true;
  String _stopwatchText = '00:00:00';
  final _stopWatch = Stopwatch();
  final _timeout = const Duration(seconds: 1);
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<double> _accelerometerValues = [];
  List<double> _userAccelerometerValues = [];
  double previousMagnitude = 0.0;
  double magnitudeDelta = 0.0;
  int stepsTaken = 0;

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    _stopWatch.stop();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  void _startTimeout() => Timer(_timeout, _handleTimeout);

  void _handleTimeout() {
    if (_stopWatch.isRunning) _startTimeout();

    setState(() => _setStopwatchText());
  }

  void _endExercise() {
    Navigator.of(context).pop({
      'stepstaken': stepsTaken,
      'totalTime': _stopwatchText,
      'name': widget.exerciseName
    });
  }

  void _startStopButtonPressed() {
    setState(() {
      if (_stopWatch.isRunning) {
        _isStart = true;
        _stopWatch.stop();
      } else {
        _isStart = false;
        _stopWatch.start();
        _startTimeout();
      }
    });
  }

  double abs(double value) => value < 0 ? -value : value;

  void _setStopwatchText() {
    _stopwatchText = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
        ':' +
        (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
  }

  String _stepsTaken() {
    if (!_stopWatch.isRunning) return this.stepsTaken.toString();
    final List<String> accelerometer =
        _accelerometerValues.map((double v) => v.toStringAsFixed(1)).toList();

    final userAccelerometer = _userAccelerometerValues
        .map((double v) => v.toStringAsFixed(1))
        .toList();

    if (accelerometer.length < 3 || userAccelerometer.length < 3)
      return this.stepsTaken.toString();

    double x = double.parse(userAccelerometer[0]);
    double y = double.parse(userAccelerometer[1]);
    double z = double.parse(userAccelerometer[2]);

    double currMagnitude = abs(sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)));

    this.magnitudeDelta = currMagnitude - previousMagnitude;

    previousMagnitude = currMagnitude;

    if (this.magnitudeDelta > walking) stepsTaken++;

    return this.stepsTaken.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final List<String> accelerometer = _userAccelerometerValues
        .map((double v) => v.toStringAsFixed(1))
        .toList();
    return Column(
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              _stopwatchText,
              style: const TextStyle(fontSize: 72),
            ),
          ),
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.none,
            child: Text(
              _stepsTaken(),
              style: const TextStyle(fontSize: 72),
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Text('Accelerometer: ' + magnitudeDelta.toString()),
              Text('Accelerometer: ' + accelerometer.toString()),
              ElevatedButton.icon(
                icon: Icon(_isStart ? Icons.play_arrow : Icons.stop),
                label: Text(_isStart ? 'Começar' : 'Parar'),
                onPressed: _startStopButtonPressed,
              ),
              ElevatedButton(
                child: const Text('Finalizar'),
                onPressed: _endExercise,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
