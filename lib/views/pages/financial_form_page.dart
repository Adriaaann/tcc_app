import 'package:flutter/material.dart';
import 'package:tcc_app/models/financial_form_data_model.dart';
import 'package:tcc_app/models/form_field_item_model.dart';
import 'package:tcc_app/services/db_helper.dart';
import 'package:tcc_app/services/financial_data_service.dart';
import 'package:tcc_app/utils/confirm_delete_form.dart';
import 'package:tcc_app/utils/format_currency_method.dart';
import 'package:tcc_app/utils/parse_double_method.dart';
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

      valueController.text = formatCurrency(formData!.value);

      if (formData!.title != null) {
        titleController.text = formData!.title!;
      }
    }
  }

  void _updateFormData({
    DateTime? date,
    double? value,
    String? category,
    String? title,
  }) {
    formData =
        (formData ??
                FinancialFormData(
                  date: date ?? DateTime.now(),
                  value: value ?? 0.0,
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

    await FinancialDataService.instance.refresh();
  }

  Future<void> _saveForm() async {
    if (valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Insira um Valor para salvar.'),
        ),
      );
      return;
    }

    final parsedValue = parseDouble(valueController.text);

    _updateFormData(
      value: parsedValue,
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

    await FinancialDataService.instance.refresh();

    if (mounted) Navigator.pop(context);
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
                        onPressed: _saveForm,
                        icon: Icons.check_rounded,
                        backgroundColor: context.colorScheme.primary,
                      ),
                      if (widget.isEdit)
                        FormButtonWidget(
                          onPressed: () async {
                            await confirmDelete(formData!, context);

                            if (context.mounted) Navigator.pop(context);
                          },
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
