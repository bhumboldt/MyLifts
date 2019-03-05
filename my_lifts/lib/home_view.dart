import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_lifts/exercise_select_view.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/models/exercise_set.dart';
import 'package:my_lifts/rep_counter_view.dart';
import 'package:my_lifts/services/exercise_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:my_lifts/services/exercise_set_service.dart';

class HomeView extends StatefulWidget {
  const HomeView();

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
  Map<String, List<Exercise>> exercisesByGroup = Map<String, List<Exercise>>();
  Map<String, Map<String, List<ExerciseSet>>> exercisesByDate =
      Map<String, Map<String, List<ExerciseSet>>>();

  ExerciseService _exerciseService;
  ExerciseSetService _exerciseSetService;

  HomeState() {
    _exerciseService = kiwi.Container().resolve<ExerciseService>();
    _exerciseSetService = kiwi.Container().resolve<ExerciseSetService>();
  }

  @override
  void initState() {
    super.initState();

    _getUserSelectedExercises();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('My Exercises',),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('History'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[_buildExerciseList(), _buildHistoryList()],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ExerciseSelectView(_flattenExerciseMap())),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getUserSelectedExercises() async {
    var userExercises = await _exerciseService.getUsersExercises();
    var userSets = await _exerciseSetService.getAllExerciseSets();
    Map<String, List<Exercise>> exerciseGroups = Map<String, List<Exercise>>();
    Map<String, Map<String, List<ExerciseSet>>> exerciseDates =
        Map<String, Map<String, List<ExerciseSet>>>();

    for (var userExercise in userExercises) {
      if (!exerciseGroups.containsKey(userExercise.exerciseGroup)) {
        exerciseGroups[userExercise.exerciseGroup] = <Exercise>[userExercise];
      } else {
        exerciseGroups[userExercise.exerciseGroup].add(userExercise);
      }
    }

    for (var userSet in userSets) {
      var actExercise = userExercises.firstWhere((exercise) {
        return exercise.id == userSet.exerciseId;
      });
      if (!exerciseDates.containsKey(userSet.dateCompleted)) {
        exerciseDates[userSet.dateCompleted] = <String, List<ExerciseSet>>{
          actExercise.name: <ExerciseSet>[userSet]
        };
      } else if (!exerciseDates[userSet.dateCompleted]
          .containsKey(actExercise.name)) {
        exerciseDates[userSet.dateCompleted]
            [actExercise.name] = <ExerciseSet>[userSet];
      } else {
        exerciseDates[userSet.dateCompleted][actExercise.name].add(userSet);
      }
    }

    setState(() {
      exercisesByGroup = exerciseGroups;
      exercisesByDate = exerciseDates;
    });
  }

  List<Exercise> _flattenExerciseMap() {
    List<Exercise> userExercises = List<Exercise>();

    for (var userExerciseGroup in exercisesByGroup.keys) {
      userExercises.addAll(exercisesByGroup[userExerciseGroup]);
    }

    return userExercises;
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: exercisesByDate.length,
      itemBuilder: (context, index) {
        var date = exercisesByDate.keys.elementAt(index);
        return ExpansionTile(
          title: Text(date),
          children: exercisesByDate[date].keys.map((exerciseName) {
            var exerciseSets = exercisesByDate[date][exerciseName];
            return Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: ExpansionTile(
                title: Text(exerciseName),
                children: exerciseSets.map((exerciseSet) {
                  return ListTile(
                    title: Text(
                        '${exerciseSet.reps} reps @ ${exerciseSet.weight} lbs.'),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final exerciseGroup = exercisesByGroup.keys.elementAt(index);

        return ExpansionTile(
          title: Text(exerciseGroup),
          children: exercisesByGroup[exerciseGroup].map((exercise) {
            return ListTile(
              title: Text(exercise.name),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RepCounterView(exercise: exercise)));
              },
            );
          }).toList(),
        );
      },
      itemCount: exercisesByGroup.length,
    );
  }
}
