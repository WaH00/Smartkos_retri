import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';

class SearchApiProvider {
  SearchApiProvider(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> searchKos({
    required String kueri,
    required double latitude,
    required double longitude,
    int topK = ApiConstants.defaultTopK,
    int nCandidates = ApiConstants.defaultNCandidates,
  }) {
    return _apiClient.post(
      ApiConstants.searchKos,
      data: buildSearchPayload(
        kueri: kueri,
        latitude: latitude,
        longitude: longitude,
        topK: topK,
        nCandidates: nCandidates,
      ),
    );
  }

  Future<dynamic> checkHealth() {
    return _apiClient.get(ApiConstants.health);
  }

  static Map<String, dynamic> buildSearchPayload({
    required String kueri,
    required double latitude,
    required double longitude,
    int topK = ApiConstants.defaultTopK,
    int nCandidates = ApiConstants.defaultNCandidates,
  }) {
    return {
      'kueri': kueri.trim(),
      'latitude': latitude,
      'longitude': longitude,
      'top_k': topK,
      'n_candidates': nCandidates,
    };
  }
}
