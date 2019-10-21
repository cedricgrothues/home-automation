import 'dart:io';

void update(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write('{"data": "Hello World"}')
    ..close();
}
