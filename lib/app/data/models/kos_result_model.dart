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

  // Favorite is local UI state until the backend exposes a favorite endpoint.
  final bool isFavorite;

  factory KosResultModel.fromJson(Map<String, dynamic> json) {
    final rawFacilities = json['fasilitas'];
    return KosResultModel(
      idKos: _asInt(json['id_kos']),
      namaKos: _asString(json['nama_kos']),
      kota: _asString(json['kota']),
      wilayah: _asString(json['wilayah']),
      fotoPath: _asString(json['foto_path']),
      hargaPerBulan: _asInt(json['harga_per_bulan']),
      predictedPrice: _asDouble(json['predicted_price']),
      distanceKm: _asDouble(json['distance_km']),
      finalScore: _asDouble(json['final_score']),
      semanticScore: _asDouble(json['semantic_score']),
      geospatialScore: _asDouble(json['geospatial_score']),
      priceBoost: _asDouble(json['price_boost']),
      priceLabel: _asString(json['price_label']),
      isSuperDeal: _asBool(json['is_super_deal']),
      rating: _asDouble(json['rating']),
      fasilitas: rawFacilities is Map
          ? FasilitasModel.fromJson(Map<String, dynamic>.from(rawFacilities))
          : const FasilitasModel.empty(),
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
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  static String _asString(dynamic value) => value?.toString() ?? '';
  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  static bool _asBool(dynamic value) =>
      value is bool ? value : value.toString().toLowerCase() == 'true';
}
