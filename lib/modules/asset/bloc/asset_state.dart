import 'package:equatable/equatable.dart';
import '../../../data/models/asset_overview.dart';

abstract class AssetState extends Equatable {
  const AssetState();

  @override
  List<Object?> get props => [];
}

class AssetInitial extends AssetState {}

class AssetLoading extends AssetState {}

class AssetLoaded extends AssetState {
  final AssetPageData data;
  const AssetLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class AssetError extends AssetState {
  final String message;
  const AssetError(this.message);

  @override
  List<Object?> get props => [message];
} 