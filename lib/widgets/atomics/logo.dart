import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  final Color? color;
  final double? size;
  const Logo({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onPrimary;

    return SvgPicture.asset(
      'assets/logos/spoonspark_logo.svg',
      height: size,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      colorFilter: ColorFilter.mode(color ?? defaultColor, BlendMode.srcIn),
    );
  }
}
