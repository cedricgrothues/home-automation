import 'dart:io';

import 'package:router/src/exceptions.dart';
import 'package:router/src/middleware.dart';
import 'package:router/src/handler.dart';
import 'package:router/src/route.dart';

class Router {
  List<RequestInterceptor> _middlewares = List();
  List<Route> _routes = List();
  Route _fallback;

  void listen({dynamic address = 'localhost', int port}) async => (await HttpServer.bind(address, port)).listen(_handle);

  // HTTP method implementations:
  // support for GET, POST, PUT, PATCH and DELETE requests

  void get(String route, {Handler handler, Middleware middleware}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'GET', handler: handler, middleware: middleware ?? (request) => request));
  }

  void post(String route, {Handler handler, Middleware middleware}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'POST', handler: handler, middleware: middleware ?? (request) => request));
  }

  void put(String route, {Handler handler, Middleware middleware}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'PUT', handler: handler, middleware: middleware ?? (request) => request));
  }

  void patch(String route, {Handler handler, Middleware middleware}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'PATCH', handler: handler, middleware: middleware ?? (request) => request));
  }

  void delete(String route, {Handler handler, Middleware middleware}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'DELETE', handler: handler, middleware: middleware ?? (request) => request));
  }

  void use(RequestInterceptor middleware) => _middlewares.add(middleware);

  void fallback(Handler handler) => _fallback = Route('*', method: 'ALL', handler: handler);

  void _handle(HttpRequest request) async {
    _middlewares.forEach((RequestInterceptor middleware) => middleware(request));

    List<Route> _matched = _routes.where((Route route) => RegExp(route.path).hasMatch(request.uri.path)).toList();
    if (_matched.isEmpty && _fallback == null) {
      RouterException.not_found(request);
    } else if (_matched.isEmpty && _fallback != null) {
      _fallback.handler(request);
    } else {
      Route route = _matched.firstWhere(
        (route) => route.method == request.method,
        orElse: () => Route(
          request.uri.path,
          method: request.method,
          handler: RouterException.unsupported,
        ),
      );

      route.handler(route.middleware(request));
    }
  }
}
