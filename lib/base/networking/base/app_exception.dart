import 'package:growtopia/base/networking/base/response_error.dart';

class AppException implements Exception {
  final String? _message;
  final String? _prefix;
  final ResponseError? _response;

  String? get message => _message;

  AppException([this._response, this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException({
    ResponseError? response,
    String? message,
  }) : super(response, message, "");
}

class BadRequestException extends AppException {
  BadRequestException({ResponseError? response, String? message})
      : super(response, message, "");
}

class UnauthorisedException extends AppException {
  UnauthorisedException({ResponseError? response, String? message})
      : super(response, message, "");
}

class MethodNotAllowedException extends AppException {
  MethodNotAllowedException({ResponseError? response, String? message})
      : super(response, message, "");
  @override
  String toString() {
    if (_response == null) {
      return "Method Not Allowed";
    } else {
      return super.toString();
    }
  }
}

class InvalidInputException extends AppException {
  InvalidInputException({ResponseError? response, String? message})
      : super(response, message, "");
}
