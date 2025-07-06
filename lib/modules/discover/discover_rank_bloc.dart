import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/rank_repository.dart';
import '../../models/chain_rank_models.dart';

abstract class DiscoverRankEvent {}
class FetchRankList extends DiscoverRankEvent {
  final String chain;
  final int page;
  final int pageSize;
  final Map<String, dynamic>? extraParams;
  final bool isRefresh; // 是否为刷新操作
  FetchRankList({
    required this.chain,
    this.page = 1,
    this.pageSize = 10,
    this.extraParams,
    this.isRefresh = false,
  });
}

class LoadMoreRankList extends DiscoverRankEvent {
  final String chain;
  final int page;
  final int pageSize;
  final Map<String, dynamic>? extraParams;
  LoadMoreRankList({
    required this.chain,
    required this.page,
    this.pageSize = 10,
    this.extraParams,
  });
}

// 状态定义
abstract class DiscoverRankState {}
class DiscoverRankInitial extends DiscoverRankState {}
class DiscoverRankLoading extends DiscoverRankState {}
class DiscoverRankLoaded extends DiscoverRankState {
  final ChainRankResponse response;
  final bool hasReachedMax; // 是否已到达最大页数
  DiscoverRankLoaded(this.response, {this.hasReachedMax = false});
}
class DiscoverRankError extends DiscoverRankState {
  final String message;
  DiscoverRankError(this.message);
}
class DiscoverRankLoadingMore extends DiscoverRankState {
  final ChainRankResponse currentResponse;
  DiscoverRankLoadingMore(this.currentResponse);
}

class DiscoverRankBloc extends Bloc<DiscoverRankEvent, DiscoverRankState> {
  final RankRepository repository;
  ChainRankResponse? _currentResponse; // 缓存当前响应数据
  
  DiscoverRankBloc(this.repository) : super(DiscoverRankInitial()) {
    on<FetchRankList>((event, emit) async {
      if (event.isRefresh) {
        // 刷新操作，重置数据
        _currentResponse = null;
      }
      
      emit(DiscoverRankLoading());
      try {
        final data = await repository.fetchRankList(
          chain: event.chain,
          page: event.page,
          pageSize: event.pageSize,
          extraParams: event.extraParams,
        );
        
        _currentResponse = data;
        final hasReachedMax = (data.data?.newCreation?.length ?? 0) < event.pageSize;
        emit(DiscoverRankLoaded(data, hasReachedMax: hasReachedMax));
      } catch (e) {
        emit(DiscoverRankError(e.toString()));
      }
    });

    on<LoadMoreRankList>((event, emit) async {
      if (_currentResponse == null) {
        emit(DiscoverRankError('没有可加载的数据'));
        return;
      }
      
      final currentResponse = _currentResponse;
      if (currentResponse == null) {
        emit(DiscoverRankError('没有可加载的数据'));
        return;
      }
      
      emit(DiscoverRankLoadingMore(currentResponse));
      try {
        final newData = await repository.fetchRankList(
          chain: event.chain,
          page: event.page,
          pageSize: event.pageSize,
          extraParams: event.extraParams,
        );
        
        // 合并数据
        final combinedData = ChainRankResponse.merge(currentResponse, newData);
        
        _currentResponse = combinedData;
        final hasReachedMax = (newData.data?.newCreation?.length ?? 0) < event.pageSize;
        emit(DiscoverRankLoaded(combinedData, hasReachedMax: hasReachedMax));
      } catch (e) {
        emit(DiscoverRankError(e.toString()));
      }
    });
  }
} 