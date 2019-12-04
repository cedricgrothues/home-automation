class StatusCodeError extends Error {
  final int code;

  StatusCodeError({this.code});
}

class ResponseError extends Error {}

class PortError extends Error {}

class NotFoundError extends Error {}
