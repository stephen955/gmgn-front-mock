/// 余额数据模型
/// 
/// 定义余额相关的数据结构，支持多链余额管理
/// 
/// 功能特性：
/// - 多链余额支持
/// - 余额格式化
/// - 错误状态管理

import 'package:equatable/equatable.dart';

/// 余额信息模型
class BalanceInfo extends Equatable {
  final String chainId;
  final String address;
  final double balance;
  final String symbol;
  final DateTime? lastUpdated;
  final bool isLoading;
  final String? error;

  const BalanceInfo({
    required this.chainId,
    required this.address,
    required this.balance,
    required this.symbol,
    this.lastUpdated,
    this.isLoading = false,
    this.error,
  });

  /// 从 JSON 创建余额信息
  factory BalanceInfo.fromJson(Map<String, dynamic> json) {
    return BalanceInfo(
      chainId: json['chain_id'] ?? '',
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      symbol: json['symbol'] ?? '',
      lastUpdated: json['last_updated'] != null 
          ? DateTime.tryParse(json['last_updated']) 
          : null,
      isLoading: json['is_loading'] ?? false,
      error: json['error'],
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'chain_id': chainId,
      'address': address,
      'balance': balance,
      'symbol': symbol,
      'last_updated': lastUpdated?.toIso8601String(),
      'is_loading': isLoading,
      'error': error,
    };
  }

  /// 复制并更新属性
  BalanceInfo copyWith({
    String? chainId,
    String? address,
    double? balance,
    String? symbol,
    DateTime? lastUpdated,
    bool? isLoading,
    String? error,
  }) {
    return BalanceInfo(
      chainId: chainId ?? this.chainId,
      address: address ?? this.address,
      balance: balance ?? this.balance,
      symbol: symbol ?? this.symbol,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 获取格式化的余额显示
  String get formattedBalance {
    if (error != null) return 'Error';
    if (isLoading) return 'Loading...';
    return '${balance.toStringAsFixed(4)} $symbol';
  }

  /// 获取短余额显示（用于UI）
  String get shortBalance {
    if (error != null) return 'Error';
    if (isLoading) return '...';
    return '${balance.toStringAsFixed(2)} $symbol';
  }

  /// 检查是否有错误
  bool get hasError => error != null && error!.isNotEmpty;

  /// 检查是否正在加载
  bool get isCurrentlyLoading => isLoading;

  /// 检查是否有有效余额
  bool get hasValidBalance => !hasError && !isLoading && balance >= 0;

  @override
  List<Object?> get props => [
    chainId, 
    address, 
    balance, 
    symbol, 
    lastUpdated, 
    isLoading, 
    error
  ];

  @override
  String toString() {
    return 'BalanceInfo(chainId: $chainId, address: $address, balance: $balance, symbol: $symbol)';
  }
}

/// 多链余额信息模型
class MultiChainBalanceInfo extends Equatable {
  final Map<String, BalanceInfo> balances;
  final String currentChainId;
  final bool isLoading;
  final String? error;

  const MultiChainBalanceInfo({
    required this.balances,
    required this.currentChainId,
    this.isLoading = false,
    this.error,
  });

  /// 从 JSON 创建多链余额信息
  factory MultiChainBalanceInfo.fromJson(Map<String, dynamic> json) {
    final balancesMap = <String, BalanceInfo>{};
    final balancesJson = json['balances'] as Map<String, dynamic>? ?? {};
    
    for (final entry in balancesJson.entries) {
      balancesMap[entry.key] = BalanceInfo.fromJson(entry.value);
    }

    return MultiChainBalanceInfo(
      balances: balancesMap,
      currentChainId: json['current_chain_id'] ?? '',
      isLoading: json['is_loading'] ?? false,
      error: json['error'],
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    final balancesJson = <String, dynamic>{};
    for (final entry in balances.entries) {
      balancesJson[entry.key] = entry.value.toJson();
    }

    return {
      'balances': balancesJson,
      'current_chain_id': currentChainId,
      'is_loading': isLoading,
      'error': error,
    };
  }

  /// 复制并更新属性
  MultiChainBalanceInfo copyWith({
    Map<String, BalanceInfo>? balances,
    String? currentChainId,
    bool? isLoading,
    String? error,
  }) {
    return MultiChainBalanceInfo(
      balances: balances ?? this.balances,
      currentChainId: currentChainId ?? this.currentChainId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 获取当前链的余额信息
  BalanceInfo? get currentChainBalance => balances[currentChainId];

  /// 获取当前链的余额
  double get currentBalance => currentChainBalance?.balance ?? 0.0;

  /// 获取当前链的符号
  String get currentSymbol => currentChainBalance?.symbol ?? '';

  /// 检查是否有错误
  bool get hasError => error != null && error!.isNotEmpty;

  /// 检查是否正在加载
  bool get isCurrentlyLoading => isLoading;

  /// 获取所有链的余额总和
  double get totalBalance {
    double total = 0.0;
    for (final balance in balances.values) {
      if (balance.hasValidBalance) {
        total += balance.balance;
      }
    }
    return total;
  }

  /// 获取支持的链列表
  List<String> get supportedChains => balances.keys.toList();

  @override
  List<Object?> get props => [balances, currentChainId, isLoading, error];

  @override
  String toString() {
    return 'MultiChainBalanceInfo(currentChainId: $currentChainId, balances: $balances)';
  }
} 