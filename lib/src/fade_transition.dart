import 'package:flutter/widgets.dart';

/// A class that provides [FadeTransition]s.
class ArnaFadeTransition {
  /// This class is not meant to be instantiated or extended; this constructor
  /// prevents instantiation and extension.
  ArnaFadeTransition._();

  /// Fade in animation.
  static FadeTransition fadeIn(
    final Widget child,
    final Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.ease,
      ),
      child: child,
    );
  }

  /// Fade out animation.
  static FadeTransition fadeOut(
    final Widget child,
    final Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Curves.ease,
      ),
      child: child,
    );
  }

  /// Keep widget on screen while it is leaving
  static FadeTransition stayOnScreen(
    final Widget child,
    final Animation<double> animation,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
      child: child,
    );
  }
}
