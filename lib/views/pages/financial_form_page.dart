import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/data/categories_list.dart';
import 'package:tcc_app/views/widgets/financial_form/category_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/date_time_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/title_field_widget.dart';
import 'package:tcc_app/views/widgets/financial_form/value_field_widget.dart';
import 'package:tcc_app/views/widgets/pop_alert_widget.dart';

class FormFieldItem {
  final IconData icon;
  final Widget widget;

  const FormFieldItem({required this.icon, required this.widget});
}

class FinancialFormData {
  DateTime? date;
  String? value;
  String? title;
  String? category;
}

class FinancialFormPage extends StatefulWidget {
  final String title;

  const FinancialFormPage({super.key, required this.title});

  @override
  State<FinancialFormPage> createState() => _FinancialFormPageState();
}

class _FinancialFormPageState extends State<FinancialFormPage> {
  final valueController = TextEditingController();
  final titleController = TextEditingController();
  final FinancialFormData formData = FinancialFormData();

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }

  void saveForm() {
    if (valueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Insira um Valor para salvar.'),
        ),
      );
      return;
    }

    formData
      ..value = valueController.text
      ..title = titleController.text;
  }

  @override
  Widget build(BuildContext context) {
    final List<FormFieldItem> fieldItems = [
      FormFieldItem(
        icon: Icons.calendar_month_rounded,
        widget: DateTimeFieldWidget(
          onDateTimeSelected: (date) => formData.date = date,
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
          onCategorySelected: (category) {
            formData.category = category.key;
          },
        ),
      ),
    ];

    return PopAlertWidget(
      widget: Scaffold(
        backgroundColor: context.colorScheme.secondaryContainer,
        appBar: AppBar(
          backgroundColor: context.colorScheme.secondaryContainer,
          title: Text(widget.title, style: context.textTheme.titleLarge),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueField(controller: valueController),
              _CardContainer(
                children: [
                  ...fieldItems.map(
                    (field) =>
                        _FormField(icon: field.icon, child: field.widget),
                  ),
                  _SaveButton(onPressed: saveForm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const _FormField({required this.icon, required this.child});

  @override
  Widget build(BuildContext context) => Row(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, color: context.colorScheme.secondary),
      Flexible(child: child),
    ],
  );
}

class _CardContainer extends StatelessWidget {
  final List<Widget> children;

  const _CardContainer({required this.children});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          //! Remover após adicionar o restante das funcionalidades
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(spacing: 16, children: children),
      ),
    ),
  );
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) =>
      IconButton.filled(onPressed: onPressed, icon: const Icon(Icons.check));
}
