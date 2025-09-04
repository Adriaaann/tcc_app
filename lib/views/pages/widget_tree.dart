import 'package:flutter/material.dart';
import 'package:tcc_app/views/data/notifiers.dart';
import 'package:tcc_app/views/pages/graphs_page.dart';
import 'package:tcc_app/views/pages/home_page.dart';
import 'package:tcc_app/views/widgets/navbar_widget.dart';

final sectionData = [
  {'color': Colors.blue, 'label': 'Cat 1', 'value': 25.0},
  {'color': Colors.deepOrange, 'label': 'Category 2', 'value': 15.0},
  {'color': Colors.deepPurpleAccent, 'label': 'Category 3', 'value': 20.0},
  {'color': Colors.indigo, 'label': 'Cat 4', 'value': 10.0},
  {'color': Colors.orange, 'label': 'Category 5', 'value': 5.0},
  {'color': Colors.purpleAccent, 'label': 'Cat 6', 'value': 15.0},
  {'color': Colors.teal, 'label': 'Cat 7', 'value': 10.0},
];

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
    tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(tabController: tabController),
      const GraphsPage(),
    ];

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) =>
            pages.elementAt(selectedPage),
      ),
      bottomNavigationBar: const NavbarWidget(),
    );
  }
}
