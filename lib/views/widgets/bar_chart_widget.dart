import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/views/data/categories_list.dart';

class BarChartWidget extends StatelessWidget {
  final List<FinancialFormData> expenses;

  const BarChartWidget(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('Sem dados disponíveis'));
    }

    final Map<String, double> totalsByKey = {};

    for (final e in expenses) {
      totalsByKey[e.category] = (totalsByKey[e.category] ?? 0) + e.value;
    }

    final List<BarChartGroupData> barGroups = [];
    final List<Map<String, dynamic>> legendData = [];

    int x = 0;

    for (final cat in categoriesList) {
      final total = totalsByKey[cat.key];

      if (total == null || total <= 0) continue;

      barGroups.add(
        BarChartGroupData(
          x: x,
          showingTooltipIndicators: [0],
          barRods: [
            BarChartRodData(
              toY: total,
              width: 24,
              color: cat.labelColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );

      legendData.add({'label': cat.label, 'color': cat.labelColor});

      x++;
    }

    if (barGroups.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.transparent,
                  tooltipPadding: EdgeInsets.zero,
                  tooltipMargin: 8,
                  getTooltipItem:
                      (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) => BarTooltipItem(
                        rod.toY.toStringAsFixed(2),
                        TextStyle(
                          color:
                              rod.color ??
                              Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                ),
              ),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: legendData
              .map(
                (entry) => Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: entry['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      entry['label'],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
