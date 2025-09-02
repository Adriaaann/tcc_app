import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_item_model.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/chip_list_widget.dart';

class FinancialCard extends StatelessWidget {
  const FinancialCard({super.key, required this.items});

  final List<FinancialItem> items;

  @override
  Widget build(BuildContext context) => Column(
    children: items
        .map(
          (item) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: context.colorScheme.primaryContainer.withValues(
                alpha: 0.5,
              ),
              child: Icon(
                item.icon,
                color: context.colorScheme.primary,
                size: 24,
              ),
            ),
            title: _TileBody(item: item),
          ),
        )
        .toList(),
  );
}

class _TileBody extends StatelessWidget {
  const _TileBody({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.4;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${item.hour.hour.toString().padLeft(2, '0')}:${item.hour.minute.toString().padLeft(2, '0')}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.title,
                      style: context.textTheme.bodyLarge,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.value,
              style: context.textTheme.bodyLarge?.copyWith(fontSize: 20),
              softWrap: false,
            ),
          ],
        ),
        if (item.tags.isNotEmpty) ChipList(chips: item.tags),
      ],
    );
  }
}
