import 'package:flutter/material.dart';

class PopAlertWidget extends StatelessWidget {
  final Widget widget;

  const PopAlertWidget({super.key, required this.widget});

  Future<bool> _confirmExit(NavigatorState navigator) async {
    final dialogKey = GlobalKey<NavigatorState>();

    final shouldPop = await showDialog<bool>(
      context: navigator.context,
      builder: (_) => AlertDialog(
        key: dialogKey,
        title: const Text('Deseja Sair?'),
        content: const Text('As alterações não salvas serão perdidas.'),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text('Continuar Editando'),
          ),
          TextButton(
            onPressed: () => navigator.pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _confirmExit(navigator);
        if (shouldPop) {
          navigator.pop(result);
        }
      },
      child: widget,
    );
  }
}
