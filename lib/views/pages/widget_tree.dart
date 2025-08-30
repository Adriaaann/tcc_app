import 'package:flutter/material.dart';
import 'package:tcc_app/views/widgets/summary_card_widget.dart';

final List<Map<String, String>> durationOptions = [
  {'value': '7_days', 'label': '7 Days'},
  {'value': '15_days', 'label': '15 Days'},
  {'value': '30_days', 'label': '30 Days'},
  {'value': '3_months', 'label': '3 Months'},
  {'value': '6_months', 'label': '6 Months'},
  {'value': '12_months', 'label': '12 Months'},
];

final List<Map<String, Object>> sectionData = [
  {'color': Colors.blue, 'label': 'Cat 1', 'value': 25.0},
  {'color': Colors.deepOrange, 'label': 'Categy 2', 'value': 15.0},
  {'color': Colors.deepPurpleAccent, 'label': 'Category 3', 'value': 20.0},
  {'color': Colors.indigo, 'label': 'C 4', 'value': 10.0},
  {'color': Colors.orange, 'label': 'CategorDAWDy 5', 'value': 5.0},
  {'color': Colors.purpleAccent, 'label': 'daw 6', 'value': 15.0},
  {'color': Colors.teal, 'label': 'daw56 7', 'value': 10.0},
];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SummaryCardWidget(
              durationOptions: durationOptions,
              sectionData: sectionData,
            ),
          ],
        ),
      ),
    ),
  );
}
