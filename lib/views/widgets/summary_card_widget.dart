import 'package:flutter/material.dart';
import 'package:tcc_app/services/db_get.dart';
import 'package:tcc_app/services/db_helper.dart';
import 'package:tcc_app/utils/format_currency_method.dart';
import 'package:tcc_app/utils/get_financial_sum_method.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/data/notifiers.dart';
import 'package:tcc_app/views/widgets/piechart_widget.dart';

class SummaryCardWidget extends StatefulWidget {
  final List<Map<String, String>> durationOptions;
  final List<Map<String, Object>> sectionData;

  const SummaryCardWidget({
    super.key,
    required this.durationOptions,
    required this.sectionData,
  });

  @override
  State<SummaryCardWidget> createState() => _SummaryCardWidgetState();
}

class _SummaryCardWidgetState extends State<SummaryCardWidget> {
  final ValueNotifier<double> totalValueNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _loadTotalValue();

    financialDataNotifier.addListener(() {
      _loadTotalValue();
    });
  }

  Future<void> _loadTotalValue() async {
    final db = DbHelper.instance;
    final expenses = await db.getAll('expenses');
    final subscriptions = await db.getAll('subscriptions');

    totalValueNotifier.value = getFinancialSumMethod([
      ...expenses,
      ...subscriptions,
    ]);
  }

  @override
  void dispose() {
    totalValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<double>(
    valueListenable: totalValueNotifier,
    builder: (context, totalValue, _) => SizedBox(
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
                durationOptions: widget.durationOptions,
              ),
              _DisplayValue(
                text: 'Total de Gastos',
                value: totalValue,
                blank: true,
                negative: false,
              ),
              PiechartWidget(data: widget.sectionData),
            ],
          ),
        ),
      ),
    ),
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
          // DropdownWidget(defaultValue: defaultValue, options: durationOptions),
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
  final double value;
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
              formatCurrency(value),
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
