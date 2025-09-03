import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class ValueField extends StatefulWidget {
  final TextEditingController controller;

  const ValueField({super.key, required this.controller});

  @override
  State<ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<ValueField> {
  final formatter = CurrencyTextInputFormatter.currency(
    name: 'BRL',
    symbol: 'R\$',
    decimalDigits: 2,
    maxValue: 1000000,
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: TextField(
      controller: widget.controller,
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
