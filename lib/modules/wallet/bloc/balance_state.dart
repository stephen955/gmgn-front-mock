/// 余额状态定义
/// 
/// 定义余额管理的状态，支持多链余额状态管理
/// 
/// 功能特性：
/// - 多链余额状态
/// - 加载状态管理
/// - 错误状态处理

import 'package:equatable/equatable.dart';
import '../models/balance_model.dart';

/// 余额状态基类
abstract class BalanceState extends Equatable {
  const BalanceState();
  
  @override
  List<Object?> get props => [];
}

/// 初始状态
class BalanceInitial extends BalanceState {
  const BalanceInitial();
}

/// 加载状态
class BalanceLoading extends BalanceState {
  final String? chainId;
  final String? address;
  
  const BalanceLoading({
    this.chainId,
    this.address,
  });
  
  @override
  List<Object?> get props => [chainId, address];
}

/// 余额加载成功状态
class BalanceLoaded extends BalanceState {
  final Map<String, BalanceInfo> balances;
  final String currentChainId;
  
  const BalanceLoaded({
    required this.balances,
    required this.currentChainId,
  });
  
  /// 获取当前链的余额信息
  BalanceInfo? get currentChainBalance => balances[currentChainId];
  
  /// 获取当前链的余额
  double get currentBalance => currentChainBalance?.balance ?? 0.0;
  
  /// 获取当前链的符号
  String get currentSymbol => currentChainBalance?.symbol ?? '';
  
  /// 检查是否有错误
  bool get hasError {
    for (final balance in balances.values) {
      if (balance.hasError) return true;
    }
    return false;
  }
  
  /// 检查是否正在加载
  bool get isLoading {
    for (final balance in balances.values) {
      if (balance.isCurrentlyLoading) return true;
    }
    return false;
  }
  
  @override
  List<Object?> get props => [balances, currentChainId];
}

/// 余额加载错误状态
class BalanceError extends BalanceState {
  final String message;
  final String? chainId;
  final String? address;
  final Map<String, BalanceInfo>? cachedBalances;
  
  const BalanceError(
    this.message, {
    this.chainId,
    this.address,
    this.cachedBalances,
  });
  
  @override
  List<Object?> get props => [message, chainId, address, cachedBalances];
}

/// 多链余额状态
class MultiChainBalanceState extends BalanceState {
  final MultiChainBalanceInfo balanceInfo;
  
  const MultiChainBalanceState(this.balanceInfo);
  
  /// 获取当前链的余额信息
  BalanceInfo? get currentChainBalance => balanceInfo.currentChainBalance;
  
  /// 获取当前链的余额
  double get currentBalance => balanceInfo.currentBalance;
  
  /// 获取当前链的符号
  String get currentSymbol => balanceInfo.currentSymbol;
  
  /// 检查是否有错误
  bool get hasError => balanceInfo.hasError;
  
  /// 检查是否正在加载
  bool get isLoading => balanceInfo.isCurrentlyLoading;
  
  /// 获取所有链的余额总和
  double get totalBalance => balanceInfo.totalBalance;
  
  /// 获取支持的链列表
  List<String> get supportedChains => balanceInfo.supportedChains;
  
  @override
  List<Object?> get props => [balanceInfo];
} 