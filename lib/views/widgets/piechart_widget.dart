import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/indicator_widget.dart';

class PiechartWidget extends StatefulWidget {
  final List<Map<String, Object>> data;

  const PiechartWidget({super.key, required this.data});

  @override
  State<PiechartWidget> createState() => _PiechartWidgetState();
}

class _PiechartWidgetState extends State<PiechartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: pieChartSection(),
                sectionsSpace: 1,
                centerSpaceRadius: 48,
                startDegreeOffset: 16,
              ),
            ),
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 2,
          children: widget.data.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final isTouched = index == touchedIndex;

            return IndicatorWidget(
              color: data['color'] as Color,
              text: data['label'] as String,
              isTouched: isTouched,
            );
          }).toList(),
        ),
      ],
    ),
  );

  List<PieChartSectionData> pieChartSection() =>
      List.generate(widget.data.length, (index) {
        final Map<String, Object> data = widget.data[index];
        final double value = data['value'] as double;
        final isTouched = index == touchedIndex;
        final radius = isTouched ? 32.0 : 40.0;

        return PieChartSectionData(
          value: value,
          title: isTouched ? '$value%' : '',
          titleStyle: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.secondary,
          ),
          titlePositionPercentageOffset: -1.5,
          color: data['color'] as Color,
          radius: radius,
        );
      });
}
