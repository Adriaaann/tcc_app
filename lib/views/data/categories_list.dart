import 'package:flutter/material.dart';
import 'package:tcc_app/models/category_model.dart';

final List<Category> categoriesList = [
  Category(
    key: 'food',
    label: 'Alimentação',
    icon: Icons.fastfood_rounded,
    backgroundColor: Colors.orange.shade100,
    labelColor: Colors.orange.shade900,
  ),
  Category(
    key: 'transport',
    label: 'Transporte',
    icon: Icons.directions_car,
    backgroundColor: Colors.blue.shade100,
    labelColor: Colors.blue.shade900,
  ),
  Category(
    key: 'health',
    label: 'Saúde',
    icon: Icons.local_hospital,
    backgroundColor: Colors.red.shade100,
    labelColor: Colors.red.shade900,
  ),
  Category(
    key: 'education',
    label: 'Educação',
    icon: Icons.school,
    backgroundColor: Colors.green.shade100,
    labelColor: Colors.green.shade900,
  ),
  Category(
    key: 'others',
    label: 'Outros',
    icon: Icons.more_horiz_rounded,
    backgroundColor: Colors.grey.shade300,
    labelColor: Colors.grey.shade900,
  ),
];
