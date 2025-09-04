class FinancialFormData {
  final DateTime date;
  final String value;
  final String category;
  final String? title;

  FinancialFormData({
    required this.date,
    required this.value,
    required this.category,
    this.title,
  });

  FinancialFormData copyWith({
    DateTime? date,
    String? value,
    String? category,
    String? title,
  }) => FinancialFormData(
    date: date ?? this.date,
    value: value ?? this.value,
    category: category ?? this.category,
    title: title ?? this.title,
  );

  @override
  String toString() =>
      'date: $date, value: $value, category: $category, title: $title';
}
