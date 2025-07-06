import 'package:flutter/material.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_event.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'package:gmgn_front/l10n/app_localizations.dart';
import 'core/theme/theme_notifier.dart';
import 'core/theme/app_theme.dart';
import 'router/guards/auth_guard.dart';
import 'modules/discover/discover_page.dart';
import 'modules/track/track_page.dart';
import 'modules/monitor/monitor_page.dart';
import 'modules/asset/asset_page.dart';
import 'l10n/l10n_extension.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/auth/bloc/auth_bloc.dart';
import 'modules/auth/bloc/user_bloc.dart';
import 'modules/auth/providers/user_provider.dart';
import 'shared/utils/chain_cubit.dart';
import 'package:gmgn_front/modules/auth/services/token_storage_service.dart';

class App extends StatefulWidget {
  final String? initialToken;
  final String? initialUserId;

  const App({this.initialToken, this.initialUserId, super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(
              create: (context) => UserBloc(),
            ),
            BlocProvider<AuthBloc>(
              create: (context) {
                final bloc = AuthBloc(
                  userBloc: BlocProvider.of<UserBloc>(context),
                );
                if (widget.initialToken != null && widget.initialUserId != null) {
                  bloc.add(AuthLoggedIn(widget.initialToken!, widget.initialUserId!));
                }
                return bloc;
              },
            ),
            BlocProvider<ChainCubit>(
              create: (_) => ChainCubit(),
            ),
          ],
          child: Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return MaterialApp.router(
                title: 'GMGN AI',
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: AppTheme.lightTheme.copyWith(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                darkTheme: AppTheme.darkTheme.copyWith(
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                themeMode: themeNotifier.themeMode,
                routerConfig: AppRouter().config(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: AuthStateListener(
                      onAuthStatusChanged: (status) {
                        // 监听认证状态变化，可以在这里处理自动登录等逻辑
                        debugPrint('认证状态变化: $status');
                      },
                      child: child!,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        DiscoverRoute(),
        TrackRoute(),
        MonitorRoute(),
        AssetRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        // 监听 tab 变化
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_tabController.index != tabsRouter.activeIndex) {
            _tabController.animateTo(tabsRouter.activeIndex);
          }
        });

        return Scaffold(
          body: child,
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 1,
                    color: const Color(0xFFF2F2F2), // 顶部分割线
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          context,
                          index: 0,
                          icon: Icons.explore,
                          label: context.l10n.discover,
                          tabsRouter: tabsRouter,
                        ),
                        _buildNavItem(
                          context,
                          index: 1,
                          icon: Icons.emoji_events,
                          label: context.l10n.leaderboard,
                          tabsRouter: tabsRouter,
                        ),
                        _buildNavItem(
                          context,
                          index: 2,
                          icon: Icons.monitor_heart,
                          label: context.l10n.monitor,
                          tabsRouter: tabsRouter,
                        ),
                        _buildNavItem(
                          context,
                          index: 3,
                          icon: Icons.account_balance_wallet,
                          label: context.l10n.asset,
                          tabsRouter: tabsRouter,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required TabsRouter tabsRouter,
  }) {
    final bool selected = tabsRouter.activeIndex == index;
    return GestureDetector(
      onTap: () {
        tabsRouter.setActiveIndex(index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFF72F5E5) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
