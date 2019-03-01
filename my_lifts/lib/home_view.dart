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
  List<Exercise> exercises;

  ExerciseService _exerciseService;

  HomeState() {
    _exerciseService = kiwi.Container().resolve<ExerciseService>();
    exercises = <Exercise>[];
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
            MaterialPageRoute(builder: (context) => ExerciseSelectView(exercises)),
          );
        },
      ),
    );
  }

  Future<void> _getUserSelectedExercises() async {
    var userExercises = await _exerciseService.getUsersExercises();
    setState(() {
     exercises =userExercises; 
    });
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
              final exercise = exercises[index];
              return ListTile(
                title: Text(exercise.name),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RepCounterView(exercise: exercise)));
                },
              );
            },
            itemCount: exercises.length,
          ),
        )
      ],
    );
  }
}
