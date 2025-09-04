import 'package:flutter/material.dart';
import 'package:tcc_app/utils/route_to_method.dart';
import 'package:tcc_app/utils/theme_extensions.dart';
import 'package:tcc_app/views/data/notifiers.dart';
import 'package:tcc_app/views/pages/financial_form_page.dart';

void main() => runApp(const NavbarWidget());

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: selectedPageNotifier,
    builder: (context, selectedPage, child) => Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIcon(
            icon: Icons.home,
            label: 'Início',
            selected: selectedPage == 0,
            onTap: () => selectedPageNotifier.value = 0,
          ),
          _AddButton(),
          _NavIcon(
            icon: Icons.bar_chart,
            label: 'Gráficos',
            selected: selectedPage == 1,
            onTap: () => selectedPageNotifier.value = 1,
          ),
        ],
      ),
    ),
  );
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      routeToMethod(context, const FinancialFormPage(isEdit: false));
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.add_rounded,
        size: 32,
        color: context.colorScheme.onPrimaryContainer,
      ),
    ),
  );
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: selected ? colors.primary : colors.onSurfaceVariant,
          ),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: selected ? colors.primary : colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
