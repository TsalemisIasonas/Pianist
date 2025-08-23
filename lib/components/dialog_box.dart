import 'package:flutter/material.dart';

/// Dialog that collects multiple entries and returns them to the caller.
class DialogBox extends StatefulWidget {
  final String practiseVal;

  const DialogBox({super.key, required this.practiseVal});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final List<String> _newEntries = [];
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFromController() {
    final v = _controller.text.trim();
    if (v.isNotEmpty) {
      setState(() => _newEntries.add(v));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add ${widget.practiseVal}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter ${widget.practiseVal} (press Add to append)',
            ),
            onSubmitted: (_) => _addFromController(),
          ),
          const SizedBox(height: 8),
          if (_newEntries.isNotEmpty)
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _newEntries
                    .map((e) => Chip(
                          label: Text(e),
                          onDeleted: () => setState(() => _newEntries.remove(e)),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _addFromController,
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop<List<String>?>(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop<List<String>>(_newEntries.isEmpty ? null : List.from(_newEntries)),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
