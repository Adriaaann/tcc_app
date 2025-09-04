import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/utils/refresh_db.dart';
import 'package:tcc_app/views/widgets/custom_tab_bar_widget.dart';
import 'package:tcc_app/views/widgets/financial_card_widget.dart';

class FinancialWidget extends StatefulWidget {
  final List<String> tabList;
  final TabController tabController;

  const FinancialWidget({
    super.key,
    required this.tabList,
    required this.tabController,
  });

  @override
  State<FinancialWidget> createState() => _FinancialWidgetState();
}

class _FinancialWidgetState extends State<FinancialWidget> {
  @override
  void initState() {
    super.initState();
    refreshFinancialData();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<List<List<FinancialFormData>>>(
        valueListenable: financialDataNotifier,
        builder: (context, cardItems, _) => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CustomTabBar(
                tabList: widget.tabList,
                tabController: widget.tabController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AnimatedBuilder(
                  animation: widget.tabController,
                  builder: (context, _) {
                    final index = widget.tabController.index;
                    return FinancialCard(items: cardItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
