import 'package:gmgn_front/data/models/monitor_models.dart';

abstract class MonitorState {}

class MonitorInitial extends MonitorState {}

class MonitorLoading extends MonitorState {}

class MonitorLoaded extends MonitorState {
  final SmartCardsResponse data;
  final String type;
  final String timeframe;
  final String filter;
  final String sort;
  
  MonitorLoaded({
    required this.data,
    required this.type,
    required this.timeframe,
    required this.filter,
    required this.sort,
  });
}

class MonitorError extends MonitorState {
  final String message;
  final String type;
  final String timeframe;
  final String filter;
  final String sort;
  
  MonitorError({
    required this.message,
    required this.type,
    required this.timeframe,
    required this.filter,
    required this.sort,
  });
}

class MonitorRefreshing extends MonitorState {
  final SmartCardsResponse? previousData;
  final String type;
  final String timeframe;
  final String filter;
  final String sort;
  
  MonitorRefreshing({
    this.previousData,
    required this.type,
    required this.timeframe,
    required this.filter,
    required this.sort,
  });
} 