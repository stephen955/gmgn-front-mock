import 'package:gmgn_front/modules/auth/models/user_models.dart';

abstract class UserState {}

/// 初始状态
class UserInitial extends UserState {}

/// 加载中状态
class UserLoading extends UserState {}

/// 用户信息加载成功
class UserLoaded extends UserState {
  final UserInfo userInfo;
  UserLoaded(this.userInfo);
}

/// 用户完整数据加载成功
class UserDataLoaded extends UserState {
  final UserDataResponse userData;
  UserDataLoaded(this.userData);
}

/// 用户信息保存成功
class UserSaved extends UserState {
  final UserInfo userInfo;
  UserSaved(this.userInfo);
}

/// 用户数据保存成功
class UserDataSaved extends UserState {
  final UserDataResponse userData;
  UserDataSaved(this.userData);
}

/// 用户信息清除成功
class UserCleared extends UserState {}

/// 用户信息更新成功
class UserUpdated extends UserState {
  final UserInfo userInfo;
  UserUpdated(this.userInfo);
}

/// 错误状态
class UserError extends UserState {
  final String message;
  UserError(this.message);
} 