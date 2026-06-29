import 'package:get/get.dart';

import '../../../core/api/api_client.dart';
import '../../../data/providers/search_api_provider.dart';
import '../../../data/repositories/search_repository.dart';
import '../controllers/detail_kos_controller.dart';

class DetailKosBinding extends Bindings {
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
    Get.lazyPut<DetailKosController>(
      () => DetailKosController(Get.find<SearchRepository>()),
    );
  }
}
