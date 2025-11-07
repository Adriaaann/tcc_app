import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_data_model.dart';
import 'package:tcc_app/services/financial_data_service.dart';
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
  final _service = FinancialDataService.instance;

  @override
  void initState() {
    super.initState();

    if (_service.cachedData == null) {
      _service.refresh();
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<FinancialData?>(
    stream: _service.stream,
    initialData: _service.cachedData,
    builder: (context, snapshot) {
      final data = snapshot.data;

      if (data == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final hasData = data.expenses.isNotEmpty || data.subscriptions.isNotEmpty;

      if (!hasData) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: Center(
            child: Text(
              'Nenhum dado encontrado.\nClique no botão abaixo para criar.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }

      final tabItems = [data.expenses, data.subscriptions];

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
                  return FinancialCard(items: tabItems[index]);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
