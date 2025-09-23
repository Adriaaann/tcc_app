import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/refresh.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
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
    FinancialDataService.instance.refresh();
  }

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<List<List<FinancialFormData>>>(
        stream: FinancialDataService.instance.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.only(top: 64),
              child: CircularProgressIndicator(),
            );
          }

          final cardItems = snapshot.data!;
          final hasData = cardItems.any((list) => list.isNotEmpty);

          if (!hasData) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Nenhum dado encontrado.\nClique no botão abaixo para começar.',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          return Padding(
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
          );
        },
      );
}
