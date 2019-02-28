import 'package:flutter/material.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/home_view.dart';

class ExerciseSelectView extends StatefulWidget {
  final Set<Exercise> selectedExercises = Set<Exercise>();

  ExerciseSelectView([List<Exercise> selectedExercises]) {
    if (selectedExercises != null && selectedExercises.length > 0) {
      this.selectedExercises.addAll(selectedExercises);
    }
  }

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
  final Set<Exercise> _selectedExercises =Set<Exercise>();
  
  @override
  void initState() {
    super.initState();

    if (widget.selectedExercises.length > 0) {
      for (var selectedExercise in widget.selectedExercises) {
        for (var exercise in _exercises) {
          if (selectedExercise.id ==exercise.id && !_selectedExercises.contains(exercise)) {
            _selectedExercises.add(exercise);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Exercises'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildExerciseList(),
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: RaisedButton(
              child: const Text(
                'DONE',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeView(
                          exercises: _selectedExercises.toList(),
                        ),
                  ),
                  (route) {
                    return false;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return ListView(
      children: _exercises.map((exercise) {
        final isSelected = _selectedExercises.contains(exercise);
        return ListTile(
          title: Text(exercise.name),
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
              : Icon(Icons.add),
        );
      }).toList(),
    );
  }
}
