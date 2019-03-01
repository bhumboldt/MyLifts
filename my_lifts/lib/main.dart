import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:my_lifts/home_view.dart';
import 'package:my_lifts/services/exercise_service.dart';
import 'package:my_lifts/services/exercise_set_service.dart';
import 'package:my_lifts/services/local_database_service.dart';

void main() async {
  var localDatabaseService =LocalDatabaseService();
  await localDatabaseService.init();
  kiwi.Container().registerSingleton((c) => localDatabaseService);
  kiwi.Container().registerSingleton((c) => ExerciseService(c.resolve<LocalDatabaseService>()));
  kiwi.Container().registerSingleton((c) => ExerciseSetService(c.resolve<LocalDatabaseService>()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Lifts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
      ),
      home: HomeView()
    );
  }
}
