import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/models/renew_token_info/renew_token_info.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:growtopia/utils/log.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../user/user_model.dart';

final _box = GetStorage();

class TokenManager {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _tokenExpireTimeKey = 'kTokenExpireTime';
  static const String _userInfoKey = 'kUserInfoKey2';
  static const String _walletPrivateKey = '_walletPrivateKey';
  static const String _walletPublicKey = '_walletPublicKey';
  static final supabase = Supabase.instance.client;

  static String walletPrivateKey() {
    return _box.read(_walletPrivateKey) ?? '';
  }

  static String walletPublicKey() {
    return _box.read(_walletPublicKey) ?? '';
  }

  static Future saveWalletPrivateKey(String key) async {
    return await _box.write(_walletPrivateKey, key);
  }

  static Future saveWalletPublicKey(String key) async {
    return await _box.write(_walletPublicKey, key);
  }

  static String accessToken() {
    return _box.read(_accessTokenKey) ?? '';
  }

  static String refreshToken() {
    return _box.read(_refreshTokenKey) ?? '';
  }

  static int? tokenExpireTimeStamp() {
    return _box.read<int>(_tokenExpireTimeKey);
  }

  static Future saveAccessToken(String token) async {
    return await _box.write(_accessTokenKey, token);
  }

  static Future saveRenewTokenInfo(RenewTokenInfo info) async {
    await _box.write(_accessTokenKey, info.accessToken);
    await _box.write(_refreshTokenKey, info.refreshToken);
    await _box.write(_tokenExpireTimeKey, info.accessTokenExpiresAt);
  }

  static Future saveTokenInfo(RenewTokenInfo info) async {
    await _box.write(_accessTokenKey, info.accessToken);
    await _box.write(_refreshTokenKey, info.refreshToken);
    await _box.write(_tokenExpireTimeKey, info.accessTokenExpiresAt);
  }

  static Rx<UserModel> userInfo = UserModel().obs;

  static Future saveUser(UserModel? user) async {
    userInfo.value = user ?? UserModel();
    if (user == null) {
      await _box.remove(_userInfoKey);
    } else {
      await _box.write(_userInfoKey, user.toJson());
    }
  }

  static bool isLoggedIn() {
    final session = supabase.auth.currentSession;
    return session != null;
  }

  static Future autoGuestLogin() async {
    try {
      await supabase.auth.signUp(
        email: '${await Utils.getDeviceId()}@growtopia.com',
        password: '123456',
        emailRedirectTo: '${Constants.appSchema}${RouterName.accountLogin}',
      );
    } catch (error) {
      await supabase.auth.signInWithPassword(
        email: '${await Utils.getDeviceId()}@growtopia.com',
        password: '123456',
      );
    }
  }

  static UserModel? getCachedUserInfo() {
    final json = _box.read(_userInfoKey);
    userInfo.value = json != null ? UserModel.fromJson(json) : UserModel();
    return userInfo.value;
  }

  static Future getNewUserInfo() async {
    try {
      final userId = supabase.auth.currentUser?.id ?? '';
      final response =
          await SupabaseAPI.get(table: 'profiles', body: {'id': userId});
      if (response != null) {
        await saveUser(UserModel.fromJson(response.first));
      }
      logDebug(response);
    } catch (error) {
      logDebug("get user error $error");
      // handleError(error);
    }
  }

  static void clearUserInfo() {
    // ContractManager.instance.removeWallet();
    saveAccessToken('');
    saveUser(null);
  }
}
