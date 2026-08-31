import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'dart:async';

void main() {
  test('Concurrent requests test', () async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://maram-milk-backend-hmz7.onrender.com/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Dummy interceptor simulating storage read
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // simulate async token read
        await Future.delayed(const Duration(milliseconds: 50));
        options.headers['Authorization'] = 'Bearer fake_token';
        handler.next(options);
      }
    ));

    print('Starting concurrent requests...');
    final start = DateTime.now();

    // Fire 4 requests concurrently
    final futures = [
      dio.get('/inventory?date=2026-08-31'),
      dio.get('/manager-inventory?date=2026-08-31'),
      dio.get('/inventory?date=2026-08-31'),
    ];

    try {
      final results = await Future.wait(futures);
      print('Completed in ${DateTime.now().difference(start).inMilliseconds}ms');
    } on DioException catch (e) {
      print('DioException after ${DateTime.now().difference(start).inMilliseconds}ms: ${e.type} - ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  });
}
