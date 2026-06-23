import 'package:get/get.dart';

import '../../../data/providers/kos_provider.dart';
import '../../../data/repositories/kos_repository.dart';
import '../controllers/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KosProvider>(() => KosProvider(), fenix: true);
    Get.lazyPut<KosRepository>(
      () => KosRepository(Get.find<KosProvider>()),
      fenix: true,
    );
    Get.lazyPut<SavedController>(
      () => SavedController(Get.find<KosRepository>()),
      fenix: true,
    );
  }
}
