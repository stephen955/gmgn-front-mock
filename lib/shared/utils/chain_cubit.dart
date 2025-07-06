import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmgn_front/modules/discover/services/chain_storage_service.dart';
import 'package:gmgn_front/shared/chain_constants.dart';

class ChainCubit extends Cubit<String> {
  ChainCubit() : super(ChainConstants.sol) {
    _loadStoredChain();
  }

  /// 从存储中加载上次选择的链
  Future<void> _loadStoredChain() async {
    try {
      final storedChain = await ChainStorageService.getSelectedChain();
      emit(storedChain);
    } catch (e) {
      // 如果加载失败，使用默认值
      emit(ChainConstants.sol);
    }
  }

  /// 设置链并保存到存储
  Future<void> setChain(String chain) async {
    try {
      await ChainStorageService.saveSelectedChain(chain);
      emit(chain);
    } catch (e) {
      // 如果保存失败，仍然更新状态
      emit(chain);
    }
  }
} 