import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/facility_chip.dart';
import '../controllers/detail_kos_controller.dart';

class DetailKosView extends GetView<DetailKosController> {
  const DetailKosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty ||
            controller.kos.value == null) {
          return EmptyState(
            title: 'Detail tidak tersedia',
            message: controller.errorMessage.value.isEmpty
                ? 'Kos yang dipilih belum bisa ditampilkan.'
                : controller.errorMessage.value,
          );
        }

        final kos = controller.kos.value!;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 300,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: controller.toggleFavorite,
                      icon: Icon(
                        kos.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: kos.isFavorite
                            ? Colors.redAccent
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: kos.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: const Color(0xFFE8F1F8),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: const Color(0xFFE8F1F8),
                    child: const Icon(Icons.apartment_rounded, size: 52),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kos.isSuperDeal)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Super Deal',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      kos.namaKos,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      kos.alamat,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _InfoPill(
                          icon: Icons.star_rounded,
                          label: kos.rating.toStringAsFixed(1),
                          color: const Color(0xFFFFB020),
                        ),
                        _InfoPill(
                          icon: Icons.route_rounded,
                          label: '${kos.jarakKm.toStringAsFixed(1)} km',
                          color: AppTheme.primary,
                        ),
                        _InfoPill(
                          icon: Icons.auto_awesome_rounded,
                          label: '${(kos.skorRelevansi * 100).round()}% cocok',
                          color: AppTheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      CurrencyFormatter.rupiah(kos.harga),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Text(
                      'per bulan',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle('Fasilitas'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kos.fasilitas
                          .map((facility) => FacilityChip(label: facility))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle('Deskripsi'),
                    const SizedBox(height: 8),
                    Text(
                      kos.deskripsi,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppTheme.secondary.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppTheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              kos.aiReason.isEmpty
                                  ? 'Direkomendasikan karena cocok dengan pencarian kamu, dekat dari lokasi pilihan, dan memiliki fasilitas yang relevan.'
                                  : kos.aiReason,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                height: 1.45,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: controller.contactOwner,
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      label: const Text('Hubungi Pemilik'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
