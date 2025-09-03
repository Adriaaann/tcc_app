import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class TitleFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const TitleFieldWidget({super.key, required this.controller});

  @override
  State<TitleFieldWidget> createState() => _TitleFieldWidgetState();
}

class _TitleFieldWidgetState extends State<TitleFieldWidget> {
  @override
  Widget build(BuildContext context) => TextField(
    controller: widget.controller,
    maxLength: 40,
    decoration: InputDecoration(
      labelText: 'Nome',
      labelStyle: context.textTheme.titleMedium?.copyWith(
        color: context.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      ),
      border: const UnderlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    ),
  );
}
