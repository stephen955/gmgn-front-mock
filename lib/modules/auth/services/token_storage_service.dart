import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../apis/auth_api.dart';

/// Token 存储服务
/// 敏感信息使用 FlutterSecureStorage，非敏感信息使用 SharedPreferences
class TokenStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  // SecureStorage 键名（敏感信息）
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  
  // SharedPreferences 键名（非敏感信息）
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _lastLoginTimeKey = 'last_login_time';
  static const String _rememberMeKey = 'remember_me';
  static const String _autoLoginKey = 'auto_login';
  static const String _tokenExpiryKey = 'token_expiry';
  
  /// 保存认证 Token（安全存储）
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
    await _setLoginStatus(true);
    await _setLastLoginTime();
    
    // 解析并保存Token过期时间
    final expiry = _parseTokenExpiry(token);
    if (expiry != null) {
      await _setTokenExpiry(expiry);
    }
  }
  
  /// 获取认证 Token（安全存储）
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  /// 保存刷新 Token（安全存储）
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }
  
  /// 获取刷新 Token（安全存储）
  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }
  
  /// 保存用户 ID（安全存储）
  static Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }
  
  /// 获取用户 ID（安全存储）
  static Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }
  
  /// 保存用户邮箱（安全存储）
  static Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: _userEmailKey, value: email);
  }
  
  /// 获取用户邮箱（安全存储）
  static Future<String?> getUserEmail() async {
    return await _secureStorage.read(key: _userEmailKey);
  }
  
  /// 设置登录状态（非敏感信息，使用 SharedPreferences）
  static Future<void> _setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }
  
  /// 检查是否已登录（非敏感信息，使用 SharedPreferences）
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  /// 设置最后登录时间（非敏感信息，使用 SharedPreferences）
  static Future<void> _setLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastLoginTimeKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  /// 获取最后登录时间（非敏感信息，使用 SharedPreferences）
  static Future<DateTime?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastLoginTimeKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  
  /// 设置Token过期时间（非敏感信息，使用 SharedPreferences）
  static Future<void> _setTokenExpiry(DateTime expiry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tokenExpiryKey, expiry.millisecondsSinceEpoch);
  }
  
  /// 获取Token过期时间（非敏感信息，使用 SharedPreferences）
  static Future<DateTime?> getTokenExpiry() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_tokenExpiryKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  
  /// 设置记住我选项（非敏感信息，使用 SharedPreferences）
  static Future<void> setRememberMe(bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
  }
  
  /// 获取记住我选项（非敏感信息，使用 SharedPreferences）
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }
  
  /// 设置自动登录选项（非敏感信息，使用 SharedPreferences）
  static Future<void> setAutoLogin(bool autoLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoLoginKey, autoLogin);
  }
  
  /// 获取自动登录选项（非敏感信息，使用 SharedPreferences）
  static Future<bool> getAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoLoginKey) ?? false;
  }
  
  /// 清除所有认证信息
  static Future<void> clearAll() async {
    // 清除安全存储中的敏感信息
    await _secureStorage.deleteAll();
    
    // 清除 SharedPreferences 中的非敏感信息
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_lastLoginTimeKey);
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_autoLoginKey);
    await prefs.remove(_tokenExpiryKey);
  }
  
  /// 清除敏感信息但保留设置
  static Future<void> clearSensitiveData() async {
    await _secureStorage.deleteAll();
    await _setLoginStatus(false);
  }
  
  /// 解析JWT Token获取过期时间
  static DateTime? _parseTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      
      if (payloadMap['exp'] != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000);
        return expiry;
      }
    } catch (e) {
      print('解析JWT Token失败: $e');
    }
    return null;
  }
  
  /// 检查 Token 是否过期（使用JWT解析）
  static Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    
    // 尝试从JWT解析过期时间
    final expiry = _parseTokenExpiry(token);
    if (expiry != null) {
      return DateTime.now().isAfter(expiry);
    }
    
    // 如果无法解析JWT，使用保存的过期时间
    final savedExpiry = await getTokenExpiry();
    if (savedExpiry != null) {
      return DateTime.now().isAfter(savedExpiry);
    }
    
    // 最后使用简单的时间检查
    final lastLoginTime = await getLastLoginTime();
    if (lastLoginTime == null) return true;
    
    // 假设 Token 有效期为 24 小时
    const tokenValidityDuration = Duration(hours: 24);
    return DateTime.now().difference(lastLoginTime) > tokenValidityDuration;
  }
  
  /// 保存完整的用户认证信息
  static Future<void> saveAuthData({
    required String token,
    required String userId,
    String? refreshToken,
    String? email,
    bool rememberMe = false,
    bool autoLogin = false,
  }) async {
    // 保存敏感信息到安全存储
    await saveToken(token);
    await saveUserId(userId);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    if (email != null) {
      await saveUserEmail(email);
    }
    
    // 保存非敏感信息到 SharedPreferences
    await setRememberMe(rememberMe);
    await setAutoLogin(autoLogin);
  }
  
  /// 获取完整的认证状态
  static Future<Map<String, dynamic>> getAuthStatus() async {
    final token = await getToken();
    final userId = await getUserId();
    final email = await getUserEmail();
    final loggedIn = await isLoggedIn();
    final lastLoginTime = await getLastLoginTime();
    final isExpired = await isTokenExpired();
    final rememberMe = await getRememberMe();
    final autoLogin = await getAutoLogin();
    final expiry = await getTokenExpiry();
    
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'isLoggedIn': loggedIn,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'isExpired': isExpired,
      'hasValidToken': token != null && !isExpired,
      'rememberMe': rememberMe,
      'autoLogin': autoLogin,
      'tokenExpiry': expiry?.toIso8601String(),
    };
  }
  
  /// 检查是否有有效的认证信息
  static Future<bool> hasValidAuth() async {
    final status = await getAuthStatus();
    print('TokenStorageService.hasValidAuth: status = $status');
    final result = status['hasValidToken'] == true && status['isLoggedIn'] == true;
    print('TokenStorageService.hasValidAuth: result = $result');
    return result;
  }
  
  /// 刷新 Token（如果支持）
  static Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;
    
    try {
      // 调用后端 API 刷新 Token
      final response = await AuthApi.refreshToken(refreshToken);
      if (response.isSuccess && response.data != null) {
        await saveToken(response.data!.token);
        if (response.data!.refreshToken != null) {
          await saveRefreshToken(response.data!.refreshToken!);
        }
        return true;
      }
      return false;
    } catch (e) {
      print('刷新 Token 失败: $e');
      return false;
    }
  }
} 