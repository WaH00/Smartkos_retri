import 'package:get/get.dart';

import '../../../data/models/kos_result_model.dart';
import '../../../data/repositories/search_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../saved/controllers/saved_controller.dart';

class DetailKosController extends GetxController {
  DetailKosController(this._repository);

  final SearchRepository _repository;
  final kos = Rxn<KosResultModel>();

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments;
    if (argument is KosResultModel) kos.value = argument;
  }

  void toggleFavorite() {
    final current = kos.value;
    if (current == null) return;
    final updated = _repository.toggleFavorite(current);
    kos.value = updated;

    if (Get.isRegistered<HomeController>()) {
      final home = Get.find<HomeController>();
      final index = home.results.indexWhere(
        (item) => item.idKos == updated.idKos,
      );
      if (index != -1) home.results[index] = updated;
    }
    if (Get.isRegistered<SavedController>()) {
      Get.find<SavedController>().loadFavorites();
    }
  }

  void contactOwner() {
    Get.snackbar(
      'Hubungi Pemilik',
      'Fitur kontak pemilik akan tersedia setelah endpoint backend disiapkan.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
