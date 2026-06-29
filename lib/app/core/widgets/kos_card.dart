import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/kos_result_model.dart';
import '../constants/api_constants.dart';
import '../theme/app_theme.dart';
import '../utils/currency_formatter.dart';
import 'facility_chip.dart';
import 'score_bars.dart';
import 'super_deal_badge.dart';

class KosCard extends StatelessWidget {
  const KosCard({
    required this.kos,
    required this.onTapDetail,
    required this.onToggleFavorite,
    super.key,
  });

  final KosResultModel kos;
  final VoidCallback onTapDetail;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstants.staticFileUrl(kos.fotoPath);
    final dealColor = kos.isSuperDeal
        ? AppTheme.orange
        : const Color(0xFFE5E7EB);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dealColor, width: kos.isSuperDeal ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(7),
                ),
                child: _KosImage(imageUrl: imageUrl),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: onToggleFavorite,
                    tooltip: kos.isFavorite ? 'Hapus dari Saved' : 'Simpan kos',
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
              if (kos.isSuperDeal)
                const Positioned(left: 12, top: 12, child: SuperDealBadge()),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        kos.namaKos,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _MetricPill(
                      icon: Icons.auto_awesome_rounded,
                      label:
                          '${(kos.finalScore * 100).toStringAsFixed(0)}% cocok',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB020),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      kos.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.near_me_outlined,
                      size: 17,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text('${kos.distanceKm.toStringAsFixed(1)} km'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(kos.locationText)),
                  ],
                ),
                if (kos.facilityLabels.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: kos.facilityLabels
                        .take(5)
                        .map((facility) => FacilityChip(label: facility))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 14),
                ScoreBars(
                  semanticScore: kos.semanticScore,
                  geospatialScore: kos.geospatialScore,
                  priceBoost: kos.priceBoost,
                  compact: true,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kos.predictedPrice > kos.hargaPerBulan)
                            Text(
                              CurrencyFormatter.rupiah(
                                kos.predictedPrice.round(),
                              ),
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                          Text.rich(
                            TextSpan(
                              text: CurrencyFormatter.rupiah(kos.hargaPerBulan),
                              style: TextStyle(
                                color: kos.isSuperDeal
                                    ? AppTheme.orange
                                    : AppTheme.primary,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                              children: const [
                                TextSpan(
                                  text: ' / bulan',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onTapDetail,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Lihat Detail'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KosImage extends StatelessWidget {
  const _KosImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const _ImagePlaceholder();
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (_, _) => const _ImagePlaceholder(showProgress: true),
      errorWidget: (_, _, _) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.showProgress = false});

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFE8F1F8),
      alignment: Alignment.center,
      child: showProgress
          ? const CircularProgressIndicator()
          : const Icon(
              Icons.apartment_rounded,
              size: 42,
              color: AppTheme.primary,
            ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.secondary, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.secondary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
