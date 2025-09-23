import 'package:tcc_app/models/financial_form_data_model.dart';

class FinancialData {
  final List<FinancialFormData> expenses;
  final List<FinancialFormData> subscriptions;

  FinancialData({required this.expenses, required this.subscriptions});
}
