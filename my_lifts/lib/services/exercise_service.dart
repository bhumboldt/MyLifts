import 'dart:async';

import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/models/user_exercise.dart';
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

  Future<void> createUserExercises(Iterable<Exercise> userExercises) async {
    await localDatabaseService.deleteAll('userexercise');
    for (var userExercise in userExercises) {
      var usersExercise = UserExercise(userExercise.id);
      await localDatabaseService.insertItem(
          'userexercise', usersExercise.toMap());
    }
  }

  Future<List<Exercise>> getUsersExercises() async {
    List<Exercise> exercises = <Exercise>[];

    var userExercisePropertiesList = await localDatabaseService.getAllItems('userexercise');
    var userExercises = List.generate(userExercisePropertiesList.length, (index) {
      return UserExercise.fromMap(userExercisePropertiesList[index]);
    });

    for (var userExercise in userExercises) {
      var exerciseProperties = await localDatabaseService.getItemWithId('exercise', userExercise.exerciseId);
      exercises.add(Exercise.fromMap(exerciseProperties.first));
    }

    return exercises;
  }
}
