import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';

class AddEntryScreen extends StatefulWidget {
  final Entry? entry;
  
  const AddEntryScreen({super.key, this.entry});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _entryService = EntryService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.desc;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  Future<void> _saveEntry() async {
    setState(() => _isLoading = true);
    final entry = Entry(
      id: widget.entry?.id ?? Uuid().v4(),
      title: _titleController.text,
      desc: _contentController.text,
      date: widget.entry?.date ?? DateTime.now().toString(),
    );
    
    if (widget.entry != null) {
      await _entryService.updateEntry(entry);
    } else {
      await _entryService.createEntry(entry);
    }
    
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _deleteEntry() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir entrada'),
        content: Text('Tem certeza que deseja excluir esta entrada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && widget.entry != null) {
      setState(() => _isLoading = true);
      await _entryService.deleteEntry(widget.entry!.id);
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Entrada' : 'Nova Entrada'),
        actions: isEditing
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _isLoading ? null : _deleteEntry,
                ),
              ]
            : null,
      ),
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
