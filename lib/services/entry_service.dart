import 'dart:core';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../models/entry.dart';

class EntryService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final Dio _dio = Dio();
  final logger = Logger();

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

  Future<void> createEntry(Entry entry) async {
    final response = await _dio.post('$baseUrl/entries', data: entry.toJson());
    logger.i(response.data);
  }

  Future<void> updateEntry(Entry entry) async {
    final response = await _dio.put('$baseUrl/entries/${entry.id}', data: entry.toJson());
    logger.i(response.data);
  }

  Future<List<Entry>> getEntries() async {
    final response = await _dio.get('$baseUrl/entries');
    final list = (response.data as List)
        .map((item) => Entry.fromJson(item))
        .toList();
    return list;
  }

  Future<void> deleteEntry(String id) async {
    final response = await _dio.delete('$baseUrl/entries/$id');
    logger.i(response.data);
  }
}
