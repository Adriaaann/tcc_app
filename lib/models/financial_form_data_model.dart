class FinancialFormData {
  final int? id;
  final DateTime date;
  final String value;
  final String category;
  final String? title;

  FinancialFormData({
    this.id,
    required this.date,
    required this.value,
    required this.category,
    this.title,
  });

  FinancialFormData copyWith({
    int? id,
    DateTime? date,
    String? value,
    String? category,
    String? title,
  }) => FinancialFormData(
    id: id ?? this.id,
    date: date ?? this.date,
    value: value ?? this.value,
    category: category ?? this.category,
    title: title ?? this.title,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'value': value,
    'category': category,
    'title': title,
  };

  factory FinancialFormData.fromMap(Map<String, dynamic> map) =>
      FinancialFormData(
        id: map['id'] as int?,
        date: DateTime.parse(map['date'] as String),
        value: map['value'] as String,
        category: map['category'] as String,
        title: map['title'] as String?,
      );
}
