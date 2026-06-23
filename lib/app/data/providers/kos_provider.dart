import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/kos_model.dart';

class KosProvider {
  KosProvider({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  final Dio _dio;
  Dio get apiClient => _dio;

  final List<KosModel> _mockKos = [
    const KosModel(
      id: '1',
      namaKos: 'Kos Eksklusif Senopati',
      alamat: 'Jl. Senopati Barat, Jakarta Selatan',
      deskripsi:
          'Kos eksklusif dekat area perkantoran dengan kamar luas, AC, Wi-Fi cepat, dan akses mudah ke transportasi umum.',
      harga: 3500000,
      rating: 4.9,
      jarakKm: 0.8,
      skorRelevansi: 0.94,
      isSuperDeal: true,
      imageUrl: 'https://picsum.photos/seed/kos-senopati/700/460',
      fasilitas: ['AC', 'Wi-Fi', 'Parking', 'KM Dalam'],
      latitude: -6.2275,
      longitude: 106.8089,
      isFavorite: true,
      aiReason:
          'Cocok karena dekat dengan lokasi pilihan, memiliki AC, Wi-Fi, dan harga kompetitif untuk area Senopati.',
    ),
    const KosModel(
      id: '2',
      namaKos: 'Kos Ceria Kemang',
      alamat: 'Jl. Kemang Raya, Jakarta Selatan',
      deskripsi:
          'Kos nyaman dengan suasana tenang, dapur bersama, area parkir motor, dan akses dekat ke kafe serta coworking space.',
      harga: 2400000,
      rating: 4.6,
      jarakKm: 2.1,
      skorRelevansi: 0.88,
      isSuperDeal: false,
      imageUrl: 'https://picsum.photos/seed/kos-kemang/700/460',
      fasilitas: ['Wi-Fi', 'Parking', 'Dapur'],
      latitude: -6.2607,
      longitude: 106.8134,
      isFavorite: true,
      aiReason:
          'Direkomendasikan untuk pencarian kos tenang dengan Wi-Fi, dapur bersama, dan lokasi strategis di Kemang.',
    ),
    const KosModel(
      id: '3',
      namaKos: 'Kos Melati Tamalanrea',
      alamat: 'Jl. Perintis Kemerdekaan, Tamalanrea, Makassar',
      deskripsi:
          'Kos dekat kampus dengan harga terjangkau, lingkungan ramai mahasiswa, dan akses mudah ke warung makan.',
      harga: 850000,
      rating: 4.4,
      jarakKm: 3.4,
      skorRelevansi: 0.79,
      isSuperDeal: true,
      imageUrl: 'https://picsum.photos/seed/kos-tamalanrea/700/460',
      fasilitas: ['Wi-Fi', 'Dapur', 'Parking'],
      latitude: -5.1343,
      longitude: 119.4891,
      isFavorite: false,
      aiReason:
          'Pilihan ekonomis untuk mahasiswa karena dekat kawasan kampus dan fasilitas dasar sudah tersedia.',
    ),
    const KosModel(
      id: '4',
      namaKos: 'Kos Mawar Dekat Kampus',
      alamat: 'Jl. Margonda Raya, Depok',
      deskripsi:
          'Kos dekat UI dengan kamar bersih, AC, KM dalam, dan akses cepat ke stasiun serta pusat kuliner Margonda.',
      harga: 1800000,
      rating: 4.7,
      jarakKm: 1.2,
      skorRelevansi: 0.92,
      isSuperDeal: true,
      imageUrl: 'https://picsum.photos/seed/kos-mawar/700/460',
      fasilitas: ['AC', 'Wi-Fi', 'KM Dalam', 'Dapur'],
      latitude: -6.3621,
      longitude: 106.8317,
      isFavorite: true,
      aiReason:
          'Sangat cocok untuk pencarian dekat UI karena jaraknya pendek, fasilitas lengkap, dan skor relevansi tinggi.',
    ),
    const KosModel(
      id: '5',
      namaKos: 'Kos Anggrek Residence',
      alamat: 'Jl. Gejayan, Sleman, Yogyakarta',
      deskripsi:
          'Residence modern untuk mahasiswa dan pekerja muda dengan Wi-Fi, parkir luas, dan area belajar bersama.',
      harga: 1500000,
      rating: 4.5,
      jarakKm: 4.6,
      skorRelevansi: 0.74,
      isSuperDeal: false,
      imageUrl: 'https://picsum.photos/seed/kos-anggrek/700/460',
      fasilitas: ['Wi-Fi', 'Parking', 'Dapur'],
      latitude: -7.7628,
      longitude: 110.3932,
      isFavorite: false,
      aiReason:
          'Cocok jika kamu mencari kos modern dengan fasilitas kerja dan belajar di sekitar Gejayan.',
    ),
    const KosModel(
      id: '6',
      namaKos: 'Kos Putri Harmoni',
      alamat: 'Jl. Tubagus Ismail, Bandung',
      deskripsi:
          'Kos putri aman dan rapi dekat area kampus, tersedia AC, KM dalam, Wi-Fi, dan penjaga kos.',
      harga: 2100000,
      rating: 4.8,
      jarakKm: 1.7,
      skorRelevansi: 0.9,
      isSuperDeal: false,
      imageUrl: 'https://picsum.photos/seed/kos-harmoni/700/460',
      fasilitas: ['AC', 'Wi-Fi', 'KM Dalam'],
      latitude: -6.8826,
      longitude: 107.6174,
      isFavorite: false,
      aiReason:
          'Direkomendasikan karena fasilitas kamar lengkap, rating tinggi, dan cocok untuk kebutuhan kos putri dekat kampus.',
    ),
    const KosModel(
      id: '7',
      namaKos: 'Kos Putra Mandiri',
      alamat: 'Jl. Soekarno Hatta, Malang',
      deskripsi:
          'Kos putra strategis dengan harga ramah mahasiswa, Wi-Fi stabil, dapur bersama, dan parkir motor.',
      harga: 950000,
      rating: 4.3,
      jarakKm: 2.9,
      skorRelevansi: 0.81,
      isSuperDeal: true,
      imageUrl: 'https://picsum.photos/seed/kos-mandiri/700/460',
      fasilitas: ['Wi-Fi', 'Parking', 'Dapur'],
      latitude: -7.9447,
      longitude: 112.6172,
      isFavorite: false,
      aiReason:
          'Cocok untuk budget mahasiswa dengan prioritas Wi-Fi, dapur, dan akses mudah ke area kampus Malang.',
    ),
    const KosModel(
      id: '8',
      namaKos: 'Kos Green House',
      alamat: 'Jl. Kaliurang KM 5, Sleman, Yogyakarta',
      deskripsi:
          'Kos bernuansa hijau dengan area komunal nyaman, AC, Wi-Fi, dapur, dan lingkungan yang relatif tenang.',
      harga: 1750000,
      rating: 4.6,
      jarakKm: 2.4,
      skorRelevansi: 0.86,
      isSuperDeal: false,
      imageUrl: 'https://picsum.photos/seed/kos-greenhouse/700/460',
      fasilitas: ['AC', 'Wi-Fi', 'Dapur', 'KM Dalam'],
      latitude: -7.747,
      longitude: 110.3798,
      isFavorite: false,
      aiReason:
          'Direkomendasikan untuk pencarian kos tenang dengan fasilitas lengkap dan suasana komunal yang nyaman.',
    ),
  ];

  Future<List<KosModel>> getMockKos() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<KosModel>.from(_mockKos);
  }

  Future<KosModel?> getMockKosById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _mockKos.firstWhere((kos) => kos.id == id);
  }

