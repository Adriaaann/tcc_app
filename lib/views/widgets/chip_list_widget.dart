import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/custom_chip_widget.dart';

class ChipList extends StatelessWidget {
  final List<String> chips;
  const ChipList({super.key, required this.chips});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Align(
      alignment: Alignment.centerRight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final visibleChips = _calculateVisibleChips(
            context,
            constraints.maxWidth,
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 4,
            children: visibleChips,
          );
        },
      ),
    ),
  );

  List<Widget> _calculateVisibleChips(BuildContext context, double maxWidth) {
    const double spacing = 4;
    double usedWidth = 0;
    final List<Widget> visibleChips = [];
    int hiddenCount = 0;

    for (var i = 0; i < chips.length; i++) {
      final chipWidth = _estimateChipWidth(context, chips[i]);

      if (usedWidth + chipWidth <= maxWidth) {
        visibleChips.add(CustomChip(label: chips[i]));
        usedWidth += chipWidth + spacing;
      } else {
        hiddenCount = chips.length - i;
        break;
      }
    }

    if (hiddenCount > 0) {
      _addHiddenChip(
        context,
        visibleChips,
        hiddenCount,
        maxWidth,
        usedWidth,
        spacing,
      );
    }

    return visibleChips;
  }

  double _estimateChipWidth(BuildContext context, String label) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.onSecondaryContainer,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width + 32;
  }

  void _addHiddenChip(
    BuildContext context,
    List<Widget> visibleChips,
    int hiddenCount,
    double maxWidth,
    double usedWidth,
    double spacing,
  ) {
    final plusChipLabel = '+$hiddenCount';
    final plusChipWidth = _estimateChipWidth(context, plusChipLabel);

    if (usedWidth + plusChipWidth <= maxWidth) {
      visibleChips.add(CustomChip(label: plusChipLabel));
    } else if (visibleChips.isNotEmpty) {
      visibleChips[visibleChips.length - 1] = CustomChip(label: plusChipLabel);
    }
  }
}
