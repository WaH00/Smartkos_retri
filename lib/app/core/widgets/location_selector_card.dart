import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

class LocationSelectorCard extends StatefulWidget {
  const LocationSelectorCard({
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.onExpandMap,
    super.key,
  });

  final double latitude;
  final double longitude;
  final double radiusKm;
  final VoidCallback onExpandMap;

  @override
  State<LocationSelectorCard> createState() => _LocationSelectorCardState();
}

class _LocationSelectorCardState extends State<LocationSelectorCard> {
  final MapController _mapController = MapController();

  LatLng get _point => LatLng(widget.latitude, widget.longitude);

  @override
  void didUpdateWidget(covariant LocationSelectorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final locationChanged =
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude;

    if (locationChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mapController.move(_point, 14);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = _point;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 148,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: widget.onExpandMap,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: point,
                          initialZoom: 13,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.smartkos.mobile',
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: point,
                                radius: widget.radiusKm * 1000,
                                useRadiusInMeter: true,
                                color: AppTheme.primary.withValues(alpha: 0.12),
                                borderColor: AppTheme.primary,
                                borderStrokeWidth: 1,
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: point,
                                width: 42,
                                height: 42,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: AppTheme.orange,
                                  size: 38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      elevation: 1,
                      child: InkWell(
                        onTap: widget.onExpandMap,
                        borderRadius: BorderRadius.circular(18),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            'Perbesar Peta',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.my_location_rounded,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Radius ${widget.radiusKm.toStringAsFixed(0)} km dari lokasi pilihan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onExpandMap,
                    icon: const Icon(Icons.open_in_full_rounded),
                    color: AppTheme.primary,
                    tooltip: 'Perbesar Peta',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
