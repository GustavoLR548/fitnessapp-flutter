import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final Map<String, dynamic> exercise;

  ResultDialog(this.exercise);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(
          children: [
            Center(
                child: const Text(
              'Confira os dados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [const Text('Nome:'), Text(exercise['name'])],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Passos dados:'),
                Text(exercise['stepstaken'].toString())
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Tempo total:'),
                Text(exercise['totalTime'].toString())
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(1),
                  child: const Text('Confirmar')),
            )
          ],
        ),
      ),
    );
  }
}
