import 'package:flutter/material.dart';
import 'package:tcc_app/models/color_family_model.dart';
import 'package:tcc_app/themes/theme.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
}

extension ExtendedColorScheme on ColorScheme {
  ColorFamily get success {
    switch (brightness) {
      case Brightness.light:
        return MaterialTheme.lightScheme().success;
      case Brightness.dark:
        return MaterialTheme.darkScheme().success;
    }
  }

  ColorFamily get warning {
    switch (brightness) {
      case Brightness.light:
        return MaterialTheme.lightScheme().warning;
      case Brightness.dark:
        return MaterialTheme.darkScheme().warning;
    }
  }
}
