import 'dart:convert';

RequestEmailResponse apiResponseFromJson(String str) =>
    RequestEmailResponse.fromJson(json.decode(str));

String loginnResponseToJson(RequestEmailResponse data) =>
    json.encode(data.toJson());

class RequestEmailResponse {
  RequestEmailResponse({required this.email, required this.status});

  final String email;
  final int status;

  factory RequestEmailResponse.fromJson(Map<String, dynamic> json) =>
      RequestEmailResponse(
          email: json["email_address"], status: json["status"]);

  Map<String, dynamic> toJson() => {
        "email_address": email,
        "status": status,
      };
}
