import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: _BackendIndicator(
                isOnline: controller.isBackendOnline.value,
                isChecking: controller.isCheckingBackend.value,
                onTap: controller.checkBackendHealth,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
            () => _SearchMetadata(
              totalResults: controller.totalResults.value,
              superDealCount: controller.superDealCount.value,
              searchTimeMs: controller.searchTimeMs.value,
              expansionTerms: controller.expansionTerms.toList(),
            ),
          ),
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
                  '${controller.totalResults.value} hasil',
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
            if (controller.isLoading.value) return const _LoadingCards();

            if (controller.errorMessage.value.isNotEmpty) {
              return EmptyState(
                title: 'Pencarian gagal',
                message: controller.errorMessage.value,
                icon: Icons.wifi_off_rounded,
              );
            }

            if (controller.results.isEmpty) {
              return EmptyState(
                title: controller.searchText.value.trim().isEmpty
                    ? 'Mulai cari kos'
                    : 'Kos belum ditemukan',
                message: controller.searchText.value.trim().isEmpty
                    ? 'Tulis kebutuhan kos kamu, lalu tekan Cari Kos.'
                    : 'Coba gunakan kata kunci yang lebih umum.',
              );
            }

            return Column(
              children: controller.results
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

class _BackendIndicator extends StatelessWidget {
  const _BackendIndicator({
    required this.isOnline,
    required this.isChecking,
    required this.onTap,
  });

  final bool isOnline;
  final bool isChecking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isChecking
        ? AppTheme.textSecondary
        : isOnline
        ? const Color(0xFF138A55)
        : const Color(0xFFC0392B);
    final label = isChecking
        ? 'Memeriksa backend'
        : isOnline
        ? 'Online'
        : 'Offline';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchTextChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.searchKos(),
              decoration: InputDecoration(
                hintText:
                    'Cari kos idaman... (Misal: Kos dekat UI ada AC dan tenang)',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: controller.searchText.value.isEmpty
                    ? null
                    : IconButton(
                        onPressed: controller.clearSearch,
                        icon: const Icon(Icons.close_rounded),
                        tooltip: 'Hapus pencarian',
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Price inputs remain UI-only until the backend supports filters.
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
          Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.searchKos,
              icon: const Icon(Icons.search_rounded),
              label: Text(
                controller.isLoading.value ? 'Mencari...' : 'Cari Kos',
              ),
            ),
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
    // Facility chips remain UI-only until the backend supports filters.
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

class _SearchMetadata extends StatelessWidget {
  const _SearchMetadata({
    required this.totalResults,
    required this.superDealCount,
    required this.searchTimeMs,
    required this.expansionTerms,
  });

  final int totalResults;
  final int superDealCount;
  final double searchTimeMs;
  final List<String> expansionTerms;

  @override
  Widget build(BuildContext context) {
    final hasMetadata =
        searchTimeMs > 0 || totalResults > 0 || expansionTerms.isNotEmpty;
    if (!hasMetadata) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              Text('$totalResults hasil'),
              Text('$superDealCount super deal'),
              Text('${searchTimeMs.toStringAsFixed(1)} ms'),
            ],
          ),
          if (expansionTerms.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Kata terkait: ${expansionTerms.join(', ')}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LoadingCards extends StatelessWidget {
  const _LoadingCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE5E7EB),
            highlightColor: const Color(0xFFF8FAFC),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
