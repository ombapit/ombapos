import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData leadingIcon;
  final VoidCallback? onLeadingPressed;
  final IconData actionIcon;
  final VoidCallback? onActionPressed;

  const CustAppBar({
    super.key,
    required this.title,
    this.leadingIcon = Icons.arrow_back,
    this.onLeadingPressed,
    this.actionIcon = Icons.add,
    this.onActionPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(
            icon: Icon(leadingIcon),
            onPressed: onLeadingPressed ?? () => context.pop(true),
          ),
          Text(title),
        ],
      ),
      actions: [IconButton(icon: Icon(actionIcon), onPressed: onActionPressed)],
    );
  }
}
