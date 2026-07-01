import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/facility_chip.dart';
import '../../../core/widgets/score_bars.dart';
import '../../../core/widgets/super_deal_badge.dart';
import '../controllers/detail_kos_controller.dart';

class DetailKosView extends GetView<DetailKosController> {
  const DetailKosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final kos = controller.kos.value;
        if (kos == null) {
          return const SafeArea(
            child: EmptyState(
              title: 'Detail tidak tersedia',
              message: 'Data kos tidak ditemukan pada hasil pencarian.',
            ),
          );
        }

        final imageUrl = ApiConstants.staticFileUrl(kos.fotoPath);
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              actions: [
                IconButton.filledTonal(
                  onPressed: controller.toggleFavorite,
                  tooltip: kos.isFavorite ? 'Hapus dari Saved' : 'Simpan kos',
                  icon: Icon(
                    kos.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: kos.isFavorite ? Colors.redAccent : AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _DetailImage(imageUrl: imageUrl),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              sliver: SliverList.list(
                children: [
                  if (kos.isSuperDeal) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SuperDealBadge(),
                          if (kos.discountPercent > 0) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Hemat ${kos.discountPercent.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppTheme.orange,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    kos.namaKos,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 19),
                      const SizedBox(width: 6),
                      Expanded(child: Text(kos.locationText)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoPill(
                        icon: Icons.star_rounded,
                        label: kos.rating.toStringAsFixed(1),
                        color: const Color(0xFFE09B00),
                      ),
                      _InfoPill(
                        icon: Icons.near_me_outlined,
                        label: '${kos.distanceKm.toStringAsFixed(1)} km',
                        color: AppTheme.primary,
                      ),
                      _InfoPill(
                        icon: Icons.auto_awesome_rounded,
                        label: '${(kos.finalScore * 100).round()}% cocok',
                        color: AppTheme.secondary,
                      ),
                      if (kos.tipeKos.isNotEmpty)
                        _InfoPill(
                          icon: Icons.meeting_room_outlined,
                          label: kos.tipeKos,
                          color: AppTheme.textSecondary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (kos.predictedPrice > kos.hargaPerBulan)
                    Text(
                      'Prediksi ${CurrencyFormatter.rupiah(kos.predictedPrice.round())}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    '${CurrencyFormatter.rupiah(kos.hargaPerBulan)} / bulan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: kos.isSuperDeal
                          ? AppTheme.orange
                          : AppTheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('Fasilitas'),
                  const SizedBox(height: 10),
                  if (kos.facilityLabels.isEmpty)
                    const Text('Informasi fasilitas belum tersedia.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kos.facilityLabels
                          .map((facility) => FacilityChip(label: facility))
                          .toList(),
                    ),
                  const SizedBox(height: 24),
                  const _SectionTitle('Rincian Skor'),
                  const SizedBox(height: 12),
                  ScoreBars(
                    semanticScore: kos.semanticScore,
                    geospatialScore: kos.geospatialScore,
                    priceBoost: kos.priceBoost,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Final score ${(kos.finalScore * 100).toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.secondary.withValues(alpha: 0.16),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppTheme.secondary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Kos ini direkomendasikan karena memiliki skor semantik, jarak, dan harga yang sesuai dengan pencarian kamu.',
                            style: TextStyle(
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
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _DetailImage extends StatelessWidget {
  const _DetailImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const _Placeholder();
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => const _Placeholder(showProgress: true),
      errorWidget: (_, _, _) => const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8F1F8),
      child: Center(
        child: showProgress
            ? const CircularProgressIndicator()
            : const Icon(
                Icons.apartment_rounded,
                size: 52,
                color: AppTheme.primary,
              ),
      ),
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
        borderRadius: BorderRadius.circular(6),
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
