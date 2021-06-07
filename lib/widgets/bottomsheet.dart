import 'package:flutter/material.dart';

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';

  @override
  Widget build(BuildContext context) {
    void _save() {
      if (!(_formKey.currentState?.validate() ?? true)) return;

      _formKey.currentState?.save();

      Navigator.of(context).pop(name);
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: name,
            maxLength: 25,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Digite o nome'),
            onSaved: (value) {
              if (value == null) return;
              name = value;
            },
            validator: (value) {
              if (value == null) return 'valor não pode ser nulo';

              if (value.isEmpty) {
                return 'O valor da conta não pode ser vazio';
              }

              return null;
            },
          ),
          _buildSizedBox(),
          ElevatedButton.icon(
            onPressed: _save,
            label: Text('Adicionar exercício'),
            icon: const Icon(Icons.add),
          ),
          _buildSizedBox(),
        ],
      ),
    );
  }

  Widget _buildSizedBox() {
    return const SizedBox(
      height: 20,
    );
  }
}
