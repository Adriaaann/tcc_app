import 'package:flutter/material.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> tabList;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabList,
  });

  @override
  Widget build(BuildContext context) => TabBar(
    controller: tabController,
    labelColor: context.colorScheme.primary,
    unselectedLabelColor: context.colorScheme.secondary,
    indicatorColor: context.colorScheme.primary,
    indicatorWeight: 2,
    dividerHeight: 1,
    tabs: tabList.map((tabText) => Tab(text: tabText)).toList(),
  );

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