  Future<KosModel> toggleFavorite(String id) async {
    final index = _mockKos.indexWhere((kos) => kos.id == id);
    if (index == -1) {
      throw StateError('Kos tidak ditemukan.');
    }

    final updated = _mockKos[index].copyWith(
      isFavorite: !_mockKos[index].isFavorite,
    );
    _mockKos[index] = updated;
    return updated;
  }

  Future<void> clearFavorites() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    for (var index = 0; index < _mockKos.length; index++) {
      if (_mockKos[index].isFavorite) {
        _mockKos[index] = _mockKos[index].copyWith(isFavorite: false);
      }
    }
  }

  // Future<List<KosModel>> searchKosFromApi({
  //   required String query,
  //   required double latitude,
  //   required double longitude,
  //   required double radiusKm,
  //   int? minPrice,
  //   int? maxPrice,
  //   List<String> facilities = const [],
  // }) async {
  //   final response = await _dio.post(
  //     ApiConstants.searchKos,
  //     data: {
  //       'query': query,
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       'radius_km': radiusKm,
  //       'min_price': minPrice,
  //       'max_price': maxPrice,
  //       'facilities': facilities,
  //     },
  //   );
  //
  //   final results = response.data['results'] as List<dynamic>;
  //   return results
  //       .map((item) => KosModel.fromJson(item as Map<String, dynamic>))
  //       .toList();
  // }
}
