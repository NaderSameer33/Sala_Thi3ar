import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> buildSmoothTransitionPage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final forwardCurved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final secondaryCurved = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final slideIn = Tween<Offset>(
        begin: const Offset(0.10, 0.0),
        end: Offset.zero,
      ).animate(forwardCurved);

      final scaleIn = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(forwardCurved);

      final fadeIn = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
        ),
      );

      final slideOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.05, 0.0),
      ).animate(secondaryCurved);

      final scaleOut = Tween<double>(
        begin: 1.0,
        end: 0.96,
      ).animate(secondaryCurved);

      final fadeOut = Tween<double>(
        begin: 1.0,
        end: 0.85,
      ).animate(secondaryCurved);

      return SlideTransition(
        position: slideOut,
        child: ScaleTransition(
          scale: scaleOut,
          child: FadeTransition(
            opacity: fadeOut,
            child: SlideTransition(
              position: slideIn,
              child: ScaleTransition(
                scale: scaleIn,
                child: FadeTransition(
                  opacity: fadeIn,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
