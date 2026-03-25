import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/entry.dart';
import '../screens/add_entry_screen.dart';
import '../services/entry_service.dart';
import '../utils/date_formatter.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onRefresh;

  const HomeScreen({super.key, this.onRefresh});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isOnline = true;
  List<Entry> _entries = [];
  final EntryService _entryService = EntryService();
  late String _randomKaomoji;

  final List<String> _kaomojis = [
    '(╥﹏╥)',
    '.·°՞(っ-ᯅ-ς)՞°·.',
    '(っ╥﹏╥ς)',
    '(´•︵•`)',
    '(ᵕ—ᴗ—)',
    '(ᴗ_ ᴗ。)',
    ';(◞‸◟)',
  ];

  @override
  void initState() {
    super.initState();
    _randomKaomoji = (_kaomojis..shuffle()).first;
    _loadEntries();
  }

  void _loadEntries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entries = await _entryService.getEntries();
      setState(() {
        _isLoading = false;
        _entries = entries;
        _isOnline = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isOnline = false;
      });
    }
  }

  Future<void> _syncWithServer() async {
    await _entryService.syncWithServer();
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/image/pen.svg',
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isDarkMode ? Colors.white : Colors.black87,
            BlendMode.srcIn,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _syncWithServer,
            tooltip: 'Sincronizar',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _randomKaomoji,
                    style: TextStyle(fontSize: 40, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Você não escreveu nada ainda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Clique em + para adicionar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _syncWithServer();
              },
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          entry.emoji,
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    title: Text(entry.title),
                    subtitle: Text(DateFormatter.formatDate(entry.date)),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEntryScreen(
                            entry: entry,
                            onSaved: () {
                              _loadEntries();
                              widget.onRefresh?.call();
                            },
                          ),
                        ),
                      );
                      if (result == true) {
                        _loadEntries();
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}
