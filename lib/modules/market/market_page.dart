import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'market_view.dart';
import '../../models/chain_rank_models.dart';

@RoutePage()
class MarketPage extends StatelessWidget {
  final ChainRankToken token;

  const MarketPage({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    // 生成模拟的K线数据
    final candles = _generateMockCandles();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: MarketDetailView(
          symbol: token.name,
          iconUrl: token.logo,
          price: _calculatePrice(), // 使用计算的价格
          change: token.progress.toDouble() * 100, // 将进度转换为百分比
          marketCap: token.usdMarketCap.toDouble(), // 转换为double
          volume24h: token.volume1h.toDouble(), // 转换为double
          candles: candles,
        ),
      ),
    );
  }

  double _calculatePrice() {
    // 基于市值和流动性计算一个合理的价格
    if (token.usdMarketCap > 0 && token.holderCount > 0) {
      // 简单的价格计算逻辑，实际应用中可能需要更复杂的算法
      return (token.usdMarketCap / token.holderCount) * 0.0001;
    }
    return 0.0001; // 默认价格
  }

  List<ChartCandle> _generateMockCandles() {
    final now = DateTime.now();
    final candles = <ChartCandle>[];
    final basePrice = _calculatePrice();
    
    for (int i = 0; i < 50; i++) {
      final time = now.subtract(Duration(minutes: (50 - i) * 5));
      final random = (i % 10) / 10.0;
      
      candles.add(ChartCandle(
        time: time,
        open: basePrice * (1 + random * 0.1),
        high: basePrice * (1 + random * 0.15),
        low: basePrice * (1 - random * 0.05),
        close: basePrice * (1 + random * 0.08),
        volume: token.volume1h.toDouble() * (0.8 + random * 0.4),
        maVol5: token.volume1h.toDouble() * (0.7 + random * 0.6),
        maVol10: token.volume1h.toDouble() * (0.6 + random * 0.8),
      ));
    }
    
    return candles;
  }
} 