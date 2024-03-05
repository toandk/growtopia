import 'package:growtopia/utils/local_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum RequestType { table, sql }

class SupabaseAPI {
  static final supabase = Supabase.instance.client;

  SupabaseAPI._();

  static Future<dynamic> get(
      {required String table,
      required Map<String, dynamic> body,
      int? from,
      int? to,
      shouldCache = false}) async {
    dynamic response;
    var request = supabase.from(table).select();
    for (String key in body.keys) {
      request = request.eq(key, body[key]);
    }
    if (from != null && to != null) {
      response = await request.range(from, to);
    } else {
      response = await request;
    }
    if (shouldCache) {
      _saveResponseToCache(_getCacheKey(table, body, from, to), response);
    }
    return response;
  }

  static Future<dynamic> update(
      {required String table,
      required Map<String, dynamic> values,
      required Map<String, dynamic> params,
      shouldCache = false}) async {
    var request = supabase.from(table).update(values);
    for (String key in params.keys) {
      request = request.eq(key, params[key]);
    }
    return await request;
  }

  static Future<dynamic> querySql(
      {required String functionName,
      Map<String, dynamic>? params,
      shouldCache = false}) async {
    final response = await supabase.rpc(functionName, params: params);

    if (shouldCache) {
      _saveResponseToCache(
          _getCacheKey(functionName, params ?? {}, 0, 0), response);
    }

    return response;
  }

  static Future<dynamic> invokeFunction(
      {required String functionName,
      required Map<String, dynamic> body,
      shouldCache = false}) async {
    final response = await supabase.functions.invoke(functionName, body: body);
    if (shouldCache) {
      _saveResponseToCache(
          _getCacheKey('functions', body, 0, 0), response.data);
    }
    return response.data;
  }

  static Future<dynamic> getFromCache(
      {required String table,
      required Map<String, dynamic> body,
      int? from,
      int? to}) async {
    String cacheKey = _getCacheKey(table, body, from, to);
    return LocalService.get(cacheKey, true);
  }

  static void _saveResponseToCache(String key, dynamic value) {
    LocalService.save(key, value, true);
  }

  static String _getCacheKey(
      String table, Map<String, dynamic> body, int? from, int? to) {
    return '$table.${body.toString()}.${from ?? 0}.${to ?? 0}.get';
  }
}
