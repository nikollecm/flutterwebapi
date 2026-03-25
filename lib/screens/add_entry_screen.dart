import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';
import '../models/entry.dart';
import '../services/entry_service.dart';

class AddEntryScreen extends StatefulWidget {
  final Entry? entry;
  final VoidCallback? onSaved;

  const AddEntryScreen({super.key, this.entry, this.onSaved});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _entryService = EntryService();
  bool _isLoading = false;
  String _selectedEmoji = '😺';

  final List<String> _emojis = [
    '😺',
    '😹',
    '😸',
    '😻',
    '😼',
    '😽',
    '🙀',
    '😿',
    '😾',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.desc;
      _selectedEmoji = widget.entry!.emoji;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Por favor, adicione um título')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final entry = Entry(
        id: widget.entry?.id ?? Uuid().v4(),
        title: _titleController.text,
        desc: _contentController.text,
        date: widget.entry?.date ?? DateTime.now().toString(),
        emoji: _selectedEmoji,
      );

      if (widget.entry != null) {
        await _entryService.updateEntry(entry);
      } else {
        await _entryService.createEntry(entry);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        _titleController.clear();
        _contentController.clear();
        _selectedEmoji = '😺';

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Entrada salva com sucesso!')));

        widget.onSaved?.call();

        if (widget.entry != null) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
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

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Escolha um emoji'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _emojis.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedEmoji = _emojis[index];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedEmoji == _emojis[index]
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(_emojis[index], style: TextStyle(fontSize: 32)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/image/pen.svg',
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
        ),
        actions: isEditing
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _isLoading ? null : _deleteEntry,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: _showEmojiPicker,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _selectedEmoji,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Toque para escolher um emoji',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                minLines: 10,
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveEntry,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Salvar', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }
}
