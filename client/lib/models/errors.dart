/// The ResponseException is thrown any time there is a problem with the reponse of a http request.
/// Example use cases: An invalid status code (`response.statusCode >= 300`) or an unexpected server response.
class ResponseException implements Exception {}

/// PortExceptions should only be thrown in [NetworkAnalyzer] if an invalid port
/// (`port < 1 || port > 65535`) was passed to the discover function.
class PortException implements Exception {}

/// NotFoundException should only be thrown in [NetworkAnalyzer] if the
/// device was not found with in the subnet.
class NotFoundException implements Exception {}
