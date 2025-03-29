import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/theme/theme.dart';

class LogoAppbar extends StatelessWidget implements PreferredSizeWidget {
  final IconButton? action;
  final bool showBackButton;
  const LogoAppbar({super.key, this.action, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          !showBackButton
              ? null
              : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      actions: [action ?? const SizedBox.shrink()],
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'spoon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 2),
          // SVG Logo
          SvgPicture.asset('assets/logos/spoonspark_logo.svg', height: 25),
          const SizedBox(width: 2),
          const Text(
            'spark',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: lightBackground,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
