import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../data/models/kos_model.dart';
import '../../../data/repositories/kos_repository.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController(this._repository);

  final KosRepository _repository;

  final searchTextController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  final searchText = ''.obs;
  final selectedArea = 'Jakarta Selatan'.obs;
  final selectedLatitude = (-6.2615).obs;
  final selectedLongitude = 106.8106.obs;
  final radiusKm = 5.0.obs;
  final selectedFacilities = <String>[].obs;
  final kosList = <KosModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedBottomNavigationIndex = 0.obs;

  final areas = const [
    'Jakarta Selatan',
    'Depok',
    'Bandung',
    'Yogyakarta',
    'Malang',
    'Makassar',
  ];

  final facilities = const [
    'Semua',
    'Wi-Fi',
    'AC',
    'Parking',
    'Dapur',
    'KM Dalam',
  ];

  @override
  void onInit() {
    super.onInit();
    searchKos();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.onClose();
  }

  Future<void> searchKos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await _repository.searchKos(
        query: searchText.value,
        latitude: selectedLatitude.value,
        longitude: selectedLongitude.value,
        radiusKm: radiusKm.value,
        minPrice: _parsePrice(minPriceController.text),
        maxPrice: _parsePrice(maxPriceController.text),
        facilities: selectedFacilities,
      );

      kosList.assignAll(results);
    } catch (_) {
      errorMessage.value = 'Pencarian gagal. Coba beberapa saat lagi.';
      Get.snackbar(
        'Pencarian gagal',
        'Belum bisa memuat rekomendasi kos. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchTextChanged(String value) {
    searchText.value = value;
  }

  void setArea(String? area) {
    if (area == null) return;
    selectedArea.value = area;
  }

  void toggleFacility(String facility) {
    if (facility == 'Semua') {
      selectedFacilities.clear();
      searchKos();
      return;
    }

    if (selectedFacilities.contains(facility)) {
      selectedFacilities.remove(facility);
    } else {
      selectedFacilities.add(facility);
    }
    searchKos();
  }

  Future<void> toggleFavorite(KosModel kos) async {
    final updated = await _repository.toggleFavorite(kos.id);
    final index = kosList.indexWhere((item) => item.id == kos.id);
    if (index != -1) {
      kosList[index] = updated;
    }
  }

  Future<void> openLocationPicker() async {
    final result = await Get.toNamed(
      AppRoutes.locationPicker,
      arguments: {
        'latitude': selectedLatitude.value,
        'longitude': selectedLongitude.value,
        'radiusKm': radiusKm.value,
      },
    );

    if (result == null) return;
    if (result is! Map<String, dynamic>) {
      Get.snackbar(
        'Lokasi tidak berubah',
        'Data lokasi dari peta belum valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedLatitude.value = (result['latitude'] as num).toDouble();
    selectedLongitude.value = (result['longitude'] as num).toDouble();
    radiusKm.value = (result['radiusKm'] as num).toDouble();
    await searchKos();
  }

  Future<void> useCurrentLocation() async {
    final position = await _getCurrentPosition();
    if (position == null) return;

    selectedLatitude.value = position.latitude;
    selectedLongitude.value = position.longitude;
    Get.snackbar(
      'Lokasi diperbarui',
      'Pencarian memakai lokasi kamu saat ini.',
      snackPosition: SnackPosition.BOTTOM,
    );
    await searchKos();
  }

  void openDetail(KosModel kos) {
    Get.toNamed(AppRoutes.detailKos, arguments: kos.id);
  }

  void setBottomNavigationIndex(int index) {
    selectedBottomNavigationIndex.value = index;
  }

  Future<void> refreshCurrentResults() => searchKos();

  int? _parsePrice(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  Future<Position?> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Layanan lokasi mati',
        'Aktifkan GPS untuk menggunakan lokasi saat ini.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      Get.snackbar(
        'Izin lokasi ditolak',
        'Berikan izin lokasi agar SmartKos bisa mencari kos terdekat.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Izin lokasi diblokir',
        'Buka pengaturan aplikasi untuk mengaktifkan izin lokasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
