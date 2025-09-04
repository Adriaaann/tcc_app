import 'package:sqflite/sqflite.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/db_helper.dart';
import 'package:tcc_app/views/data/notifiers.dart';

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

Future<bool> hasFinancialData() async {
  final db = await DbHelper.instance.database;

  final expenseCount =
      Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM expenses'),
      ) ??
      0;

  final subscriptionCount =
      Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM subscriptions'),
      ) ??
      0;

  return expenseCount > 0 || subscriptionCount > 0;
}
