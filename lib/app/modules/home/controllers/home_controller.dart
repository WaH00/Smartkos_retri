import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../data/models/kos_result_model.dart';
import '../../../data/repositories/search_repository.dart';
import '../../../routes/app_routes.dart';
import '../../saved/controllers/saved_controller.dart';

class HomeController extends GetxController {
  HomeController(this._repository);

  final SearchRepository _repository;

  final searchController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  final isLoading = false.obs;
  final isBackendOnline = false.obs;
  final isCheckingBackend = false.obs;
  final errorMessage = ''.obs;
  final errorHint = ''.obs;
  final results = <KosResultModel>[].obs;
  final expansionTerms = <String>[].obs;
  final searchTimeMs = 0.0.obs;
  final totalResults = 0.obs;
  final superDealCount = 0.obs;
  final selectedLatitude = (-6.1862).obs;
  final selectedLongitude = 106.8348.obs;
  final topK = ApiConstants.defaultTopK.obs;
  final nCandidates = ApiConstants.defaultNCandidates.obs;

  final searchText = ''.obs;
  final selectedArea = 'Jakarta Selatan'.obs;
  final radiusKm = 5.0.obs;
  final selectedFacilities = <String>[].obs;
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
    'Parkir',
    'Dapur',
    'KM Dalam',
  ];

  @override
  void onInit() {
    super.onInit();
    checkBackendHealth();
  }

  @override
  void onClose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.onClose();
  }

  Future<void> checkBackendHealth() async {
    isCheckingBackend.value = true;
    try {
      isBackendOnline.value = await _repository.checkHealth();
    } catch (_) {
      isBackendOnline.value = false;
    } finally {
      isCheckingBackend.value = false;
    }
  }

  Future<void> searchKos() async {
    final kueri = searchController.text.trim();
    if (kueri.isEmpty) {
      Get.snackbar(
        'Kata kunci diperlukan',
        'Masukkan kebutuhan kos yang ingin kamu cari.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    errorHint.value = '';
    try {
      final response = await _repository.searchKos(
        kueri: kueri,
        latitude: selectedLatitude.value,
        longitude: selectedLongitude.value,
        topK: topK.value,
        nCandidates: nCandidates.value,
      );

      isBackendOnline.value = true;
      results.assignAll(response.results);
      expansionTerms.assignAll(response.expansionTerms);
      searchTimeMs.value = response.searchTimeMs;
      totalResults.value = response.totalResults;
      superDealCount.value = response.superDealCount;
    } catch (error) {
      final isOffline =
          error is ApiException &&
          (error.message.contains('tidak dapat diakses') ||
              error.message.contains('melewati batas waktu'));
      if (isOffline) isBackendOnline.value = false;

      errorMessage.value = isOffline
          ? 'Backend tidak dapat diakses. Pastikan FastAPI berjalan di port 8000.'
          : 'Pencarian gagal. Silakan coba beberapa saat lagi.';
      errorHint.value = error.toString();
      Get.snackbar(
        'Pencarian gagal',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchTextChanged(String value) => searchText.value = value;

  void setArea(String? area) {
    if (area != null) selectedArea.value = area;
  }

  void toggleFacility(String facility) {
    // Facility selections remain UI-only until the backend supports filters.
    if (facility == 'Semua') {
      selectedFacilities.clear();
      return;
    }
    selectedFacilities.contains(facility)
        ? selectedFacilities.remove(facility)
        : selectedFacilities.add(facility);
  }

  void toggleFavorite(KosResultModel kos) {
    final updated = _repository.toggleFavorite(kos);
    final index = results.indexWhere((item) => item.idKos == kos.idKos);
    if (index != -1) results[index] = updated;
    if (Get.isRegistered<SavedController>()) {
      Get.find<SavedController>().loadFavorites();
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
    if (result is! Map) return;

    final latitude = result['latitude'];
    final longitude = result['longitude'];
    final radius = result['radiusKm'];
    if (latitude is! num || longitude is! num || radius is! num) {
      Get.snackbar(
        'Lokasi tidak berubah',
        'Data lokasi dari peta belum valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    selectedLatitude.value = latitude.toDouble();
    selectedLongitude.value = longitude.toDouble();
    radiusKm.value = radius.toDouble();
    // Radius remains UI-only until the backend search schema supports it.
  }

  Future<void> useCurrentLocation() async {
    try {
      final position = await _getCurrentPosition();
      if (position == null) return;

      selectedLatitude.value = position.latitude;
      selectedLongitude.value = position.longitude;
      Get.snackbar(
        'Lokasi diperbarui',
        'Pencarian akan memakai lokasi kamu saat ini.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Lokasi gagal dimuat',
        'Tidak dapat membaca lokasi saat ini. Gunakan pin pada peta.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    results.clear();
    expansionTerms.clear();
    searchTimeMs.value = 0;
    totalResults.value = 0;
    superDealCount.value = 0;
    errorMessage.value = '';
    errorHint.value = '';
  }

  void openDetail(KosResultModel kos) {
    Get.toNamed(
      AppRoutes.detailKos,
      arguments: {
        'kos': kos,
        'userLatitude': selectedLatitude.value,
        'userLongitude': selectedLongitude.value,
      },
    );
  }

  void setBottomNavigationIndex(int index) {
    selectedBottomNavigationIndex.value = index;
  }

  Future<void> refreshCurrentResults() async {
    if (searchController.text.trim().isEmpty) {
      await checkBackendHealth();
      return;
    }
    await searchKos();
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
