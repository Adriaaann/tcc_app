import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/models/form_field_item_model.dart';
import 'package:tcc_app/services/db_helper.dart';
import 'package:tcc_app/services/db_utils.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/data/categories_list.dart';
import 'package:tcc_app/views/widgets/financial_form/card_container_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/category_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/date_time_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/form_button_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/form_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/title_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/value_field_widget.dart';
import 'package:tcc_app/views/widgets/pop_alert_widget.dart';

class FinancialFormPage extends StatefulWidget {
  final bool isEdit;
  final FinancialFormData? initialData;

  const FinancialFormPage({super.key, required this.isEdit, this.initialData});

  @override
  State<FinancialFormPage> createState() => _FinancialFormPageState();
}

class _FinancialFormPageState extends State<FinancialFormPage> {
  FinancialFormData? formData;
  final valueController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      formData = widget.initialData;
      valueController.text = formData!.value;
      if (formData!.title != null) {
        titleController.text = formData!.title!;
      }
    }
  }

  void _updateFormData({
    DateTime? date,
    String? value,
    String? category,
    String? title,
  }) {
    formData =
        (formData ??
                FinancialFormData(
                  date: date ?? DateTime.now(),
                  value: value ?? valueController.text,
                  category: category ?? categoriesList.first.key,
                  title: titleController.text.isNotEmpty
                      ? titleController.text
                      : null,
                ))
            .copyWith(
              date: date,
              value: value,
              category: category,
              title: title,
            );
  }

  Future<void> deleteFormData(FinancialFormData data) async {
    if (data.id == null) return;

    final db = await DbHelper.instance.database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [data.id]);

    await refreshFinancialData();
  }

  Future<void> saveForm() async {
    if (valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Insira um Valor para salvar.'),
        ),
      );
      return;
    }

    _updateFormData(
      value: valueController.text,
      title: titleController.text.isNotEmpty ? titleController.text : null,
    );

    final db = await DbHelper.instance.database;

    if (formData!.id != null) {
      await db.update(
        'expenses',
        formData!.toMap(),
        where: 'id = ?',
        whereArgs: [formData!.id],
      );
    } else {
      final id = await db.insert('expenses', formData!.toMap());
      formData = formData!.copyWith(id: id);
    }

    await refreshFinancialData();

    if (mounted) Navigator.pop(context);
  }

  Future<void> confirmDelete(FinancialFormData data) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar?'),
        content: const Text('Deseja realmente deletar este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final db = await DbHelper.instance.database;
      if (data.id != null) {
        await db.delete('expenses', where: 'id = ?', whereArgs: [data.id]);
        await refreshFinancialData();
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FormFieldItem> fieldItems = [
      FormFieldItem(
        icon: Icons.calendar_month_rounded,
        widget: DateTimeFieldWidget(
          initialDateTime: formData?.date,
          onDateTimeSelected: (date) => _updateFormData(date: date),
        ),
      ),
      FormFieldItem(
        icon: Icons.title,
        widget: TitleFieldWidget(controller: titleController),
      ),
      FormFieldItem(
        icon: Icons.bookmark_outline_rounded,
        widget: CategoryFieldWidget(
          categories: categoriesList,
          initialCategory: formData != null
              ? categoriesList.firstWhere(
                  (c) => c.key == formData!.category,
                  orElse: () => categoriesList.first,
                )
              : null,
          onCategorySelected: (category) =>
              _updateFormData(category: category.key),
        ),
      ),
    ];

    return PopAlertWidget(
      widget: Scaffold(
        backgroundColor: context.colorScheme.secondaryContainer,
        appBar: AppBar(
          backgroundColor: context.colorScheme.secondaryContainer,
          title: Text(
            widget.isEdit ? 'Editar' : 'Criar',
            style: context.textTheme.titleLarge,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueField(controller: valueController),
              CardContainerWidget(
                children: [
                  ...fieldItems.map(
                    (field) =>
                        FormFieldWidget(icon: field.icon, child: field.widget),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FormButtonWidget(
                        onPressed: saveForm,
                        icon: Icons.check_rounded,
                        backgroundColor: context.colorScheme.primary,
                      ),
                      if (widget.isEdit)
                        FormButtonWidget(
                          onPressed: () => confirmDelete(formData!),
                          icon: Icons.delete_rounded,
                          backgroundColor: context.colorScheme.error,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
