import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:tcc_app/themes/theme.dart';
import 'package:tcc_app/utils/typography.dart';

import 'package:tcc_app/views/pages/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting('pt_BR', null);
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
      routes: {'/': (context) => const WidgetTree()},
    );
  }
}
