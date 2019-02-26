import 'package:flutter/material.dart';
import 'package:my_lifts/exercise.dart';

class CreateDaysView extends StatefulWidget {
  final List<Exercise> exercises;

  CreateDaysView({ this.exercises });

  @override
  CreateDaysState createState() => CreateDaysState();
}

class CreateDaysState extends State<CreateDaysView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Days'),
      ),
      body: Column(
        children: <Widget>[

          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: _buildExerciseList(),
          )
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.exercises[index].name),
        );
      },
      itemCount: widget.exercises.length,
    );
  }
}