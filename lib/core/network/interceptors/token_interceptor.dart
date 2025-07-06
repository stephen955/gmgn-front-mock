import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../modules/auth/services/token_storage_service.dart';

class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 使用TokenStorageService获取token
      final token = await TokenStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      print('TokenInterceptor error: $e');
    }
    handler.next(options);
  }
} 