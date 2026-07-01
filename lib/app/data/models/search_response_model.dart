import 'kos_result_model.dart';

class SearchResponseModel {
  const SearchResponseModel({
    required this.status,
    required this.queryOriginal,
    required this.queryPreprocessed,
    required this.queryExpanded,
    required this.expansionTerms,
    required this.totalCandidates,
    required this.searchTimeMs,
    required this.totalResults,
    required this.superDealCount,
    required this.results,
  });

  final String status;
  final String queryOriginal;
  final String queryPreprocessed;
  final String queryExpanded;
  final List<String> expansionTerms;
  final int totalCandidates;
  final double searchTimeMs;
  final int totalResults;
  final int superDealCount;
  final List<KosResultModel> results;

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel.fromResponse(json);
  }

  factory SearchResponseModel.fromResponse(dynamic response) {
    final rawItems = _extractItems(response);
    final results = rawItems
        .whereType<Map>()
        .map((item) => KosResultModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    final rawTotalResults = _read(response, 'total_results');

    return SearchResponseModel(
      status: _asString(_read(response, 'status'), fallback: 'success'),
      queryOriginal: _asString(_read(response, 'query_original')),
      queryPreprocessed: _asString(_read(response, 'query_preprocessed')),
      queryExpanded: _asString(_read(response, 'query_expanded')),
      expansionTerms: _stringList(_read(response, 'expansion_terms')),
      totalCandidates: _asInt(_read(response, 'total_candidates')),
      searchTimeMs: _asDouble(_read(response, 'search_time_ms')),
      totalResults: rawTotalResults == null
          ? results.length
          : _asInt(rawTotalResults),
      superDealCount: _asInt(_read(response, 'super_deal_count')),
      results: results,
    );
  }

  static List<dynamic> _extractItems(dynamic value, [int depth = 0]) {
    if (value is List) return value;
    if (value is! Map || depth > 3) return const [];

    final map = Map<String, dynamic>.from(value);
    if (map.containsKey('id_kos') || map.containsKey('nama_kos')) {
      return [map];
    }

    for (final key in const ['results', 'items', 'kos']) {
      final candidate = map[key];
      if (candidate is List) return candidate;
    }

    for (final key in const ['data', 'payload', 'response', 'result']) {
      final candidate = map[key];
      if (candidate is List) return candidate;
      if (candidate is Map) {
        final nested = _extractItems(candidate, depth + 1);
        if (nested.isNotEmpty) return nested;
      }
    }
    return const [];
  }

  static dynamic _read(dynamic value, String key, [int depth = 0]) {
    if (value is! Map || depth > 3) return null;
    final map = Map<String, dynamic>.from(value);
    if (map.containsKey(key)) return map[key];

    for (final wrapper in const ['data', 'payload', 'response', 'result']) {
      final nested = map[wrapper];
      if (nested is Map) {
        final result = _read(nested, key, depth + 1);
        if (result != null) return result;
      }
    }
    return null;
  }

  static String _asString(dynamic value, {String fallback = ''}) {
    final text = value?.toString() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static List<String> _stringList(dynamic value) =>
      value is List ? value.map((item) => item.toString()).toList() : const [];

  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
