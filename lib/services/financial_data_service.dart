import 'dart:async';
import 'package:tcc_app/models/financial_data_model.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/db_get.dart';
import 'package:tcc_app/services/db_helper.dart';

class FinancialDataService {
  FinancialDataService._internal() {
    _initialize();
  }

  static final FinancialDataService instance = FinancialDataService._internal();

  final StreamController<FinancialData?> _controller =
      StreamController<FinancialData?>.broadcast();

  Stream<FinancialData?> get stream => _controller.stream;

  FinancialData? _cachedData;
  bool _isInitialized = false;

  Future<void> _initialize() async {
    await _loadData();
    _isInitialized = true;
  }

  Future<void> _loadData() async {
    try {
      final db = DbHelper.instance;
      final expenses = await db.getAllFrom('expenses');
      final subscriptions = await db.getAllFrom('subscriptions');

      final markedExpenses = expenses
          .map((e) => e.copyWith(sourceTable: 'expenses'))
          .toList();

      final markedSubscriptions = subscriptions
          .map((e) => e.copyWith(sourceTable: 'subscriptions'))
          .toList();

      final data = FinancialData(
        expenses: markedExpenses,
        subscriptions: markedSubscriptions,
      );

      _cachedData = data;
      _controller.add(data);
    } catch (e) {
      _controller.addError(e);
    }
  }

  FinancialData? get cachedData => _cachedData;

  Future<void> refresh() async {
    await _loadData();
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initialize();
    }
  }

  List<FinancialFormData> get allItems {
    if (_cachedData == null) return [];
    return [..._cachedData!.expenses, ..._cachedData!.subscriptions];
  }

  List<FinancialFormData> getLastDaysData(int days) {
    if (_cachedData == null) return [];
    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days - 1));

    return allItems.where((e) => e.date.isAfter(cutoff)).toList();
  }

  void dispose() {
    _controller.close();
  }
}
