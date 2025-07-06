import '../../core/network/api_service.dart';

class AssetRepository {
  final ApiService _apiService = ApiService();

  /// 获取资产页数据
  Future<Map<String, dynamic>> fetchAssetData({String chain = 'sol'}) async {
    return _apiService.fetchAssetData(chain: chain);
  }
} 