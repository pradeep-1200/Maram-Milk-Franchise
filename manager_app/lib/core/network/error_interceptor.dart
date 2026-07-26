import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/authentication/providers/auth_provider.dart';

class ErrorInterceptor extends Interceptor {
  final Ref ref;

  ErrorInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/login')) {
      // Idempotent logout and redirect handled by authProvider
      ref.read(authProvider.notifier).logout();
    }
    super.onError(err, handler);
  }
}
