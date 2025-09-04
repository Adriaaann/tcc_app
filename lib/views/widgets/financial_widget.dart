import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/views/widgets/custom_tab_bar_widget.dart';
import 'package:tcc_app/views/widgets/financial_card_widget.dart';

class FinancialWidget extends StatelessWidget {
  final List<String> tabList;
  final TabController tabController;
  final List<List<FinancialFormData>> cardItems;

  const FinancialWidget({
    super.key,
    required this.tabList,
    required this.tabController,
    required this.cardItems,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      children: [
        CustomTabBar(tabList: tabList, tabController: tabController),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              final index = tabController.index;
              return FinancialCard(items: cardItems[index]);
            },
          ),
        ),
      ],
    ),
  );
}
