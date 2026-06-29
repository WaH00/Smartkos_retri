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
    final rawResults = json['results'];
    return SearchResponseModel(
      status: json['status']?.toString() ?? '',
      queryOriginal: json['query_original']?.toString() ?? '',
      queryPreprocessed: json['query_preprocessed']?.toString() ?? '',
      queryExpanded: json['query_expanded']?.toString() ?? '',
      expansionTerms: _stringList(json['expansion_terms']),
      totalCandidates: _asInt(json['total_candidates']),
      searchTimeMs: _asDouble(json['search_time_ms']),
      totalResults: _asInt(json['total_results']),
      superDealCount: _asInt(json['super_deal_count']),
      results: rawResults is List
          ? rawResults
                .whereType<Map>()
                .map(
                  (item) =>
                      KosResultModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
    );
  }

  static List<String> _stringList(dynamic value) =>
      value is List ? value.map((item) => item.toString()).toList() : const [];
  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
}
