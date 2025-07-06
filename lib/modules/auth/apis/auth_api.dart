import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_models.dart';
import '../models/user_models.dart';
import '../../../core/config/app_config.dart';

/// 认证相关API接口
class AuthApi {
  static String get baseUrl => AppConfig.apiBaseUrl;

  /// 处理HTTP响应
  static ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
    String operation,
  ) {
    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return ApiResponse.fromJson(jsonResponse, fromJson);
      } catch (e) {
        return ApiResponse(
          code: -1,
          message: '$operation 响应解析失败: $e',
        );
      }
    } else if (response.statusCode == 401) {
      return ApiResponse(
        code: 401,
        message: '认证失败，请检查用户名和密码',
      );
    } else if (response.statusCode == 404) {
      return ApiResponse(
        code: 404,
        message: '服务不可用，请稍后重试',
      );
    } else if (response.statusCode >= 500) {
      return ApiResponse(
        code: response.statusCode,
        message: '服务器错误，请稍后重试',
      );
    } else {
      return ApiResponse(
        code: response.statusCode,
        message: '$operation 请求失败: ${response.statusCode}',
      );
    }
  }

  /// 处理网络异常
  static ApiResponse<T> _handleException<T>(dynamic e, String operation) {
    if (e is http.ClientException) {
      return ApiResponse(
        code: -1,
        message: '网络连接失败，请检查网络设置',
      );
    } else if (e.toString().contains('SocketException')) {
      return ApiResponse(
        code: -1,
        message: '无法连接到服务器，请检查网络连接',
      );
    } else if (e.toString().contains('TimeoutException')) {
      return ApiResponse(
        code: -1,
        message: '请求超时，请稍后重试',
      );
    } else {
      return ApiResponse(
        code: -1,
        message: '$operation 网络错误: $e',
      );
    }
  }

  /// 用户注册
  static Future<ApiResponse<RegisterResponse>> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vas/api/v1/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, RegisterResponse.fromJson, '注册');
    } catch (e) {
      return _handleException(e, '注册');
    }
  }

  /// 用户登录
  static Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vas/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, LoginResponse.fromJson, '登录');
    } catch (e) {
      return _handleException(e, '登录');
    }
  }

  /// 忘记密码
  static Future<ApiResponse<ForgotPasswordResponse>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vas/api/v1/auth/forgot_password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, ForgotPasswordResponse.fromJson, '忘记密码');
    } catch (e) {
      return _handleException(e, '忘记密码');
    }
  }

  /// Apple登录
  static Future<ApiResponse<AppleLoginResponse>> appleLogin() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vas/api/v1/auth/apple'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({}), // Apple登录可能需要额外的参数
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, AppleLoginResponse.fromJson, 'Apple登录');
    } catch (e) {
      return _handleException(e, 'Apple登录');
    }
  }

  /// Telegram登录
  static Future<ApiResponse<TelegramLoginResponse>> telegramLogin(TelegramLoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/vas/api/v1/auth/telegram'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, TelegramLoginResponse.fromJson, 'Telegram登录');
    } catch (e) {
      return _handleException(e, 'Telegram登录');
    }
  }

  /// 刷新Token
  static Future<ApiResponse<LoginResponse>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, LoginResponse.fromJson, '刷新Token');
    } catch (e) {
      return _handleException(e, '刷新Token');
    }
  }

  /// 获取用户信息
  static Future<ApiResponse<UserInfo>> getUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vas/api/v1/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, UserInfo.fromJson, '获取用户信息');
    } catch (e) {
      return _handleException(e, '获取用户信息');
    }
  }

  /// 获取用户完整数据
  static Future<ApiResponse<UserDataResponse>> getUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vas/api/v1/user/data'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, UserDataResponse.fromJson, '获取用户数据');
    } catch (e) {
      return _handleException(e, '获取用户数据');
    }
  }

  /// 更新用户信息
  static Future<ApiResponse<UserInfo>> updateUserInfo(
    String token,
    UpdateUserInfoRequest request,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/vas/api/v1/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      return _handleResponse(response, UserInfo.fromJson, '更新用户信息');
    } catch (e) {
      return _handleException(e, '更新用户信息');
    }
  }
} 