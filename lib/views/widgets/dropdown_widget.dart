import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class DropdownWidget extends StatefulWidget {
  final String defaultValue;
  final List<Map<String, String>> options;

  const DropdownWidget({
    super.key,
    required this.defaultValue,
    required this.options,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: context.colorScheme.primaryContainer.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      isDense: true,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      underline: const SizedBox(),
      iconEnabledColor: context.colorScheme.onPrimaryContainer,
      style: context.textTheme.titleMedium?.copyWith(
        color: context.colorScheme.secondary,
        fontWeight: FontWeight.w600,
      ),
      value: _selectedValue,
      items: widget.options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option['value'],
              child: Text(option['label']!),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    ),
  );
}
