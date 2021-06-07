import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

class Exercise with ChangeNotifier {
  final String _name;
  final String _date;
  int _id;
  String _totalTime;
  int _stepstaken;

  Exercise(this._name, this._id,
      [this._totalTime = '', this._stepstaken = 0, this._date = '']);

  Map<String, dynamic> get toMap => {
        'name': this._name,
        'totalTime': this._totalTime,
        'stepstaken': this._stepstaken,
      };

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
      map['name'], map['id'], map['totalTime'], map['stepstaken'], map['date']);

  // Getters

  int get id => this._id;
  String get name => this._name;
  String get totalTime => this._totalTime;
  String get date =>
      DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.parse(_date)).toString();
  String get dateDay =>
      DateFormat('dd/MM').format(DateTime.parse(_date)).toString();
  int get stepstaken => this._stepstaken;

  // Setters

  set id(int id) => this._id = id;
  set totalTime(String time) => this._totalTime = time;
  set stepstaken(int stepsTaken) => this._stepstaken = stepsTaken;
}
