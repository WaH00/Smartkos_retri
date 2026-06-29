import '../models/kos_result_model.dart';
import '../models/search_response_model.dart';
import '../providers/search_api_provider.dart';

class SearchRepository {
  SearchRepository(this._provider);

  final SearchApiProvider _provider;
  final Map<int, KosResultModel> _favorites = {};

  Future<SearchResponseModel> searchKos({
    required String kueri,
    required double latitude,
    required double longitude,
    required int topK,
    required int nCandidates,
  }) async {
    final json = await _provider.searchKos(
      kueri: kueri,
      latitude: latitude,
      longitude: longitude,
      topK: topK,
      nCandidates: nCandidates,
    );
    final response = SearchResponseModel.fromJson(json);
    final hydrated = response.results
        .map(
          (kos) => kos.copyWith(isFavorite: _favorites.containsKey(kos.idKos)),
        )
        .toList();
    return SearchResponseModel(
      status: response.status,
      queryOriginal: response.queryOriginal,
      queryPreprocessed: response.queryPreprocessed,
      queryExpanded: response.queryExpanded,
      expansionTerms: response.expansionTerms,
      totalCandidates: response.totalCandidates,
      searchTimeMs: response.searchTimeMs,
      totalResults: response.totalResults,
      superDealCount: response.superDealCount,
      results: hydrated,
    );
  }

  Future<bool> checkHealth() async {
    await _provider.checkHealth();
    return true;
  }

  List<KosResultModel> getFavorites() => _favorites.values.toList();

  KosResultModel toggleFavorite(KosResultModel kos) {
    if (_favorites.containsKey(kos.idKos)) {
      _favorites.remove(kos.idKos);
      return kos.copyWith(isFavorite: false);
    }
    final saved = kos.copyWith(isFavorite: true);
    _favorites[kos.idKos] = saved;
    return saved;
  }

  void clearFavorites() => _favorites.clear();
}
