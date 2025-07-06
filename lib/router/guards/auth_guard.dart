import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/auth/services/token_storage_service.dart';
import '../../modules/auth/bloc/auth_bloc.dart';
import '../../modules/auth/bloc/auth_state.dart';
import '../app_router.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_event.dart';

/// 认证路由守卫
/// 修改：不再自动跳转到登录页面，让页面自己处理未登录状态
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasValidAuth = await TokenStorageService.hasValidAuth();
    if (hasValidAuth) {
      resolver.next(true);
    } else {
      // 不再自动跳转到登录页面，允许页面自己处理未登录状态
      resolver.next(true);
    }
  }
}

/// 游客路由守卫（已登录用户不能访问）
class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    print('GuestGuard: 检查认证状态...');
    final hasValidAuth = await TokenStorageService.hasValidAuth();
    print('GuestGuard: hasValidAuth = $hasValidAuth');
    if (hasValidAuth) {
      print('GuestGuard: 用户已登录，重定向到 AssetRoute');
      router.replaceAll([const AssetRoute()]);
      resolver.next(false);
    } else {
      print('GuestGuard: 用户未登录，允许访问登录/注册页面');
      resolver.next(true);
    }
  }
}

/// 认证状态检查 Mixin
mixin AuthStateMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // 在 Bloc 架构中，认证状态由 AuthBloc 管理
    // 这里可以添加其他初始化逻辑
  }
}

/// 认证状态监听 Widget
class AuthStateListener extends StatelessWidget {
  final Widget child;
  final Function(AuthState status)? onAuthStatusChanged;

  const AuthStateListener({
    required this.child,
    this.onAuthStatusChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // 监听认证状态变化
        onAuthStatusChanged?.call(state);
      },
      child: child,
    );
  }
} 