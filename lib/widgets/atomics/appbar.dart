import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/action_row.dart';
import 'package:recipeapp/widgets/atomics/logo.dart';

class LogoAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final bool showBackButton;
  final Widget? leading;

  const LogoAppbar({
    super.key,
    this.actions = const [],
    this.showBackButton = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
              : null),
      actions: [TightActionRow(actions: actions)],
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('swish', style: theme.textTheme.headlineSmall),
          const SizedBox(width: SpoonSparkTheme.spacingXS),
          Logo(size: SpoonSparkTheme.fontXXL, color: theme.colorScheme.primary),
          const SizedBox(width: SpoonSparkTheme.spacingXS),
          Text('dish', style: theme.textTheme.headlineSmall),
          const SizedBox(width: SpoonSparkTheme.spacingS),
        ],
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
