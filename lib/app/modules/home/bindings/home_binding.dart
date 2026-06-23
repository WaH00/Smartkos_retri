import 'package:get/get.dart';

import '../../../data/providers/kos_provider.dart';
import '../../../data/repositories/kos_repository.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../saved/controllers/saved_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KosProvider>(() => KosProvider(), fenix: true);
    Get.lazyPut<KosRepository>(
      () => KosRepository(Get.find<KosProvider>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<KosRepository>()),
      fenix: true,
    );
    Get.lazyPut<SavedController>(
      () => SavedController(Get.find<KosRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
