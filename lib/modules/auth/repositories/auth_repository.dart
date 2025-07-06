import '../apis/auth_api.dart';
import '../models/auth_models.dart';
import '../models/user_models.dart';
import '../services/token_storage_service.dart';
import '../services/user_storage_service.dart';

/// 认证数据仓库
class AuthRepository {
  /// 用户注册
  static Future<ApiResponse<RegisterResponse>> register({
    required String username,
    required String email,
  }) async {
    final request = RegisterRequest(
      username: username,
      email: email,
    );
    return await AuthApi.register(request);
  }

  /// 用户登录
  static Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
    );
    final response = await AuthApi.login(request);
    
    // 登录成功后保存认证信息和用户信息
    if (response.isSuccess && response.data != null) {
      final loginData = response.data!;
      
      // 保存认证信息
      await TokenStorageService.saveAuthData(
        token: loginData.token,
        userId: loginData.userId,
        refreshToken: loginData.refreshToken,
        email: email,
      );
      
      // 如果有用户信息，保存用户信息
      if (loginData.userInfo != null) {
        await UserStorageService.saveUserInfo(loginData.userInfo!);
      }
    }
    
    return response;
  }

  /// 忘记密码
  static Future<ApiResponse<ForgotPasswordResponse>> forgotPassword({
    required String email,
  }) async {
    final request = ForgotPasswordRequest(
      email: email,
    );
    return await AuthApi.forgotPassword(request);
  }

  /// Apple登录
  static Future<ApiResponse<AppleLoginResponse>> appleLogin() async {
    final response = await AuthApi.appleLogin();
    
    // 登录成功后保存认证信息和用户信息
    if (response.isSuccess && response.data != null) {
      final loginData = response.data!;
      
      // 保存认证信息
      await TokenStorageService.saveAuthData(
        token: loginData.token,
        userId: loginData.userId,
        refreshToken: loginData.refreshToken,
      );
      
      // 如果有用户信息，保存用户信息
      if (loginData.userInfo != null) {
        await UserStorageService.saveUserInfo(loginData.userInfo!);
      }
    }
    
    return response;
  }

  /// Telegram登录
  static Future<ApiResponse<TelegramLoginResponse>> telegramLogin({
    required Map<String, dynamic> telegramPayload,
  }) async {
    final request = TelegramLoginRequest(
      payload: telegramPayload,
    );
    final response = await AuthApi.telegramLogin(request);
    
    // 登录成功后保存认证信息和用户信息
    if (response.isSuccess && response.data != null) {
      final loginData = response.data!;
      
      // 保存认证信息
      await TokenStorageService.saveAuthData(
        token: loginData.token,
        userId: loginData.userId,
        refreshToken: loginData.refreshToken,
      );
      
      // 如果有用户信息，保存用户信息
      if (loginData.userInfo != null) {
        await UserStorageService.saveUserInfo(loginData.userInfo!);
      }
    }
    
    return response;
  }

  /// 获取用户信息
  static Future<ApiResponse<UserInfo>> getUserInfo(String token) async {
    return await AuthApi.getUserInfo(token);
  }

  /// 获取用户完整数据
  static Future<ApiResponse<UserDataResponse>> getUserData(String token) async {
    return await AuthApi.getUserData(token);
  }

  /// 更新用户信息
  static Future<ApiResponse<UserInfo>> updateUserInfo(
    String token,
    UpdateUserInfoRequest request,
  ) async {
    final response = await AuthApi.updateUserInfo(token, request);
    
    // 更新成功后保存到本地
    if (response.isSuccess && response.data != null) {
      await UserStorageService.saveUserInfo(response.data!);
    }
    
    return response;
  }

  /// 登出
  static Future<void> logout() async {
    await TokenStorageService.clearAll();
    await UserStorageService.clearUserInfo();
  }

  /// 从本地获取用户信息
  static Future<UserInfo?> getLocalUserInfo() async {
    return await UserStorageService.getUserInfo();
  }

  /// 从本地获取用户完整数据
  static Future<UserDataResponse?> getLocalUserData() async {
    return await UserStorageService.getUserData();
  }

  /// 检查用户信息是否需要更新
  static Future<bool> shouldUpdateUserInfo() async {
    return await UserStorageService.shouldUpdateUserInfo();
  }
} 