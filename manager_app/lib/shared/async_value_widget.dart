import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'app_loading_state.dart';
import 'app_error_state.dart';

class AppAsyncWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final VoidCallback? onRetry;
  final String? loadingMessage;
  final bool isCardError;

  const AppAsyncWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loadingMessage,
    this.isCardError = false,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => AppLoadingState(message: loadingMessage),
      error: (error, stackTrace) => AppErrorState(
        message: _getErrorMessage(error, stackTrace),
        onRetry: onRetry,
        isCard: isCardError,
      ),
    );
  }

  String _getErrorMessage(Object error, [StackTrace? stackTrace]) {
    // Print stack trace to console so we don't silently swallow exceptions!
    debugPrint('AppAsyncWidget caught error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace:\n$stackTrace');
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout || 
          error.type == DioExceptionType.receiveTimeout) {
        return "Connection timed out. Please check your internet and try again.";
      }
      if (error.type == DioExceptionType.connectionError || 
          error.type == DioExceptionType.unknown) {
        return "Couldn't reach the server. Please check your connection.";
      }
      if (error.response?.data != null && error.response?.data is Map && error.response!.data['error'] != null) {
        return error.response!.data['error'].toString();
      }
      return "Something went wrong on our end (Error ${error.response?.statusCode}).";
    }
    return error.toString().replaceAll('Exception: ', '');
  }
}
