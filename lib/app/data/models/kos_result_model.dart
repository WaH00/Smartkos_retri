import 'fasilitas_model.dart';

class KosResultModel {
  const KosResultModel({
    required this.idKos,
    required this.namaKos,
    required this.kota,
    required this.wilayah,
    required this.fotoPath,
    required this.hargaPerBulan,
    required this.predictedPrice,
    required this.distanceKm,
    required this.finalScore,
    required this.semanticScore,
    required this.geospatialScore,
    required this.priceBoost,
    required this.priceLabel,
    required this.isSuperDeal,
    required this.rating,
    required this.fasilitas,
    this.tipeKos = '',
    this.isFavorite = false,
  });

  final int idKos;
  final String namaKos;
  final String kota;
  final String wilayah;
  final String fotoPath;
  final int hargaPerBulan;
  final double predictedPrice;
  final double distanceKm;
  final double finalScore;
  final double semanticScore;
  final double geospatialScore;
  final double priceBoost;
  final String priceLabel;
  final bool isSuperDeal;
  final double rating;
  final FasilitasModel fasilitas;
  final String tipeKos;

  // Favorite is local UI state until the backend exposes a favorite endpoint.
  final bool isFavorite;

  factory KosResultModel.fromJson(Map<String, dynamic> json) {
    return KosResultModel(
      idKos: _asInt(_first(json, ['id_kos', 'id', '_id'])),
      namaKos: _asString(_first(json, ['nama_kos', 'namaKos', 'name'])),
      kota: _asString(_first(json, ['kota', 'city'])),
      wilayah: _asString(_first(json, ['wilayah', 'area', 'alamat'])),
      fotoPath: _asString(
        _first(json, ['foto_path', 'image_url', 'foto', 'photo']),
      ),
      hargaPerBulan: _asInt(
        _first(json, ['harga_per_bulan', 'harga', 'price']),
      ),
      predictedPrice: _asDouble(
        _first(json, ['predicted_price', 'harga_prediksi']),
      ),
      distanceKm: _asDouble(
        _first(json, ['distance_km', 'jarak_km', 'distance', 'jarak']),
      ),
      finalScore: _asScore(
        _first(json, ['final_score', 'score', 'skor', 'skor_relevansi']),
      ),
      semanticScore: _asScore(
        _first(json, ['semantic_score', 'semanticScore']),
      ),
      geospatialScore: _asScore(
        _first(json, ['geospatial_score', 'geospatialScore']),
      ),
      priceBoost: _asScore(_first(json, ['price_boost', 'priceBoost'])),
      priceLabel: _asString(_first(json, ['price_label', 'priceLabel'])),
      isSuperDeal: _asBool(_first(json, ['is_super_deal', 'isSuperDeal'])),
      rating: _asDouble(json['rating']),
      fasilitas: FasilitasModel.fromDynamic(
        _first(json, ['fasilitas', 'facilities']),
      ),
      tipeKos: _asString(_first(json, ['tipe_kos', 'tipeKos', 'type'])),
    );
  }

  double get priceSaving => predictedPrice - hargaPerBulan;

  double get discountPercent =>
      predictedPrice > 0 ? priceSaving / predictedPrice * 100 : 0;

  String get locationText {
    final parts = [wilayah, kota].where((value) => value.trim().isNotEmpty);
    return parts.join(', ');
  }

  List<String> get facilityLabels => fasilitas.labels;

  KosResultModel copyWith({bool? isFavorite}) {
    return KosResultModel(
      idKos: idKos,
      namaKos: namaKos,
      kota: kota,
      wilayah: wilayah,
      fotoPath: fotoPath,
      hargaPerBulan: hargaPerBulan,
      predictedPrice: predictedPrice,
      distanceKm: distanceKm,
      finalScore: finalScore,
      semanticScore: semanticScore,
      geospatialScore: geospatialScore,
      priceBoost: priceBoost,
      priceLabel: priceLabel,
      isSuperDeal: isSuperDeal,
      rating: rating,
      fasilitas: fasilitas,
      tipeKos: tipeKos,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';
  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  static double _asScore(dynamic value) {
    final score = _asDouble(value);
    return score > 1 && score <= 100 ? score / 100 : score;
  }

  static bool _asBool(dynamic value) =>
      value is bool ? value : value.toString().toLowerCase() == 'true';

  static dynamic _first(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value;
    }
    return null;
  }
}
