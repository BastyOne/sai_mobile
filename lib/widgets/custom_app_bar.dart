import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onSelectLogout;

  const CustomAppBar({
    super.key,
    required this.titleWidget,
    this.actions,
    this.onSelectLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(0, 85, 169, 1),
      elevation: 0,
      title: titleWidget,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(), // Opens the drawer
      ),
      actions: actions,
    );
  }
}
