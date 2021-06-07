import 'package:fitnessapp/providers/exercices.dart';
import 'package:fitnessapp/widgets/icontext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseDetails extends StatelessWidget {
  static const routeName = '/exercise-details';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;

    final exercise =
        Provider.of<Exercises>(context, listen: false).findById(id);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informações do exercício'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    exercise.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                IconText(exercise.date, Icons.calendar_today),
                const SizedBox(
                  height: 15,
                ),
                IconText(exercise.stepstaken.toString() + ' passos dados',
                    Icons.directions_walk),
                const SizedBox(
                  height: 15,
                ),
                IconText('Tempo total: ' + exercise.totalTime, Icons.lock_clock)
              ],
            ),
          ),
        ));
  }
}
