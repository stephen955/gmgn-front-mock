/// 余额Cubit
/// 
/// 管理余额状态，使用Cubit模式
/// 
/// 功能特性：
/// - 余额状态管理
/// - 链切换监听
/// - 错误处理
/// - 缓存管理

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/balance_model.dart';
import '../services/balance_service.dart';
import 'balance_state.dart';

/// 余额Cubit
/// 管理余额状态和业务逻辑
class BalanceCubit extends Cubit<BalanceState> {
  final BalanceService _balanceService;
  
  BalanceCubit({
    BalanceService? balanceService,
  }) : _balanceService = balanceService ?? BalanceService(),
       super(const BalanceInitial());
  
  /// 获取单个链的余额
  /// 
  /// [chainId] - 链ID
  /// [address] - 钱包地址
  /// [forceRefresh] - 是否强制刷新
  Future<void> fetchBalance(
    String chainId, 
    String address, {
    bool forceRefresh = false,
  }) async {
    try {
      // 验证参数
      if (chainId.isEmpty || address.isEmpty) {
        emit(BalanceError('Invalid parameters: chainId and address are required'));
        return;
      }
      
      // 检查链是否支持
      if (!_balanceService.isChainSupported(chainId)) {
        emit(BalanceError('Unsupported chain: $chainId'));
        return;
      }
      
      // 验证地址格式
      if (!_balanceService.isValidAddress(chainId, address)) {
        emit(BalanceError('Invalid address format for chain: $chainId'));
        return;
      }
      
      // 发出加载状态
      emit(BalanceLoading(chainId: chainId, address: address));
      
      // 获取余额
      final balance = await _balanceService.getBalance(
        chainId, 
        address, 
        forceRefresh: forceRefresh,
      );
      
      // 检查是否有错误
      if (balance.hasError) {
        emit(BalanceError(
          balance.error!,
          chainId: chainId,
          address: address,
        ));
        return;
      }
      
      // 发出成功状态
      emit(BalanceLoaded(
        balances: {chainId: balance},
        currentChainId: chainId,
      ));
      
    } catch (e) {
      emit(BalanceError(
        'Failed to fetch balance: ${e.toString()}',
        chainId: chainId,
        address: address,
      ));
    }
  }
  
  /// 获取多个链的余额
  /// 
  /// [address] - 钱包地址
  /// [chainIds] - 链ID列表
  /// [currentChainId] - 当前链ID
  /// [forceRefresh] - 是否强制刷新
  Future<void> fetchBalances(
    String address,
    List<String> chainIds, {
    required String currentChainId,
    bool forceRefresh = false,
  }) async {
    try {
      // 验证参数
      if (address.isEmpty || chainIds.isEmpty) {
        emit(BalanceError('Invalid parameters: address and chainIds are required'));
        return;
      }
      
      // 检查当前链是否在列表中
      if (!chainIds.contains(currentChainId)) {
        emit(BalanceError('Current chain not in chainIds list'));
        return;
      }
      
      // 发出加载状态
      emit(BalanceLoading(address: address));
      
      // 获取余额
      final balances = await _balanceService.getBalances(
        address, 
        chainIds, 
        forceRefresh: forceRefresh,
      );
      
      // 检查是否有错误
      bool hasError = false;
      String errorMessage = '';
      for (final balance in balances.values) {
        if (balance.hasError) {
          hasError = true;
          errorMessage = balance.error!;
          break;
        }
      }
      
      if (hasError) {
        emit(BalanceError(
          errorMessage,
          address: address,
          cachedBalances: balances,
        ));
        return;
      }
      
      // 发出成功状态
      emit(BalanceLoaded(
        balances: balances,
        currentChainId: currentChainId,
      ));
      
    } catch (e) {
      emit(BalanceError(
        'Failed to fetch balances: ${e.toString()}',
        address: address,
      ));
    }
  }
  
