/// Monitor 模块数据模型，包含SmartCards响应结构与卡片详情
import '../../models/base_response.dart';

// 类型兼容工具
num _parseNum(dynamic v) {
  if (v is num) return v;
  if (v is String) return num.tryParse(v) ?? 0;
  return 0;
}

double _parseDouble(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

int _parseInt(dynamic v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  if (v is double) return v.toInt();
  if (v is num) return v.toInt();
  return 0;
}

class SmartCardsResponse extends BaseResponse {
  final SmartCardsData data;

  SmartCardsResponse({
    required int code,
    required String reason,
    required String message,
    required this.data,
  }) : super(code: code, reason: reason, message: message);

  factory SmartCardsResponse.fromJson(Map<String, dynamic> json) {
    return SmartCardsResponse(
      code: _parseInt(json['code']),
      reason: json['reason'] ?? '',
      message: json['message'] ?? '',
      data: SmartCardsData.fromJson(json['data'] ?? {}),
    );
  }
}

class SmartCardsData {
  final List<SmartCard> cards;
  final int total;
  final int page;
  final int pageSize;

  SmartCardsData({
    required this.cards,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory SmartCardsData.fromJson(Map<String, dynamic> json) {
    return SmartCardsData(
      cards: (json['cards'] as List<dynamic>? ?? [])
          .map((e) => SmartCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: _parseInt(json['total']),
      page: _parseInt(json['page']),
      pageSize: _parseInt(json['page_size']),
    );
  }
}

class SmartCard {
  final String symbol;
  final String name;
  final String logo;
  final String address;
  final num price;
  final num priceChange24h;
  final num priceChangePercent24h;
  final num volume24h;
  final num marketCap;
  final num liquidity;
  final int holderCount;
  final int buyCount;
  final int sellCount;
  final num netInflow;
  final List<WalletInfo> wallets;
  final String timeInfo;
  final int createdTimestamp;

  SmartCard({
    required this.symbol,
    required this.name,
    required this.logo,
    required this.address,
    required this.price,
    required this.priceChange24h,
    required this.priceChangePercent24h,
    required this.volume24h,
    required this.marketCap,
    required this.liquidity,
    required this.holderCount,
    required this.buyCount,
    required this.sellCount,
    required this.netInflow,
    required this.wallets,
    required this.timeInfo,
    required this.createdTimestamp,
  });

  factory SmartCard.fromJson(Map<String, dynamic> json) {
    return SmartCard(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      address: json['address'] ?? '',
      price: _parseNum(json['price']),
      priceChange24h: _parseNum(json['price_change_24h']),
      priceChangePercent24h: _parseNum(json['price_change_percent_24h']),
      volume24h: _parseNum(json['volume_24h']),
      marketCap: _parseNum(json['market_cap']),
      liquidity: _parseNum(json['liquidity']),
      holderCount: _parseInt(json['holder_count']),
      buyCount: _parseInt(json['buy_count']),
      sellCount: _parseInt(json['sell_count']),
      netInflow: _parseNum(json['net_inflow']),
      wallets: (json['wallets'] as List<dynamic>? ?? [])
          .map((e) => WalletInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeInfo: json['time_info'] ?? '',
      createdTimestamp: _parseInt(json['created_timestamp']),
    );
  }
}

class WalletInfo {
  final String name;
  final String address;
  final num amount;
  final num flow;
  final String trades;
  final int people;
  final String timeInfo;
  final String avatar;

  WalletInfo({
    required this.name,
    required this.address,
    required this.amount,
    required this.flow,
    required this.trades,
    required this.people,
    required this.timeInfo,
    required this.avatar,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      amount: _parseNum(json['amount']),
      flow: _parseNum(json['flow']),
      trades: json['trades'] ?? '',
      people: _parseInt(json['people']),
      timeInfo: json['time_info'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
} 