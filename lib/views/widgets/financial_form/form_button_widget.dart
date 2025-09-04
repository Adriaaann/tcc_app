import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class FormButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;

  const FormButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => IconButton.filled(
    style: IconButton.styleFrom(backgroundColor: backgroundColor),
    onPressed: onPressed,
    icon: Icon(icon, color: context.colorScheme.surface),
  );
}
