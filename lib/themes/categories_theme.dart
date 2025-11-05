import 'package:flutter/material.dart';

class CategoryColor {
  final Color label;
  final Color background;

  const CategoryColor({required this.label, required this.background});
}

class CategoriesTheme {
  static const food = CategoryColor(
    label: Color(0xFFDF8919),
    background: Color(0xFFF8DEBC),
  );

  static const transport = CategoryColor(
    label: Color(0xFFBE2E14),
    background: Color(0xFFFFC8C8),
  );

  static const housing = CategoryColor(
    label: Color(0xFF5A4391),
    background: Color(0xFFD9C7FA),
  );

  static const health = CategoryColor(
    label: Color(0xFF1C6D2E),
    background: Color(0xFFC0F1C1),
  );

  static const leisure = CategoryColor(
    label: Color(0xFF0A548A),
    background: Color(0xFFD1E3F8),
  );

  static const education = CategoryColor(
    label: Color(0xFFAA01AA),
    background: Color(0xFFF4D4F5),
  );

  static const other = CategoryColor(
    label: Color(0xFF494144),
    background: Color(0xFFDBD4D6),
  );

  static const Map<String, CategoryColor> all = {
    'food': food,
    'transport': transport,
    'housing': housing,
    'health': health,
    'leisure': leisure,
    'education': education,
    'other': other,
  };

  static CategoryColor of(String key) => all[key] ?? other;
}
