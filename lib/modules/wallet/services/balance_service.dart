/// 余额服务
/// 
/// 统一管理多链余额获取逻辑，使用单例模式
/// 
/// 功能特性：
/// - 多链余额获取
/// - 批量余额查询
/// - 错误处理
/// - 防抖优化

import 'dart:async';
import '../models/balance_model.dart';
import 'balance_provider.dart';
import 'solana_balance_provider.dart';
import 'bsc_balance_provider.dart';

/// 余额服务
/// 单例模式，统一管理余额获取
class BalanceService {
  static final BalanceService _instance = BalanceService._internal();
  factory BalanceService() => _instance;
  BalanceService._internal() {
    _initializeProviders();
  }
  
  // 防抖定时器
  final Map<String, Timer> _debounceTimers = {};
  
  /// 初始化余额提供者
  void _initializeProviders() {
    // 注册Solana提供者
    final solanaProvider = LoggingBalanceProvider(
      RetryBalanceProvider(
        CachedBalanceProvider(
          SolanaBalanceProvider(),
        ),
      ),
    );
    BalanceProviderFactory.registerProvider('sol', solanaProvider);
    
    // 注册BSC提供者
    final bscProvider = LoggingBalanceProvider(
      RetryBalanceProvider(
        CachedBalanceProvider(
          BSCBalanceProvider(),
        ),
      ),
    );
    BalanceProviderFactory.registerProvider('bsc', bscProvider);
  }
  
  /// 获取单个链的余额
  /// 
  /// [chainId] - 链ID
  /// [address] - 钱包地址
  /// [forceRefresh] - 是否强制刷新（忽略缓存）
  Future<BalanceInfo> getBalance(
    String chainId, 
    String address, {
    bool forceRefresh = false,
  }) async {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      
      // 如果强制刷新，清除缓存
      if (forceRefresh && provider is CachedBalanceProvider) {
        provider.clearCacheForAddress(address);
      }
      
      return await provider.getBalance(address);
    } catch (e) {
      return BalanceInfo(
        chainId: chainId,
        address: address,
        balance: 0.0,
        symbol: _getChainSymbol(chainId),
        error: 'Service error: ${e.toString()}',
      );
    }
  }
  
  /// 批量获取多个链的余额
  /// 
  /// [address] - 钱包地址
  /// [chainIds] - 链ID列表
  /// [forceRefresh] - 是否强制刷新
  Future<Map<String, BalanceInfo>> getBalances(
    String address,
    List<String> chainIds, {
    bool forceRefresh = false,
  }) async {
    final results = <String, BalanceInfo>{};
    
    // 并发获取余额
    final futures = chainIds.map((chainId) async {
      final balance = await getBalance(chainId, address, forceRefresh: forceRefresh);
      return MapEntry(chainId, balance);
    });
    
    final balanceResults = await Future.wait(futures);
    
    for (final entry in balanceResults) {
      results[entry.key] = entry.value;
    }
    
    return results;
  }
  
  /// 获取所有支持链的余额
  /// 
  /// [address] - 钱包地址
  /// [forceRefresh] - 是否强制刷新
  Future<Map<String, BalanceInfo>> getAllBalances(
    String address, {
    bool forceRefresh = false,
  }) async {
    final supportedChains = BalanceProviderFactory.getSupportedChains();
    return await getBalances(address, supportedChains, forceRefresh: forceRefresh);
  }
  
  /// 防抖获取余额
  /// 
  /// [chainId] - 链ID
  /// [address] - 钱包地址
  /// [callback] - 回调函数
  /// [debounceTime] - 防抖时间
  void getBalanceDebounced(
    String chainId,
    String address,
    Function(BalanceInfo) callback, {
    Duration debounceTime = const Duration(milliseconds: 300),
  }) {
    final key = '${chainId}_$address';
    
    // 取消之前的定时器
    _debounceTimers[key]?.cancel();
    
    // 设置新的定时器
    _debounceTimers[key] = Timer(debounceTime, () async {
      final balance = await getBalance(chainId, address);
      callback(balance);
      _debounceTimers.remove(key);
    });
  }
  
  /// 取消防抖请求
  void cancelDebouncedRequest(String chainId, String address) {
    final key = '${chainId}_$address';
    _debounceTimers[key]?.cancel();
    _debounceTimers.remove(key);
  }
  
  /// 清除所有缓存
  void clearAllCache() {
    final providers = BalanceProviderFactory.getAllProviders();
    for (final provider in providers.values) {
      if (provider is CachedBalanceProvider) {
        provider.clearCache();
      }
    }
  }
  
  /// 清除指定链的缓存
  void clearChainCache(String chainId) {
    final provider = BalanceProviderFactory.getProvider(chainId);
    if (provider is CachedBalanceProvider) {
      provider.clearCache();
    }
  }
  
  /// 获取支持的链列表
  List<String> getSupportedChains() {
    return BalanceProviderFactory.getSupportedChains();
  }
  
  /// 检查是否支持指定链
  bool isChainSupported(String chainId) {
    return BalanceProviderFactory.isChainSupported(chainId);
  }
  
  /// 获取链的显示名称
  String getChainDisplayName(String chainId) {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      return provider.chainDisplayName;
    } catch (e) {
      return chainId.toUpperCase();
    }
  }
  
  /// 获取链的符号
  String getChainSymbol(String chainId) {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      return provider.chainSymbol;
    } catch (e) {
      return chainId.toUpperCase();
    }
  }
  
  /// 验证地址格式
  bool isValidAddress(String chainId, String address) {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      return provider.isValidAddress(address);
    } catch (e) {
      return false;
    }
  }
  
  /// 格式化地址显示
  String formatAddress(String chainId, String address) {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      return provider.formatAddress(address);
    } catch (e) {
      return address;
    }
  }
  
  /// 获取链的小数位数
  int getChainDecimals(String chainId) {
    try {
      final provider = BalanceProviderFactory.getProvider(chainId);
      return provider.chainDecimals;
    } catch (e) {
      return 18; // 默认18位小数
    }
  }
  
  /// 注册新的余额提供者
  void registerProvider(String chainId, IBalanceProvider provider) {
    BalanceProviderFactory.registerProvider(chainId, provider);
  }
  
  /// 获取余额提供者
  IBalanceProvider getProvider(String chainId) {
    return BalanceProviderFactory.getProvider(chainId);
  }

  _getChainSymbol(String chainId) {}
} 