/// Token 工具类，提供链ID到Token名称的映射
class TokenUtils {
  /// 根据链ID获取Token名称，未匹配时返回 fallback
  static String getTokenName(String chainId, {String fallback = 'SOL'}) {
    switch (chainId.toLowerCase()) {
      case 'sol':
        return 'SOL';
      case 'bsc':
        return 'BNB';
      case 'eth':
        return 'ETH';
      case 'tron':
        return 'TRX';
      default:
        return fallback;
    }
  }
} 