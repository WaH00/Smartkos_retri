import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/kos_result_model.dart';
import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({this.showScaffold = true, super.key});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = RefreshIndicator(
      onRefresh: controller.loadFavorites,
      child: Obx(
        () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            _SavedHeader(
              count: controller.favorites.length,
              onClearAll: controller.clearFavorites,
            ),
            const SizedBox(height: 18),
            if (controller.favorites.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 72),
                child: EmptyState(
                  title: 'Belum ada kos tersimpan',
                  message:
                      'Tekan ikon hati pada hasil pencarian untuk menyimpan kos.',
                  icon: Icons.favorite_border_rounded,
                ),
              )
            else
              ...controller.favorites.map(
                (kos) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _SavedKosCard(
                    kos: kos,
                    onTap: () => controller.openDetail(kos),
                    onToggleFavorite: () => controller.toggleFavorite(kos),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (!showScaffold) return content;
    return Scaffold(
      appBar: AppBar(title: const Text('KosFind')),
      body: content,
    );
  }
}

class _SavedHeader extends StatelessWidget {
  const _SavedHeader({required this.count, required this.onClearAll});

  final int count;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final propertyText = count == 1 ? 'property' : 'properties';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kos Tersimpan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: '$count $propertyText saved to your ',
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: const [
                    TextSpan(
                      text: 'wishlist.',
                      style: TextStyle(
                        color: Color(0xFF005BD3),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: count == 0 ? null : onClearAll,
          child: const Text('Clear All'),
        ),
      ],
    );
  }
}

class _SavedKosCard extends StatelessWidget {
  const _SavedKosCard({
    required this.kos,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final KosResultModel kos;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black.withValues(alpha: 0.2),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 142,
          child: Row(
            children: [
              _SavedKosImage(kos: kos),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              kos.namaKos,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: onToggleFavorite,
                            constraints: const BoxConstraints.tightFor(
                              width: 34,
                              height: 34,
                            ),
                            padding: EdgeInsets.zero,
                            tooltip: 'Hapus dari Saved',
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFF1D8BFF),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              kos.locationText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 5,
                        children: kos.facilityLabels
                            .take(3)
                            .map((facility) => _MiniFacility(label: facility))
                            .toList(),
                      ),
                      const Spacer(),
                      const Divider(height: 1),
                      const SizedBox(height: 7),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              CurrencyFormatter.rupiah(kos.hargaPerBulan),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF005BD3),
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const Text(
                            '/ bulan',
                            style: TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedKosImage extends StatelessWidget {
  const _SavedKosImage({required this.kos});

  final KosResultModel kos;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstants.staticFileUrl(kos.fotoPath);
    return SizedBox(
      width: 112,
      height: 142,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(8),
            ),
            child: imageUrl.isEmpty
                ? const _ImageFallback()
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => const _ImageFallback(),
                    errorWidget: (_, _, _) => const _ImageFallback(),
                  ),
          ),
          if (kos.isSuperDeal)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                      size: 8,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Best Deal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFE5E7EB),
      child: Center(child: Icon(Icons.apartment_rounded)),
    );
  }
}

class _MiniFacility extends StatelessWidget {
  const _MiniFacility({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.length > 9 ? '${label.substring(0, 9)}.' : label,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
