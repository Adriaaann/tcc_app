import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/views/data/categories_list.dart';

List<Map<String, Object>> calculateSectionData(
  List<FinancialFormData> allItems,
) {
  final Map<String, double> categoryTotals = {};
  double total = 0.0;

  for (var item in allItems) {
    categoryTotals[item.category] =
        (categoryTotals[item.category] ?? 0.0) + item.value;
    total += item.value;
  }

  if (total == 0) return [];

  final filteredCategories = categoriesList
      .where((category) => (categoryTotals[category.key] ?? 0.0) > 0)
      .toList();

  return List.generate(filteredCategories.length, (index) {
    final category = filteredCategories[index];
    final value = categoryTotals[category.key]!;
    final percentage = double.parse(((value / total) * 100).toStringAsFixed(2));
    return {
      'color': index == filteredCategories.length - 1
          ? category.backgroundColor
          : category.labelColor,
      'label': category.label,
      'value': percentage,
    };
  });
}
