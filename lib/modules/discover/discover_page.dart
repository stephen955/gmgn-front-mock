import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gmgn_front/modules/discover/widgets/discover_header.dart';
import 'package:gmgn_front/shared/utils/network_error_handler.dart';
import 'package:gmgn_front/shared/widgets/asset_overview_card.dart';
import 'package:gmgn_front/modules/discover/widgets/discover_tab_filter.dart';
import 'package:gmgn_front/modules/discover/widgets/asset_list_cell.dart';
import 'discover_rank_bloc.dart';
import '../../data/repositories/rank_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:gmgn_front/shared/utils/chain_cubit.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class IDataLoader {
  void loadData(BuildContext context, {bool isRefresh = false});
  void loadMoreData(BuildContext context);
}

abstract class IAutoRefreshable {
  void startAutoRefresh();
  void stopAutoRefresh();
  void onAutoRefreshChanged(bool enabled);
}

abstract class IStateManager {
  void onChainChanged(BuildContext context, String chain);
  void onFilterChanged(BuildContext context, Map<String, dynamic>? extraParams);
}
// ======================================================

/// 数据加载器实现
class DiscoverDataLoader implements IDataLoader {

  final DiscoverRankBloc _bloc;
  final ChainCubit _chainCubit;
  int _currentPage = 1;
  Map<String, dynamic>? _currentExtraParams;
  bool _isLoading = false;

  DiscoverDataLoader(this._bloc, this._chainCubit);

  @override
  void loadData(BuildContext context, {bool isRefresh = false}) {
    if (_isLoading) return;
    
    if (isRefresh) {
      _currentPage = 1;
    }
    
    try {
      final currentChain = _chainCubit.state;
      _bloc.add(FetchRankList(
        chain: currentChain,
        page: _currentPage,
        pageSize: 10,
        extraParams: _currentExtraParams,
        isRefresh: isRefresh,
      ));
    } catch (e) {
      debugPrint('Load data error: $e');
    }
  }

  @override
  void loadMoreData(BuildContext context) {
    if (_isLoading) return;
    
    _currentPage++;
    try {
      final currentChain = _chainCubit.state;
      _bloc.add(LoadMoreRankList(
        chain: currentChain,
        page: _currentPage,
        pageSize: 10,
        extraParams: _currentExtraParams,
      ));
    } catch (e) {
      debugPrint('Load more data error: $e');
      _currentPage--;
    }
  }

  void setExtraParams(Map<String, dynamic>? extraParams) {
    _currentExtraParams = extraParams;
  }

  void resetPage() {
    _currentPage = 1;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
  }
}

/// 自动刷新管理器
class AutoRefreshManager implements IAutoRefreshable {
  Timer? _autoRefreshTimer;
  bool _isAutoRefreshEnabled = false;
  bool _isPaused = false;
  final VoidCallback _onRefresh;

  AutoRefreshManager(this._onRefresh);

  @override
  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    // 暂停自动刷新，设置为一个很大的间隔
    _autoRefreshTimer = Timer.periodic(const Duration(hours: 24), (timer) {
      if (_isAutoRefreshEnabled && !_isPaused) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _onRefresh();
        });
      }
    });
  }

  @override
  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  void onAutoRefreshChanged(bool enabled) {
    _isAutoRefreshEnabled = enabled;
    if (enabled) {
      startAutoRefresh();
    } else {
      stopAutoRefresh();
    }
  }

  void pauseAutoRefresh() {
    _isPaused = true;
  }

  void resumeAutoRefresh() {
    _isPaused = false;
  }

  void dispose() {
    stopAutoRefresh();
  }
}

/// 状态管理器
class DiscoverStateManager implements IStateManager {
  final DiscoverDataLoader _dataLoader;
  final ChainCubit _chainCubit;

  DiscoverStateManager(this._dataLoader, this._chainCubit);

  @override
  void onChainChanged(BuildContext context, String chain) {
    _chainCubit.setChain(chain);
    _dataLoader.resetPage();
    _dataLoader.loadData(context, isRefresh: true);
  }

  @override
  void onFilterChanged(BuildContext context, Map<String, dynamic>? extraParams) {
    _dataLoader.setExtraParams(extraParams);
    _dataLoader.resetPage();
    _dataLoader.loadData(context, isRefresh: true);
  }
}

/// 刷新控制器管理器
class RefreshControllerManager {
  final RefreshController _refreshController;
  final IDataLoader _dataLoader;

  RefreshControllerManager(this._dataLoader)
      : _refreshController = RefreshController();

  RefreshController get controller => _refreshController;

  void onRefresh(BuildContext context) {
    _dataLoader.loadData(context, isRefresh: true);
  }

  void onLoadMore(BuildContext context) {
    _dataLoader.loadMoreData(context);
  }

