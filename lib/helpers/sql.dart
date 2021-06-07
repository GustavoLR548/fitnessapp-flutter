import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class SQLDatabase {
  static Future<Database> get database async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'exercises.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE user_exercises(' +
          'id INTEGER PRIMARY KEY,' +
          'name TEXT,' +
          'totalTime TEXT,' +
          'date TEXT,' +
          'stepstaken INTEGER)');
    }, version: 1);
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final sqlDb = await SQLDatabase.database;
    return await sqlDb.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  static Future<void> update(String table, Map<String, dynamic> data) async {
    final sqlDb = await SQLDatabase.database;
    await sqlDb.update(table, data);
  }

  static Future<List<Map<String, dynamic>>> read(String table) async {
    final sqlDb = await SQLDatabase.database;
    return sqlDb.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final sqlDb = await SQLDatabase.database;
    sqlDb.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
