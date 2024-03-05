import 'dart:async';

import 'package:dio/dio.dart';
import 'package:growtopia/base/networking/base/interceptors/authentication_interceptor.dart';
import 'package:growtopia/base/networking/base/interceptors/logger_interceptor.dart';

/// initialize a service with base url
class ApiService {
  static Dio? _dio;
  String baseUrl;
  late Options requestOptions;

  ApiService(
    this.baseUrl, {
    Duration timeout = const Duration(seconds: 60),
  }) {
    requestOptions = _initRequestOptions(timeout: timeout);
    _setupDio();
  }

  Options _initRequestOptions({
    Duration timeout = const Duration(seconds: 60),
  }) {
    return Options(
      receiveDataWhenStatusError: true,
      receiveTimeout: timeout,
    );
  }

  void _setupDio() {
    if (_dio != null) return;

    // create dio instance with options above
    _dio = Dio();

    // inject interceptors, if there is no passed so the default is [AuthenticationInterceptor]
    _dio?.interceptors.addAll([AuthenticationInterceptor()]);
    // inject network logger
    _dio?.interceptors.add(LoggerInterceptor());
    // Inject token 401 interceptor
    // _dio?.interceptors.add(TokenInterceptor(_dio!));
  }

  Future<Response<T>> getData<T>({
    required String endPoint,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.get<T>(baseUrl + endPoint,
          queryParameters: query,
          cancelToken: cancelToken,
          options: requestOptions);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> postData<T>({
    required String endPoint,
    dynamic body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<T> response = await _dio!.post<T>(
        baseUrl + endPoint,
        queryParameters: query,
        data: body,
        cancelToken: cancelToken,
        options: requestOptions,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> putData<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.put<T>(baseUrl + endPoint,
          queryParameters: query,
          data: body,
          cancelToken: cancelToken,
          options: requestOptions);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> patchData<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.patch<T>(baseUrl + endPoint,
          queryParameters: query,
          data: body,
          cancelToken: cancelToken,
          options: requestOptions);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.delete<T>(
        baseUrl + endPoint,
        queryParameters: query,
        data: body,
        cancelToken: cancelToken,
        options: _initRequestOptions()
          ..contentType =
              "application/x-www-form-urlencoded", // calendar service không cho phép truyền content-type = "application/json" khi body null
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
