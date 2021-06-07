import 'package:fitnessapp/providers/exercices.dart';
import 'package:fitnessapp/screens/ExerciseDetails.dart';
import 'package:fitnessapp/screens/ExerciseListView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Exercises(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: ExercisesListView(),
        routes: {ExerciseDetails.routeName: (ctx) => ExerciseDetails()},
      ),
    );
  }
}
