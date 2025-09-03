import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/widgets/financial_form/date_time_field_widget.dart';
import 'package:tcc_app/views/widgets/pop_alert_widget.dart';

class FinancialFormPage extends StatelessWidget {
  final String title;

  const FinancialFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final formatter = CurrencyTextInputFormatter.currency(
      name: 'BRL',
      symbol: 'R\$',
      decimalDigits: 2,
      maxValue: 1000000,
    );

    return PopAlertWidget(
      widget: Scaffold(
        backgroundColor: context.colorScheme.secondaryContainer,
        appBar: AppBar(
          backgroundColor: context.colorScheme.secondaryContainer,
          title: Text(title, style: context.textTheme.titleLarge),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              spacing: 32,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ValueField(formatter: formatter),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        spacing: 8,
                        children: [
                          DateTimeField(
                            onDateTimeSelected: (date) {
                              log('$date');
                            },
                          ),
                          IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Icons.check),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ValueField extends StatelessWidget {
  const _ValueField({required this.formatter});

  final CurrencyTextInputFormatter formatter;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[formatter],
      style: context.textTheme.bodyMedium?.copyWith(fontSize: 32),
      decoration: InputDecoration(
        labelText: 'Valor',
        labelStyle: context.textTheme.titleLarge?.copyWith(
          color: context.colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
        hintText: 'R\$0,00',
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          fontSize: 32,
          color: context.colorScheme.outline,
        ),
        border: const UnderlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
    ),
  );
}
