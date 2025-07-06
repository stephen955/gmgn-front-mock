import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
class NetworkErrorHandler {
  /// 处理网络错误并返回用户友好的错误信息
  static String handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return '网络连接失败，请检查网络设置';
    } else if (error.toString().contains('Connection reset by peer')) {
      return '连接被重置，请稍后重试';
    } else if (error.toString().contains('timeout')) {
      return '请求超时，请检查网络连接';
    } else {
      return '网络请求失败，请稍后重试';
    }
  }

  /// 处理Dio错误
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时，请检查网络连接';
      case DioExceptionType.sendTimeout:
        return '发送超时，请稍后重试';
      case DioExceptionType.receiveTimeout:
        return '接收超时，请稍后重试';
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response?.statusCode);
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '网络连接错误，请检查网络设置';
      case DioExceptionType.unknown:
        return '未知网络错误，请稍后重试';
      default:
        return '网络请求失败，请稍后重试';
    }
  }

  /// 处理HTTP响应错误
  static String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请重新登录';
      case 403:
        return '访问被拒绝';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务暂时不可用';
      case 504:
        return '网关超时';
      default:
        return '服务器错误 (${statusCode ?? 'unknown'})';
    }
  }

  /// 显示网络错误对话框
  static void showNetworkErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('网络错误'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  /// 显示网络错误SnackBar
  static void showNetworkErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: '重试',
          textColor: Colors.white,
          onPressed: () {
            // 这里可以添加重试逻辑
          },
        ),
      ),
    );
  }

  /// 检查是否为网络连接错误
  static bool isNetworkConnectionError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
             error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.receiveTimeout ||
             error.type == DioExceptionType.sendTimeout;
    }
    return error.toString().contains('Connection reset by peer') ||
           error.toString().contains('timeout') ||
           error.toString().contains('SocketException');
  }

  /// 检查是否为服务器错误
  static bool isServerError(dynamic error) {
    if (error is DioException && error.response != null) {
      final statusCode = error.response!.statusCode;
      return statusCode != null && statusCode >= 500;
    }
    return false;
  }
} 