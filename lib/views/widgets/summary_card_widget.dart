import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/refresh.dart';
import 'package:tcc_app/views/data/categories_list.dart';
import 'package:tcc_app/views/widgets/piechart_widget.dart';
import 'package:tcc_app/utils/get_financial_sum_method.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/utils/format_currency_method.dart';

class SummaryCardWidget extends StatelessWidget {
  final List<Map<String, String>> durationOptions;

  const SummaryCardWidget({super.key, required this.durationOptions});

  List<Map<String, Object>> _calculateSectionData(
    List<FinancialFormData> allItems,
  ) {
    final Map<String, double> categoryTotals = {};
    double total = 0.0;

    for (var item in allItems) {
      categoryTotals[item.category] =
          (categoryTotals[item.category] ?? 0.0) + item.value;
      total += item.value;
    }

    if (total == 0) return [];

    final filteredCategories = categoriesList
        .where((cat) => (categoryTotals[cat.key] ?? 0.0) > 0)
        .toList();

    return List.generate(filteredCategories.length, (index) {
      final cat = filteredCategories[index];
      final value = categoryTotals[cat.key]!;
      final percentage = double.parse(
        ((value / total) * 100).toStringAsFixed(2),
      );
      return {
        'color': index == filteredCategories.length - 1
            ? cat.backgroundColor
            : cat.labelColor,
        'label': cat.label,
        'value': percentage,
      };
    });
  }

  double _calculateTotal(List<FinancialFormData> allItems) =>
      getFinancialSumMethod(allItems);

  @override
  Widget build(
    BuildContext context,
  ) => StreamBuilder<List<List<FinancialFormData>>>(
    stream: FinancialDataService.instance.stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.active) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Erro: ${snapshot.error}'));
      }

      final cardItems = snapshot.data ?? [[], []];

      final allItems = [...cardItems[0], ...cardItems[1]];
      final totalValue = _calculateTotal(allItems);
      final sectionData = _calculateSectionData(allItems);

      if (allItems.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Nenhum dado encontrado.\nClique no botão abaixo para começar.',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryHeader(
                  text: 'Resumo',
                  defaultValue: '30_days',
                  durationOptions: durationOptions,
                ),
                _DisplayValue(
                  text: 'Total de Gastos',
                  value: formatCurrency(totalValue),
                  blank: true,
                  negative: false,
                ),
                if (sectionData.isNotEmpty) PiechartWidget(data: sectionData),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SummaryHeader extends StatelessWidget {
  final String text;
  final String defaultValue;
  final List<Map<String, String>> durationOptions;

  const _SummaryHeader({
    required this.text,
    required this.defaultValue,
    required this.durationOptions,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            text,
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.person)),
    ],
  );
}

class _DisplayValue extends StatelessWidget {
  const _DisplayValue({
    required this.text,
    required this.value,
    required this.negative,
    required this.blank,
  });

  final String text;
  final String value;
  final bool negative;
  final bool blank;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = blank
        ? context.colorScheme.primary
        : negative
        ? context.colorScheme.errorContainer
        : context.colorScheme.success.colorContainer;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: statusColor, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
