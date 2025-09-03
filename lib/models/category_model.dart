import 'package:flutter/material.dart';

class Category {
  final String key;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color labelColor;

  const Category({
    required this.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.labelColor,
  });
}
