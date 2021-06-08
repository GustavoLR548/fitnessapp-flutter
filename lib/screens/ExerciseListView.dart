import 'package:fitnessapp/providers/exercices.dart';
import 'package:fitnessapp/screens/ExerciseDetails.dart';
import 'package:fitnessapp/screens/ExerciseScreen.dart';
import 'package:fitnessapp/widgets/bottomsheet.dart';
import 'package:fitnessapp/widgets/resultDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesListView extends StatelessWidget {
  Future<void> _newExercise(context) async {
    String? name = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Wrap(children: [
        Padding(
            padding: MediaQuery.of(context).viewInsets, child: MyBottomSheet())
      ]),
    );

    if (name == null) return;

    DateTime creationDate = DateTime.now();

    Map<String, dynamic>? newExercise = await Navigator.of(context).push(
        MaterialPageRoute<Map<String, dynamic>>(
            builder: (context) => ExerciseScreen(name)));

    if (newExercise == null) return;

    newExercise['date'] = creationDate.toIso8601String();

    int? add = await showDialog(
      context: context,
      builder: (context) => ResultDialog(newExercise),
    );

    if (add == null) return;

    await Provider.of<Exercises>(context, listen: false).add(newExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Pedômetro'),
      ),
      body: _buildBody(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _newExercise(context),
        tooltip: 'Novo exercício',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final allExercises = Provider.of<Exercises>(context, listen: false);
    return FutureBuilder(
      future: allExercises.fetchData(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? _noExercises()
              : _showExercises(context),
    );
  }

  Widget _noExercises() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const Text('Carregando...')
      ],
    );
  }

  Widget _showExercises(BuildContext context) {
    return Consumer<Exercises>(
        builder: (context, exercises, _) => exercises.size == 0
            ? const Center(child: const Text('Nenhum exercício registrado'))
            : ListView.builder(
                itemCount: exercises.size,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) => Card(
                  elevation: 6,
                  child: ListTile(
                    onTap: () => Navigator.of(context).pushNamed(
                        ExerciseDetails.routeName,
                        arguments: exercises.items[index].id),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async =>
                          await Provider.of<Exercises>(context, listen: false)
                              .delete(exercises.items[index].id),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: FittedBox(
                        child: Text(
                          exercises.items[index].dateDay,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Text(exercises.items[index].name),
                  ),
                ),
              ));
  }
}
