import 'package:get/get.dart';

import '../../../data/models/kos_model.dart';
import '../../../data/repositories/kos_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../saved/controllers/saved_controller.dart';

class DetailKosController extends GetxController {
  DetailKosController(this._repository);

  final KosRepository _repository;

  final kos = Rxn<KosModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadKos();
  }

  Future<void> loadKos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final id = Get.arguments as String?;
      if (id == null) {
        errorMessage.value = 'Data kos tidak ditemukan.';
        return;
      }
      kos.value = await _repository.getKosById(id);
    } catch (_) {
      errorMessage.value = 'Gagal memuat detail kos.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite() async {
    final current = kos.value;
    if (current == null) return;

    final updated = await _repository.toggleFavorite(current.id);
    kos.value = updated;

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshCurrentResults();
    }
    if (Get.isRegistered<SavedController>()) {
      await Get.find<SavedController>().loadFavorites();
    }
  }

  void contactOwner() {
    Get.snackbar(
      'Hubungi Pemilik',
      'Mockup: integrasi WhatsApp atau chat pemilik akan ditambahkan nanti.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
