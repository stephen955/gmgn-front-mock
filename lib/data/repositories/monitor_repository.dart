/// Monitor 模块数据仓库，负责SmartCards数据获取与缓存
import '../../core/network/api_service.dart';
import '../models/monitor_models.dart';

class MonitorRepository {
  final ApiService _apiService = ApiService();

  /// 获取SmartCards数据
  Future<SmartCardsResponse> fetchSmartCards({
    required String type,
    required String timeframe,
    Map<String, dynamic>? extraParams,
  }) {
    return _apiService.fetchSmartCards(
      type: type,
      timeframe: timeframe,
      extraParams: extraParams,
    );
  }

  /// 获取SOL类型的SmartCards数据
  Future<SmartCardsResponse> fetchSolSmartCards({
    String timeframe = '24h',
    Map<String, dynamic>? extraParams,
  }) {
    return fetchSmartCards(
      type: 'sol',
      timeframe: timeframe,
      extraParams: extraParams,
    );
  }

  /// 获取KOL类型的SmartCards数据
  Future<SmartCardsResponse> fetchKolSmartCards({
    String timeframe = '24h',
    Map<String, dynamic>? extraParams,
  }) {
    return fetchSmartCards(
      type: 'kol',
      timeframe: timeframe,
      extraParams: extraParams,
    );
  }
} 