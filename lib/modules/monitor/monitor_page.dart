import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gmgn_front/modules/monitor/widgets/category_tabbar.dart';
import 'package:gmgn_front/modules/monitor/widgets/filter_bar.dart';
import 'package:gmgn_front/modules/monitor/widgets/smart_money_card.dart';
import 'package:gmgn_front/modules/monitor/bloc/monitor_bloc.dart';
import 'package:gmgn_front/modules/monitor/bloc/monitor_event.dart';
import 'package:gmgn_front/modules/monitor/bloc/monitor_state.dart';

@RoutePage()
class MonitorPage extends StatefulWidget {
  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> with SingleTickerProviderStateMixin {
  late MonitorBloc _monitorBloc;
  
  String period = '24h';
  String filter = '全部';
  String sort = '涨幅';
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _monitorBloc = MonitorBloc();
    _loadInitialData();
  }

  void _loadInitialData() {
    final type = _getCurrentType();
    _monitorBloc.add(MonitorLoadRequested(
      type: type,
      timeframe: period,
      filter: filter,
      sort: sort,
    ));
  }

  String _getCurrentType() {
    switch (currentTabIndex) {
      case 0:
        return 'sol'; // 聪明钱
      case 1:
        return 'kol'; // KOL
      default:
        return 'sol';
    }
  }

  void _onTabChange(int index) {
    setState(() {
      currentTabIndex = index;
    });
    _loadData();
  }

  void _loadData() {
    final type = _getCurrentType();
    _monitorBloc.add(MonitorLoadRequested(
      type: type,
      timeframe: period,
      filter: filter,
      sort: sort,
    ));
  }

  void _onPeriodChanged(String? value) {
    if (value != null) {
      setState(() {
        period = value;
      });
      _monitorBloc.add(MonitorTimeframeChanged(value));
    }
  }

  void _onFilterChanged(String? value) {
    if (value != null) {
      setState(() {
        filter = value;
      });
      _monitorBloc.add(MonitorFilterChanged(value));
    }
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        sort = value;
      });
      _monitorBloc.add(MonitorSortChanged(value));
    }
  }

  Future<void> _onRefresh() async {
    final type = _getCurrentType();
    _monitorBloc.add(MonitorRefreshRequested(
      type: type,
      timeframe: period,
      filter: filter,
      sort: sort,
    ));
  }

  @override
  void dispose() {
    _monitorBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _monitorBloc,
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
              child: Column(
                children: [
                  CategoryTabBar(
                    tabs: const ['聪明钱', 'KOL', '狙击新币'],
                    initialIndex: currentTabIndex,
                    onTabChange: _onTabChange,
                  ),
                  // FilterBar(
                  //   selectedPeriod: period,
                  //   periodOptions: const ['24h', '7d', '30d'],
                  //   onPeriodChanged: _onPeriodChanged,
                  //   selectedFilter: filter,
                  //   filterOptions: const ['全部', '买入', '卖出'],
                  //   onFilterChanged: _onFilterChanged,
                  //   selectedSort: sort,
                  //   sortOptions: const ['涨幅', '流入量', '市值'],
                  //   onSortChanged: _onSortChanged,
                  // )
                ],
              ),
            ),
          ),
        ),
        body: Padding(padding: EdgeInsets.only(top: 4),child: IndexedStack(
          index: currentTabIndex,
          children: [
            // 聪明钱内容
            _buildContent(),
            // KOL内容
            _buildContent(),
            // 狙击新币内容
            const Center(child: Text('狙击新币 内容')),
          ],
        ),),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<MonitorBloc, MonitorState>(
      builder: (context, state) {
        if (state is MonitorInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MonitorLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MonitorError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }

        if (state is MonitorLoaded) {
          final cards = state.data.data.cards;
          
          if (cards.isEmpty) {
            return const Center(
              child: Text('暂无数据'),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, idx) {
                final card = cards[idx];
                return SmartMoneyCard(
                  name: card.name,
                  address: card.address,
                  people: card.holderCount,
                  netInflow: card.netInflow.toStringAsFixed(2),
                  v: card.volume24h.toStringAsFixed(2),
                  mc: card.marketCap.toStringAsFixed(2),
                  percent: '${card.priceChangePercent24h.toStringAsFixed(2)}%',
                  percentColor: card.priceChangePercent24h >= 0 ? Colors.green : Colors.red,
                  wallet: card.wallets.isNotEmpty ? card.wallets.first.name : '',
                  trades: '${card.buyCount}/${card.sellCount}',
                  flow: card.netInflow.toStringAsFixed(2),
                  amount: card.price.toStringAsFixed(2),
                  timeInfo: card.timeInfo,
                  logo: card.logo,
                  onBuy: () {
                    // 处理买入逻辑
                    print('买入 ${card.name}');
                  },
                  wallets: card.wallets,
                );
              },
            ),
          );
        }

        if (state is MonitorRefreshing) {
          final cards = state.previousData?.data.cards ?? [];
          
          if (cards.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, idx) {
                final card = cards[idx];
                return SmartMoneyCard(
                  name: card.name,
                  address: card.address,
                  people: card.holderCount,
                  netInflow: card.netInflow.toStringAsFixed(2),
                  v: card.volume24h.toStringAsFixed(2),
                  mc: card.marketCap.toStringAsFixed(2),
                  percent: '${card.priceChangePercent24h.toStringAsFixed(2)}%',
                  percentColor: card.priceChangePercent24h >= 0 ? Colors.green : Colors.red,
                  wallet: card.wallets.isNotEmpty ? card.wallets.first.name : '',
                  trades: '${card.buyCount}/${card.sellCount}',
                  flow: card.netInflow.toStringAsFixed(2),
                  amount: card.price.toStringAsFixed(2),
                  timeInfo: card.timeInfo,
                  logo: card.logo,
                  onBuy: () {
                    // 处理买入逻辑
                    print('买入 ${card.name}');
                  },
                  wallets: card.wallets,
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('未知状态'),
        );
      },
    );
  }
}



