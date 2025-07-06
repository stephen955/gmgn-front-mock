import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  static const int _defaultConnectTimeout = 15; // 15秒连接超时
  static const int _defaultReceiveTimeout = 30; // 30秒接收超时
  static const int _defaultSendTimeout = 15; // 15秒发送超时
  static const int _maxRetries = 3; // 最大重试次数

  /// 配置Dio实例
  static Dio configureDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: _defaultConnectTimeout),
      receiveTimeout: Duration(seconds: _defaultReceiveTimeout),
      // 只在非Web平台设置sendTimeout，避免Web平台警告
      sendTimeout: kIsWeb ? null : Duration(seconds: _defaultSendTimeout),
      headers: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Cache-Control': 'no-cache',
      },
    ));

    // 添加重试拦截器
    dio.interceptors.add(_RetryInterceptor());

    return dio;
  }

  /// 配置CachedNetworkImage
  static void configureCachedNetworkImage() {
    // 设置全局配置
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  }

  /// 检查网络连接
  static Future<bool> checkNetworkConnectivity() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://www.google.com',
        options: Options(
          // 只在非Web平台设置sendTimeout
          sendTimeout: kIsWeb ? null : Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Network connectivity check failed: $e');
      return false;
    }
  }
}

/// 重试拦截器
class _RetryInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
      final maxRetries = 3;

      if (retryCount < maxRetries) {
        // 延迟重试，使用指数退避
        final delay = Duration(seconds: (1 << retryCount));
        await Future.delayed(delay);

        // 更新重试计数
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          // 重新发送请求
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // 如果重试失败，继续处理错误
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // 只对特定错误进行重试
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.sendTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.type == DioExceptionType.badResponse && 
            err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }
} 