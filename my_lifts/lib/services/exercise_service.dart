import 'dart:async';

import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/services/local_database_service.dart';

class ExerciseService {
  final LocalDatabaseService localDatabaseService;

  ExerciseService(this.localDatabaseService);

  Future<Iterable<Exercise>> getExercises() async {
    var exerciseStrings = await localDatabaseService.getAllItems('exercise');
    return List.generate(exerciseStrings.length, (index) {
      return Exercise.fromMap(exerciseStrings[index]);
    });
  }
}