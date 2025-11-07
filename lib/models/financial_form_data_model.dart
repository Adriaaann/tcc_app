class FinancialFormData {
  final int? id;
  final DateTime date;
  final double value;
  final String category;
  final String? title;
  final String sourceTable;

  FinancialFormData({
    this.id,
    required this.date,
    required this.value,
    required this.category,
    this.title,
    this.sourceTable = 'expenses',
  });

  FinancialFormData copyWith({
    int? id,
    DateTime? date,
    double? value,
    String? category,
    String? title,
    String? sourceTable,
  }) => FinancialFormData(
    id: id ?? this.id,
    date: date ?? this.date,
    value: value ?? this.value,
    category: category ?? this.category,
    title: title ?? this.title,
    sourceTable: sourceTable ?? this.sourceTable,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'value': value,
    'category': category,
    'title': title,
  };

  factory FinancialFormData.fromMap(Map<String, dynamic> map, String table) =>
      FinancialFormData(
        id: map['id'] as int?,
        date: DateTime.parse(map['date']),
        value: map['value'] is int
            ? (map['value'] as int).toDouble()
            : map['value'],
        category: map['category'] as String,
        title: map['title'] as String?,
        sourceTable: table,
      );
}
