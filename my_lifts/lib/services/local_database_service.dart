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
      await database.execute('create table userexercise(id integer primary key autoincrement, exercise_id int, foreign key(exercise_id) references exercise(id))');
      await database.execute('create table exerciseset(id integer primary key autoincrement, exercise_id int, reps int, weight int, timestamp text, date_completed text, foreign key(exercise_id) references exercise(id))');
      await addInitialExercises(database);
    });
  }

  Future<List<Map<String, dynamic>>> getItemsWithQuery(String query, [List<dynamic> arguments]) {
    return db.rawQuery(query, arguments);
  }

  Future<List<Map<String, dynamic>>> getAllItems(String tableName) {
    return db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getItemWithId(String tableName, int id) {
    return db.rawQuery('select * from $tableName where id = ?', [id]);
  }

  Future<int> insertItem(String tableName, Map<String, dynamic> properties) {
    return db.insert(tableName, properties);
  }

  Future<void> deleteAll(String tableName) {
    return db.delete(tableName);
  }

  Future<void> addInitialExercises(Database database) async {
    var localExercises =_getLocalExercises();
    for (var localExercise in localExercises) {
      await database.execute('insert into exercise(id, name, exercise_group) values(?, ?, ?)', [localExercise.id, localExercise.name, localExercise.exerciseGroup]);
    }
  }

  List<LocalExercise> _getLocalExercises() {
    return <LocalExercise>[
      LocalExercise(0, 'Barbell Curls', 'Arms'), 
      LocalExercise(1, 'Squat', 'Legs'),
      LocalExercise(2, 'Bench Press', 'Chest'),
      LocalExercise(3, 'Deadlift', 'Legs'),
      LocalExercise(4, 'Leg Press', 'Legs'),
      LocalExercise(5, 'Seated Leg Curl', 'Legs'),
      LocalExercise(6, 'Leg Extensions', 'Legs'),
      LocalExercise(7, 'Standing Calf Raises', 'Legs'),
      LocalExercise(8, 'Incline Dumbbell Press', 'Chest'),
      LocalExercise(9, 'Decline Dumbbell Bench Press', 'Chest'),
      LocalExercise(10, 'Dumbbell Flyes', 'Chest'),
      LocalExercise(11, 'Cable Crossover', 'Chest'),
      LocalExercise(12, 'Bent-Arm Barbell Pullover', 'Chest'),
      LocalExercise(13, 'Crunches', 'Abs'),
      LocalExercise(14, 'Flutter Kicks', 'Abs'),
      LocalExercise(15, 'Planks', 'Abs'),
      LocalExercise(16, 'Pullups', 'Back'),
      LocalExercise(17, 'Reverse Grip Bent-Over Rows', 'Back'),
      LocalExercise(18, 'Bent-Over Rows', 'Back'),
      LocalExercise(19, 'One-Arm Dumbbell Rows', 'Back'),
      LocalExercise(20, 'Wide-Grip Lat Pulldown', 'Back'),
      LocalExercise(21, 'Dumbbell Shrug', 'Back'),
      LocalExercise(22, 'Dumbbell Shoulder Press', 'Shoulders'),
      LocalExercise(23, 'Arnold Dumbbell Press', 'Shoulders'),
      LocalExercise(24, 'Side Lateral Raise', 'Shoulders'),
      LocalExercise(25, 'Front Dumbbell Raise', 'Shoulders'),
      LocalExercise(26, 'Upright Barbell Row', 'Shoulders'),
      LocalExercise(27, 'Barbell Lunge', 'Legs'),
      LocalExercise(28, 'Romanian Lunge', 'Legs'),
      LocalExercise(29, 'Close-Grip Bench Press', 'Arms'),
      LocalExercise(30, 'Tricep Pushdown', 'Arms'),
      LocalExercise(31, 'Lying Tricep Press', 'Arms'),
      LocalExercise(32, 'V-Bar Pulldown', 'Arms'),
      LocalExercise(33, 'Dumbbell Alternate Bicep Curl', 'Arms'),
      LocalExercise(34, 'Preacher Curl', 'Arms'),
      LocalExercise(35, 'Reverse Barbell Curl', 'Arms'),
      LocalExercise(36, 'Dips', 'Arms'),
      LocalExercise(37, 'Hammer Curls', 'Arms'),
      LocalExercise(38, 'Overhead Military Press', 'Shoulders'),
      LocalExercise(39, 'Cable Curls', 'Arms'),
      LocalExercise(40, 'Butterfly', 'Chest'),
    ];
  }
}

class LocalExercise {
  int id;
  String name;
  String exerciseGroup;

  LocalExercise(this.id, this.name, this.exerciseGroup);
}