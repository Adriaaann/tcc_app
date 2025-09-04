import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/services/db_helper.dart';

extension DbHelperFilters on DbHelper {
  Future<List<FinancialFormData>> getAll(String table) async {
    final db = await database;
    final maps = await db.query(table);

    return maps
        .map(
          (map) => FinancialFormData(
            id: map['id'] as int,
            date: DateTime.parse(map['date'] as String),
            value: map['value'] as double,
            category: map['category'] as String,
            title: map['title'] as String?,
          ),
        )
        .toList();
  }

  Future<Map<String, List<FinancialFormData>>> getRecentMultiple({
    required String durationValue,
    String? category,
    String table = 'all',
  }) async {
    final db = await database;

    DateTime fromDate = DateTime.now();
    switch (durationValue) {
      case '7_days':
        fromDate = fromDate.subtract(const Duration(days: 7));
        break;
      case '15_days':
        fromDate = fromDate.subtract(const Duration(days: 15));
        break;
      case '30_days':
        fromDate = fromDate.subtract(const Duration(days: 30));
        break;
      case '3_months':
        fromDate = DateTime(fromDate.year, fromDate.month - 3, fromDate.day);
        break;
      case '6_months':
        fromDate = DateTime(fromDate.year, fromDate.month - 6, fromDate.day);
        break;
      case '12_months':
        fromDate = DateTime(fromDate.year - 1, fromDate.month, fromDate.day);
        break;
      default:
        fromDate = fromDate.subtract(const Duration(days: 30));
    }

    final whereClause = category != null && category.isNotEmpty
        ? 'date >= ? AND category = ?'
        : 'date >= ?';
    final whereArgs = category != null && category.isNotEmpty
        ? [fromDate.toIso8601String(), category]
        : [fromDate.toIso8601String()];

    final Map<String, List<FinancialFormData>> result = {};

    Future<List<FinancialFormData>> queryTable(String t) async {
      final maps = await db.query(
        t,
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'date DESC',
      );
      return maps
          .map(
            (map) => FinancialFormData(
              id: map['id'] as int,
              date: DateTime.parse(map['date'] as String),
              value: (map['value'] as num).toDouble(),
              category: map['category'] as String,
              title: map['title'] as String?,
            ),
          )
          .toList();
    }

    if (table == 'expenses' || table == 'all') {
      result['expenses'] = await queryTable('expenses');
    }

    if (table == 'subscriptions' || table == 'all') {
      result['subscriptions'] = await queryTable('subscriptions');
    }

    return result;
  }
}
