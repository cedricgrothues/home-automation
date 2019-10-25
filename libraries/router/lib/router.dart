/// Web server middleware for handeling HTTP requests using Dart's HttpServer
///
/// Get started with a simple Hello World app:
/// ```dart
/// import 'dart:io';
/// import 'package:router/router.dart';
///
/// main(List<String> args) {
///   Router()
///    ..get('/', handler: (request) async {
///       request.response.writeln("Hello, World!");
///       await request.close()
///     })
///    ..listen(port: 8080);
/// }
/// ```
library router;

export 'src/router.dart';

export 'src/exceptions.dart';
export 'src/middleware.dart';
export 'src/handler.dart';
export 'src/logger.dart';
export 'src/route.dart';
