import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/modules/asset/widgets/analysis_stats_card.dart';
import 'package:gmgn_front/router/app_router.dart';
import '../../shared/widgets/asset_overview_card.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../../core/theme/app_theme_context_ext.dart';
import 'package:gmgn_front/core/theme/app_theme_extensions.dart';
import 'package:gmgn_front/l10n/l10n_extension.dart';
import 'package:gmgn_front/modules/asset/widgets/wallet_info_tile.dart';
import 'package:gmgn_front/shared/utils/chain_cubit.dart';
import 'bloc/asset_cubit.dart';
import 'bloc/asset_state.dart';
import '../../data/repositories/asset_repository.dart';

@RoutePage()
class AssetPage extends StatelessWidget {
  const AssetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssetCubit(AssetRepository())..fetchAssetData(),
      child: const AssetView(),
    );
  }
}

class AssetView extends StatelessWidget {
  const AssetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;
    final currentChain = context.watch<ChainCubit>().state;
    return BlocBuilder<AssetCubit, AssetState>(
      builder: (context, state) {
        if (state is AssetLoading || state is AssetInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AssetLoaded) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              titleSpacing: 16,
              title: const WalletInfoTile(),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    AssetOverviewCard(
                      tokenName: state.data.wallet.symbol,
                      // 你可以根据 AssetOverviewCard 需要传递更多参数
                    ),
                    const SizedBox(height: 16),
                    AnalysisStatsCard(
                      tabs: ['PnL', '分析', '盈利分布', '钓鱼检测'],
                      period: '7d',
                      stats: {
                        '总盈亏': state.data.analysis.totalProfit,
                        '未实现利润': state.data.analysis.unrealizedProfit,
                        '7d 平均持仓时长': state.data.analysis.avgHoldTime7d,
                        '7d 买入总成本': state.data.analysis.totalCost7d,
                        '7d 代币平均买入成本': state.data.analysis.avgBuyCost7d,
                        '7d 代币平均实现利润': state.data.analysis.avgRealizedProfit7d,
                      },
                      profitDistribution: state.data.profitDistribution,
                      phishingDetection: state.data.phishingDetection,
                      pnl: state.data.pnl,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        } else if (state is AssetError) {
          return Center(child: Text('加载失败: \\${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class AssetsContentUnlogged extends StatelessWidget {
  final AppColorsExtension colors;
  final AppSpacingExtension spacing;
  final AppTypographyExtension typography;
  final VoidCallback? onRegister;
  final VoidCallback? onLogin;

  const AssetsContentUnlogged({
    super.key,
    required this.colors,
    required this.spacing,
    required this.typography,
    this.onRegister,
    this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyles = context.appButtonStyles;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '更快发现，秒级交易 🚀',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF222222),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              '快速上链操作，一键交易；自动止盈止损。',
              style: TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  width: 120,
                  child: OutlinedButton(
                    onPressed: onRegister ?? () {
                      print('onRegister button pressed');
                      try {
                        AutoRouter.of(context).push(const RegisterRoute());
                        print('RegisterRoute pushed successfully');
                      } catch (e) {
                        print('Error pushing RegisterRoute: $e');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color:Color(0xFFE8E8E8), width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      context.l10n.register,
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onLogin ?? () {
                      print('onLogin button pressed');
                      try {
                        AutoRouter.of(context).push(const LoginRoute());
                        print('LoginRoute pushed successfully');
                      } catch (e) {
                        print('Error pushing LoginRoute: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2CF6ED),
                      foregroundColor: Color(0xFF222222),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color:Color(0xFFE8E8E8), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      context.l10n.login,
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}