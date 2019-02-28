import 'package:flutter/material.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/models/exercise_set.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RepCounterView extends StatefulWidget {
  final Exercise exercise;

  const RepCounterView({this.exercise});

  @override
  RepCounterState createState() => RepCounterState();
}

class RepCounterState extends State<RepCounterView> {
  final _repsTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  final _weightFocusNode =FocusNode();
  final _repsFocusNode =FocusNode();
  final List<ExerciseSet> sets = List<ExerciseSet>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name),
          bottom: TabBar(
            tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Lift'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Chart'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _buildRepWeightForm(),
                  _buildAddSetButton(),
                  _buildSetList()
                ],
              ),
            ),
            _buildChart()
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      width: 250,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: charts.TimeSeriesChart(
          _createData(),
          animate: true,
          defaultInteractions: true,
        ),
      ),
    );
  }

  List<charts.Series<ChartSet, DateTime>> _createData() {
    final data = [
      ChartSet(maxWeight: 100, time: DateTime(2019, 2, 26)),
      ChartSet(maxWeight: 120, time: DateTime(2019, 2, 27)),
      ChartSet(maxWeight: 135, time: DateTime(2019, 3, 3)),
      ChartSet(maxWeight: 110, time: DateTime(2019, 3, 9)),
      ChartSet(maxWeight: 100, time: DateTime(2019, 4, 10)),
      ChartSet(maxWeight: 100, time: DateTime(2019, 4, 17))
    ];

    return [
      charts.Series<ChartSet, DateTime>(
          data: data,
          id: 'Max Weight',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (chartSet, _) => chartSet.time,
          measureFn: (chartSet, _) => chartSet.maxWeight)
    ];
  }

  Widget _buildAddSetButton() {
    return Padding(
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
      );
  }

  Widget _buildRepWeightForm() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: _repsTextController,
              decoration: InputDecoration(hintText: 'Reps'),
              maxLength: 3,
              keyboardType: TextInputType.number,
              focusNode: _repsFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (text) {
                _repsFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_weightFocusNode);
              },
            ),
          ),
        ),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('@'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextField(
              controller: _weightTextController,
              decoration: InputDecoration(hintText: 'Weight'),
              maxLength: 4,
              keyboardType: TextInputType.number,
              focusNode: _weightFocusNode,
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
          const Center(
            child: Text(
              'Sets',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          const Divider(),
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

class ChartSet {
  final DateTime time;
  final int maxWeight;

  const ChartSet({this.time, this.maxWeight});
}
