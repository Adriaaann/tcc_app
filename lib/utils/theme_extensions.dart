import 'package:flutter/material.dart';
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
        return MaterialTheme.success.light;
      case Brightness.dark:
        return MaterialTheme.success.dark;
    }
  }

  ColorFamily get warning {
    switch (brightness) {
      case Brightness.light:
        return MaterialTheme.warning.light;
      case Brightness.dark:
        return MaterialTheme.warning.dark;
    }
  }
}
