import 'network_client.dart';
import 'package:gmgn_front/models/chain_rank_models.dart';
import 'package:gmgn_front/data/models/monitor_models.dart';
import 'package:gmgn_front/data/models/track_card_model.dart';

class ApiService {
  final _dio = NetworkClient().dio;

  Future<dynamic> getUserInfo() async {
    final response = await _dio.get('/user/info');
    return response.data;
  }

  /// 获取资产页数据
  Future<Map<String, dynamic>> fetchAssetData({String chain = 'sol'}) async {
    final response = await _dio.get(
      '/vas/api/v1/wallet/info',
      queryParameters: {'chain': chain},
    );
    return response.data;
  }

  /// 获取链上Rank榜单数据
  Future<ChainRankResponse> fetchRankList({
    required String chain,
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? extraParams,
  }) async {
    final params = {
      'page': page,
      'page_size': pageSize,
      ...?extraParams,
    };
    print('[ApiService] 请求: /vas/api/v1/rank/$chain, params: ' + params.toString());
    try {
      final response = await _dio.post(
        '/vas/api/v1/rank/$chain',
        data: params,
      );
      print('[ApiService] 响应: ' + response.data.toString());
      return ChainRankResponse.fromJson(response.data);
    } catch (e, stack) {
      print('[ApiService] 请求失败: $e');
      print(stack);
      rethrow;
    }
  }

  /// 获取SmartCards数据
  Future<SmartCardsResponse> fetchSmartCards({
    required String type,
    required String timeframe,
    Map<String, dynamic>? extraParams,
  }) async {
    final params = {
      'device_id': '29cb6e40-0312-4d02-956f-a8c620eebb2b',
      'client_id': 'gmgn_web_20250705-807-88f0c55',
      'from_app': 'gmgn',
      'app_ver': '20250705-807-88f0c55',
      'tz_name': 'Asia/Shanghai',
      'tz_offset': '28800',
      'app_lang': 'zh-CN',
      'fp_did': 'd5af68f4f09be22a76718105bff06d2a',
      'os': 'web',
      ...?extraParams,
    };
    print('[ApiService] 请求: /vas/api/v1/smart_cards/cards/$type/$timeframe, params: ' + params.toString());
    try {
      final response = await _dio.get(
        '/vas/api/v1/smart_cards/cards/$type/$timeframe',
        queryParameters: params,
      );
      print('[ApiService] 响应: ' + response.data.toString());
      return SmartCardsResponse.fromJson(response.data);
    } catch (e, stack) {
      print('[ApiService] 请求失败: $e');
      print(stack);
      rethrow;
    }
  }

  /// 获取 Track 榜单数据
  Future<List<TrackCardModel>> fetchTrackCards() async {
    final response = await _dio.get('/vas/api/v1/follow_cards/cards/');
    final data = response.data['data']['cards'] as List<dynamic>;
    return data.map((e) => TrackCardModel.fromJson(e)).toList();
  }
} 