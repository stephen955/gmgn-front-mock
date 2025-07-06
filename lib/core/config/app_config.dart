import 'package:flutter/foundation.dart';

/// 应用配置类
enum AppEnvironment { development, production }

class AppConfig {
  static const String _devApiUrl = 'http://localhost:3000'; // 本地mock服务器
  static const String _prodApiUrl = ''; // 生产环境API地址
  
  /// 获取当前环境的API基础URL
  static String get apiBaseUrl {
    if (kDebugMode) {
      return _devApiUrl;
    } else {
      return _prodApiUrl;
    }
  }
  
  /// 获取当前环境名称
  static String get environment {
    if (kDebugMode) {
      return 'development';
    } else {
      return 'production';
    }
  }
  
  /// 是否启用调试模式
  static bool get isDebugMode => kDebugMode;
  
  /// 网络请求超时时间（秒）
  static const int connectTimeout = 15;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 15;
  
  /// 重试次数
  static const int maxRetries = 3;
} 