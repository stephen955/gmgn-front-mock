import 'package:gmgn_front/core/network/api_service.dart';
import '../models/track_card_model.dart';

class TrackRepository {
  final ApiService _apiService = ApiService();

  Future<List<TrackCardModel>> fetchTrackCards() {
    return _apiService.fetchTrackCards();
  }
} 