  void handleStateChange(DiscoverRankState state) {
    if (state is DiscoverRankLoaded) {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    } else if (state is DiscoverRankError) {
      _refreshController.refreshFailed();
      _refreshController.loadFailed();
    }
  }

  void dispose() {
    _refreshController.dispose();
  }
}

/// 错误处理器
class DiscoverErrorHandler {
  static void handleError(BuildContext context, String message) {
    if (context.mounted) {
      final errorMessage = NetworkErrorHandler.handleError(message);
      NetworkErrorHandler.showNetworkErrorSnackBar(context, errorMessage);
    }
  }
}

/// 主页面组件
@RoutePage()
class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
          child: DiscoverHeader(),
        ),
      ),
      body: BlocProvider<DiscoverRankBloc>(
        create: (_) => DiscoverRankBloc(RankRepository()),
        child: const _DiscoverPageContent(),
      ),
    );
  }
}

/// 页面内容组件
class _DiscoverPageContent extends StatefulWidget {
  const _DiscoverPageContent();

  @override
  State<_DiscoverPageContent> createState() => _DiscoverPageContentState();
}

class _DiscoverPageContentState extends State<_DiscoverPageContent> {
  late final RefreshControllerManager _refreshManager;
  late final DiscoverDataLoader _dataLoader;
  late final AutoRefreshManager _autoRefreshManager;
  late final DiscoverStateManager _stateManager;
  bool _isInitialized = false;
  bool _isFirstLoadCompleted = false;
  bool _autoRefreshEnabled = false;
  ScrollController? _scrollController;
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    final chainCubit = context.read<ChainCubit>();
    final rankBloc = context.read<DiscoverRankBloc>();

