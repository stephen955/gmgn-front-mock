import 'user_models.dart';

/// 注册请求模型
class RegisterRequest {
  final String username;
  final String email;

  RegisterRequest({
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}

/// 注册响应模型
class RegisterResponse {
  final String userId;
  final String username;
  final String createdAt;

  RegisterResponse({
    required this.userId,
    required this.username,
    required this.createdAt,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

/// 登录请求模型
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// 登录响应模型
class LoginResponse {
  final String token;
  final String userId;
  final int expiresIn;
  final String? refreshToken;
  final UserInfo? userInfo;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.expiresIn,
    this.refreshToken,
    this.userInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      expiresIn: json['expiresIn'] is int ? json['expiresIn'] : (json['expiresIn'] as num?)?.toInt() ?? 0,
      refreshToken: json['refreshToken'],
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }
}

/// 忘记密码请求模型
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

/// 忘记密码响应模型
class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({
    required this.message,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] ?? '',
    );
  }
}

/// Apple登录响应模型
class AppleLoginResponse {
  final String token;
  final String userId;
  final String provider;
  final int expiresIn;
  final String? refreshToken;
  final UserInfo? userInfo;

  AppleLoginResponse({
    required this.token,
    required this.userId,
    required this.provider,
    required this.expiresIn,
    this.refreshToken,
    this.userInfo,
  });

  factory AppleLoginResponse.fromJson(Map<String, dynamic> json) {
    return AppleLoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      provider: json['provider'] ?? '',
      expiresIn: json['expiresIn'] is int ? json['expiresIn'] : (json['expiresIn'] as num?)?.toInt() ?? 0,
      refreshToken: json['refreshToken'],
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }
}

/// Telegram登录请求模型
class TelegramLoginRequest {
  final Map<String, dynamic> payload;

  TelegramLoginRequest({
    required this.payload,
  });

  Map<String, dynamic> toJson() {
    return payload;
  }
}

/// Telegram登录响应模型
class TelegramLoginResponse {
  final String token;
  final String userId;
  final String provider;
  final int expiresIn;
  final String? refreshToken;
  final UserInfo? userInfo;

  TelegramLoginResponse({
    required this.token,
    required this.userId,
    required this.provider,
    required this.expiresIn,
    this.refreshToken,
    this.userInfo,
  });

  factory TelegramLoginResponse.fromJson(Map<String, dynamic> json) {
    return TelegramLoginResponse(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      provider: json['provider'] ?? '',
      expiresIn: json['expiresIn'] is int ? json['expiresIn'] : (json['expiresIn'] as num?)?.toInt() ?? 0,
      refreshToken: json['refreshToken'],
      userInfo: json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }
}

/// 通用API响应模型
class ApiResponse<T> {
  final int code;
  final T? data;
  final String? message;

  ApiResponse({
    required this.code,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ApiResponse<T>(
      code: json['code'] ?? 0,
      data: json['data'] != null ? fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  bool get isSuccess => code == 0;
} 