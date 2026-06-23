import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerController extends GetxController {
  final mapController = MapController();

  final selectedLatitude = (-6.2615).obs;
  final selectedLongitude = 106.8106.obs;
  final radiusKm = 5.0.obs;
  final isLoadingLocation = false.obs;

  LatLng get selectedPoint =>
      LatLng(selectedLatitude.value, selectedLongitude.value);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) return;
    selectedLatitude.value =
        args['latitude'] as double? ?? selectedLatitude.value;
    selectedLongitude.value =
        args['longitude'] as double? ?? selectedLongitude.value;
    radiusKm.value = args['radiusKm'] as double? ?? radiusKm.value;
  }

  void setPoint(LatLng point) {
    selectedLatitude.value = point.latitude;
    selectedLongitude.value = point.longitude;
  }

  void setRadius(double value) {
    radiusKm.value = value;
  }

  Future<void> useCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      final position = await _getCurrentPosition();
      if (position == null) return;

      final point = LatLng(position.latitude, position.longitude);
      setPoint(point);
      mapController.move(point, 14);
      Get.snackbar(
        'Lokasi ditemukan',
        'Pin dipindahkan ke lokasi kamu saat ini.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void confirmLocation() {
    Get.back(
      result: {
        'latitude': selectedLatitude.value,
        'longitude': selectedLongitude.value,
        'radiusKm': radiusKm.value,
      },
    );
  }

  Future<Position?> _getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Layanan lokasi mati',
        'Aktifkan GPS untuk memilih lokasi saat ini.',
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
        'SmartKos membutuhkan izin lokasi untuk memakai GPS.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Izin lokasi diblokir',
        'Aktifkan izin lokasi dari pengaturan aplikasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
