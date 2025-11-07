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
  final bool? isSubscription;

  const FinancialFormPage({
    super.key,
    required this.isEdit,
    this.initialData,
    this.isSubscription,
  });

  @override
  State<FinancialFormPage> createState() => _FinancialFormPageState();
}

class _FinancialFormPageState extends State<FinancialFormPage> {
  FinancialFormData? formData;
  final valueController = TextEditingController();
  final titleController = TextEditingController();
  late bool isSubscription;
  late bool originalIsSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      formData = widget.initialData;
      valueController.text = formatCurrency(formData!.value);
      if (formData!.title != null) titleController.text = formData!.title!;
    }

    if (widget.initialData != null) {
      isSubscription = formData!.sourceTable == 'subscriptions';
      originalIsSubscription = isSubscription;
    } else {
      isSubscription = widget.isSubscription ?? false;
      originalIsSubscription = isSubscription;
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
                  sourceTable: isSubscription ? 'subscriptions' : 'expenses',
                ))
            .copyWith(
              date: date,
              value: value,
              category: category,
              title: title,
              sourceTable: isSubscription ? 'subscriptions' : 'expenses',
            );
  }

  Future<void> _saveForm() async {
    if (valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Insira um valor para salvar.'),
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
    final newTable = isSubscription ? 'subscriptions' : 'expenses';
    final oldTable = originalIsSubscription ? 'subscriptions' : 'expenses';

    if (formData!.id == null) {
      final id = await db.insert(newTable, formData!.toMap());
      formData = formData!.copyWith(id: id, sourceTable: newTable);
    } else if (newTable == oldTable) {
      await db.update(
        newTable,
        formData!.toMap(),
        where: 'id = ?',
        whereArgs: [formData!.id],
      );
    } else {
      await db.delete(oldTable, where: 'id = ?', whereArgs: [formData!.id]);
      final id = await db.insert(newTable, formData!.toMap());
      formData = formData!.copyWith(id: id, sourceTable: newTable);
    }

    await FinancialDataService.instance.refresh();

    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteForm() async {
    if (formData?.id == null) return;
    final db = await DbHelper.instance.database;
    final table = formData!.sourceTable;

    await db.delete(table, where: 'id = ?', whereArgs: [formData!.id]);
    await FinancialDataService.instance.refresh();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<FormFieldItem> fieldItems = [
      FormFieldItem(
        icon: Icons.subscriptions_rounded,
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('É uma assinatura?', style: context.textTheme.titleMedium),
            Switch(
              value: isSubscription,
              onChanged: (val) {
                setState(() => isSubscription = val);
              },
            ),
          ],
        ),
      ),
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
                            await _deleteForm();
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
