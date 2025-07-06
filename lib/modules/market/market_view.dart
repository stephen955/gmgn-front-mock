// market_detail_view.dart

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';

/// 蜡烛图数据模型，包含成交量和 MAVOL5/MAVOL10
class ChartCandle {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;   // 成交量
  final double maVol5;   // MAVOL5
  final double maVol10;  // MAVOL10

  ChartCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.maVol5,
    required this.maVol10,
  });
}

/// 主组件：市场详情视图
class MarketDetailView extends StatelessWidget {
  final String symbol;
  final String iconUrl;
  final double price;
  final double change;      // 百分比，例如 8.19
  final double marketCap;   // 单位 K
  final double volume24h;   // 单位 USD
  final List<ChartCandle> candles;

  const MarketDetailView({
    Key? key,
    required this.symbol,
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.marketCap,
    required this.volume24h,
    required this.candles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(symbol: symbol, iconUrl: iconUrl),
        const _Tabs(),
        _PriceInfo(
          symbol: symbol,
          iconUrl: iconUrl,
          price: price,
          change: change,
          marketCap: marketCap,
          volume24h: volume24h,
        ),
        const SizedBox(height: 8),
        Expanded(child: _ChartSection(candles: candles)),
        const _IndicatorBar(),
        _TradePanel(symbol: symbol),
      ],
    );
  }
}

/// 顶部 Header
class _Header extends StatelessWidget {
  final String symbol;
  final String iconUrl;

  const _Header({Key? key, required this.symbol, required this.iconUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.router.pop(),
            child: const Icon(Icons.arrow_back_ios, size: 18),
          ),
          Row(
            children: [
              ClipOval(
                child: Image.network(iconUrl, width: 32, height: 32, fit: BoxFit.cover),
              ),
              const SizedBox(width: 8),
              Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medication, size: 10, color: Colors.white),
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.notifications_none),
              SizedBox(width: 12),
              Icon(Icons.star_border),
            ],
          ),
        ],
      ),
    );
  }
}

/// 横向滑动 Tabs
class _Tabs extends StatelessWidget {
  const _Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = [
      '行情', '活动', '持有者(6)', '我的交易', '持有代币', '开发者代币', '池信息'
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: tabs.length,
        itemBuilder: (_, idx) {
          final isActive = idx == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Text(
                  tabs[idx],
                  style: TextStyle(
                    fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
                if (isActive) const SizedBox(height: 4),
                if (isActive)
                  Container(width: 20, height: 2, color: Colors.black),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 价格信息区
class _PriceInfo extends StatelessWidget {
  final String symbol;
  final String iconUrl;
  final double price;
  final double change;
  final double marketCap;
  final double volume24h;

  const _PriceInfo({
    Key? key,
    required this.symbol,
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.marketCap,
    required this.volume24h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changeColor = change >= 0 ? Colors.green : Colors.red;
    final changeStr = change >= 0
        ? '+${change.toStringAsFixed(2)}%'
        : '${change.toStringAsFixed(2)}%';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$${price.toStringAsFixed(7)} $changeStr',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: changeColor),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.search, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Icon(Icons.menu, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('8KxX...pump', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 4),
              Icon(Icons.copy, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('总市值 \$${marketCap.toStringAsFixed(2)}K',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(width: 20),
              Text('24h成交额 \$${volume24h.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

/// 一行 Chart：K线 + 成交量 + 均线，支持平移/缩放，且上、下图分开
class _ChartSection extends StatelessWidget {
  final List<ChartCandle> candles;
  final ZoomPanBehavior _zoomPan = ZoomPanBehavior(
    enablePanning: true,
    enablePinching: true,
    zoomMode: ZoomMode.x,
    maximumZoomLevel: 20,
  );

  _ChartSection({Key? key, required this.candles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // 上半区：K 线图
          Expanded(
            flex: 7,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
              zoomPanBehavior: _zoomPan,
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.minutes,
                dateFormat: DateFormat.Hm(),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              primaryYAxis: NumericAxis(
                opposedPosition: true,
                majorGridLines: const MajorGridLines(width: 0.3),
                axisLine: const AxisLine(width: 0),
                labelStyle: const TextStyle(fontSize: 10),
                majorTickLines: const MajorTickLines(size: 0),
              ),

              series: <CartesianSeries<ChartCandle, DateTime>>[
                CandleSeries<ChartCandle, DateTime>(
                  dataSource: candles,
                  xValueMapper: (c, _) => c.time,
                  lowValueMapper: (c, _) => c.low,
                  highValueMapper: (c, _) => c.high,
                  openValueMapper: (c, _) => c.open,
                  closeValueMapper: (c, _) => c.close,
                  bullColor: Colors.green,
                  bearColor: Colors.red,
                ),
              ],
              crosshairBehavior: CrosshairBehavior(
                enable: true,
                lineType: CrosshairLineType.horizontal,
                lineDashArray: <double>[5, 5],
                activationMode: ActivationMode.singleTap,
                hideDelay: 3000,
              ),
              tooltipBehavior: TooltipBehavior(enable: false),
            ),
          ),

          const SizedBox(height: 8),
          // 下半区：成交量 + 均线
          Expanded(
            flex: 3,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              backgroundColor: Colors.transparent,
              zoomPanBehavior: _zoomPan,
              primaryXAxis: DateTimeAxis(
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              primaryYAxis: NumericAxis(isVisible: false),
              series: <CartesianSeries<ChartCandle, DateTime>>[
                ColumnSeries<ChartCandle, DateTime>(
                  dataSource: candles,
                  xValueMapper: (d, _) => d.time,
                  yValueMapper: (d, _) => d.volume,
                  color: Colors.green.withOpacity(0.7),
                ),
                LineSeries<ChartCandle, DateTime>(
                  dataSource: candles,
                  xValueMapper: (d, _) => d.time,
                  yValueMapper: (d, _) => d.maVol5,
                  color: const Color(0xFFFF9500),
                  width: 2,
                ),
                LineSeries<ChartCandle, DateTime>(
                  dataSource: candles,
                  xValueMapper: (d, _) => d.time,
                  yValueMapper: (d, _) => d.maVol10,
                  color: const Color(0xFF00BFFF),
                  width: 2,
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: false),
            ),
          ),
        ],
      ),
    );
  }
}

/// 技术指标横向滚动条
class _IndicatorBar extends StatelessWidget {
  const _IndicatorBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = [
      'MA', 'EMA', 'BOLL', 'SAR', '|', 'VOL', 'MACD', 'KDJ',
      'RSI', 'StochRsi', 'TRIX', 'OBV', 'WR', 'CCI', 'ROC'
    ];
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, idx) => Text(
          items[idx],
          style: TextStyle(
            color: idx == 5 ? Colors.black : Colors.grey,
            fontSize: 12,
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}

/// 下单区
class _TradePanel extends StatelessWidget {
  final String symbol;

  const _TradePanel({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buyButtons = ['0.01', '0.1', '0.5', '1'];
    final sellButtons = ['25%', '50%', '75%', '100%'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('点击立即提交市价单',
              style: TextStyle(color: Colors.orange, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('买入',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Text('余额 0 SOL',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 4),
                  Icon(Icons.add_circle_outline,
                      size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: buyButtons.map((v) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F8EC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(v, style: const TextStyle(color: Colors.green)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('卖出',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('余额 0 $symbol (0 SOL)',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: sellButtons.map((v) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(v, style: const TextStyle(color: Colors.red)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
