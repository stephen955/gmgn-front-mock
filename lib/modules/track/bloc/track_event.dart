import 'package:equatable/equatable.dart';

abstract class TrackEvent extends Equatable {
  const TrackEvent();

  @override
  List<Object?> get props => [];
}

class TrackLoadRequested extends TrackEvent {
  final String type;
  final String timeframe;
  final String filter;
  final String sort;

  const TrackLoadRequested({
    required this.type,
    required this.timeframe,
    required this.filter,
    required this.sort,
  });

  @override
  List<Object?> get props => [type, timeframe, filter, sort];
}

class TrackRefreshRequested extends TrackEvent {
  final String type;
  final String timeframe;
  final String filter;
  final String sort;

  const TrackRefreshRequested({
    required this.type,
    required this.timeframe,
    required this.filter,
    required this.sort,
  });

  @override
  List<Object?> get props => [type, timeframe, filter, sort];
}

class TrackTimeframeChanged extends TrackEvent {
  final String timeframe;

  const TrackTimeframeChanged(this.timeframe);

  @override
  List<Object?> get props => [timeframe];
}

class TrackFilterChanged extends TrackEvent {
  final String filter;

  const TrackFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class TrackSortChanged extends TrackEvent {
  final String sort;

  const TrackSortChanged(this.sort);

  @override
  List<Object?> get props => [sort];
} 