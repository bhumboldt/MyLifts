
import 'package:flutter/material.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/rep_counter_view.dart';

class HomeView extends StatefulWidget {
  final List<Exercise> exercises;
  
  const HomeView({ this.exercises });

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
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final exercise =widget.exercises[index];
        return ListTile(
          title: Text(exercise.name),
          onTap: () {
            print('Hey there!');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RepCounterView(exercise: exercise)
            ));
          },
        );
      },
      itemCount: widget.exercises.length,
    );
  }
}