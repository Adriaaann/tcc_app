import 'package:flutter/material.dart';
import 'package:tcc_app/views/data/notifiers.dart';
import 'package:tcc_app/views/pages/graphs_page.dart';
import 'package:tcc_app/views/pages/home_page.dart';
import 'package:tcc_app/views/widgets/navbar_widget.dart';

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
