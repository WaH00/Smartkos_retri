class KosModel {
  const KosModel({
    required this.id,
    required this.namaKos,
    required this.alamat,
    required this.deskripsi,
    required this.harga,
    required this.rating,
    required this.jarakKm,
    required this.skorRelevansi,
    required this.isSuperDeal,
    required this.imageUrl,
    required this.fasilitas,
    required this.latitude,
    required this.longitude,
    required this.isFavorite,
    required this.aiReason,
  });

  final String id;
  final String namaKos;
  final String alamat;
  final String deskripsi;
  final int harga;
  final double rating;
  final double jarakKm;
  final double skorRelevansi;
  final bool isSuperDeal;
  final String imageUrl;
  final List<String> fasilitas;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final String aiReason;

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: (json['id'] ?? json['_id']).toString(),
      namaKos: json['namaKos'] ?? json['nama_kos'] ?? '',
      alamat: json['alamat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: (json['harga'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      jarakKm: (json['jarakKm'] ?? json['jarak_km'] as num?)?.toDouble() ?? 0,
      skorRelevansi:
          (json['skorRelevansi'] ?? json['skor_relevansi'] as num?)
              ?.toDouble() ??
          0,
      isSuperDeal: json['isSuperDeal'] ?? json['is_super_deal'] ?? false,
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      fasilitas: List<String>.from(json['fasilitas'] ?? const []),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      isFavorite: json['isFavorite'] ?? json['is_favorite'] ?? false,
      aiReason: json['aiReason'] ?? json['ai_reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kos': namaKos,
      'alamat': alamat,
      'deskripsi': deskripsi,
      'harga': harga,
      'rating': rating,
      'jarak_km': jarakKm,
      'skor_relevansi': skorRelevansi,
      'is_super_deal': isSuperDeal,
      'image_url': imageUrl,
      'fasilitas': fasilitas,
      'latitude': latitude,
      'longitude': longitude,
      'is_favorite': isFavorite,
      'ai_reason': aiReason,
    };
  }

  KosModel copyWith({
    String? id,
    String? namaKos,
    String? alamat,
    String? deskripsi,
    int? harga,
    double? rating,
    double? jarakKm,
    double? skorRelevansi,
    bool? isSuperDeal,
    String? imageUrl,
    List<String>? fasilitas,
    double? latitude,
    double? longitude,
    bool? isFavorite,
    String? aiReason,
  }) {
    return KosModel(
      id: id ?? this.id,
      namaKos: namaKos ?? this.namaKos,
      alamat: alamat ?? this.alamat,
      deskripsi: deskripsi ?? this.deskripsi,
      harga: harga ?? this.harga,
      rating: rating ?? this.rating,
      jarakKm: jarakKm ?? this.jarakKm,
      skorRelevansi: skorRelevansi ?? this.skorRelevansi,
      isSuperDeal: isSuperDeal ?? this.isSuperDeal,
      imageUrl: imageUrl ?? this.imageUrl,
      fasilitas: fasilitas ?? this.fasilitas,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      aiReason: aiReason ?? this.aiReason,
    );
  }
}
