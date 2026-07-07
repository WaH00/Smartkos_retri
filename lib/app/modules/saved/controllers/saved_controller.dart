import 'package:get/get.dart';

import '../../../data/models/kos_result_model.dart';
import '../../../data/repositories/search_repository.dart';
import '../../../routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class SavedController extends GetxController {
  SavedController(this._repository);

  final SearchRepository _repository;
  final favorites = <KosResultModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    favorites.assignAll(_repository.getFavorites());
  }

  void toggleFavorite(KosResultModel kos) {
    _repository.toggleFavorite(kos);
    loadFavorites();
    _syncHome(kos.idKos);
  }

  void clearFavorites() {
    if (favorites.isEmpty) return;
    final ids = favorites.map((kos) => kos.idKos).toList();
    _repository.clearFavorites();
    loadFavorites();
    for (final id in ids) {
      _syncHome(id);
    }
    Get.snackbar(
      'Wishlist dikosongkan',
      'Semua kos tersimpan sudah dihapus.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openDetail(KosResultModel kos) {
    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      Get.toNamed(
        AppRoutes.detailKos,
        arguments: {
          'kos': kos,
          'userLatitude': home.selectedLatitude.value,
          'userLongitude': home.selectedLongitude.value,
        },
      );
      return;
    }
    Get.toNamed(AppRoutes.detailKos, arguments: kos);
  }

  void _syncHome(int idKos) {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    final index = home.results.indexWhere((kos) => kos.idKos == idKos);
    if (index != -1) {
      final isSaved = _repository.getFavorites().any(
        (kos) => kos.idKos == idKos,
      );
      home.results[index] = home.results[index].copyWith(isFavorite: isSaved);
    }
  }
}
