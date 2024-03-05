// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:growtopia/configs/constants.dart';
// import 'package:growtopia/models/base/api_response.dart';
// import 'package:growtopia/models/token/token_manager.dart';
// import 'package:growtopia/routes/routes.dart';
// import 'package:growtopia/utils/log.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:growtopia/utils/utils.dart';

// final box = GetStorage();

// class TokenInterceptor extends Interceptor {
//   final Dio _dio;
//   static String? tokenHeader;
//   static int renewCount = 0;
//   final _tokenDio = Dio(BaseOptions(
//       baseUrl: Constants.apiDomain, contentType: Headers.jsonContentType));

//   TokenInterceptor(this._dio);

//   @override
//   void onError(
//     DioError err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     // Assume 401 stands for token expired
//     if (err.response?.statusCode == 401) {
//       _logout();
//       // final options = err.response!.requestOptions;
//       // // If the token has been updated, repeat directly.
//       // if (tokenHeader != options.headers['Authorization'] &&
//       //     tokenHeader != null) {
//       //   logDebug(
//       //       "token \n $tokenHeader \n ${options.headers['Authorization']}");
//       //   options.headers['Authorization'] = tokenHeader;
//       //   options.headers['x-language'] = Utils.currentLanguageCode();
//       //   //repeat
//       //   _dio
//       //       .fetch(options)
//       //       .then(handler.resolve)
//       //       .catchError((e) => handler.reject(e));
//       //   return;
//       // }
//       // // update token and repeat
//       // // Lock to block the incoming request until the token updated
//       // _dio.lock();
//       // _dio.interceptors.responseLock.lock();
//       // _dio.interceptors.errorLock.lock();

//       // renewToken(options, handler);
//     } else {
//       handler.next(err);
//     }
//   }

//   void _logout() {
//     TokenManager.clearUserInfo();
//     Get.offAllNamed(RouterName.login);
//   }

//   void renewToken(RequestOptions options, ErrorInterceptorHandler handler) {
//     renewCount++;
//     if (renewCount >= 5) return; // To avoid calling too many renew token
//     final body = {"refresh_token": ""};
//     _tokenDio
//         .post("${Constants.apiDomain}${Constants.renewTokenPath}", data: body)
//         .then((d) {
//       // ApiResponse<RenewTokenInfo> result = ApiResponse.fromJson(d.data);
//       // options.headers['Authorization'] =
//       //     tokenHeader = "Bearer ${result.data.accessToken}";
//       // TokenManager.saveRenewTokenInfo(result.data);
//       // logDebug("renew token done $renewCount");
//     }).whenComplete(() {
//       _dio.unlock();
//       _dio.interceptors.responseLock.unlock();
//       _dio.interceptors.errorLock.unlock();
//     }).then((e) {
//       //repeat
//       _dio
//           .fetch(options)
//           .then(handler.resolve)
//           .catchError((e) => handler.reject(e));
//     }).catchError((e) {
//       logDebug("renew error $e");
//       handler.reject(e);
//     });
//   }
// }
