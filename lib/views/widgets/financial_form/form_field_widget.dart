import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class FormFieldWidget extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const FormFieldWidget({super.key, required this.icon, required this.child});

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
