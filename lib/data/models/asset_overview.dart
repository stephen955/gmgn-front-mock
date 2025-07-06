class AssetOverview {
  final String symbol;
  final String icon;
  final double balance;
  final String balanceUnit;
  final bool showBalance;

  AssetOverview({
    required this.symbol,
    required this.icon,
    required this.balance,
    required this.balanceUnit,
    required this.showBalance,
  });

  factory AssetOverview.fromJson(Map<String, dynamic> json) {
    return AssetOverview(
      symbol: json['symbol'],
      icon: json['icon'],
      balance: (json['balance'] as num).toDouble(),
      balanceUnit: json['balance_unit'],
      showBalance: json['show_balance'],
    );
  }
}

class PnlStats {
  final double realizedProfitPercent;
  final double realizedProfitAmount;
  final String realizedProfitUnit;
  final double winRate;
  final List<num> chart;

  PnlStats({
    required this.realizedProfitPercent,
    required this.realizedProfitAmount,
    required this.realizedProfitUnit,
    required this.winRate,
    required this.chart,
  });

  factory PnlStats.fromJson(Map<String, dynamic> json) {
    return PnlStats(
      realizedProfitPercent: (json['realized_profit_percent'] as num).toDouble(),
      realizedProfitAmount: (json['realized_profit_amount'] as num).toDouble(),
      realizedProfitUnit: json['realized_profit_unit'],
      winRate: (json['win_rate'] as num).toDouble(),
      chart: List<num>.from(json['chart']),
    );
  }
}

class AnalysisStats {
  final String totalProfit;
  final String unrealizedProfit;
  final String avgHoldTime7d;
  final String totalCost7d;
  final String avgBuyCost7d;
  final String avgRealizedProfit7d;

  AnalysisStats({
    required this.totalProfit,
    required this.unrealizedProfit,
    required this.avgHoldTime7d,
    required this.totalCost7d,
    required this.avgBuyCost7d,
    required this.avgRealizedProfit7d,
  });

  factory AnalysisStats.fromJson(Map<String, dynamic> json) {
    return AnalysisStats(
      totalProfit: json['total_profit'],
      unrealizedProfit: json['unrealized_profit'],
      avgHoldTime7d: json['avg_hold_time_7d'],
      totalCost7d: json['total_cost_7d'],
      avgBuyCost7d: json['avg_buy_cost_7d'],
      avgRealizedProfit7d: json['avg_realized_profit_7d'],
    );
  }
}

class ProfitDistributionItem {
  final String label;
  final int value;

  ProfitDistributionItem({required this.label, required this.value});

  factory ProfitDistributionItem.fromJson(Map<String, dynamic> json) {
    return ProfitDistributionItem(
      label: json['label'],
      value: json['value'],
    );
  }
}

class PhishingDetectionItem {
  final String label;
  final int value;
  final int percent;

  PhishingDetectionItem({
    required this.label,
    required this.value,
    required this.percent,
  });

  factory PhishingDetectionItem.fromJson(Map<String, dynamic> json) {
    return PhishingDetectionItem(
      label: json['label'],
      value: json['value'],
      percent: json['percent'],
    );
  }
}

class AssetPageData {
  final AssetOverview wallet;
  final PnlStats pnl;
  final AnalysisStats analysis;
  final List<ProfitDistributionItem> profitDistribution;
  final List<PhishingDetectionItem> phishingDetection;

  AssetPageData({
    required this.wallet,
    required this.pnl,
    required this.analysis,
    required this.profitDistribution,
    required this.phishingDetection,
  });

  factory AssetPageData.fromJson(Map<String, dynamic> json) {
    return AssetPageData(
      wallet: AssetOverview.fromJson(json['wallet']),
      pnl: PnlStats.fromJson(json['pnl']),
      analysis: AnalysisStats.fromJson(json['analysis']),
      profitDistribution: (json['profit_distribution'] as List)
          .map((e) => ProfitDistributionItem.fromJson(e))
          .toList(),
      phishingDetection: (json['phishing_detection'] as List)
          .map((e) => PhishingDetectionItem.fromJson(e))
          .toList(),
    );
  }
} 