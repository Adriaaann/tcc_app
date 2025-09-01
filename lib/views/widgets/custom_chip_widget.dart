import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class CustomChip extends StatelessWidget {
  final String label;

  const CustomChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Chip(
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    backgroundColor: context.colorScheme.secondaryContainer.withValues(
      alpha: 0.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(64),
      side: BorderSide(color: context.colorScheme.secondaryContainer),
    ),
    label: Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.labelSmall?.copyWith(
        color: context.colorScheme.onSecondaryContainer,
      ),
    ),
  );
}
