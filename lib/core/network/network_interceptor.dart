import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: 在此处添加 token
    // options.headers['Authorization'] = 'Bearer your_token';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 可在此处理响应
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 统一处理 token 失效
    if (err.response?.statusCode == 401) {
      // TODO: 跳转登录页或清理本地 token
      // 例如：Get.offAllNamed('/login');
    }
    super.onError(err, handler);
  }
} 