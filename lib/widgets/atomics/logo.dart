import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  final Color? color;
  const Logo({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onPrimary;

    return SvgPicture.asset(
      'assets/logos/spoonspark_logo.svg',
      fit: BoxFit.contain,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(color ?? defaultColor, BlendMode.srcIn),
    );
  }
}
