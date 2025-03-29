import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<IconButton>? actions;
  final bool showBackButton;
  const LogoAppbar({super.key, this.actions, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading:
          !showBackButton
              ? null
              : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      actions: actions ?? [],
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'spoon',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 2),
          // SVG Logo
          SvgPicture.asset(
            'assets/logos/spoonspark_logo.svg',
            height: 25,
            colorFilter: ColorFilter.mode(theme.primaryColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 2),
          const Text(
            'spark',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 8),
        ],
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
