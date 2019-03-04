import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_lifts/exercise_select_view.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/rep_counter_view.dart';
import 'package:my_lifts/services/exercise_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class HomeView extends StatefulWidget {
  const HomeView();

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
  Map<String, List<Exercise>> exercisesByGroup = Map<String, List<Exercise>>();

  ExerciseService _exerciseService;

  HomeState() {
    _exerciseService = kiwi.Container().resolve<ExerciseService>();
  }

  @override
  void initState() {
    super.initState();

    _getUserSelectedExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _buildExerciseList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ExerciseSelectView(_flattenExerciseMap())),
          );
        },
      ),
    );
  }

  Future<void> _getUserSelectedExercises() async {
    var userExercises = await _exerciseService.getUsersExercises();
    Map<String, List<Exercise>> exerciseGroups = Map<String, List<Exercise>>();

    for (var userExercise in userExercises) {
      if (!exerciseGroups.containsKey(userExercise.exerciseGroup)) {
        exerciseGroups[userExercise.exerciseGroup] = <Exercise>[userExercise];
      } else {
        exerciseGroups[userExercise.exerciseGroup].add(userExercise);
      }
    }

    setState(() {
      exercisesByGroup = exerciseGroups;
    });
  }

  List<Exercise> _flattenExerciseMap() {
    List<Exercise> userExercises = List<Exercise>();

    for (var userExerciseGroup in exercisesByGroup.keys) {
      userExercises.addAll(exercisesByGroup[userExerciseGroup]);
    }

    return userExercises;
  }

  Widget _buildExerciseList() {
    return Column(
      children: <Widget>[
        const Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              'Current Exercises',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              final exerciseGroup = exercisesByGroup.keys.elementAt(index);

              return ExpansionTile(
                title: Text(exerciseGroup),
                children: exercisesByGroup[exerciseGroup].map((exercise) {
                  return ListTile(
                    title: Text(exercise.name),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RepCounterView(exercise: exercise)));
                    },
                  );
                }).toList(),
              );
            },
            itemCount: exercisesByGroup.length,
          ),
        )
      ],
    );
  }
}
