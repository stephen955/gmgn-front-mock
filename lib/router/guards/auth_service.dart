import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 认证服务
/// 负责管理用户登录状态和认证信息
class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  /// 检查用户是否已登录
  static Future<bool> isLoggedIn() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final isLoggedIn = await _storage.read(key: _isLoggedInKey);
      return token != null && token.isNotEmpty && isLoggedIn == 'true';
    } catch (e) {
      return false;
    }
  }

  /// 获取用户 Token
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// 获取用户 ID
  static Future<String?> getUserId() async {
    try {
      return await _storage.read(key: _userIdKey);
    } catch (e) {
      return null;
    }
  }

  /// 保存登录信息
  static Future<void> saveLoginInfo({
    required String token,
    required String userId,
  }) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userIdKey, value: userId);
      await _storage.write(key: _isLoggedInKey, value: 'true');
    } catch (e) {
      // 处理存储错误
    }
  }

  /// 清除登录信息
  static Future<void> clearLoginInfo() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userIdKey);
      await _storage.delete(key: _isLoggedInKey);
    } catch (e) {
      // 处理清除错误
    }
  }

  /// 更新 Token
  static Future<void> updateToken(String newToken) async {
    try {
      await _storage.write(key: _tokenKey, value: newToken);
    } catch (e) {
      // 处理更新错误
    }
  }

  /// 检查 Token 是否有效（可选：调用后端验证）
  static Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }
      
      // TODO: 可以在这里调用后端 API 验证 token 有效性
      // 例如：await dio.get('/auth/verify', headers: {'Authorization': 'Bearer $token'});
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 强制登出
  static Future<void> logout() async {
    await clearLoginInfo();
  }
} 