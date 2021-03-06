import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_lifts/models/exercise.dart';
import 'package:my_lifts/models/exercise_set.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_lifts/services/exercise_set_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class RepCounterView extends StatefulWidget {
  final Exercise exercise;

  const RepCounterView({this.exercise});

  @override
  RepCounterState createState() => RepCounterState();
}

class RepCounterState extends State<RepCounterView> {
  final _repsTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  final _weightFocusNode = FocusNode();
  final _repsFocusNode = FocusNode();
  
  List<ExerciseSet> _sets = List<ExerciseSet>();
  List<ChartSet> _chartData = List<ChartSet>();
  Map<String, List<ExerciseSet>> _allSets = Map<String, List<ExerciseSet>>();

  ExerciseSetService _exerciseSetService;

  RepCounterState() {
    _exerciseSetService = kiwi.Container().resolve<ExerciseSetService>();
  }

  @override
  void initState() {
    super.initState();

    _retrieveExerciseSets();
    _retrieveChartData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('History'),
              )
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
                  _buildSetList()
                ],
              ),
            ),
            _buildChart(),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Future<void> _retrieveExerciseSets() async {
    var completedSets = await _exerciseSetService.getExerciseSetsForExerciseOnDate(widget.exercise.id, DateFormat.yMd().format(DateTime.now()));
    setState(() {
     _sets =completedSets;
    });
  }

  Future<void> _retrieveChartData() async {
    var allCompletedSets =await _exerciseSetService.getExerciseSetsForExerciseId(widget.exercise.id);
    Map<String, int> weightMap = Map<String, int>();
    List<ChartSet> chartData = List<ChartSet>();
    Map<String, List<ExerciseSet>> exercisesByDate = Map<String, List<ExerciseSet>>();

    for (var completedSet in allCompletedSets) {
      if (!weightMap.containsKey(completedSet.dateCompleted)) {
        weightMap[completedSet.dateCompleted] =completedSet.weight;
      } else if (weightMap[completedSet.dateCompleted] < completedSet.weight) {
        weightMap[completedSet.dateCompleted] =completedSet.weight;
      }

      if (!exercisesByDate.containsKey(completedSet.dateCompleted)) {
        exercisesByDate[completedSet.dateCompleted] = <ExerciseSet>[ completedSet ];
      } else {
        exercisesByDate[completedSet.dateCompleted].add(completedSet);
      }
    }

    for (var key in weightMap.keys) {
      chartData.add(ChartSet(date: DateFormat().add_yMd().parse(key), maxWeight:weightMap[key]));
    }

    setState(() {
     _chartData =chartData;
     _allSets =exercisesByDate;
    });
  }

  Widget _buildChart() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: charts.TimeSeriesChart(
          _createData(),
          animate: true,
          defaultInteractions: true,
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var date =_allSets.keys.elementAt(index);
        return ExpansionTile(
          title: Text(date),
          children: _allSets[date].map((exerciseSet) {
            return ListTile(
              title: Text('${exerciseSet.reps} reps @ ${exerciseSet.weight} lbs.'),
            );
          }).toList(),
        );
      },
      itemCount: _allSets.keys.length,
    );
  }

  List<charts.Series<ChartSet, DateTime>> _createData() {
    return [
      charts.Series<ChartSet, DateTime>(
          data: _chartData,
          id: 'Max Weight',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (chartSet, _) => chartSet.date,
          measureFn: (chartSet, _) => chartSet.maxWeight)
    ];
  }

  Widget _buildAddSetButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, right: 8.0),
      child: IconButton(
        color: Theme.of(context).accentColor,
        icon: Icon(Icons.add),
        onPressed: () => _submitSet(),
      ),
    );
  }

  Future<void> _submitSet() async {
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
      var datetimeNow =DateTime.now();
      var dateString = DateFormat.yMd().format(datetimeNow);
      var timeString =DateFormat.Hm().format(datetimeNow);
      var exerciseSet =ExerciseSet(exerciseId: widget.exercise.id, reps: reps, weight: weight, timestamp: timeString, dateCompleted: dateString);
      var exerciseSetId = await _exerciseSetService.createExerciseSet(exerciseSet);
      exerciseSet.id =exerciseSetId;

      setState(() {
        _sets.add(exerciseSet);
        _repsTextController.text = '';
        _weightTextController.text = '';
      });
    }
  }

  Widget _buildRepWeightForm() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0),
            child: TextField(
              controller: _repsTextController,
              decoration: InputDecoration(labelText: 'Reps', border: OutlineInputBorder()),
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
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 12.0),
            child: TextField(
              controller: _weightTextController,
              decoration: InputDecoration(labelText: 'Weight', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              focusNode: _weightFocusNode,
              onSubmitted: (text) {
                _submitSet();
              },
            ),
          ),
        ),
        _buildAddSetButton()
      ],
    );
  }

  Widget _buildSetList() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: <Widget>[
          const Center(
            child: Text(
              'Sets Done Today',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          const Divider(),
          Container(
            height: 300.0,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final exerciseSet = _sets[index];
                return ListTile(
                  title: Text('Set ${index + 1}: ${exerciseSet.reps} Reps @ ${exerciseSet.weight} lbs.'),
                );
              },
              itemCount: _sets.length,
            ),
          )
        ],
      ),
    );
  }
}

class ChartSet {
  final DateTime date;
  final int maxWeight;

  const ChartSet({this.date, this.maxWeight});
}
