import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/manager_profile.dart';
import '../../../core/router/app_router.dart';
import '../../../core/network/api_client.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

class AuthState {
  final bool isLoading;
  final ManagerProfile? profile;
  final String? error;

  const AuthState({this.isLoading = false, this.profile, this.error});

  AuthState copyWith({bool? isLoading, ManagerProfile? profile, String? error, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  static const _tokenKey = 'jwt_token';
  static const _profileNameKey = 'profile_name';
  static const _profileRoleKey = 'profile_role';
  static const _profileBranchKey = 'profile_branch';

  @override
  AuthState build() => const AuthState();

  Future<String?> getToken() async {
    final storage = ref.read(secureStorageProvider);
    return await storage.read(key: _tokenKey);
  }

  Future<void> checkInitialAuth() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: _tokenKey);
    if (token != null) {
      final name = await storage.read(key: _profileNameKey);
      final role = await storage.read(key: _profileRoleKey);
      final branch = await storage.read(key: _profileBranchKey);
      
      if (name != null && role != null && branch != null) {
        state = state.copyWith(
          profile: ManagerProfile(name: name, role: role, branchName: branch),
        );
        ref.read(routerProvider).go('/dashboard');
      } else {
        await logout();
      }
    } else {
      ref.read(routerProvider).go('/login');
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data != null && response.data['token'] != null && response.data['manager'] != null) {
        final token = response.data['token'];
        final manager = response.data['manager'];

        final profile = ManagerProfile.fromJson(manager);

        final storage = ref.read(secureStorageProvider);
        await storage.write(key: _tokenKey, value: token);
        await storage.write(key: _profileNameKey, value: profile.name);
        await storage.write(key: _profileRoleKey, value: profile.role);
        await storage.write(key: _profileBranchKey, value: profile.branchName);

        state = state.copyWith(isLoading: false, profile: profile);
        ref.read(routerProvider).go('/dashboard');
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = 'Incorrect email or password.';
        } else if (e.type == DioExceptionType.connectionTimeout || 
                   e.type == DioExceptionType.receiveTimeout || 
                   e.type == DioExceptionType.unknown) {
          errorMessage = "Couldn't reach the server, check your connection.";
        } else if (e.response?.data != null && e.response?.data is Map && e.response!.data['error'] != null) {
           errorMessage = e.response!.data['error'];
        }
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  bool _isLoggingOut = false;

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    
    final storage = ref.read(secureStorageProvider);
    await storage.deleteAll();
    state = const AuthState();
    
    ref.read(routerProvider).go('/login');
    
    _isLoggingOut = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
