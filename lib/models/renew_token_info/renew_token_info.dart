import 'package:json_annotation/json_annotation.dart';
part 'renew_token_info.g.dart';

@JsonSerializable()
class RenewTokenInfo {
  @JsonKey(name: "access_token")
  String? accessToken;

  @JsonKey(name: "access_token_expires_at")
  int? accessTokenExpiresAt;

  @JsonKey(name: "refresh_token")
  String? refreshToken;

  RenewTokenInfo(
      {this.accessToken = "",
      this.refreshToken = "",
      this.accessTokenExpiresAt});

  factory RenewTokenInfo.fromJson(Map<String, dynamic> data) =>
      _$RenewTokenInfoFromJson(data);

  Map<String, dynamic> toJson() => _$RenewTokenInfoToJson(this);
}
