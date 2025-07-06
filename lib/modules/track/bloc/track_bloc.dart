import 'package:flutter_bloc/flutter_bloc.dart';
import 'track_event.dart';
import 'track_state.dart';
import 'package:gmgn_front/data/repositories/track_repository.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final TrackRepository repository;
  TrackBloc({TrackRepository? repository})
      : repository = repository ?? TrackRepository(),
        super(TrackInitial()) {
    on<TrackLoadRequested>(_onTrackLoadRequested);
    on<TrackRefreshRequested>(_onTrackRefreshRequested);
    on<TrackTimeframeChanged>(_onTrackTimeframeChanged);
    on<TrackFilterChanged>(_onTrackFilterChanged);
    on<TrackSortChanged>(_onTrackSortChanged);
  }

  Future<void> _onTrackLoadRequested(
    TrackLoadRequested event,
    Emitter<TrackState> emit,
  ) async {
    emit(TrackLoading());
    try {
      final cardList = await repository.fetchTrackCards();
      // TrackCardModel => TrackCard
      final cards = List<TrackCard>.generate(cardList.length, (idx) {
        final c = cardList[idx];
        return TrackCard.fromJson({
          'name': c.name,
          'address': c.address,
          'rank': idx + 1,
          'profit': c.profit,
          'totalValue': c.totalValue,
          'tradeCount': c.tradeCount,
          'avatar': c.avatar,
          'timeInfo': c.timeInfo,
          'pnlPercent': c.pnlPercent,
          'winTradeCount': c.winTradeCount,
          'loseTradeCount': c.loseTradeCount,
          'winRate': c.winRate,
          'followers': c.followers,
          'chainLogo': c.chainLogo,
        });
      });
      final data = TrackData(cards: cards);
      emit(TrackLoaded(data));
    } catch (e) {
      emit(TrackError(e.toString()));
    }
  }

  Future<void> _onTrackRefreshRequested(
    TrackRefreshRequested event,
    Emitter<TrackState> emit,
  ) async {
    final currentState = state;
    if (currentState is TrackLoaded) {
      emit(TrackRefreshing(currentState.data));
    }
    try {
      final cardList = await repository.fetchTrackCards();
      final cards = List<TrackCard>.generate(cardList.length, (idx) {
        final c = cardList[idx];
        return TrackCard.fromJson({
          'name': c.name,
          'address': c.address,
          'rank': idx + 1,
          'profit': c.profit,
          'totalValue': c.totalValue,
          'tradeCount': c.tradeCount,
          'avatar': c.avatar,
          'timeInfo': c.timeInfo,
          'pnlPercent': c.pnlPercent,
          'winTradeCount': c.winTradeCount,
          'loseTradeCount': c.loseTradeCount,
          'winRate': c.winRate,
          'followers': c.followers,
          'chainLogo': c.chainLogo,
        });
      });
      final data = TrackData(cards: cards);
      emit(TrackLoaded(data));
    } catch (e) {
      emit(TrackError(e.toString()));
    }
  }

  void _onTrackTimeframeChanged(
    TrackTimeframeChanged event,
    Emitter<TrackState> emit,
  ) {}

  void _onTrackFilterChanged(
    TrackFilterChanged event,
    Emitter<TrackState> emit,
  ) {}

  void _onTrackSortChanged(
    TrackSortChanged event,
    Emitter<TrackState> emit,
  ) {}
} 