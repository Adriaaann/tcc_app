import 'dart:async';
import 'package:tcc_app/models/financial_data_model.dart';
import 'package:tcc_app/services/db_get.dart';
import 'package:tcc_app/services/db_helper.dart';

class FinancialDataService {
  FinancialDataService._internal() {
    _loadData();
  }

  static final FinancialDataService instance = FinancialDataService._internal();

  final StreamController<FinancialData> _controller =
      StreamController.broadcast();

  Stream<FinancialData> get stream => _controller.stream;

  FinancialData? _cachedData;

  Future<void> _loadData() async {
    final db = DbHelper.instance;
    final expenses = await db.getAllFrom('expenses');
    final subscriptions = await db.getAllFrom('subscriptions');

    final data = FinancialData(
      expenses: expenses,
      subscriptions: subscriptions,
    );
    _cachedData = data;
    _controller.add(data);
  }

  FinancialData? get cachedData => _cachedData;

  Future<void> refresh() async {
    await _loadData();
  }

  void dispose() {
    _controller.close();
  }
}
