import 'package:flutter/material.dart';

import 'package:tcc_app/themes/theme.dart';
import 'package:tcc_app/utils/typography.dart';

import 'package:tcc_app/views/welcome_page.dart';
import 'package:tcc_app/views/pages/widget_tree.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/home': (context) => const WidgetTree(),
      },
    );
  }
}
