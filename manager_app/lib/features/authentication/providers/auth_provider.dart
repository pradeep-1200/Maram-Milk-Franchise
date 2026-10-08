import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/manager_profile.dart';
import '../../../core/router/app_router.dart';
import '../../../core/network/api_client.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

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

  bool get isReadOnly => profile?.role == 'ADMIN';
}

class AuthNotifier extends Notifier<AuthState> {
  static const _tokenKey = 'jwt_token';
  static const _profileNameKey = 'profile_name';
  static const _profileRoleKey = 'profile_role';
  static const _profileBranchKey = 'profile_branch';
  static const _profilePhotoKey = 'profile_photo';

  @override
  AuthState build() => const AuthState();

  String? _cachedToken;
  String? get currentToken => _cachedToken;

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final storage = ref.read(secureStorageProvider);
    _cachedToken = await storage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<void> checkInitialAuth() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: _tokenKey);
    if (token != null) {
      _cachedToken = token;
      final name = await storage.read(key: _profileNameKey);
      final role = await storage.read(key: _profileRoleKey);
      final branch = await storage.read(key: _profileBranchKey);
      final photoUrl = await storage.read(key: _profilePhotoKey);
      
      if (name != null && role != null && branch != null) {
        state = state.copyWith(
          profile: ManagerProfile(name: name, role: role, branchName: branch, photoUrl: photoUrl),
        );
        ref.read(routerProvider).go('/dashboard');
        
        // Fetch fresh profile in background
        _fetchMe();
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
        _cachedToken = token;
        await storage.write(key: _tokenKey, value: token);
        await storage.write(key: _profileNameKey, value: profile.name);
        await storage.write(key: _profileRoleKey, value: profile.role);
        await storage.write(key: _profileBranchKey, value: profile.branchName);
        if (profile.photoUrl != null) {
          await storage.write(key: _profilePhotoKey, value: profile.photoUrl!);
        } else {
          await storage.delete(key: _profilePhotoKey);
        }

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

  Future<void> _fetchMe() async {
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get('/auth/me');
      if (response.statusCode == 200 && response.data['manager'] != null) {
        final profile = ManagerProfile.fromJson(response.data['manager']);
        state = state.copyWith(profile: profile);
        final storage = ref.read(secureStorageProvider);
        if (profile.photoUrl != null) {
          await storage.write(key: _profilePhotoKey, value: profile.photoUrl!);
        } else {
          await storage.delete(key: _profilePhotoKey);
        }
      }
    } catch (e) {
      // Ignore background fetch errors
    }
  }

  Future<void> uploadPhoto(String filePath) async {
    try {
      final dio = ref.read(apiClientProvider);
      final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: p.basename(filePath),
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await dio.post(
        '/auth/photo',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 && response.data['url'] != null) {
        final newUrl = response.data['url'];
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(photoUrl: newUrl);
          state = state.copyWith(profile: updatedProfile);
          final storage = ref.read(secureStorageProvider);
          await storage.write(key: _profilePhotoKey, value: newUrl);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  bool _isLoggingOut = false;

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    
    final storage = ref.read(secureStorageProvider);
    _cachedToken = null;
    await storage.deleteAll();
    state = const AuthState();
    
    ref.read(routerProvider).go('/login');
    
    _isLoggingOut = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
