import 'package:dio/dio.dart';
import 'network_interceptor.dart';
import 'interceptors/token_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'network_config.dart';
import '../config/app_config.dart';

class NetworkClient {
  static final NetworkClient _instance = NetworkClient._internal();
  late final Dio dio;

  factory NetworkClient() {
    return _instance;
  }

  NetworkClient._internal() {
    dio = NetworkConfig.configureDio();
    // 使用配置类中的API地址
    dio.options.baseUrl = AppConfig.apiBaseUrl;

    dio.interceptors.addAll([
      NetworkInterceptor(),
      TokenInterceptor(),
      ErrorInterceptor(),
      // 其它拦截器
    ]);
  }
} 