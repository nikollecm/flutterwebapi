import 'dart:core';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/entry.dart';
import 'local_storage_service.dart';

class EntryService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final Dio _dio = Dio();
  final logger = Logger();
  final LocalStorageService _localStorage = LocalStorageService();

  EntryService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d(options.uri);
          handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i(response.statusCode);
          handler.next(response);
        },
        onError: (error, handler) {
          logger.e(error.message);
          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _isOnline() async {
    try {
      final response = await _dio.get('$baseUrl/entries').timeout(Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> createEntry(Entry entry) async {
    logger.d('Criando entrada: ${entry.title}');
    
    try {
      await _localStorage.addEntry(entry);
      logger.i('Entry salva localmente');
    } catch (e) {
      logger.w('Falha ao salvar localmente: $e');
    }
    
    try {
      final response = await _dio.post('$baseUrl/entries', data: entry.toJson()).timeout(Duration(seconds: 5));
      logger.i('Entry criada na API: ${response.data}');
    } catch (e) {
      logger.w('Falha ao sincronizar com API: $e');
      if (e.toString().contains('PlatformException')) {
        rethrow;
      }
    }
  }

  Future<void> updateEntry(Entry entry) async {
    try {
      await _localStorage.updateEntry(entry);
    } catch (e) {
      logger.w('Falha ao atualizar localmente: $e');
    }
    
    try {
      final response = await _dio.put('$baseUrl/entries/${entry.id}', data: entry.toJson());
      logger.i('Entry atualizada na API: ${response.data}');
    } catch (e) {
      logger.w('Falha ao sincronizar com API: $e');
    }
  }

  Future<List<Entry>> getEntries() async {
    try {
      final response = await _dio.get('$baseUrl/entries').timeout(Duration(seconds: 5));
      final list = (response.data as List)
          .map((item) => Entry.fromJson(item))
          .toList();
      
      try {
        await _localStorage.saveEntries(list);
        logger.i('Entries carregadas da API e cache atualizado');
      } catch (e) {
        logger.w('Falha ao atualizar cache: $e');
      }
      
      return list;
    } catch (e) {
      logger.w('Falha ao buscar da API, tentando cache local: $e');
      try {
        return await _localStorage.getEntries();
      } catch (cacheError) {
        logger.e('Falha ao buscar do cache: $cacheError');
        return [];
      }
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await _localStorage.deleteEntry(id);
    } catch (e) {
      logger.w('Falha ao deletar localmente: $e');
    }
    
    try {
      final response = await _dio.delete('$baseUrl/entries/$id');
      logger.i('Entry deletada na API: ${response.data}');
    } catch (e) {
      logger.w('Falha ao sincronizar com API: $e');
    }
  }

  Future<void> syncWithServer() async {
    try {
      final response = await _dio.get('$baseUrl/entries').timeout(Duration(seconds: 5));
      final list = (response.data as List)
          .map((item) => Entry.fromJson(item))
          .toList();
      
      await _localStorage.saveEntries(list);
      logger.i('Sincronização completa com o servidor');
    } catch (e) {
      logger.e('Falha na sincronização: $e');
    }
  }
}
