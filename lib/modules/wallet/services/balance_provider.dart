/// 余额提供者接口
/// 
/// 定义余额获取的策略模式接口，支持多链余额查询
/// 
/// 功能特性：
/// - 统一余额获取接口
/// - 支持不同链的特定实现
/// - 错误处理和重试机制

import '../models/balance_model.dart';

/// 余额提供者接口
/// 策略模式的基础接口，用于不同链的余额获取
abstract class IBalanceProvider {
  /// 获取余额
  /// 
  /// [address] - 钱包地址
  /// 返回余额信息
  Future<BalanceInfo> getBalance(String address);
  
  /// 获取链ID
  String get chainId;
  
  /// 获取链的显示名称
  String get chainDisplayName;
  
  /// 获取链的符号
  String get chainSymbol;
  
  /// 获取链的小数位数
  int get chainDecimals;
  
  /// 验证地址格式
  bool isValidAddress(String address);
  
  /// 格式化地址显示
  String formatAddress(String address);
}

/// 余额提供者工厂
/// 工厂模式，用于创建对应的余额提供者
class BalanceProviderFactory {
  static final Map<String, IBalanceProvider> _providers = {};
  
  /// 注册余额提供者
  static void registerProvider(String chainId, IBalanceProvider provider) {
    _providers[chainId] = provider;
  }
  
  /// 获取余额提供者
  static IBalanceProvider getProvider(String chainId) {
    final provider = _providers[chainId];
    if (provider == null) {
      throw Exception('Unsupported chain: $chainId');
    }
    return provider;
  }
  
  /// 获取所有支持的链ID
  static List<String> getSupportedChains() {
    return _providers.keys.toList();
  }
  
  /// 检查是否支持指定链
  static bool isChainSupported(String chainId) {
    return _providers.containsKey(chainId);
  }
  
  /// 获取所有提供者
  static Map<String, IBalanceProvider> getAllProviders() {
    return Map.unmodifiable(_providers);
  }
}

/// 余额提供者装饰器基类
/// 装饰器模式的基础类，用于添加额外功能
abstract class BalanceProviderDecorator implements IBalanceProvider {
  final IBalanceProvider _provider;
  
  BalanceProviderDecorator(this._provider);
  
  @override
  Future<BalanceInfo> getBalance(String address) async {
    return await _provider.getBalance(address);
  }
  
  @override
  String get chainId => _provider.chainId;
  
  @override
  String get chainDisplayName => _provider.chainDisplayName;
  
  @override
  String get chainSymbol => _provider.chainSymbol;
  
  @override
  int get chainDecimals => _provider.chainDecimals;
  
  @override
  bool isValidAddress(String address) => _provider.isValidAddress(address);
  
  @override
  String formatAddress(String address) => _provider.formatAddress(address);
}

/// 缓存装饰器
/// 为余额提供者添加缓存功能
class CachedBalanceProvider extends BalanceProviderDecorator {
  final Map<String, BalanceInfo> _cache = {};
  final Duration _cacheDuration;
  
  CachedBalanceProvider(
    IBalanceProvider provider, {
    Duration cacheDuration = const Duration(minutes: 5),
  }) : _cacheDuration = cacheDuration, super(provider);
  
  @override
  Future<BalanceInfo> getBalance(String address) async {
    final cacheKey = '${chainId}_$address';
    final cached = _cache[cacheKey];
    
    // 检查缓存是否有效
    if (cached != null && cached.lastUpdated != null) {
      final age = DateTime.now().difference(cached.lastUpdated!);
      if (age < _cacheDuration) {
        return cached;
      }
    }
    
    // 获取新数据
    final balance = await super.getBalance(address);
    
    // 更新缓存
    _cache[cacheKey] = balance;
    
    return balance;
  }
  
  /// 清除缓存
  void clearCache() {
    _cache.clear();
  }
  
  /// 清除指定地址的缓存
  void clearCacheForAddress(String address) {
    final cacheKey = '${chainId}_$address';
    _cache.remove(cacheKey);
  }
}

/// 重试装饰器
/// 为余额提供者添加重试功能
class RetryBalanceProvider extends BalanceProviderDecorator {
  final int _maxRetries;
  final Duration _retryDelay;
  
  RetryBalanceProvider(
    IBalanceProvider provider, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) : _maxRetries = maxRetries, _retryDelay = retryDelay, super(provider);
  
  @override
  Future<BalanceInfo> getBalance(String address) async {
    Exception? lastException;
    
    for (int i = 0; i < _maxRetries; i++) {
      try {
        return await super.getBalance(address);
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        
        // 如果不是最后一次重试，等待后继续
        if (i < _maxRetries - 1) {
          await Future.delayed(_retryDelay);
        }
      }
    }
    
    // 所有重试都失败了，返回错误信息
    return BalanceInfo(
      chainId: chainId,
      address: address,
      balance: 0.0,
      symbol: chainSymbol,
      error: 'Failed after $_maxRetries retries: ${lastException?.toString()}',
    );
  }
}

/// 日志装饰器
/// 为余额提供者添加日志功能
class LoggingBalanceProvider extends BalanceProviderDecorator {
  LoggingBalanceProvider(IBalanceProvider provider) : super(provider);
  
  @override
  Future<BalanceInfo> getBalance(String address) async {
    final startTime = DateTime.now();
    
    try {
      final result = await super.getBalance(address);
      final duration = DateTime.now().difference(startTime);
      
      print('BalanceProvider[$chainId]: Successfully fetched balance for $address in ${duration.inMilliseconds}ms');
      
      return result;
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      
      print('BalanceProvider[$chainId]: Failed to fetch balance for $address after ${duration.inMilliseconds}ms: $e');
      
      rethrow;
    }
  }
} 