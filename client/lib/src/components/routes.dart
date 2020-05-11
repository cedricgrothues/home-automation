import 'package:flutter/material.dart';

/// Custom route which has no transitions.
class NoTransitionRoute<T> extends MaterialPageRoute<T> {
  NoTransitionRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

/// Custom route which has no transition when pushed, but has a pop animation.
class NoPushTransitionRoute<T> extends MaterialPageRoute<T> {
  NoPushTransitionRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // is popping
    if (animation.status == AnimationStatus.reverse) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

/// Custom route which has no transition when popped, but has a push animation.
class NoPopTransitionRoute<T> extends MaterialPageRoute<T> {
  NoPopTransitionRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // is pushing
    if (animation.status == AnimationStatus.forward) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
    return child;
  }
}

/// Custom route with a fade transition.
class FadeTransitionRoute<T> extends PageRouteBuilder<T> {
  FadeTransitionRoute({this.child})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  final Widget child;
}

/// Custom route with a slide transition.
class SlideTransitionRoute<T> extends PageRouteBuilder<T> {
  SlideTransitionRoute({this.child})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final curve = Curves.fastLinearToSlowEaseIn;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

  final Widget child;
}
