import 'package:flutter/material.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required super.builder});

  @override
  Duration get transitionDuration => Duration.zero; // No transition
  @override
  Duration get reverseTransitionDuration => Duration.zero; // No pop transition
  @override
  bool get hasScopedWillPopCallback => false;
  @override
  bool get maintainState => true;
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // Removes any transition animations if needed
  }
}
