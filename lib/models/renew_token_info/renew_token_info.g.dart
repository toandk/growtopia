// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renew_token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenewTokenInfo _$RenewTokenInfoFromJson(Map<String, dynamic> json) =>
    RenewTokenInfo(
      accessToken: json['access_token'] as String? ?? "",
      refreshToken: json['refresh_token'] as String? ?? "",
      accessTokenExpiresAt: json['access_token_expires_at'] as int?,
    );

Map<String, dynamic> _$RenewTokenInfoToJson(RenewTokenInfo instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'access_token_expires_at': instance.accessTokenExpiresAt,
      'refresh_token': instance.refreshToken,
    };
