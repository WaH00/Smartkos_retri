import 'package:get/get.dart';

import '../../../data/models/kos_model.dart';
import '../../../data/repositories/kos_repository.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class SavedController extends GetxController {
  SavedController(this._repository);

  final KosRepository _repository;

  final favorites = <KosModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      favorites.assignAll(await _repository.getFavoriteKos());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(KosModel kos) async {
    await _repository.toggleFavorite(kos.id);
    await loadFavorites();
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshCurrentResults();
    }
  }

  Future<void> clearFavorites() async {
    if (favorites.isEmpty) return;

    await _repository.clearFavorites();
    await loadFavorites();
    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshCurrentResults();
    }

    Get.snackbar(
      'Wishlist dikosongkan',
      'Semua kos tersimpan sudah dihapus.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openDetail(KosModel kos) {
    Get.toNamed(AppRoutes.detailKos, arguments: kos.id);
  }
}
