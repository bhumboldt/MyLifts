import 'package:flutter/material.dart';
import 'package:my_lifts/exercise_select_view.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/rep_counter_view.dart';

class HomeView extends StatefulWidget {
  final List<Exercise> exercises;

  const HomeView({this.exercises});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
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
            MaterialPageRoute(builder: (context) => ExerciseSelectView(widget.exercises)),
          );
        },
      ),
    );
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
              final exercise = widget.exercises[index];
              return ListTile(
                title: Text(exercise.name),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RepCounterView(exercise: exercise)));
                },
              );
            },
            itemCount: widget.exercises.length,
          ),
        )
      ],
    );
  }
}
