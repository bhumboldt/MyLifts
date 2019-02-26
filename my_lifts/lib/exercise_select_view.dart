import 'package:flutter/material.dart';
import 'package:my_lifts/create_days_view.dart';
import 'package:my_lifts/exercise.dart';

class ExerciseSelectView extends StatefulWidget {
  @override
  ExerciseSelectState createState() => ExerciseSelectState();
}

class ExerciseSelectState extends State<ExerciseSelectView> {
  final _exercises = <Exercise>[
    Exercise(exerciseGroup: 'Arms', name: 'Curls', id: 0),
    Exercise(exerciseGroup: 'Legs', name: 'Squats', id: 1),
    Exercise(exerciseGroup: 'Legs', name: 'Deadlift', id: 2),
    Exercise(exerciseGroup: 'Chest', name: 'Bench Press', id: 3)
  ];
  final _selectedExercises = Set<Exercise>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercises'),
      ),
      body:
        Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: _buildExerciseList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                child: Text('NEXT', style: TextStyle(color: Colors.white),),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateDaysView(exercises: _selectedExercises.toList(),)
                  ));
                },
              ),
            )
          ],
        )
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          final isSelected = _selectedExercises.contains(exercise);
          return ListTile(
            title: Text(_exercises[index].name),
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedExercises.remove(exercise);
                } else {
                  _selectedExercises.add(exercise);
                }
              });
            },
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
          );
        },
        itemCount: _exercises.length,
      );
  }
}
