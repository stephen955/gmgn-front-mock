import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/modules/monitor/bloc/monitor_event.dart';
import 'package:gmgn_front/modules/monitor/bloc/monitor_state.dart';
import 'package:gmgn_front/data/repositories/monitor_repository.dart';
import 'package:gmgn_front/data/models/monitor_models.dart';

class MonitorBloc extends Bloc<MonitorEvent, MonitorState> {
  final MonitorRepository _repository = MonitorRepository();

  MonitorBloc() : super(MonitorInitial()) {
    on<MonitorLoadRequested>(_onLoadRequested);
    on<MonitorRefreshRequested>(_onRefreshRequested);
    on<MonitorFilterChanged>(_onFilterChanged);
    on<MonitorSortChanged>(_onSortChanged);
    on<MonitorTimeframeChanged>(_onTimeframeChanged);
  }

  Future<void> _onLoadRequested(
    MonitorLoadRequested event,
    Emitter<MonitorState> emit,
  ) async {
    emit(MonitorLoading());
    
    try {
      SmartCardsResponse data;
      
      if (event.type == 'sol') {
        data = await _repository.fetchSolSmartCards(
          timeframe: event.timeframe,
        );
      } else if (event.type == 'kol') {
        data = await _repository.fetchKolSmartCards(
          timeframe: event.timeframe,
        );
      } else {
        throw Exception('不支持的类型: ${event.type}');
      }
      emit(MonitorLoaded(
        data: data,
        type: event.type,
        timeframe: event.timeframe,
        filter: event.filter,
        sort: event.sort,
      ));
    } catch (e) {
      emit(MonitorError(
        message: '加载数据失败: $e',
        type: event.type,
        timeframe: event.timeframe,
        filter: event.filter,
        sort: event.sort,
      ));
    }
  }

  Future<void> _onRefreshRequested(
    MonitorRefreshRequested event,
    Emitter<MonitorState> emit,
  ) async {
    // 获取当前状态的数据用于显示刷新状态
    SmartCardsResponse? previousData;
    if (state is MonitorLoaded) {
      previousData = (state as MonitorLoaded).data;
    }
    
    emit(MonitorRefreshing(
      previousData: previousData,
      type: event.type,
      timeframe: event.timeframe,
      filter: event.filter,
      sort: event.sort,
    ));
    
    try {
      SmartCardsResponse data;
      
      if (event.type == 'sol') {
        data = await _repository.fetchSolSmartCards(
          timeframe: event.timeframe,
        );
      } else if (event.type == 'kol') {
        data = await _repository.fetchKolSmartCards(
          timeframe: event.timeframe,
        );
      } else {
        throw Exception('不支持的类型: ${event.type}');
      }
      
      emit(MonitorLoaded(
        data: data,
        type: event.type,
        timeframe: event.timeframe,
        filter: event.filter,
        sort: event.sort,
      ));
    } catch (e) {
      emit(MonitorError(
        message: '刷新数据失败: $e',
        type: event.type,
        timeframe: event.timeframe,
        filter: event.filter,
        sort: event.sort,
      ));
    }
  }

  void _onFilterChanged(
    MonitorFilterChanged event,
    Emitter<MonitorState> emit,
  ) {
    if (state is MonitorLoaded) {
      final currentState = state as MonitorLoaded;
      emit(MonitorLoaded(
        data: currentState.data,
        type: currentState.type,
        timeframe: currentState.timeframe,
        filter: event.filter,
        sort: currentState.sort,
      ));
    }
  }

  void _onSortChanged(
    MonitorSortChanged event,
    Emitter<MonitorState> emit,
  ) {
    if (state is MonitorLoaded) {
      final currentState = state as MonitorLoaded;
      emit(MonitorLoaded(
        data: currentState.data,
        type: currentState.type,
        timeframe: currentState.timeframe,
        filter: currentState.filter,
        sort: event.sort,
      ));
    }
  }

  void _onTimeframeChanged(
    MonitorTimeframeChanged event,
    Emitter<MonitorState> emit,
  ) {
    if (state is MonitorLoaded) {
      final currentState = state as MonitorLoaded;
      // 时间范围改变时重新加载数据
      add(MonitorLoadRequested(
        type: currentState.type,
        timeframe: event.timeframe,
        filter: currentState.filter,
        sort: currentState.sort,
      ));
    }
  }
} 