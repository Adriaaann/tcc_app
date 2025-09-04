import 'package:tcc_app/models/financial_form_data_model.dart';

double getFinancialSumMethod(
  List<FinancialFormData> items, {
  String? category,
}) {
  double sum = 0.0;

  for (final item in items) {
    if (category != null && item.category != category) continue;

    final value = item.value;
    sum += value;
  }

  return sum;
}
