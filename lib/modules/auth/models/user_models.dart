/// 用户信息模型
class UserInfo {
  final String userId;
  final String username;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? profile;
  final String? walletAddress;
  final double? balance;
  final String? balanceSymbol;

  UserInfo({
    required this.userId,
    required this.username,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.lastLoginAt,
    this.profile,
    this.walletAddress,
    this.balance,
    this.balanceSymbol,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.tryParse(json['lastLoginAt']) 
          : null,
      profile: json['profile'],
      walletAddress: json['walletAddress'] ?? json['wallet_address'],
      balance: (json['balance'] is num)
          ? (json['balance'] as num).toDouble()
          : double.tryParse(json['balance']?.toString() ?? ''),
      balanceSymbol: json['balanceSymbol'] ?? json['balance_symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'profile': profile,
      'walletAddress': walletAddress,
      'balance': balance,
      'balanceSymbol': balanceSymbol,
    };
  }
}

/// 用户数据响应模型
class UserDataResponse {
  final UserInfo userInfo;
  final Map<String, dynamic>? statistics;
  final List<Map<String, dynamic>>? recentActivities;

  UserDataResponse({
    required this.userInfo,
    this.statistics,
    this.recentActivities,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      userInfo: UserInfo.fromJson(json['userInfo'] ?? {}),
      statistics: json['statistics'],
      recentActivities: json['recentActivities'] != null 
          ? List<Map<String, dynamic>>.from(json['recentActivities'])
          : null,
    );
  }
}

/// 更新用户信息请求模型
class UpdateUserInfoRequest {
  final String? username;
  final String? email;
  final String? avatar;
  final Map<String, dynamic>? profile;

  UpdateUserInfoRequest({
    this.username,
    this.email,
    this.avatar,
    this.profile,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (username != null) json['username'] = username;
    if (email != null) json['email'] = email;
    if (avatar != null) json['avatar'] = avatar;
    if (profile != null) json['profile'] = profile;
    return json;
  }
} 