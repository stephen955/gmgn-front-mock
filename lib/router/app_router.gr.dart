// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AssetPage]
class AssetRoute extends PageRouteInfo<void> {
  const AssetRoute({List<PageRouteInfo>? children})
    : super(AssetRoute.name, initialChildren: children);

  static const String name = 'AssetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AssetPage();
    },
  );
}

/// generated route for
/// [DiscoverPage]
class DiscoverRoute extends PageRouteInfo<void> {
  const DiscoverRoute({List<PageRouteInfo>? children})
    : super(DiscoverRoute.name, initialChildren: children);

  static const String name = 'DiscoverRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DiscoverPage();
    },
  );
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [MarketPage]
class MarketRoute extends PageRouteInfo<MarketRouteArgs> {
  MarketRoute({
    Key? key,
    required ChainRankToken token,
    List<PageRouteInfo>? children,
  }) : super(
         MarketRoute.name,
         args: MarketRouteArgs(key: key, token: token),
         initialChildren: children,
       );

  static const String name = 'MarketRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MarketRouteArgs>();
      return MarketPage(key: args.key, token: args.token);
    },
  );
}

class MarketRouteArgs {
  const MarketRouteArgs({this.key, required this.token});

  final Key? key;

  final ChainRankToken token;

  @override
  String toString() {
    return 'MarketRouteArgs{key: $key, token: $token}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MarketRouteArgs) return false;
    return key == other.key && token == other.token;
  }

  @override
  int get hashCode => key.hashCode ^ token.hashCode;
}

/// generated route for
/// [MonitorPage]
class MonitorRoute extends PageRouteInfo<void> {
  const MonitorRoute({List<PageRouteInfo>? children})
    : super(MonitorRoute.name, initialChildren: children);

  static const String name = 'MonitorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return MonitorPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [TrackPage]
class TrackRoute extends PageRouteInfo<void> {
  const TrackRoute({List<PageRouteInfo>? children})
    : super(TrackRoute.name, initialChildren: children);

  static const String name = 'TrackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TrackPage();
    },
  );
}
