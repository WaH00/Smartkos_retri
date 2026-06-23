import '../models/kos_model.dart';
import '../providers/kos_provider.dart';

class KosRepository {
  KosRepository(this._provider);

  final KosProvider _provider;

  Future<List<KosModel>> searchKos({
    required String query,
    required double latitude,
    required double longitude,
    required double radiusKm,
    int? minPrice,
    int? maxPrice,
    List<String> facilities = const [],
  }) async {
    // Reserved for the real API search request; mock data already stores distance.
    final _ = (latitude, longitude);
    final kos = await _provider.getMockKos();
    final normalizedQuery = query.trim().toLowerCase();
    final selectedFacilities = facilities
        .where((facility) => facility.toLowerCase() != 'semua')
        .toList();

    final filtered = kos.where((item) {
      final searchableText = [
        item.namaKos,
        item.alamat,
        item.deskripsi,
        ...item.fasilitas,
      ].join(' ').toLowerCase();

      final matchesQuery =
          normalizedQuery.isEmpty || searchableText.contains(normalizedQuery);
      final matchesMinPrice = minPrice == null || item.harga >= minPrice;
      final matchesMaxPrice = maxPrice == null || item.harga <= maxPrice;
      final matchesFacilities =
          selectedFacilities.isEmpty ||
          selectedFacilities.every(item.fasilitas.contains);
      final matchesRadius = item.jarakKm <= radiusKm;

      return matchesQuery &&
          matchesMinPrice &&
          matchesMaxPrice &&
          matchesFacilities &&
          matchesRadius;
    }).toList();

    filtered.sort((a, b) {
      final superDealComparison = b.isSuperDeal.toString().compareTo(
        a.isSuperDeal.toString(),
      );
      if (superDealComparison != 0) return superDealComparison;

      final scoreComparison = b.skorRelevansi.compareTo(a.skorRelevansi);
      if (scoreComparison != 0) return scoreComparison;

      final distanceComparison = a.jarakKm.compareTo(b.jarakKm);
      if (distanceComparison != 0) return distanceComparison;

      return a.harga.compareTo(b.harga);
    });

    return filtered;
  }

  Future<KosModel?> getKosById(String id) => _provider.getMockKosById(id);

  Future<List<KosModel>> getFavoriteKos() async {
    final kos = await _provider.getMockKos();
    return kos.where((item) => item.isFavorite).toList();
  }

  Future<KosModel> toggleFavorite(String id) => _provider.toggleFavorite(id);

  Future<void> clearFavorites() => _provider.clearFavorites();
}
