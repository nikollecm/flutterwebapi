import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/entry.dart';
import '../screens/add_entry_screen.dart';
import '../services/entry_service.dart';
import '../utils/date_formatter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<Entry> _entries = [];
  final EntryService _entryService = EntryService();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    setState(() {
      _isLoading = true;
    });
    final entries = await _entryService.getEntries();
    setState(() {
      _isLoading = false;
      _entries = entries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Daily Diary',
              style: GoogleFonts.poppins(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    title: Text(entry.title),
                    subtitle: Text(DateFormatter.formatDate(entry.date)),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEntryScreen(entry: entry),
                        ),
                      );
                      if (result == true) {
                        _loadEntries();
                      }
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/add-entry');
            _loadEntries();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
