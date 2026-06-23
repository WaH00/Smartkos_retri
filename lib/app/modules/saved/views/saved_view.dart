import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/kos_model.dart';
import '../controllers/saved_controller.dart';

class SavedView extends GetView<SavedController> {
  const SavedView({this.showScaffold = true, super.key});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final content = RefreshIndicator(
      onRefresh: controller.loadFavorites,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
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
                      'Tekan ikon hati pada kartu kos untuk menyimpan pilihan favorit.',
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
        );
      }),
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
          style: TextButton.styleFrom(
            minimumSize: const Size(64, 30),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            foregroundColor: const Color(0xFF005BD3),
            disabledForegroundColor: const Color(0xFF9CA3AF),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
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

  final KosModel kos;
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              kos.namaKos,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: onToggleFavorite,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.16),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Color(0xFF1D8BFF),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              _compactAddress(kos.alamat),
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
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: kos.fasilitas
                            .take(3)
                            .map((facility) => _MiniFacility(label: facility))
                            .toList(),
                      ),
                      const Spacer(),
                      Container(height: 1, color: const Color(0xFFE5E7EB)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Rp',
                                  style: TextStyle(
                                    color: Color(0xFF005BD3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    height: 0.9,
                                  ),
                                ),
                                Text(
                                  _priceNumber(kos.harga),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF005BD3),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 2),
                            child: Text(
                              '/ bulan',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
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

  String _compactAddress(String address) {
    if (address.toLowerCase().contains('jakarta selatan')) {
      return 'Jakarta Selatan';
    }
    final parts = address.split(',');
    return parts.length > 1 ? parts.last.trim() : address;
  }

  String _priceNumber(int value) {
    return CurrencyFormatter.rupiah(value).replaceFirst('Rp', '').trim();
  }
}

class _SavedKosImage extends StatelessWidget {
  const _SavedKosImage({required this.kos});

  final KosModel kos;

  @override
  Widget build(BuildContext context) {
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
            child: CachedNetworkImage(
              imageUrl: kos.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: const Color(0xFFE5E7EB)),
              errorWidget: (_, _, _) => Container(
                color: const Color(0xFFE5E7EB),
                child: const Icon(Icons.apartment_rounded),
              ),
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
                  borderRadius: BorderRadius.circular(9),
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
        label.length > 8 ? '${label.substring(0, 8)}.' : label,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
