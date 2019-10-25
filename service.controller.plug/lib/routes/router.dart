import 'dart:io';
import 'dart:convert';

class Router {
  final dynamic address;
  final int port;

  Router({this.address, this.port}) : assert(address != null && port != null);

  List<Route> _routes = [];

  void listen() async => (await HttpServer.bind(address, port)).listen(_handle);

  void get(String route, {void Function(HttpRequest request) handler}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'GET', handler: handler));
  }

  void post(String route, {void Function(HttpRequest request) handler}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'POST', handler: handler));
  }

  void patch(String route, {void Function(HttpRequest request) handler}) {
    assert(handler != null && route != null);
    _routes.add(Route(route, method: 'PATCH', handler: handler));
  }

  void _notFound(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..headers.contentType = ContentType.json
      ..write(json.encode({"message": "Path \'${request.uri.path}\' not found."}))
      ..close();
  }

  void _unsupported(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..headers.contentType = ContentType.json
      ..write(json.encode({"message": "Method \'${request.method}\' not allowed."}))
      ..close();
  }

  void _handle(HttpRequest request) async {
    List<Route> _matched = _routes.where((Route route) => RegExp(route.route).hasMatch(request.uri.path)).toList();
    if (_matched.isEmpty)
      _notFound(request);
    else {
      _matched
          .firstWhere((route) => route.method == request.method,
              orElse: () => Route(request.uri.path, method: request.method, handler: _unsupported))
          .handler(request);
    }
  }
}

class Route {
  final String route, method;
  final void Function(HttpRequest) handler;

  Route(
    this.route, {
    this.method,
    this.handler,
  }) : assert(handler != null && method != null && route != null);
}
