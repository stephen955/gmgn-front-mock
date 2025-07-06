class TrackCardModel {
  final String address;
  final String name;
  final String logo;
  final double price;
  final int holderCount;
  final double marketCap;
  final int swaps;
  final int buys;
  final int sells;
  final double volume;
  final List<TrackWalletModel> wallets;

  double get pnlPercent => wallets.isNotEmpty ? wallets[0].pnlPercent : 0;
  int get winTradeCount => buys;
  int get loseTradeCount => sells;
  double get winRate => (buys + sells) > 0 ? (buys / (buys + sells) * 100) : 0;
  int get followers => holderCount;
  String get chainLogo => wallets.isNotEmpty ? wallets[0].chainLogo : '';
  String get timeInfo => wallets.isNotEmpty ? _formatTime(wallets[0].balanceTs) : '';
  String get avatar => logo;
  double get profit => wallets.isNotEmpty ? wallets[0].profit : 0;
  double get totalValue => marketCap;
  int get tradeCount => swaps;

  TrackCardModel({
    required this.address,
    required this.name,
    required this.logo,
    required this.price,
    required this.holderCount,
    required this.marketCap,
    required this.swaps,
    required this.buys,
    required this.sells,
    required this.volume,
    required this.wallets,
  });

  factory TrackCardModel.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is double) return v.toInt();
      if (v is num) return v.toInt();
      return 0;
    }
    double _parseDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      if (v is num) return v.toDouble();
      return 0.0;
    }
    return TrackCardModel(
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      price: _parseDouble(json['price']),
      holderCount: _parseInt(json['holder_count']),
      marketCap: _parseDouble(json['market_cap']),
      swaps: _parseInt(json['swaps']),
      buys: _parseInt(json['buys']),
      sells: _parseInt(json['sells']),
      volume: _parseDouble(json['volume']),
      wallets: (json['wallets'] as List<dynamic>? ?? [])
          .map((e) => TrackWalletModel.fromJson(e))
          .toList(),
    );
  }

  static String _formatTime(int ts) {
    if (ts == 0) return '';
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final diff = now - ts;
    if (diff < 60) return '${diff}秒以前';
    if (diff < 3600) return '${diff ~/ 60}分以前';
    if (diff < 86400) return '${diff ~/ 3600}小时以前';
    return '${diff ~/ 86400}天以前';
  }
}

class TrackWalletModel {
  final String name;
  final String avatar;
  final String walletAddress;
  final double netInflow;
  final double amountTotal;
  final int buys;
  final int sells;
  final String side;
  final int balanceTs;
  final String twitterUsername;
  final String twitterName;

  double get pnlPercent => 0;
  double get profit => netInflow;
  String get chainLogo => '';

  TrackWalletModel({
    required this.name,
    required this.avatar,
    required this.walletAddress,
    required this.netInflow,
    required this.amountTotal,
    required this.buys,
    required this.sells,
    required this.side,
    required this.balanceTs,
    required this.twitterUsername,
    required this.twitterName,
  });

  factory TrackWalletModel.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is double) return v.toInt();
      if (v is num) return v.toInt();
      return 0;
    }
    double _parseDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      if (v is num) return v.toDouble();
      return 0.0;
    }
    return TrackWalletModel(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      walletAddress: json['wallet_address'] ?? '',
      netInflow: _parseDouble(json['net_inflow']),
      amountTotal: _parseDouble(json['amount_total']),
      buys: _parseInt(json['buys']),
      sells: _parseInt(json['sells']),
      side: json['side'] ?? '',
      balanceTs: _parseInt(json['balance_ts']),
      twitterUsername: json['twitter_username'] ?? '',
      twitterName: json['twitter_name'] ?? '',
    );
  }
} 