  /// 获取所有支持链的余额
  /// 
  /// [address] - 钱包地址
  /// [currentChainId] - 当前链ID
  /// [forceRefresh] - 是否强制刷新
  Future<void> fetchAllBalances(
    String address, {
    required String currentChainId,
    bool forceRefresh = false,
  }) async {
    try {
      // 验证参数
      if (address.isEmpty) {
        emit(BalanceError('Address is required'));
        return;
      }
      
      // 获取支持的链列表
      final supportedChains = _balanceService.getSupportedChains();
      
      if (supportedChains.isEmpty) {
        emit(BalanceError('No supported chains available'));
        return;
      }
      
      // 检查当前链是否支持
      if (!supportedChains.contains(currentChainId)) {
        emit(BalanceError('Current chain not supported: $currentChainId'));
        return;
      }
      
      // 发出加载状态
      emit(BalanceLoading(address: address));
      
      // 获取所有余额
      final balances = await _balanceService.getAllBalances(
        address, 
        forceRefresh: forceRefresh,
      );
      
      // 检查是否有错误
      bool hasError = false;
      String errorMessage = '';
      for (final balance in balances.values) {
        if (balance.hasError) {
          hasError = true;
          errorMessage = balance.error!;
          break;
        }
      }
      
      if (hasError) {
        emit(BalanceError(
          errorMessage,
          address: address,
          cachedBalances: balances,
        ));
        return;
      }
      
      // 创建多链余额信息
      final balanceInfo = MultiChainBalanceInfo(
        balances: balances,
        currentChainId: currentChainId,
      );
      
      // 发出成功状态
      emit(MultiChainBalanceState(balanceInfo));
      
    } catch (e) {
      emit(BalanceError(
        'Failed to fetch all balances: ${e.toString()}',
        address: address,
      ));
    }
  }
  
  /// 链切换时自动获取余额
  /// 
  /// [chainId] - 新的链ID
  /// [address] - 钱包地址
  void onChainChanged(String chainId, String address) {
    fetchBalance(chainId, address);
  }
  
  /// 防抖获取余额
  /// 
  /// [chainId] - 链ID
  /// [address] - 钱包地址
  void fetchBalanceDebounced(String chainId, String address) {
    _balanceService.getBalanceDebounced(
      chainId,
      address,
      (balance) {
        if (balance.hasError) {
          emit(BalanceError(
            balance.error!,
            chainId: chainId,
            address: address,
          ));
        } else {
          emit(BalanceLoaded(
            balances: {chainId: balance},
            currentChainId: chainId,
          ));
        }
      },
    );
  }
  
  /// 取消防抖请求
  void cancelDebouncedRequest(String chainId, String address) {
    _balanceService.cancelDebouncedRequest(chainId, address);
  }
  
  /// 清除缓存
  void clearCache() {
    _balanceService.clearAllCache();
  }
  
  /// 清除指定链的缓存
  void clearChainCache(String chainId) {
    _balanceService.clearChainCache(chainId);
  }
  
  /// 获取支持的链列表
  List<String> getSupportedChains() {
    return _balanceService.getSupportedChains();
  }
  
  /// 检查是否支持指定链
  bool isChainSupported(String chainId) {
    return _balanceService.isChainSupported(chainId);
  }
  
  /// 验证地址格式
  bool isValidAddress(String chainId, String address) {
    return _balanceService.isValidAddress(chainId, address);
  }
  
  /// 格式化地址显示
  String formatAddress(String chainId, String address) {
    return _balanceService.formatAddress(chainId, address);
  }
  
  /// 获取链的显示名称
  String getChainDisplayName(String chainId) {
    return _balanceService.getChainDisplayName(chainId);
  }
  
  /// 获取链的符号
  String getChainSymbol(String chainId) {
    return _balanceService.getChainSymbol(chainId);
  }
  
  /// 重置状态
  void reset() {
    emit(const BalanceInitial());
  }
} 