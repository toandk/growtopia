import 'package:dio/dio.dart';
import 'package:growtopia/utils/utils.dart';

class ResponseError {
  int? code;
  String? message;
  Map<String, dynamic>? data;
  int? httpStatusCode;

  ResponseError({this.code, this.message, this.data, this.httpStatusCode});

  ResponseError.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data =
        json["data"] is Map<String, dynamic> ? json["data"] : json;
    code ??= ParserHelper.parseInt(data['code']);
    message ??= data['message'];
    // code ??= json['err_code'];
    message ??= data['otp'];
  }

  factory ResponseError.fromDioResponse(Response response) {
    ResponseError responseError = ResponseError();
    if (response.data is Map<String, dynamic>) {
      responseError = ResponseError.fromJson(response.data);
    } else if (response.data is String) {
      responseError.message = response.data;
    }
    responseError.httpStatusCode = response.statusCode;
    return responseError;
  }
}
