import 'package:fitnessapp/helpers/sql.dart';
import 'package:fitnessapp/models/exercise.dart';
import 'package:flutter/cupertino.dart';

class Exercises with ChangeNotifier {
  List<Exercise> _items = [];
  static const tableName = 'user_exercises';

  List<Exercise> get items => [...this._items];

  int get size => _items.length;

  Exercise findById(int id) =>
      this._items.firstWhere((element) => element.id == id);

  Future<void> fetchData() async {
    final datalist = await SQLDatabase.read(tableName);

    if (datalist.length == 0) return;

    _items = datalist.map((item) => Exercise.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> add(Map<String, dynamic>? data) async {
    if (data == null) return;

    int id = await SQLDatabase.insert(tableName, data);

    data['id'] = id;

    _items.add(Exercise.fromMap(data));

    notifyListeners();
  }

  Future<void> update(Map<String, dynamic>? data, int? id) async {
    if (data == null || id == null) return;

    data['id'] = id;

    final contaToUpdate = _items.indexWhere((element) => element.id == id);

    _items[contaToUpdate] = Exercise.fromMap(data);

    await SQLDatabase.update(tableName, data);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    var exercise = _items.firstWhere((element) => element.id == id);

    _items.remove(exercise);
    await SQLDatabase.delete(tableName, id.toString());
    notifyListeners();
  }
}