    _dataLoader = DiscoverDataLoader(rankBloc, chainCubit);
    _refreshManager = RefreshControllerManager(_dataLoader);
    _autoRefreshManager = AutoRefreshManager(() {
      _dataLoader.loadData(context, isRefresh: true);
    });
    _stateManager = DiscoverStateManager(_dataLoader, chainCubit);
    // 确保初始状态下自动刷新是关闭的
    _autoRefreshManager.onAutoRefreshChanged(false);
    if (!_isInitialized) {
      _isInitialized = true;
      _dataLoader.loadData(context, isRefresh: true);
    }
  }

  @override
  void dispose() {
    _refreshManager.dispose();
    _autoRefreshManager.dispose();
    _scrollController?.dispose();
    _scrollEndTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscoverRankBloc, DiscoverRankState>(
      listener: (context, state) {
        if (!mounted) return;
        
        _refreshManager.handleStateChange(state);
        
        if (state is DiscoverRankLoading || state is DiscoverRankLoadingMore) {
          _dataLoader.setLoading(true);
        } else {
          _dataLoader.setLoading(false);
        }
        
        // 首次加载完成后自动开启自动刷新
        if (state is DiscoverRankLoaded && !_isFirstLoadCompleted) {
          _isFirstLoadCompleted = true;
          // 暂停自动刷新功能
          // setState(() {
          //   _autoRefreshEnabled = true;
          // });
          // _autoRefreshManager.onAutoRefreshChanged(true);
        }
        
        if (state is DiscoverRankError) {
          DiscoverErrorHandler.handleError(context, state.message);
        }
      },
      child: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    return Stack(
      children: [
        _buildBackground(),
        _buildContent(),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE4FDFA), Colors.white],
          stops: [0, 0.31],
        ),
      ),
      // Web平台移除高度约束，让内容自然撑开
      constraints: kIsWeb ? null : const BoxConstraints(minHeight: 0),
    );
  }
  

  Widget _buildContent() {
    return SafeArea(
      top: !kIsWeb,
      child: Padding(
        padding: EdgeInsets.only(top: kIsWeb ? 0 : 0),
        child: SmartRefresher(
          controller: _refreshManager.controller,
          onRefresh: () => _refreshManager.onRefresh(context),
          onLoading: () => _refreshManager.onLoadMore(context),
          enablePullUp: !kIsWeb,
          enablePullDown: !kIsWeb,
          header: _buildRefreshHeader(),
          footer: _buildRefreshFooter(),
          child: _buildScrollContent(),
        ),
      ),
    );
  }

  Widget _buildRefreshHeader() {
    return const ClassicHeader(
      refreshingText: '',
      idleText: '',
      completeText: '',
      releaseText: '',
      refreshingIcon: CupertinoActivityIndicator(),
      completeIcon: Icon(Icons.check, color: Colors.green),
      failedIcon: Icon(Icons.error, color: Colors.red),
    );
  }

  Widget _buildRefreshFooter() {
    return const ClassicFooter(
      loadingText: '',
      idleText: '',
      noDataText: '',
      failedText: '',
      canLoadingText: '',
      loadingIcon: CupertinoActivityIndicator(),
      noMoreIcon: Icon(Icons.check, color: Colors.grey),
      failedIcon: Icon(Icons.error, color: Colors.red),
    );
  }

  Widget _buildScrollContent() {
    _setupScrollController();
    
    return CustomScrollView(
      controller: _scrollController,
      // 在Web环境下使用更适合的滚动物理效果
      physics: kIsWeb 
        ? const AlwaysScrollableScrollPhysics() 
        : const AlwaysScrollableScrollPhysics(),
      // Web平台添加额外的滚动优化
      cacheExtent: kIsWeb ? 1000.0 : 250.0, // Web平台增加缓存范围
      slivers: [
        // 顶部占位，防止内容和Header重叠
        SliverToBoxAdapter(
          child: SizedBox(height: kIsWeb ? 48 : 0),
        ),
        const SliverToBoxAdapter(child: AssetOverviewCard()),
        _buildTabFilter(),
        _buildAssetList(),
      ],
    );
  }

  void _onScrollChanged() {
    // 暂停自动刷新
    _autoRefreshManager.pauseAutoRefresh();
    
    // 取消之前的定时器
    _scrollEndTimer?.cancel();
    
    // 设置新的定时器，在滚动停止后恢复自动刷新
    // Web环境下使用更短的延迟，提高响应性
    final delay = kIsWeb ? 100 : 300; // Web环境下使用更短的延迟
    _scrollEndTimer = Timer(Duration(milliseconds: delay), () {
      if (mounted) {
        _autoRefreshManager.resumeAutoRefresh();
      }
    });
  }

  // 在Web环境下优化滚动监听器
  void _setupScrollController() {
    if (_scrollController == null) {
      _scrollController = ScrollController();
      
      // Web环境下直接使用监听器，不使用节流
      _scrollController!.addListener(_onScrollChanged);
      
      // Web平台添加调试信息
      if (kIsWeb) {
        debugPrint('Web平台滚动控制器已初始化');
      }
    }
  }

  Widget _buildTabFilter() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabFilterDelegate(
        child: BlocBuilder<ChainCubit, String>(
          builder: (context, currentChain) {
            return DiscoverTabFilter(
              currentChain: currentChain,
              onChainChanged: (chain) => _stateManager.onChainChanged(context, chain),
              onFilterChanged: (params) => _stateManager.onFilterChanged(context, params),
              onAutoRefreshChanged: _autoRefreshManager.onAutoRefreshChanged,
              autoRefreshEnabled: _autoRefreshEnabled,
            );
          },
        ),
      ),
    );
  }

  
  Widget _buildAssetList() {
    return BlocBuilder<DiscoverRankBloc, DiscoverRankState>(
      builder: (context, state) {
        return _buildStateContent(state);
      },
    );
  }

  Widget _buildStateContent(DiscoverRankState state) {
    if (state is DiscoverRankLoading) {
      return _buildLoadingState();
    } else if (state is DiscoverRankLoaded) {
      return _buildLoadedState(state);
    } else if (state is DiscoverRankLoadingMore) {
      return _buildLoadingMoreState(state);
    } else if (state is DiscoverRankError) {
      return _buildErrorState(state);
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildLoadingState() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildLoadedState(DiscoverRankLoaded state) {
    final response = state.response;
    final data = response?.data;
    final tokens = data?.newCreation ?? [];
    
    if (tokens.isEmpty) {
      return _buildEmptyState();
    }
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= tokens.length) return null;
          final token = tokens[index];
          return AssetListCell(
            token: token,
            onBuy: () {},
            onCopy: () {},
            onView: () {},
            showDivider: index < tokens.length - 1,
          );
        },
        childCount: tokens.length,
      ),
    );
  }

  Widget _buildLoadingMoreState(DiscoverRankLoadingMore state) {
    final response = state.currentResponse;
    final data = response?.data;
    final tokens = data?.newCreation ?? [];
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < tokens.length) {
            final token = tokens[index];
            return AssetListCell(
              token: token,
              onBuy: () {},
              onCopy: () {},
              onView: () {},
              showDivider: index < tokens.length - 1,
            );
          } else {
            return _buildLoadingMoreIndicator();
          }
        },
        childCount: tokens.length + 1,
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('正在加载更多...'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('暂无数据', style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 8),
              Text('下拉刷新试试', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(DiscoverRankError state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('加载失败', style: TextStyle(color: Colors.red, fontSize: 16)),
              const SizedBox(height: 8),
              Text(state.message, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _dataLoader.loadData(context, isRefresh: true),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 标签过滤器代理
class _TabFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  
  _TabFilterDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  double get maxExtent => 100.0;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

