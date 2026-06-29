import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';

class SearchApiProvider {
  SearchApiProvider(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> searchKos({
    required String kueri,
    required double latitude,
    required double longitude,
    int topK = ApiConstants.defaultTopK,
    int nCandidates = ApiConstants.defaultNCandidates,
  }) {
    return _apiClient.post(
      ApiConstants.searchKos,
      data: {
        'kueri': kueri.trim(),
        'latitude': latitude,
        'longitude': longitude,
        'top_k': topK,
        'n_candidates': nCandidates,
      },
    );
  }

  Future<Map<String, dynamic>> checkHealth() {
    return _apiClient.get(ApiConstants.health);
  }
}
