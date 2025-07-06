abstract class MonitorEvent {}

class MonitorLoadRequested extends MonitorEvent {
  final String type; // 'sol' 或 'kol'
  final String timeframe;
  final String filter;
  final String sort;
  
  MonitorLoadRequested({
    required this.type,
    this.timeframe = '24h',
    this.filter = '全部',
    this.sort = '涨幅',
  });
}

class MonitorRefreshRequested extends MonitorEvent {
  final String type;
  final String timeframe;
  final String filter;
  final String sort;
  
  MonitorRefreshRequested({
    required this.type,
    this.timeframe = '24h',
    this.filter = '全部',
    this.sort = '涨幅',
  });
}

class MonitorFilterChanged extends MonitorEvent {
  final String filter;
  MonitorFilterChanged(this.filter);
}

class MonitorSortChanged extends MonitorEvent {
  final String sort;
  MonitorSortChanged(this.sort);
}

class MonitorTimeframeChanged extends MonitorEvent {
  final String timeframe;
  MonitorTimeframeChanged(this.timeframe);
} 