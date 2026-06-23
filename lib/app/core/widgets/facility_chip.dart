import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FacilityChip extends StatelessWidget {
  const FacilityChip({
    required this.label,
    this.selected = false,
    this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      avatar: selected
          ? const Icon(Icons.check_rounded, size: 16, color: AppTheme.primary)
          : null,
      labelStyle: TextStyle(
        color: selected ? AppTheme.primary : AppTheme.textPrimary,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      ),
    );
  }
}
