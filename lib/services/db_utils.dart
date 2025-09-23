import 'package:sqflite/sqflite.dart';
import 'package:tcc_app/services/db_helper.dart';

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
