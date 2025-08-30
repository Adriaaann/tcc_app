import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/dropdown_widget.dart';
import 'package:tcc_app/views/widgets/piechart_widget.dart';

class SummaryCardWidget extends StatelessWidget {
  final List<Map<String, String>> durationOptions;
  final List<Map<String, Object>> sectionData;

  const SummaryCardWidget({
    super.key,
    required this.durationOptions,
    required this.sectionData,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryHeader(
              text: 'Summary',
              defaultValue: '30_days',
              durationOptions: durationOptions,
            ),
            const _DisplayValue(
              text: 'Gastos',
              value: r'R$ 1.000,25',
              blank: true,
              negative: false,
            ),
            PiechartWidget(data: sectionData),
          ],
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
    spacing: 16,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: context.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.primary,
        ),
      ),
      DropdownWidget(defaultValue: defaultValue, options: durationOptions),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: statusColor, width: 4)),
          ),
          child: Column(
            spacing: 4,
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
      ),
    );
  }
}
