import 'package:get/get.dart';

import '../modules/detail_kos/bindings/detail_kos_binding.dart';
import '../modules/detail_kos/views/detail_kos_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/location_picker/bindings/location_picker_binding.dart';
import '../modules/location_picker/views/location_picker_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.detailKos,
      page: () => const DetailKosView(),
      binding: DetailKosBinding(),
    ),
    GetPage(
      name: AppRoutes.locationPicker,
      page: () => const LocationPickerView(),
      binding: LocationPickerBinding(),
    ),
    GetPage(
      name: AppRoutes.saved,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
