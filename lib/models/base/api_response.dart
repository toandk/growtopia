// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

import 'base_parser_json.dart';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse<T> {
  ApiResponse({
    required this.status,
    required this.data,
  });

  final int? status;
  final T data;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        data: GPParserJson.parseJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toString(),
      };
}
