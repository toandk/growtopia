import 'dart:convert';

CodeResponse apiResponseFromJson(String str) =>
    CodeResponse.fromJson(json.decode(str));

String codeResponseToJson(CodeResponse data) => json.encode(data.toJson());

class CodeResponse {
  CodeResponse({required this.code});

  final String code;

  factory CodeResponse.fromJson(Map<String, dynamic> json) =>
      CodeResponse(code: json["code"]);

  Map<String, dynamic> toJson() => {"code": code};
}
