import 'package:shared_preferences/shared_preferences.dart';
import 'package:gmgn_front/shared/chain_constants.dart';

/// 链存储服务
/// 负责管理用户选择的链的持久化存储
class ChainStorageService {
  static const String _selectedChainKey = 'selected_chain';
  
  /// 保存用户选择的链
  static Future<void> saveSelectedChain(String chain) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedChainKey, chain);
  }
  
  /// 获取用户上次选择的链
  static Future<String> getSelectedChain() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedChainKey) ?? ChainConstants.sol;
  }
  
  /// 清除存储的链选择
  static Future<void> clearSelectedChain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedChainKey);
  }
  
  /// 检查是否有存储的链选择
  static Future<bool> hasStoredChain() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_selectedChainKey);
  }
} 