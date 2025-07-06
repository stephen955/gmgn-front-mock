import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/modules/auth/bloc/user_event.dart';
import 'package:gmgn_front/modules/auth/repositories/auth_repository.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_event.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_state.dart';
import 'package:gmgn_front/modules/auth/bloc/user_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserBloc userBloc;

  AuthBloc({required this.userBloc}) : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthRepository.login(email: event.email, password: event.password);
      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(result.data!.token, result.data!.userId));
        userBloc.add(UserFetchRequested(result.data!.token));
      } else {
        emit(AuthError(result.message ?? '登录失败'));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthRepository.register(username: event.username, email: event.email);
      if (result.isSuccess) {
        emit(AuthInitial()); // 注册成功后回到初始状态
      } else {
        emit(AuthError(result.message ?? '注册失败'));
      }
    });

    on<AuthForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthRepository.forgotPassword(email: event.email);
      if (result.isSuccess) {
        emit(AuthInitial()); // 忘记密码成功后回到初始状态
      } else {
        emit(AuthError(result.message ?? '忘记密码请求失败'));
      }
    });

    on<AuthAppleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthRepository.appleLogin();
      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(result.data!.token, result.data!.userId));
        userBloc.add(UserFetchRequested(result.data!.token));
      } else {
        emit(AuthError(result.message ?? 'Apple登录失败'));
      }
    });

    on<AuthTelegramLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthRepository.telegramLogin(telegramPayload: event.telegramPayload ?? {});
      if (result.isSuccess && result.data != null) {
        emit(AuthAuthenticated(result.data!.token, result.data!.userId));
        userBloc.add(UserFetchRequested(result.data!.token));
      } else {
        emit(AuthError(result.message ?? 'Telegram登录失败'));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await AuthRepository.logout();
      emit(AuthInitial());
    });

    on<AuthLoggedIn>((event, emit) async {
      emit(AuthAuthenticated(event.token, event.userId));
      userBloc.add(UserFetchRequested(event.token));
    });
  }
} 