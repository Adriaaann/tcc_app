import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_data_model.dart';
import 'package:tcc_app/services/financial_data_service.dart';
import 'package:tcc_app/views/data/constants.dart';
import 'package:tcc_app/views/widgets/bar_chart_widget.dart';
import 'package:tcc_app/views/widgets/line_chart_widget.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  String selectedDuration = durationOptions.first['value'] as String;

  @override
  void initState() {
    super.initState();
    FinancialDataService.instance.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      body: StreamBuilder<FinancialData?>(
        stream: FinancialDataService.instance.stream,
        initialData: FinancialDataService.instance.cachedData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.expenses.isEmpty && data.subscriptions.isEmpty) {
            return Center(
              child: Text(
                'Nenhum dado encontrado.\nClique no botão abaixo para criar.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          final filtered = _filterDataByDuration(data);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                DropdownButton<String>(
                  value: selectedDuration,
                  isExpanded: true,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedDuration = value);
                    }
                  },
                  items: durationOptions
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option['value'] as String,
                          child: Text(option['label'] as String),
                        ),
                      )
                      .toList(),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _ChartCard(
                        title: 'Evolução de Despesas',
                        child: LineChartWidget(
                          durationKey: selectedDuration,
                          filtered.expenses,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ChartCard(
                        title: 'Distribuição por Categoria',
                        child: BarChartWidget(filtered.expenses),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  FinancialData _filterDataByDuration(FinancialData data) {
    final now = DateTime.now();
    Duration duration;

    switch (selectedDuration) {
      case '7_days':
        duration = const Duration(days: 7);
        break;
      case '15_days':
        duration = const Duration(days: 15);
        break;
      case '30_days':
        duration = const Duration(days: 30);
        break;
      case '3_months':
        duration = const Duration(days: 90);
        break;
      case '6_months':
        duration = const Duration(days: 180);
        break;
      case '12_months':
        duration = const Duration(days: 365);
        break;
      default:
        duration = const Duration(days: 30);
    }

    final cutoff = now.subtract(duration);

    return FinancialData(
      expenses: data.expenses.where((e) => e.date.isAfter(cutoff)).toList(),
      subscriptions: data.subscriptions
          .where((s) => s.date.isAfter(cutoff))
          .toList(),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 32,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: child,
          ),
        ],
      ),
    ),
  );
}
