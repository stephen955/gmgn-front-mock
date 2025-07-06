/// Solana余额提供者
/// 
/// 实现Solana链的余额查询功能
/// 
/// 功能特性：
/// - Solana RPC API调用
/// - 地址格式验证
/// - 错误处理

import 'package:dio/dio.dart';
import '../models/balance_model.dart';
import 'balance_provider.dart';

/// Solana余额提供者实现
class SolanaBalanceProvider implements IBalanceProvider {
  final Dio _dio;
  final String _rpcUrl;
  
  SolanaBalanceProvider({
    Dio? dio,
    String? rpcUrl,
  }) : _dio = dio ?? Dio(),
       _rpcUrl = rpcUrl ?? 'https://api.mainnet-beta.solana.com';
  
  @override
  String get chainId => 'sol';
  
  @override
  String get chainDisplayName => 'SOL';
  
  @override
  String get chainSymbol => 'SOL';
  
  @override
  int get chainDecimals => 9;
  
  @override
  bool isValidAddress(String address) {
    // Solana地址格式验证
    // Solana地址是base58编码的32字节公钥
    if (address.isEmpty) return false;
    
    // 基本格式检查
    if (!RegExp(r'^[1-9A-HJ-NP-Za-km-z]{32,44}$').hasMatch(address)) {
      return false;
    }
    
    return true;
  }
  
  @override
  String formatAddress(String address) {
    if (address.isEmpty) return '';
    if (address.length <= 8) return address;
    return '${address.substring(0, 4)}...${address.substring(address.length - 4)}';
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
          error: 'Invalid Solana address format',
        );
      }
      
      // 调用Solana RPC API
      final response = await _dio.post(
        _rpcUrl,
        data: {
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'getBalance',
          'params': [address]
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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
      
      // 检查RPC错误
      if (data['error'] != null) {
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'RPC Error: ${data['error']['message']}',
        );
      }
      
      // 解析余额
      final result = data['result'];
      if (result == null || result['value'] == null) {
        return BalanceInfo(
          chainId: chainId,
          address: address,
          balance: 0.0,
          symbol: chainSymbol,
          error: 'Invalid response format',
        );
      }
      
      // 转换余额（从lamports到SOL）
      final lamports = BigInt.parse(result['value'].toString());
      final balance = lamports / BigInt.from(10).pow(chainDecimals);
      final remainder = lamports % BigInt.from(10).pow(chainDecimals);
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