import 'dart:convert';

LoginResponse apiResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginnResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({required this.accessToken, required this.type});

  final String accessToken;
  // final String message;
  final String type;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      accessToken: json["access_token"],
      // message: json["otp"],
      type: json["token_type"]);

  Map<String, dynamic> toJson() =>
      {"access_token": accessToken, "token_type": type};
}
