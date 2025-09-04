import 'package:flutter/material.dart';
import 'package:tcc_app/models/category_model.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class CategoryFieldWidget extends StatefulWidget {
  final List<Category> categories;
  final ValueChanged<Category> onCategorySelected;
  final Category? initialCategory;

  const CategoryFieldWidget({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.initialCategory,
  });

  @override
  State<CategoryFieldWidget> createState() => _CategoryFieldWidgetState();
}

class _CategoryFieldWidgetState extends State<CategoryFieldWidget> {
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? widget.categories.last;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCategorySelected(selectedCategory);
    });
  }

  void _openCategorySheet(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final result = await showModalBottomSheet<Category>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.categories.length,
          itemBuilder: (context, index) {
            final category = widget.categories[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: category.backgroundColor.withValues(
                    alpha: 0.8,
                  ),
                  child: Icon(
                    category.icon,
                    color: category.labelColor,
                    size: 24,
                  ),
                ),
                title: Text(category.label),
                onTap: () => Navigator.pop(context, category),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(height: 2),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedCategory = result;
      });
      widget.onCategorySelected(result);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _openCategorySheet(context),
    child: Row(
      spacing: 8,
      children: [
        Chip(
          backgroundColor: selectedCategory.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: selectedCategory.labelColor),
          ),
          avatar: Icon(
            selectedCategory.icon,
            color: context.colorScheme.outline,
          ),
          label: Text(
            selectedCategory.label,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.scrim,
            ),
          ),
        ),
        const Icon(Icons.keyboard_arrow_down_rounded),
      ],
    ),
  );
}
