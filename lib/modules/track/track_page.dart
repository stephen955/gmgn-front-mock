import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/track_bloc.dart';
import 'bloc/track_event.dart';
import 'bloc/track_state.dart' hide TrackCard;
import 'widgets/track_card.dart';
import 'package:gmgn_front/modules/monitor/widgets/category_tabbar.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({Key? key}) : super(key: key);

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  late TrackBloc _trackBloc;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _trackBloc = TrackBloc();
    _loadData();
  }

  void _onTabChange(int index) {
    setState(() {
      currentTabIndex = index;
    });
    _loadData();
  }

  void _loadData() {
    // 这里只处理牛人榜，其他tab后续可补充
    if (currentTabIndex == 0) {
      _trackBloc.add(const TrackLoadRequested(
        type: 'profit', timeframe: '', filter: '', sort: '',
      ));
    }
  }

  Future<void> _onRefresh() async {
    if (currentTabIndex == 0) {
      _trackBloc.add(const TrackRefreshRequested(
        type: 'profit', timeframe: '', filter: '', sort: '',
      ));
    }
  }

  @override
  void dispose() {
    _trackBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _trackBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SafeArea(
            bottom: false,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
                ),
              ),
              child: CategoryTabBar(
                tabs: const ['牛人榜', '钱包追踪', '追踪'],
                initialIndex: currentTabIndex,
                onTabChange: _onTabChange,
              ),
            ),
          ),
        ),
        body: IndexedStack(
          index: currentTabIndex,
          children: [
            // 牛人榜内容
            BlocBuilder<TrackBloc, TrackState>(
              builder: (context, state) {
                if (state is TrackLoading || state is TrackInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TrackError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }
                if (state is TrackLoaded) {
                  final cards = state.data.cards;
                  if (cards.isEmpty) {
                    return const Center(child: Text('暂无数据'));
                  }
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, idx) {
                        final card = cards[idx];
                        return TrackCard(
                          // TODO: 这里填充你的 TrackCardModel 字段
                          // 例如：
                          name: card.name,
                          address: card.address,
                          rank: idx + 1,
                          profit: card.profit,
                          pnlPercent: card.pnlPercent,
                          totalValue: card.totalValue,
                          tradeCount: card.tradeCount,
                          winTradeCount: card.winTradeCount,
                          loseTradeCount: card.loseTradeCount,
                          winRate: card.winRate,
                          followers: card.followers,
                          avatar: card.avatar,
                          chainLogo: card.chainLogo,
                          timeInfo: card.timeInfo,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // 钱包追踪内容
            const Center(child: Text('钱包追踪')), // 可后续补充
            // 追踪内容
            const Center(child: Text('追踪')), // 可后续补充
          ],
        ),
      ),
    );
  }
} 