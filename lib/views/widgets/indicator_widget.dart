import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({
    super.key,
    required this.color,
    required this.text,
    required this.isTouched,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isTouched;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: isTouched
          ? context.colorScheme.onPrimaryContainer.withValues(alpha: 0.10)
          : Colors.transparent,
    ),
    child: Row(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Text(
          text,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.tertiary,
          ),
        ),
      ],
    ),
  );
}
