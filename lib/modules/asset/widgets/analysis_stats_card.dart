import 'package:flutter/material.dart';
import '../../../data/models/asset_overview.dart';

class AnalysisStatsCard extends StatefulWidget {
  final List<String> tabs;
  final String period;
  final Map<String, String> stats;
  final List<ProfitDistributionItem> profitDistribution;
  final List<PhishingDetectionItem> phishingDetection;
  final PnlStats pnl;
  final void Function(int)? onTabChanged;

  const AnalysisStatsCard({
    Key? key,
    required this.tabs,
    required this.period,
    required this.stats,
    required this.profitDistribution,
    required this.phishingDetection,
    required this.pnl,
    this.onTabChanged,
  }) : super(key: key);

  @override
  _AnalysisCardState createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisStatsCard> {
  int _selectedIndex = 0;

  // 样式常量
  static const _cardMargin = EdgeInsets.symmetric(horizontal: 8);
  static const _cardRadius = BorderRadius.all(Radius.circular(12));
  static const _cardColor = Color(0xFFF9F9F9);

  static const _labelStyle = TextStyle(
    fontSize: 14, color: Color(0xFF666666), height: 1.2,
  );
  static const _valueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF333333),
    height: 1.2,
  );

  static const _tabPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
  static const _tabRadius = BorderRadius.all(Radius.circular(6));
  static const _tabSelectedBg = Color(0xFF333333);
  static const _tabUnselectedBg = Color(0xFFF5F5F5);
  static const _tabSelectedText = Colors.white;
  static const _tabUnselectedText = Color(0xFF999999);

  static const _periodPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const _periodBg = Color(0xFFF5F5F5);
  static const _periodRadius = BorderRadius.all(Radius.circular(16));
  static const _periodTextStyle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: Color(0xFF333333), height: 1.2,
  );

  static const _itemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _cardMargin,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: _cardRadius,
      ),
      child: Column(
        children: [
          _buildTabsRow(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildTabsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.tabs.asMap().entries.map((e) {
                  final selected = e.key == _selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedIndex = e.key);
                      widget.onTabChanged?.call(e.key);
                    },
                    child: Container(
                      padding: _tabPadding,
                      decoration: BoxDecoration(
                        color: selected ? _tabSelectedBg : _tabUnselectedBg,
                        borderRadius: _tabRadius,
                      ),
                      child: Text(
                        e.value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                          color: selected ? _tabSelectedText : _tabUnselectedText,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            padding: _periodPadding,
            decoration: BoxDecoration(
              color: _periodBg,
              borderRadius: _periodRadius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.period, style: _periodTextStyle),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Color(0xFF666666)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildPnLContent();
      case 1:
        return _buildStatsList();
      case 2:
        return _buildDistributionContent();
      case 3:
        return _buildPhishingContent();
      default:
        return _buildStatsList();
    }
  }

  Widget _buildPnLContent() {
    // PnL 内容 - 用 widget.pnl 数据
    const barColor = Color(0xFF333333);
    const barWidth = 8.0;
    const barHeight = 40.0;
    const dashSize = 4.0;
    const dashCount = 20;
    const dashColor = Color(0xFFCCCCCC);
    return Padding(
      padding: _itemPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('已实现利润', style: _labelStyle),
              Text('胜率 ${widget.pnl.winRate.toStringAsFixed(0)}%', style: _valueStyle),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '+${widget.pnl.realizedProfitPercent.toStringAsFixed(1)}% (+${widget.pnl.realizedProfitAmount} ${widget.pnl.realizedProfitUnit})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00C851),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // 柱状图和虚线基线（可根据 widget.pnl.chart 渲染更复杂图表，这里保持原样）
          Column(
            children: [
              SizedBox(
                height: barHeight,
                child: Center(
                  child: Container(
                    width: barWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(barWidth / 2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: dashSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (_) {
                    return Container(
                      width: dashSize,
                      height: dashSize,
                      decoration: BoxDecoration(
                        color: dashColor,
                        borderRadius: BorderRadius.circular(dashSize / 2),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsList() {
    return Column(
      children: widget.stats.entries.map((e) {
        return Padding(
          padding: _itemPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.key, style: _labelStyle),
              Text(e.value, style: _valueStyle),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistributionContent() {
    // 用 widget.profitDistribution 数据
    final items = widget.profitDistribution;
    // legend 配色顺序与 label 保持一致
    final colors = [
      Color(0xFF00C851),
      Color(0xFF66BB6A),
      Color(0xFFCCCCCC),
      Color(0xFFFFA726),
      Color(0xFFFF4444),
    ];
    const countStyle = TextStyle(fontSize: 14, color: Color(0xFF333333));
    const labelStyle = TextStyle(fontSize: 14, color: Color(0xFF666666));
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左边 legend 列
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(items[i].label, style: labelStyle),
                  ],
                ),
              );
            }),
          ),
          const Spacer(),
          // 右边 count 列
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(items.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(items[i].value.toString(), style: countStyle),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPhishingContent() {
    // 用 widget.phishingDetection 数据
    final items = widget.phishingDetection;
    const dotSize = 8.0;
    const dotColor = Color(0xFF00C851);
    const labelStyle = TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.2);
    const valueStyle = TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.2);
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    return Padding(
      padding: padding,
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: dotSize, height: dotSize,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(item.label + '：', style: labelStyle),
                const Spacer(),
                Text('${item.value} (${item.percent}%)', style: valueStyle),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: FakePage()),
      ),
    );
  }
}

class FakePage extends StatelessWidget {
  const FakePage({super.key});
  @override
  Widget build(BuildContext context) {
    final fakeStats = {
      '总盈亏': '-0.145 SOL (-79.76%)',
      '未实现利润': '0.052 SOL',
      '7d 平均持仓时长': '12h 30m',
      '7d 买入总成本': '1.234 SOL',
      '7d 代币平均买入成本': '0.123 SOL',
      '7d 代币平均实现利润': '0.010 SOL',
    };
    final fakeProfitDistribution = [
      ProfitDistributionItem(label: '>500%', value: 2),
      ProfitDistributionItem(label: '200%~500%', value: 5),
      ProfitDistributionItem(label: '0%~200%', value: 8),
      ProfitDistributionItem(label: '0%~-50%', value: 3),
      ProfitDistributionItem(label: '<-50%', value: 1),
    ];
    final fakePhishingDetection = [
      PhishingDetectionItem(label: '黑名单', value: 1, percent: 5),
      PhishingDetectionItem(label: '未购买', value: 2, percent: 10),
      PhishingDetectionItem(label: '卖出量大于买入量', value: 0, percent: 0),
      PhishingDetectionItem(label: '十秒内完成买/卖', value: 4, percent: 20),
    ];
    final fakePnl = PnlStats(
      realizedProfitPercent: -79.76,
      realizedProfitAmount: -0.145,
      realizedProfitUnit: 'SOL',
      winRate: 0,
      chart: [0, 0, 0, 0, 0, 0, 0],
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          AnalysisStatsCard(
            tabs: ['PnL', '分析', '盈利分布', '钓鱼检测'],
            period: '7d',
            stats: fakeStats,
            profitDistribution: fakeProfitDistribution,
            phishingDetection: fakePhishingDetection,
            pnl: fakePnl,
          ),
        ],
      ),
    );
  }
}