
import 'dart:async';

import 'package:my_lifts/models/exercise_set.dart';
import 'package:my_lifts/services/local_database_service.dart';

class ExerciseSetService {
  LocalDatabaseService _localDatabaseService;

  ExerciseSetService(this._localDatabaseService);

  Future<List<ExerciseSet>> getExerciseSetsForExerciseId(int exerciseId) async {
    var exerciseSetProperties = await _localDatabaseService.getItemsWithQuery('select * from exerciseset where exercise_id = ?', [exerciseId]);
    return List.generate(exerciseSetProperties.length, (index) {
      return ExerciseSet.fromMap(exerciseSetProperties[index]);
    });
  }

  Future<List<ExerciseSet>> getExerciseSetsForExerciseOnDate(int exerciseId, String date) async {
    var exerciseSetProperties = await _localDatabaseService.getItemsWithQuery('select * from exerciseset where exercise_id = ? and date_completed = ?', [exerciseId, date]);
    return List.generate(exerciseSetProperties.length, (index) {
      return ExerciseSet.fromMap(exerciseSetProperties[index]);
    });
  }

  Future<int> createExerciseSet(ExerciseSet exerciseSet) {
    return _localDatabaseService.insertItem('exerciseset', exerciseSet.toMap());
  }
}