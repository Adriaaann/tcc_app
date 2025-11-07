import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';

class LineChartWidget extends StatelessWidget {
  final List<FinancialFormData> expenses;
  final String durationKey;

  const LineChartWidget(this.expenses, {super.key, required this.durationKey});

  @override
  Widget build(BuildContext context) => _buildChart(context);

  Widget _buildChart(BuildContext context) {
    final now = DateTime.now();
    final isDays = durationKey.contains('days');
    final range = _getRangeFromDuration(durationKey);

    final startDate = isDays
        ? now.subtract(Duration(days: range - 1))
        : DateTime(now.year, now.month - (range - 1), 1);

    final spots = <FlSpot>[];

    for (int i = 0; i < range; i++) {
      final date = isDays
          ? startDate.add(Duration(days: i))
          : DateTime(startDate.year, startDate.month + i, 1);

      final total = expenses
          .where(
            (e) => isDays
                ? e.date.year == date.year &&
                      e.date.month == date.month &&
                      e.date.day == date.day
                : e.date.year == date.year && e.date.month == date.month,
          )
          .fold<double>(0, (sum, e) => sum + (e.value > 0 ? e.value : 0));

      spots.add(FlSpot(i.toDouble(), total < 0 ? 0 : total));
    }

    final labels = _generateLabels(startDate, range, isDays);
    final int maxLabels = isDays ? 4 : 3;
    final step = (range / maxLabels).ceil().clamp(1, range);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: _getMaxY(spots),
          clipData: const FlClipData.all(),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipColor: (touchedSpot) =>
                  const Color.fromARGB(150, 255, 255, 255),
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final color = Theme.of(context).colorScheme.primary;

                return LineTooltipItem(
                  spot.y.toStringAsFixed(2),
                  TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.25,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 4,
              preventCurveOverShooting: true,
              spots: spots,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondaryContainer,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Color.fromARGB(69, 96, 125, 139),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => const FlLine(
              color: Color.fromARGB(69, 96, 125, 139),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                minIncluded: false,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: step.toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index % step != 0 ||
                      index < 0 ||
                      index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _getRangeFromDuration(String key) {
    switch (key) {
      case '7_days':
        return 7;
      case '15_days':
        return 15;
      case '30_days':
        return 30;
      case '3_months':
        return 3;
      case '6_months':
        return 6;
      case '12_months':
        return 12;
      default:
        return 7;
    }
  }

  List<String> _generateLabels(DateTime start, int range, bool isDays) {
    final formatter = isDays
        ? DateFormat('d/M', 'pt_BR')
        : DateFormat('MMM', 'pt_BR');

    final labels = <String>[];
    for (int i = 0; i < range; i++) {
      final date = isDays
          ? start.add(Duration(days: i))
          : DateTime(start.year, start.month + i, 1);
      labels.add(formatter.format(date));
    }
    return labels;
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;

    final maxVal = spots.map((s) => s.y).reduce(max);
    if (maxVal <= 0) return 100;

    final magnitude = pow(
      10,
      max(0, (log(maxVal) / ln10).floor() - 1),
    ).toDouble();

    final step = magnitude * 10;
    final roundedMax = ((maxVal / step).ceil()) * step;

    return roundedMax.toDouble();
  }
}
