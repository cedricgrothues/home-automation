import 'dart:io';

/// A function which handles a [Request].
///
/// A [Handler] which wraps one or more other handlers to perform pre or post
/// processing is known as a "middleware".
///
/// A [Handler] may receive a request directly from an HTTP server or it
/// may have been touched by other middleware. Similarly the response may be
/// directly returned by an HTTP server or have further processing done by other
/// middleware.
typedef Handler = void Function(HttpRequest request);
