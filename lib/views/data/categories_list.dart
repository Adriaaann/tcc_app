import 'package:flutter/material.dart';
import 'package:tcc_app/models/category_model.dart';
import 'package:tcc_app/themes/categories_theme.dart';

final List<Category> categoriesList = [
  Category(
    key: 'food',
    label: 'Alimentação',
    icon: Icons.fastfood_rounded,
    backgroundColor: CategoriesTheme.food.background,
    labelColor: CategoriesTheme.food.label,
  ),
  Category(
    key: 'transport',
    label: 'Transporte',
    icon: Icons.directions_car_rounded,
    backgroundColor: CategoriesTheme.transport.background,
    labelColor: CategoriesTheme.transport.label,
  ),
  Category(
    key: 'housing',
    label: 'Moradia',
    icon: Icons.home_rounded,
    backgroundColor: CategoriesTheme.housing.background,
    labelColor: CategoriesTheme.housing.label,
  ),
  Category(
    key: 'health',
    label: 'Saúde',
    icon: Icons.local_hospital_rounded,
    backgroundColor: CategoriesTheme.health.background,
    labelColor: CategoriesTheme.health.label,
  ),
  Category(
    key: 'leisure',
    label: 'Lazer',
    icon: Icons.movie_rounded,
    backgroundColor: CategoriesTheme.leisure.background,
    labelColor: CategoriesTheme.leisure.label,
  ),
  Category(
    key: 'education',
    label: 'Educação',
    icon: Icons.school,
    backgroundColor: CategoriesTheme.education.background,
    labelColor: CategoriesTheme.education.label,
  ),
  Category(
    key: 'others',
    label: 'Outros',
    icon: Icons.more_horiz_rounded,
    backgroundColor: CategoriesTheme.other.background,
    labelColor: CategoriesTheme.other.label,
  ),
];
