import '../models/user_models.dart';

abstract class UserEvent {}

/// 获取用户信息事件
class UserFetchRequested extends UserEvent {
  final String token;
  UserFetchRequested(this.token);
}

/// 保存用户信息事件
class UserSaveRequested extends UserEvent {
  final UserInfo userInfo;
  UserSaveRequested(this.userInfo);
}

/// 保存用户完整数据事件
class UserDataSaveRequested extends UserEvent {
  final UserDataResponse userData;
  UserDataSaveRequested(this.userData);
}

/// 从本地加载用户信息事件
class UserLoadFromLocalRequested extends UserEvent {}

/// 清除用户信息事件
class UserClearRequested extends UserEvent {}

/// 更新用户信息字段事件
class UserUpdateFieldsRequested extends UserEvent {
  final Map<String, dynamic> fields;
  UserUpdateFieldsRequested(this.fields);
} 