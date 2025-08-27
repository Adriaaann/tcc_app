import 'package:flutter/material.dart';

import 'package:tcc_app/themes/theme.dart';
import 'package:tcc_app/utils/typography.dart';

import 'package:tcc_app/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = createTextTheme('Roboto', 'Roboto Slab');
    final materialTheme = MaterialTheme(baseTextTheme);

    return MaterialApp(
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      home: const WelcomePage(),
    );
  }
}
