import 'dart:io';

class Logger {
  static void Function(HttpRequest) minimal = (HttpRequest request) => print('${request.method} ${request.uri.path}');
}
