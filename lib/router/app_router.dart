import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../modules/asset/asset_page.dart';
import '../modules/auth/view/login_page.dart';
import '../modules/auth/view/register_page.dart';
import '../modules/auth/view/forgot_password_page.dart';
import '../modules/track/track_page.dart';
import '../modules/discover/discover_page.dart';
import '../modules/monitor/monitor_page.dart';
import '../modules/market/market_page.dart';
import '../models/chain_rank_models.dart';
import '../app.dart';
import 'guards/auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 主页面路由（包含底部导航栏）
    AutoRoute(
      page: MainRoute.page, 
      initial: true,
      children: [
        AutoRoute(
          page: DiscoverRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: TrackRoute.page,
        ),
        AutoRoute(
          page: MonitorRoute.page,
        ),
        AutoRoute(
          page: AssetRoute.page,
        ),
      ],
    ),
    
    // 市场详情页面
    AutoRoute(
      page: MarketRoute.page,
    ),
    
    // 游客路由（已登录用户不能访问）
    AutoRoute(
      page: LoginRoute.page,
      guards: [GuestGuard()],
    ),
    AutoRoute(
      page: RegisterRoute.page,
      guards: [GuestGuard()],
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
      guards: [GuestGuard()],
    ),
  ];
}
