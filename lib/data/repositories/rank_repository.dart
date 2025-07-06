/// Rank 榜单数据仓库，负责数据获取与缓存
import '../../core/network/api_service.dart';
import '../../models/chain_rank_models.dart';

class RankRepository {
  final ApiService _apiService = ApiService();

  Future<ChainRankResponse> fetchRankList({
    required String chain,
    int page = 1,
    int pageSize = 10,
    Map<String, dynamic>? extraParams,
  }) {
    return _apiService.fetchRankList(
      chain: chain,
      page: page,
      pageSize: pageSize,
      extraParams: extraParams,
    );
  }
} 