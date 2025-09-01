import 'package:flutter/material.dart';

class FinancialItem {
  final IconData icon;
  final DateTime hour;
  final String title;
  final String value;
  final List<String> tags;

  FinancialItem({
    required this.icon,
    required this.hour,
    required this.title,
    required this.value,
    required this.tags,
  });
}
