import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/facility_chip.dart';
import '../../../core/widgets/kos_card.dart';
import '../../../core/widgets/location_selector_card.dart';
import '../../../core/widgets/price_filter_box.dart';
import '../../profile/views/profile_view.dart';
import '../../saved/controllers/saved_controller.dart';
import '../../saved/views/saved_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('KosFind'),
          actions: controller.selectedBottomNavigationIndex.value == 0
              ? [
                  IconButton(
                    onPressed: controller.refreshCurrentResults,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Muat ulang',
                  ),
                ]
              : [
                  IconButton(
                    onPressed: () => controller.setBottomNavigationIndex(2),
                    icon: const Icon(Icons.account_circle_outlined),
                    tooltip: 'Profile',
                  ),
                ],
        ),
        body: IndexedStack(
          index: controller.selectedBottomNavigationIndex.value,
          children: const [
            _ExploreTab(),
            SavedView(showScaffold: false),
            ProfileView(showScaffold: false),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedBottomNavigationIndex.value,
          onDestinationSelected: (index) {
            controller.setBottomNavigationIndex(index);
            if (index == 1 && Get.isRegistered<SavedController>()) {
              Get.find<SavedController>().loadFavorites();
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreTab extends GetView<HomeController> {
  const _ExploreTab();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshCurrentResults,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          _SearchPanel(controller: controller),
          const SizedBox(height: 18),
          Obx(
            () => LocationSelectorCard(
              latitude: controller.selectedLatitude.value,
              longitude: controller.selectedLongitude.value,
              radiusKm: controller.radiusKm.value,
              onExpandMap: controller.openLocationPicker,
            ),
          ),
          const SizedBox(height: 20),
          _FilterChips(controller: controller),
          const SizedBox(height: 22),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: Text(
                    'Rekomendasi Kos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${controller.kosList.length} hasil',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return EmptyState(
                title: 'Pencarian gagal',
                message: controller.errorMessage.value,
                icon: Icons.wifi_off_rounded,
              );
            }

            if (controller.kosList.isEmpty) {
              return const EmptyState(
                title: 'Kos belum ditemukan',
                message:
                    'Coba ubah kata kunci, fasilitas, harga, atau radius pencarian.',
              );
            }

            return Column(
              children: controller.kosList
                  .map(
                    (kos) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: KosCard(
                        kos: kos,
                        onTapDetail: () => controller.openDetail(kos),
                        onToggleFavorite: () => controller.toggleFavorite(kos),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => DropdownButtonFormField<String>(
              initialValue: controller.selectedArea.value,
              items: controller.areas
                  .map(
                    (area) => DropdownMenuItem(value: area, child: Text(area)),
                  )
                  .toList(),
              onChanged: controller.setArea,
              decoration: const InputDecoration(
                labelText: 'Area',
                prefixIcon: Icon(Icons.location_city_rounded),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: controller.useCurrentLocation,
            icon: const Icon(Icons.my_location_rounded),
            label: const Text('Gunakan Lokasi Saat Ini'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.searchTextController,
            onChanged: controller.onSearchTextChanged,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => controller.searchKos(),
            decoration: const InputDecoration(
              hintText:
                  'Cari kos idaman... (Misal: Kos dekat UI ada AC dan tenang)',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PriceFilterBox(
                  controller: controller.minPriceController,
                  label: 'Min price',
                  hint: '500000',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PriceFilterBox(
                  controller: controller.maxPriceController,
                  label: 'Max price',
                  hint: '3500000',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: controller.searchKos,
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Cari Kos'),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.facilities.map((facility) {
          final selected = facility == 'Semua'
              ? controller.selectedFacilities.isEmpty
              : controller.selectedFacilities.contains(facility);
          return FacilityChip(
            label: facility,
            selected: selected,
            onSelected: (_) => controller.toggleFacility(facility),
          );
        }).toList(),
      ),
    );
  }
}
