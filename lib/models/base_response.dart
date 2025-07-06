/// 通用API基础响应模型
class BaseResponse {
  final int code;
  final String reason;
  final String message;

  BaseResponse({
    required this.code,
    required this.reason,
    required this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'] is int ? json['code'] : (json['code'] as num?)?.toInt() ?? 0,
      reason: json['reason'] ?? '',
      message: json['message'] ?? '',
    );
  }
} 