import 'dart:io';

import 'package:router/router.dart';

import 'handler.dart';

class Route {
  final String path, method;
  final Middleware middleware;
  final void Function(HttpRequest) handler;

  Route(
    this.path, {
    this.method,
    this.middleware,
    this.handler,
  }) : assert(handler != null && method != null && path != null);
}

/// Exposes a [Controller] or a [Controller] method to the Internet.
/// Example:
///
/// ```dart
/// @Routable('/elements')
/// class ElementController extends Controller {
///
///   @Routable('/')
///   List<Element> getList() => someComputationHere();
///
///   @Routable('/int:elementId')
///   getElement(int elementId) => someOtherComputation();
///
/// }
/// ```
class Routable {
  final String path;
  final String method;
  final Handler handler;

  static const Routable get = Routable(null, method: 'GET'),
      post = Routable(null, method: 'POST'),
      patch = Routable(null, method: 'PATCH'),
      put = Routable(null, method: 'PUT'),
      delete = Routable(null, method: 'DELETE'),
      head = Routable(null, method: 'HEAD');

  const Routable(this.path, {this.method = "GET", this.handler});

  const Routable.method(this.method, {this.handler}) : path = null;
}
