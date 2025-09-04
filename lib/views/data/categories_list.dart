import 'package:flutter/material.dart';
import 'package:tcc_app/models/category_model.dart';

final List<Category> categoriesList = [
  Category(
    key: 'food',
    label: 'Alimentação',
    icon: Icons.fastfood_rounded,
    backgroundColor: Colors.orange.shade200,
    labelColor: Colors.orange.shade800,
  ),
  Category(
    key: 'transport',
    label: 'Transporte',
    icon: Icons.directions_car,
    backgroundColor: Colors.blue.shade200,
    labelColor: Colors.blue.shade800,
  ),
  Category(
    key: 'health',
    label: 'Saúde',
    icon: Icons.local_hospital,
    backgroundColor: Colors.red.shade200,
    labelColor: Colors.red.shade800,
  ),
  Category(
    key: 'education',
    label: 'Educação',
    icon: Icons.school,
    backgroundColor: Colors.green.shade200,
    labelColor: Colors.green.shade800,
  ),
  Category(
    key: 'others',
    label: 'Outros',
    icon: Icons.more_horiz_rounded,
    backgroundColor: Colors.grey.shade400,
    labelColor: Colors.grey.shade100,
  ),
];
