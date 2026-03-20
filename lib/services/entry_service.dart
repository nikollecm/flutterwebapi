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
}
