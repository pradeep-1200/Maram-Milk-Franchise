import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../../attendance/models/delivery_person.dart';
import '../../../core/network/api_client.dart';

class StaffNotifier extends AsyncNotifier<List<DeliveryPerson>> {
  @override
  Future<List<DeliveryPerson>> build() async {
    try {
      return await _fetchStaff('');
    } catch (e, st) {
      return Future.error(e, st);
    }
  }

  Future<List<DeliveryPerson>> _fetchStaff(String search) async {
    final dio = ref.read(apiClientProvider);
    final response = await dio.get(
      '/delivery-persons',
      queryParameters: search.isNotEmpty ? {'search': search} : null,
    );
    final List<dynamic> data = response.data;
    return data.map((json) => DeliveryPerson.fromJson(json)).toList();
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStaff(query));
  }

  Future<void> addStaff(DeliveryPerson dp) async {
    await addStaffWithResponse(dp);
  }

  Future<DeliveryPerson?> addStaffWithResponse(DeliveryPerson dp) async {
    try {
      final dio = ref.read(apiClientProvider);
      final data = dp.toJson();
      data.remove('_id'); // Backend generates ID
      data.remove('dpCode'); // Backend generates dpCode
      
      // Remove nulls and empty strings
      data.removeWhere((key, value) => value == null || value == '');

      final response = await dio.post('/delivery-persons', data: data);
      ref.invalidateSelf();
      return DeliveryPerson.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow; // _handleDioError should throw, but if it doesn't we rethrow
    }
  }

  Future<void> updateStaff(String id, DeliveryPerson dp) async {
    try {
      final dio = ref.read(apiClientProvider);
      final data = dp.toJson();
      data.remove('_id');
      data.remove('dpCode');
      data.remove('photoUrl');
      data.remove('aadharCopyUrl');
      data.remove('licenseCopyUrl');
      
      data.removeWhere((key, value) => value == null || value == '');

      await dio.put('/delivery-persons/$id', data: data);
      ref.invalidateSelf();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> deactivateStaff(String id) async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/delivery-persons/$id/deactivate');
      ref.invalidateSelf();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> reactivateStaff(String id) async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.post('/delivery-persons/$id/reactivate');
      ref.invalidateSelf();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDeletePreview(String id) async {
    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.get('/delivery-persons/$id/delete-preview');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<void> deleteStaff(String id) async {
    try {
      final dio = ref.read(apiClientProvider);
      await dio.delete('/delivery-persons/$id');
      ref.invalidateSelf();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data['error'] != null && data['error']['message'] != null) {
        throw Exception(data['error']['message']);
      }
    }
    throw Exception('A network or server error occurred');
  }

  Future<String> uploadFile(String dpId, String filePath, String type) async {
    final dio = ref.read(apiClientProvider);
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final typeSplit = mimeType.split('/');
    
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        contentType: MediaType(typeSplit[0], typeSplit.length > 1 ? typeSplit[1] : ''),
      ),
    });

    final response = await dio.post(
      '/delivery-persons/$dpId/$type',
      data: formData,
    );
    
    ref.invalidateSelf(); // Refresh to get the new URLs
    return response.data['url'] ?? '';
  }
}

final staffProvider = AsyncNotifierProvider<StaffNotifier, List<DeliveryPerson>>(() {
  return StaffNotifier();
});
