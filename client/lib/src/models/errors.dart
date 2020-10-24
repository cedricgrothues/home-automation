/// A [ResponseException] is thrown any time there is a problem
// with the response of an HTTP request.
class ResponseException implements Exception {}

/// PortExceptions should only be thrown by a [NetworkAnalyzer] instance
/// if an invalid port (`port < 1 || port > 65535`) was passed to the
/// discover function.
class PortException implements Exception {}

/// NotFoundException should only be thrown by a [NetworkAnalyzer] instance
/// if the device was not found with in the user's subnet.
class NotFoundException implements Exception {}
