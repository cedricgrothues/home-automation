import 'dart:io';
import 'dart:convert';

class RouterException {
  static void not_found(HttpRequest request, {String message}) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..headers.contentType = ContentType.json
      ..write(json.encode({"message": message ?? "Path \'${request.uri.path}\' not found."}))
      ..close();
  }

  static void unsupported(HttpRequest request, {String message}) {
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..headers.contentType = ContentType.json
      ..write(json.encode({"message": message ?? "Method \'${request.method}\' not allowed."}))
      ..close();
  }
}
