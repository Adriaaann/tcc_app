import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
final financialDataNotifier = ValueNotifier<List<List<FinancialFormData>>>([
  [],
  [],
]);
