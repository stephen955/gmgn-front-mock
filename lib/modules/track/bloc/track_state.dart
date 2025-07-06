import 'package:equatable/equatable.dart';

abstract class TrackState extends Equatable {
  const TrackState();

  @override
  List<Object?> get props => [];
}

class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackLoaded extends TrackState {
  final TrackData data;

  const TrackLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class TrackRefreshing extends TrackState {
  final TrackData? previousData;

  const TrackRefreshing(this.previousData);

  @override
  List<Object?> get props => [previousData];
}

class TrackError extends TrackState {
  final String message;

  const TrackError(this.message);

  @override
  List<Object?> get props => [message];
}

class TrackData {
  final List<TrackCard> cards;

  const TrackData({required this.cards});
}

class TrackCard {
  final String name;
  final String address;
  final int rank;
  final double profit;
  final double totalValue;
  final int tradeCount;
  final String avatar;
  final String timeInfo;
  final double pnlPercent;
  final int winTradeCount;
  final int loseTradeCount;
  final double winRate;
  final int followers;
  final String chainLogo;

  const TrackCard({
    required this.name,
    required this.address,
    required this.rank,
    required this.profit,
    required this.totalValue,
    required this.tradeCount,
    required this.avatar,
    required this.timeInfo,
    required this.pnlPercent,
    required this.winTradeCount,
    required this.loseTradeCount,
    required this.winRate,
    required this.followers,
    required this.chainLogo,
  });

  factory TrackCard.fromJson(Map<String, dynamic> json) {
    return TrackCard(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      rank: json['rank'] ?? 0,
      profit: (json['profit'] ?? 0).toDouble(),
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      tradeCount: json['tradeCount'] ?? 0,
      avatar: json['avatar'] ?? '',
      timeInfo: json['timeInfo'] ?? '',
      pnlPercent: (json['pnlPercent'] ?? 0).toDouble(),
      winTradeCount: json['winTradeCount'] ?? 0,
      loseTradeCount: json['loseTradeCount'] ?? 0,
      winRate: (json['winRate'] ?? 0).toDouble(),
      followers: json['followers'] ?? 0,
      chainLogo: json['chainLogo'] ?? '',
    );
  }
} 