import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_models.dart';
import '../services/user_storage_service.dart';
import '../services/token_storage_service.dart';
import '../repositories/auth_repository.dart';

/// 用户信息提供者
/// 用于在应用中共享用户信息状态
class UserProvider extends ChangeNotifier {
  UserInfo? _currentUser;
  UserDataResponse? _currentUserData;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserInfo? get currentUser => _currentUser;
  UserDataResponse? get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  /// 初始化用户信息
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // 检查是否有有效的认证信息
      final hasValidAuth = await TokenStorageService.hasValidAuth();
      if (hasValidAuth) {
        // 从本地加载用户信息
        final userInfo = await UserStorageService.getUserInfo();
        if (userInfo != null) {
          _currentUser = userInfo;
          notifyListeners();
        }
        
        // 检查是否需要更新用户信息
        final shouldUpdate = await UserStorageService.shouldUpdateUserInfo();
        if (shouldUpdate) {
          await _fetchUserInfo();
        }
      }
    } catch (e) {
      _error = '初始化用户信息失败: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 获取用户信息
  Future<void> fetchUserInfo() async {
    await _fetchUserInfo();
  }

  /// 内部获取用户信息方法
  Future<void> _fetchUserInfo() async {
    _setLoading(true);
    _error = null;
    
    try {
      final token = await TokenStorageService.getToken();
      if (token == null) {
        _error = '没有有效的认证令牌';
        _setLoading(false);
        return;
      }

      final result = await AuthRepository.getUserInfo(token);
      if (result.isSuccess && result.data != null) {
        _currentUser = result.data!;
        await UserStorageService.saveUserInfo(result.data!);
        notifyListeners();
      } else {
        _error = result.message ?? '获取用户信息失败';
        notifyListeners();
      }
    } catch (e) {
      _error = '获取用户信息失败: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 获取用户完整数据
  Future<void> fetchUserData() async {
    _setLoading(true);
    _error = null;
    
    try {
      final token = await TokenStorageService.getToken();
      if (token == null) {
        _error = '没有有效的认证令牌';
        _setLoading(false);
        return;
      }

      final result = await AuthRepository.getUserData(token);
      if (result.isSuccess && result.data != null) {
        _currentUserData = result.data!;
        await UserStorageService.saveUserData(result.data!);
        notifyListeners();
      } else {
        _error = result.message ?? '获取用户数据失败';
        notifyListeners();
      }
    } catch (e) {
      _error = '获取用户数据失败: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 更新用户信息
  Future<void> updateUserInfo(UpdateUserInfoRequest request) async {
    _setLoading(true);
    _error = null;
    
    try {
      final token = await TokenStorageService.getToken();
      if (token == null) {
        _error = '没有有效的认证令牌';
        _setLoading(false);
        return;
      }

      final result = await AuthRepository.updateUserInfo(token, request);
      if (result.isSuccess && result.data != null) {
        _currentUser = result.data!;
        notifyListeners();
      } else {
        _error = result.message ?? '更新用户信息失败';
        notifyListeners();
      }
    } catch (e) {
      _error = '更新用户信息失败: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 更新用户信息字段
  Future<void> updateUserInfoFields(Map<String, dynamic> fields) async {
    try {
      await UserStorageService.updateUserInfoFields(fields);
      final updatedUserInfo = await UserStorageService.getUserInfo();
      if (updatedUserInfo != null) {
        _currentUser = updatedUserInfo;
        notifyListeners();
      }
    } catch (e) {
      _error = '更新用户信息失败: $e';
      notifyListeners();
    }
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    try {
      await UserStorageService.clearUserInfo();
      _currentUser = null;
      _currentUserData = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = '清除用户信息失败: $e';
      notifyListeners();
    }
  }

  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// 用户信息提供者扩展
extension UserProviderExtension on BuildContext {
  UserProvider get userProvider => Provider.of<UserProvider>(this, listen: false);
  UserInfo? get currentUser => userProvider.currentUser;
  UserDataResponse? get currentUserData => userProvider.currentUserData;
  bool get isLoggedIn => userProvider.isLoggedIn;
  bool get isLoading => userProvider.isLoading;
  String? get userError => userProvider.error;
} 