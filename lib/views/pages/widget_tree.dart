import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_item_model.dart';
import 'package:tcc_app/views/widgets/financial_widget.dart';
import 'package:tcc_app/views/widgets/summary_card_widget.dart';

final durationOptions = [
  {'value': '7_days', 'label': '7 Days'},
  {'value': '15_days', 'label': '15 Days'},
  {'value': '30_days', 'label': '30 Days'},
  {'value': '3_months', 'label': '3 Months'},
  {'value': '6_months', 'label': '6 Months'},
  {'value': '12_months', 'label': '12 Months'},
];

final sectionData = [
  {'color': Colors.blue, 'label': 'Cat 1', 'value': 25.0},
  {'color': Colors.deepOrange, 'label': 'Category 2', 'value': 15.0},
  {'color': Colors.deepPurpleAccent, 'label': 'Category 3', 'value': 20.0},
  {'color': Colors.indigo, 'label': 'Cat 4', 'value': 10.0},
  {'color': Colors.orange, 'label': 'Category 5', 'value': 5.0},
  {'color': Colors.purpleAccent, 'label': 'Cat 6', 'value': 15.0},
  {'color': Colors.teal, 'label': 'Cat 7', 'value': 10.0},
];

final tabList = ['Subscriptions', 'Expenses'];

final chipList = [
  'Restaurant',
  'Travel',
  'Shopping',
  'Bills',
  'Groceries',
  'Car',
  'Education',
  'Streaming',
  'Gym',
];

final List<FinancialItem> example15Items = List.generate(
  15,
  (index) => FinancialItem(
    icon: Icons.shopping_cart,
    hour: DateTime(2025, 9, 1, 8 + (index % 12), (index * 5) % 60),
    title: 'Expense $index',
    value: 'R\$ ${100 + index * 10},00',
    tags: ['tags $index', 'tagsdawdaw $index', 'tags $index'],
  ),
);

final List<FinancialItem> example3Items = [
  FinancialItem(
    icon: Icons.restaurant,
    hour: DateTime(2025, 9, 1, 12, 30),
    title: 'Lunch',
    value: 'R\$ 45,00',
    tags: ['Duas Tags', 'Café'],
  ),
  FinancialItem(
    icon: Icons.local_cafe,
    hour: DateTime(2025, 9, 1, 15, 0),
    title: 'Coffee',
    value: 'R\$ 12,50',
    tags: [],
  ),
  FinancialItem(
    icon: Icons.directions_bus,
    hour: DateTime(2025, 9, 1, 18, 15),
    title: 'Bus Ticket',
    value: 'R\$ 7,25',
    tags: ['ABlubblbauba'],
  ),
];

final List<List<FinancialItem>> combinedItems = [example15Items, example3Items];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() => setState(() {})); // troca aba
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SummaryCardWidget(
              durationOptions: durationOptions,
              sectionData: sectionData,
            ),
            FinancialWidget(
              tabList: tabList,
              tabController: tabController,
              cardItems: combinedItems,
            ),
          ],
        ),
      ),
    ),
  );
}
