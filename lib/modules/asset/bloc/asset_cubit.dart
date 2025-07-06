import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/asset_overview.dart';
import '../../../data/repositories/asset_repository.dart';
import './asset_state.dart';

class AssetCubit extends Cubit<AssetState> {
  final AssetRepository repository;
  AssetCubit(this.repository) : super(AssetInitial());

  Future<void> fetchAssetData({String chain = 'sol'}) async {
    emit(AssetLoading());
    try {
      final json = await repository.fetchAssetData(chain:chain);
      final data = AssetPageData.fromJson(json);
      emit(AssetLoaded(data: data));
    } catch (e) {
      emit(AssetError(e.toString()));
    }
  }
} 