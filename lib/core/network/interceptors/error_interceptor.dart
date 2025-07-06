import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: 处理未授权（如跳转登录页、清除本地token等）
    } else if (err.type == DioErrorType.connectionTimeout) {
      // TODO: 处理连接超时
    } else if (err.type == DioErrorType.receiveTimeout) {
      // TODO: 处理接收超时
    }
    // 其他错误处理
    handler.next(err);
  }
} 