import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/financial_data_service.dart';
import 'package:tcc_app/utils/format_currency_method.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/data/categories_list.dart';
import 'package:tcc_app/views/pages/financial_form_page.dart';

class FinancialCard extends StatelessWidget {
  const FinancialCard({super.key, required this.items});

  final List<FinancialFormData> items;

  String _formatDate(DateTime date) {
    final format = DateFormat('d MMM', 'pt_BR');
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items]..sort((a, b) => b.date.compareTo(a.date));

    final Map<String, List<FinancialFormData>> groupedItems = {};
    for (final item in sortedItems) {
      final dateKey = _formatDate(item.date);
      groupedItems.putIfAbsent(dateKey, () => []).add(item);
    }

    final List<Widget> widgets = [];

    groupedItems.forEach((date, itemsOfDay) {
      widgets.add(
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            date,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );

      widgets.addAll(
        itemsOfDay.map((item) {
          final category = categoriesList.firstWhere(
            (c) => c.key == item.category,
            orElse: () => categoriesList.last,
          );

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: category.backgroundColor,
              child: Icon(category.icon, color: category.labelColor, size: 24),
            ),
            title: _TileBody(item: item),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FinancialFormPage(isEdit: true, initialData: item),
                ),
              );

              await FinancialDataService.instance.refresh();
            },
          );
        }),
      );
    });

    return Column(children: widgets);
  }
}

class _TileBody extends StatelessWidget {
  const _TileBody({required this.item});

  final FinancialFormData item;

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
                    '${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.title ?? '',
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
              formatCurrency(item.value),
              style: context.textTheme.bodyLarge?.copyWith(fontSize: 20),
              softWrap: false,
            ),
          ],
        ),
        // if (item.tags.isNotEmpty) ChipList(chips: item.tags),
      ],
    );
  }
}
