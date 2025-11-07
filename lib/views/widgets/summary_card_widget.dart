import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_data_model.dart';
import 'package:tcc_app/services/financial_data_service.dart';
import 'package:tcc_app/utils/calculate_section_data.dart';
import 'package:tcc_app/views/widgets/piechart_widget.dart';
import 'package:tcc_app/utils/get_financial_sum_method.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/utils/format_currency_method.dart';

class SummaryCardWidget extends StatefulWidget {
  final List<Map<String, String>> durationOptions;

  const SummaryCardWidget({super.key, required this.durationOptions});

  @override
  State<SummaryCardWidget> createState() => _SummaryCardWidgetState();
}

class _SummaryCardWidgetState extends State<SummaryCardWidget> {
  final _service = FinancialDataService.instance;

  @override
  void initState() {
    super.initState();

    if (_service.cachedData == null) {
      _service.refresh();
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<FinancialData?>(
    stream: _service.stream,
    initialData: _service.cachedData,
    builder: (context, snapshot) {
      final data = snapshot.data;

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final allItems = [...data.expenses, ...data.subscriptions];

      final now = DateTime.now();
      final last30DaysItems = allItems.where((item) {
        final difference = now.difference(item.date).inDays;
        return difference >= 0 && difference < 30;
      }).toList();

      final totalValue = getFinancialSumMethod(last30DaysItems);
      final sectionData = calculateSectionData(last30DaysItems);

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
              spacing: 8,
              children: [
                _SummaryHeader(
                  text: 'Resumo',
                  defaultValue: '30_days',
                  durationOptions: widget.durationOptions,
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
    spacing: 8,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        text,
        style: context.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.primary,
        ),
      ),
      Text(
        '(30 dias)',
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: context.colorScheme.primary,
        ),
      ),
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
