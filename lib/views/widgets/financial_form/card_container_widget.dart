import 'package:flutter/material.dart';

class CardContainerWidget extends StatelessWidget {
  final List<Widget> children;

  const CardContainerWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          //! remover ao adicionar mais info
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(spacing: 16, children: children),
      ),
    ),
  );
}
