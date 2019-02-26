import 'package:flutter/material.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/models/exercise_set.dart';

class RepCounterView extends StatefulWidget {
  final Exercise exercise;

  const RepCounterView({this.exercise});

  @override
  RepCounterState createState() => RepCounterState();
}

class RepCounterState extends State<RepCounterView> {
  final _repsTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  final List<ExerciseSet> sets = List<ExerciseSet>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          _buildRepWeightForm(),
          _buildAddSetButton(),
          _buildSetList()
        ]),
      ),
    );
  }

  Widget _buildAddSetButton() {
    return Container(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          child: Text(
            'ADD SET',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            int reps = 0;
            int weight = 0;
            if (_repsTextController.text.isNotEmpty &&
                _repsTextController.text != null) {
              reps = int.tryParse(_repsTextController.text);
            }

            if (_weightTextController.text.isNotEmpty &&
                _weightTextController.text != null) {
              weight = int.tryParse(_weightTextController.text);
            }

            if (reps != 0 && weight != 0) {
              setState(() {
                sets.add(ExerciseSet(
                    exerciseId: widget.exercise.id,
                    reps: reps,
                    weight: weight));
                _repsTextController.text = '';
                _weightTextController.text = '';
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildRepWeightForm() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: _repsTextController,
              decoration: InputDecoration(labelText: 'Reps'),
              maxLength: 3,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextFormField(
              controller: _weightTextController,
              decoration: InputDecoration(labelText: 'Weight'),
              maxLength: 4,
              keyboardType: TextInputType.number,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetList() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Sets',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          Divider(),
          Container(
            height: 300.0,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final exerciseSet = sets[index];
                return ListTile(
                  title: Text(
                      'Set ${index + 1}: ${exerciseSet.reps} Reps @ ${exerciseSet.weight} lbs.'),
                );
              },
              itemCount: sets.length,
            ),
          )
        ],
      ),
    );
  }
}
