import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  Database db;

  LocalDatabaseService();

  Future<void> init() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'mylifts.db');

    db = await openDatabase(path, version: 1, onCreate: (database, version) async {
      await database.execute('create table exercise(id int primary key, name text, exercise_group text)');
      await addInitialExercises(database);
    });
  }

  Future<List<Map<String, dynamic>>> getAllItems(String tableName) {
    return db.query(tableName);
  }

  Future<void> addInitialExercises(Database database) async {
    await database.execute('insert into exercise(id, name, exercise_group) values(0, \'Curls\', \'Arms\')');
    await database.execute('insert into exercise(id, name, exercise_group) values(1, \'Squat\', \'Legs\')');
    await database.execute('insert into exercise(id, name, exercise_group) values(2, \'Bench Press\', \'Chest\')');
    await database.execute('insert into exercise(id, name, exercise_group) values(3, \'Deadlift\', \'Legs\')');
  }
}