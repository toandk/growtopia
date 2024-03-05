import 'package:dio/dio.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/utils/utils.dart';

class AuthenticationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String token = TokenManager.accessToken();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'x-language': Utils.currentLanguageCode()
    };
    options.headers.addAll(headers);

    handler.next(options);
  }
}
