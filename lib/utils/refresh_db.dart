import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/db_helper.dart';

final financialDataNotifier = ValueNotifier<List<List<FinancialFormData>>>([
  [],
  [],
]);

Future<void> refreshFinancialData() async {
  final db = await DbHelper.instance.database;

  final expenseMaps = await db.query('expenses', orderBy: 'date DESC');
  final subscriptionMaps = await db.query(
    'subscriptions',
    orderBy: 'date DESC',
  );

  final expenses = expenseMaps
      .map((e) => FinancialFormData.fromMap(e))
      .toList();
  final subscriptions = subscriptionMaps
      .map((e) => FinancialFormData.fromMap(e))
      .toList();

  financialDataNotifier.value = [expenses, subscriptions];
}
