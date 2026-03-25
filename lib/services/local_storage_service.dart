import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entry.dart';

class LocalStorageService {
  static const String _entriesKey = 'cached_entries';
  static SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveEntries(List<Entry> entries) async {
    try {
      final prefs = await _getPrefs();
      final jsonList = entries.map((e) => e.toJson()).toList();
      await prefs.setString(_entriesKey, jsonEncode(jsonList));
    } catch (e) {
      print('Erro ao salvar entradas: $e');
    }
  }

  Future<List<Entry>> getEntries() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_entriesKey);
      
      if (jsonString == null) {
        return [];
      }
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => Entry.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar entradas: $e');
      return [];
    }
  }

  Future<void> addEntry(Entry entry) async {
    try {
      final entries = await getEntries();
      entries.add(entry);
      await saveEntries(entries);
    } catch (e) {
      print('Erro ao adicionar entrada: $e');
      rethrow;
    }
  }

  Future<void> updateEntry(Entry updatedEntry) async {
    try {
      final entries = await getEntries();
      final index = entries.indexWhere((e) => e.id == updatedEntry.id);
      
      if (index != -1) {
        entries[index] = updatedEntry;
        await saveEntries(entries);
      }
    } catch (e) {
      print('Erro ao atualizar entrada: $e');
      rethrow;
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      final entries = await getEntries();
      entries.removeWhere((e) => e.id == id);
      await saveEntries(entries);
    } catch (e) {
      print('Erro ao deletar entrada: $e');
      rethrow;
    }
  }

  Future<void> clearCache() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_entriesKey);
    } catch (e) {
      print('Erro ao limpar cache: $e');
    }
  }
}
