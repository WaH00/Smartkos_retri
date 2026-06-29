import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ScoreBars extends StatelessWidget {
  const ScoreBars({
    required this.semanticScore,
    required this.geospatialScore,
    required this.priceBoost,
    this.compact = false,
    super.key,
  });

  final double semanticScore;
  final double geospatialScore;
  final double priceBoost;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ScoreBar(label: 'Semantik', value: semanticScore, compact: compact),
        SizedBox(height: compact ? 5 : 9),
        _ScoreBar(label: 'Jarak', value: geospatialScore, compact: compact),
        SizedBox(height: compact ? 5 : 9),
        _ScoreBar(label: 'Harga', value: priceBoost, compact: compact),
      ],
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.label,
    required this.value,
    required this.compact,
  });

  final String label;
  final double value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0.0, 1.0).toDouble();
    return Row(
      children: [
        SizedBox(
          width: compact ? 58 : 72,
          child: Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: normalized,
              minHeight: compact ? 5 : 7,
              backgroundColor: const Color(0xFFE5E7EB),
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${(normalized * 100).round()}%',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
