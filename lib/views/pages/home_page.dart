import 'package:flutter/material.dart';
import 'package:tcc_app/views/data/constants.dart';
import 'package:tcc_app/views/pages/widget_tree.dart';
import 'package:tcc_app/views/widgets/financial_widget.dart';
import 'package:tcc_app/views/widgets/summary_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SummaryCardWidget(
            durationOptions: durationOptions,
            sectionData: sectionData,
          ),
          FinancialWidget(
            tabList: tabBarTitles,
            tabController: tabController,
            cardItems: combinedItems,
          ),
        ],
      ),
    ),
  );
}
