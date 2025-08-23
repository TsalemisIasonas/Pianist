import 'package:flutter/material.dart';

class EditDeleteDialogBox extends StatelessWidget {
  final TextEditingController editController;
  const EditDeleteDialogBox({super.key, required this.editController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit or Delete'),
      content: TextField(
        controller: editController,
        decoration: const InputDecoration(hintText: 'Edit chord name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop('delete'),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(editController.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
