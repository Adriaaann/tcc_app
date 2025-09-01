import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_item_model.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/chip_list_widget.dart';

class FinancialCard extends StatelessWidget {
  const FinancialCard({super.key, required this.items});

  final List<FinancialItem> items;

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(items.length, (index) {
      final item = items[index];
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: _DisplayIcon(item: item),
        title: _TileBody(item: item),
      );
    }),
  );
}

class _DisplayIcon extends StatelessWidget {
  const _DisplayIcon({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    backgroundColor: context.colorScheme.primaryContainer.withValues(
      alpha: 0.5,
    ),
    child: Icon(item.icon, color: context.colorScheme.primary, size: 24),
  );
}

class _TileBody extends StatelessWidget {
  const _TileBody({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.4,
            ),
            child: Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                _DisplayTime(item: item),
                _DisplayTitle(item: item),
              ],
            ),
          ),
          _DisplayValue(item: item),
        ],
      ),
      if (item.tags.isNotEmpty) ChipList(chips: item.tags),
    ],
  );
}

class _DisplayValue extends StatelessWidget {
  const _DisplayValue({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) => Text(
    item.value,
    style: context.textTheme.bodyLarge?.copyWith(fontSize: 20),
    softWrap: false,
  );
}

class _DisplayTitle extends StatelessWidget {
  const _DisplayTitle({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) => Flexible(
    child: Text(
      item.title,
      style: context.textTheme.bodyLarge,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
  );
}

class _DisplayTime extends StatelessWidget {
  const _DisplayTime({required this.item});

  final FinancialItem item;

  @override
  Widget build(BuildContext context) => Text(
    '${item.hour.hour.toString().padLeft(2, '0')}:${item.hour.minute.toString().padLeft(2, '0')}',
    style: context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.tertiary,
    ),
  );
}
