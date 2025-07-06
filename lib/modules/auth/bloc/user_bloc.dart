import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/modules/auth/repositories/auth_repository.dart';
import 'package:gmgn_front/modules/auth/models/user_models.dart';
import 'package:gmgn_front/modules/auth/bloc/user_event.dart';
import 'package:gmgn_front/modules/auth/bloc/user_state.dart';
import 'package:gmgn_front/modules/auth/services/user_storage_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    // 获取用户信息
    on<UserFetchRequested>((event, emit) async {
      emit(UserLoading());
      try {
        final result = await AuthRepository.getUserInfo(event.token);
        if (result.isSuccess && result.data != null) {
          // 保存到本地存储
          await UserStorageService.saveUserInfo(result.data!);
          emit(UserLoaded(result.data!));
        } else {
          emit(UserError(result.message ?? '获取用户信息失败'));
        }
      } catch (e) {
        emit(UserError('获取用户信息失败: $e'));
      }
    });

    // 保存用户信息
    on<UserSaveRequested>((event, emit) async {
      try {
        await UserStorageService.saveUserInfo(event.userInfo);
        emit(UserSaved(event.userInfo));
      } catch (e) {
        emit(UserError('保存用户信息失败: $e'));
      }
    });

    // 保存用户完整数据
    on<UserDataSaveRequested>((event, emit) async {
      try {
        await UserStorageService.saveUserData(event.userData);
        emit(UserDataSaved(event.userData));
      } catch (e) {
        emit(UserError('保存用户数据失败: $e'));
      }
    });

    // 从本地加载用户信息
    on<UserLoadFromLocalRequested>((event, emit) async {
      emit(UserLoading());
      try {
        final userInfo = await UserStorageService.getUserInfo();
        if (userInfo != null) {
          emit(UserLoaded(userInfo));
        } else {
          emit(UserError('本地没有用户信息'));
        }
      } catch (e) {
        emit(UserError('加载本地用户信息失败: $e'));
      }
    });

    // 清除用户信息
    on<UserClearRequested>((event, emit) async {
      try {
        await UserStorageService.clearUserInfo();
        emit(UserCleared());
      } catch (e) {
        emit(UserError('清除用户信息失败: $e'));
      }
    });

    // 更新用户信息字段
    on<UserUpdateFieldsRequested>((event, emit) async {
      try {
        await UserStorageService.updateUserInfoFields(event.fields);
        final updatedUserInfo = await UserStorageService.getUserInfo();
        if (updatedUserInfo != null) {
          emit(UserUpdated(updatedUserInfo));
        } else {
          emit(UserError('更新用户信息失败'));
        }
      } catch (e) {
        emit(UserError('更新用户信息失败: $e'));
      }
    });
  }
} 