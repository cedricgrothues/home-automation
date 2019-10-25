import 'dart:io';

import 'handler.dart';

/// A function which creates a new [Handler] by wrapping a [Handler].
///
/// You can extend the functions of a [Handler] by wrapping it in
/// [Middleware] that can intercept and process a request before it it sent
/// to a handler, a response after it is sent by a handler, or both.
///
/// Because [Middleware] consumes a [Handler] and returns a new
/// [Handler], multiple [Middleware] instances can be composed
/// together to offer rich functionality.
///
/// Common uses for middleware include caching, logging, and authentication.
typedef Middleware = HttpRequest Function(HttpRequest request);

typedef RequestInterceptor = void Function(HttpRequest request);
