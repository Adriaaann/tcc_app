import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_item_model.dart';
import 'package:tcc_app/views/widgets/custom_tab_bar_widget.dart';
import 'package:tcc_app/views/widgets/financial_card_widget.dart';

class FinancialWidget extends StatelessWidget {
  final List<String> tabList;
  final TabController tabController;
  final List<List<FinancialItem>> cardItems;

  const FinancialWidget({
    super.key,
    required this.tabList,
    required this.tabController,
    required this.cardItems,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsGeometry.only(top: 16),
    child: Column(
      children: [
        CustomTabBar(tabList: tabList, tabController: tabController),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: IndexedStack(
            index: tabController.index,
            children: cardItems
                .map((items) => FinancialCard(items: items))
                .toList(),
          ),
        ),
      ],
    ),
  );
}
