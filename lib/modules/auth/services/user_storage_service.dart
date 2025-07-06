import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_models.dart';

/// 用户信息存储服务
/// 使用 SharedPreferences 存储用户信息（非敏感信息）
class UserStorageService {
  // SharedPreferences 键名
  static const String _userInfoKey = 'user_info';
  static const String _userDataKey = 'user_data';
  static const String _lastUserUpdateKey = 'last_user_update';
  
  /// 保存用户信息
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = userInfo.toJson();
    await prefs.setString(_userInfoKey, jsonEncode(userInfoJson));
    await _setLastUserUpdate();
  }
  
  /// 获取用户信息
  static Future<UserInfo?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString(_userInfoKey);
    if (userInfoString != null) {
      try {
        final userInfoJson = jsonDecode(userInfoString);
        return UserInfo.fromJson(userInfoJson);
      } catch (e) {
        print('解析用户信息失败: $e');
        return null;
      }
    }
    return null;
  }
  
  /// 保存用户完整数据
  static Future<void> saveUserData(UserDataResponse userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = {
      'userInfo': userData.userInfo.toJson(),
      'statistics': userData.statistics,
      'recentActivities': userData.recentActivities,
    };
    await prefs.setString(_userDataKey, jsonEncode(userDataJson));
    await _setLastUserUpdate();
  }
  
  /// 获取用户完整数据
  static Future<UserDataResponse?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      try {
        final userDataJson = jsonDecode(userDataString);
        return UserDataResponse.fromJson(userDataJson);
      } catch (e) {
        print('解析用户数据失败: $e');
        return null;
      }
    }
    return null;
  }
  
  /// 设置最后用户信息更新时间
  static Future<void> _setLastUserUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastUserUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  /// 获取最后用户信息更新时间
  static Future<DateTime?> getLastUserUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastUserUpdateKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  
  /// 检查用户信息是否需要更新（超过5分钟）
  static Future<bool> shouldUpdateUserInfo() async {
    final lastUpdate = await getLastUserUpdate();
    if (lastUpdate == null) return true;
    
    const updateInterval = Duration(minutes: 5);
    return DateTime.now().difference(lastUpdate) > updateInterval;
  }
  
  /// 清除用户信息
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userInfoKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_lastUserUpdateKey);
  }
  
  /// 更新用户信息的部分字段
  static Future<void> updateUserInfoFields(Map<String, dynamic> fields) async {
    final currentUserInfo = await getUserInfo();
    if (currentUserInfo != null) {
      final updatedUserInfo = UserInfo(
        userId: currentUserInfo.userId,
        username: fields['username'] ?? currentUserInfo.username,
        email: fields['email'] ?? currentUserInfo.email,
        avatar: fields['avatar'] ?? currentUserInfo.avatar,
        createdAt: currentUserInfo.createdAt,
        lastLoginAt: fields['lastLoginAt'] != null 
            ? DateTime.tryParse(fields['lastLoginAt']) 
            : currentUserInfo.lastLoginAt,
        profile: fields['profile'] ?? currentUserInfo.profile,
        walletAddress: fields['walletAddress'] ?? currentUserInfo.walletAddress,
        balance: fields['balance'] != null 
            ? (fields['balance'] is num ? fields['balance'].toDouble() : double.tryParse(fields['balance'].toString()))
            : currentUserInfo.balance,
        balanceSymbol: fields['balanceSymbol'] ?? currentUserInfo.balanceSymbol,
      );
      await saveUserInfo(updatedUserInfo);
    }
  }
} 