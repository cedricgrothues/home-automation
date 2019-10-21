library service.controller.plug;

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:service.controller.plug/routes.dart';

Future<void> main() async {
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4001);

  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        if (request.uri == '/device/:id') update(request);
        break;
      default:
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..headers.contentType = ContentType.json
          ..write('{"message": "Unsupported request method: ${request.method}"}')
          ..close();
    }
  }
}
