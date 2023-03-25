import 'package:flutter/widgets.dart';

/// Defines a transition in which outgoing elements fade out, then incoming
/// elements fade in and scale up.
///
/// The fade through pattern provides a transition animation between UI
/// elements that do not have a strong relationship to one another.
///
/// Scale is only applied to incoming elements to emphasize new content over
/// old.
class ArnaFadeThroughTransition extends StatelessWidget {
  /// Creates an [ArnaFadeThroughTransition].
  ///
  /// The [animation] and [secondaryAnimation] argument are required and must
  /// not be null.
  const ArnaFadeThroughTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    this.fillColor,
    this.child,
  });

  /// The animation that drives the [child]'s entrance and exit.
  final Animation<double> animation;

  /// The animation that transitions [child] when new content is pushed on top
  /// of it.
  final Animation<double> secondaryAnimation;

  /// The color to use for the background color during the transition.
  final Color? fillColor;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and
  /// [secondaryAnimation].
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return _ZoomedFadeInFadeOut(
      animation: animation,
      child: DecoratedBox(
        decoration: BoxDecoration(color: fillColor),
        child: _ZoomedFadeInFadeOut(
          animation: ReverseAnimation(secondaryAnimation),
          child: child,
        ),
      ),
    );
  }
}

class _ZoomedFadeInFadeOut extends StatelessWidget {
  const _ZoomedFadeInFadeOut({
    required this.animation,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        final BuildContext context,
        final Animation<double> animation,
        final Widget? child,
      ) {
        return _ZoomedFadeIn(animation: animation, child: child);
      },
      reverseBuilder: (
        final BuildContext context,
        final Animation<double> animation,
        final Widget? child,
      ) {
        return _FadeOut(animation: animation, child: child);
      },
      child: child,
    );
  }
}

class _ZoomedFadeIn extends StatelessWidget {
  const _ZoomedFadeIn({
    required this.animation,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;

  static final CurveTween _inCurve = CurveTween(
    curve: const Cubic(0.0, 0.0, 0.2, 1.0),
  );
  static final TweenSequence<double> _scaleIn = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.91),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.91, end: 1.0).chain(_inCurve),
        weight: 13 / 20,
      ),
    ],
  );
  static final TweenSequence<double> _fadeInOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.0),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(_inCurve),
        weight: 13 / 20,
      ),
    ],
  );

  @override
  Widget build(final BuildContext context) {
    return FadeTransition(
      opacity: _fadeInOpacity.animate(animation),
      child: ScaleTransition(
        scale: _scaleIn.animate(animation),
        child: child,
      ),
    );
  }
}

class _FadeOut extends StatelessWidget {
  const _FadeOut({
    required this.animation,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;

  static final CurveTween _outCurve = CurveTween(
    curve: const Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static final TweenSequence<double> _fadeOutOpacity = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(_outCurve),
        weight: 7 / 20,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(0.0),
        weight: 13 / 20,
      ),
    ],
  );

  @override
  Widget build(final BuildContext context) {
    return FadeTransition(
      opacity: _fadeOutOpacity.animate(animation),
      child: child,
    );
  }
}
