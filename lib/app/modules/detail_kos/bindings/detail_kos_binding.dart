import 'package:get/get.dart';

import '../../../data/providers/kos_provider.dart';
import '../../../data/repositories/kos_repository.dart';
import '../controllers/detail_kos_controller.dart';

class DetailKosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KosProvider>(() => KosProvider(), fenix: true);
    Get.lazyPut<KosRepository>(
      () => KosRepository(Get.find<KosProvider>()),
      fenix: true,
    );
    Get.lazyPut<DetailKosController>(
      () => DetailKosController(Get.find<KosRepository>()),
    );
  }
}
