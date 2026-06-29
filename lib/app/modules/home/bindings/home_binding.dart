import 'package:get/get.dart';

import '../../../core/api/api_client.dart';
import '../../../data/providers/search_api_provider.dart';
import '../../../data/repositories/search_repository.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../saved/controllers/saved_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(ApiClient.new, fenix: true);
    Get.lazyPut<SearchApiProvider>(
      () => SearchApiProvider(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<SearchRepository>(
      () => SearchRepository(Get.find<SearchApiProvider>()),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<SearchRepository>()),
      fenix: true,
    );
    Get.lazyPut<SavedController>(
      () => SavedController(Get.find<SearchRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
