/// BSC余额提供者
/// 
/// 实现BSC链的余额查询功能
/// 
/// 功能特性：
/// - BSCScan API调用
/// - 地址格式验证
/// - 错误处理

import 'package:dio/dio.dart';
import '../models/balance_model.dart';
import 'balance_provider.dart';

/// BSC余额提供者实现
class BSCBalanceProvider implements IBalanceProvider {
  final Dio _dio;
  final String _apiUrl;
  final String? _apiKey;
  
  BSCBalanceProvider({
    Dio? dio,
    String? apiUrl,
    String? apiKey,
  }) : _dio = dio ?? Dio(),
       _apiUrl = apiUrl ?? 'https://api.bscscan.com/api',
       _apiKey = apiKey;
  
  @override
  String get chainId => 'bsc';
  
  @override
  String get chainDisplayName => 'BSC';
  
  @override
  String get chainSymbol => 'BNB';
  
  @override
  int get chainDecimals => 18;
  
  @override
  bool isValidAddress(String address) {
    // BSC地址格式验证（Ethereum兼容）
    if (address.isEmpty) return false;
    
    // 检查长度和前缀
    if (!address.startsWith('0x') || address.length != 42) {
      return false;
    }
    
    // 检查十六进制格式
    if (!RegExp(r'^0x[0-9a-fA-F]{40}$').hasMatch(address)) {
      return false;
    }
    
    return true;
  }
  
  @override
  String formatAddress(String address) {
    if (address.isEmpty) return '';
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }
  
  @override
  Future<BalanceInfo> getBalance(String address) async {
    try {
      // 验证地址格式
      if (!isValidAddress(address)) {
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'Invalid BSC address format',
        );
      }
      
      // 构建查询参数
      final queryParams = <String, dynamic>{
        'module': 'account',
        'action': 'balance',
        'address': address,
        'tag': 'latest',
      };
      
      // 添加API密钥（如果提供）
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        queryParams['apikey'] = _apiKey;
      }
      
      // 调用BSCScan API
      final response = await _dio.get(
        _apiUrl,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      
      // 检查响应状态
      if (response.statusCode != 200) {
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'HTTP ${response.statusCode}: ${response.statusMessage}',
        );
      }
      
      final data = response.data;
      
      // 检查API错误
      if (data['status'] != '1') {
        final message = data['message'] ?? 'Unknown API error';
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'API Error: $message',
        );
      }
      
      // 解析余额
      final result = data['result'];
      if (result == null) {
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'Invalid response format',
        );
      }
      
      // 转换余额（从wei到BNB）
      final wei = BigInt.parse(result.toString());
      final balance = wei / BigInt.from(10).pow(chainDecimals);
      final remainder = wei % BigInt.from(10).pow(chainDecimals);
      final balanceDouble = balance.toDouble() + (remainder.toDouble() / BigInt.from(10).pow(chainDecimals).toDouble());
      
      return BalanceInfo(
        chainId: chainId,
        address: address,
        balance: balanceDouble,
        symbol: chainSymbol,
        lastUpdated: DateTime.now(),
      );
      
    } catch (e) {
      return BalanceInfo(
        chainId: chainId,
        address: address,
        balance: 0.0,
        symbol: chainSymbol,
        error: 'Network error: ${e.toString()}',
      );
    }
  }
} 