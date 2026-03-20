import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _entryService = EntryService();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    setState(() => _isLoading = true);
    final entry = Entry(
      id: Uuid().v4(),
      title: _titleController.text,
      desc: _contentController.text,
      date: DateTime.now().toString(),
    );
    await _entryService.createEntry(entry);
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Entry')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEntry,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
