class StringUtils {
  /// 格式化数字显示
  static String formatNum(num? value) {
    if (value == null) return '0';
    
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  /// 获取时间差描述
  static String getTimeAgo(int timestamp) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final diff = now - timestamp;
    
    if (diff < 60000) { // 1分钟内
      return '刚刚';
    } else if (diff < 3600000) { // 1小时内
      return '${(diff / 60000).round()}分钟前';
    } else if (diff < 86400000) { // 1天内
      return '${(diff / 3600000).round()}小时前';
    } else if (diff < 2592000000) { // 30天内
      return '${(diff / 86400000).round()}天前';
    } else {
      return '${(diff / 2592000000).round()}个月前';
    }
  }

  /// 截断地址显示
  static String truncateAddress(String address) {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  /// 检查字符串是否为空或null
  static bool isEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// 检查字符串是否不为空
  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }
} 