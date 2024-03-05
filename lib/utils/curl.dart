import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:get/get.dart';

/*
  Source: https://github.com/talisk/curl
  Print 
*/

enum Platform { win, posix }
final _r1 = RegExp(r'"');
final _r2 = RegExp(r'%');
final _r3 = RegExp(r'\\');
final _r4 = RegExp(r'[\r\n]+');
final _r5 = RegExp(r"[^\x20-\x7E]|'");
final _r7 = RegExp(r"'");
final _r8 = RegExp(r'\n');
final _r9 = RegExp(r'\r');
final _r10 = RegExp(r'[[{}\]]');
const _urlencoded = 'application/x-www-form-urlencoded';

String _escapeStringWindows(String str) =>
    '"${str
        .replaceAll(_r1, '""')
        .replaceAll(_r2, '"%"')
        .replaceAll(_r3, '\\\\')
        .replaceAllMapped(_r4, (match) => '"^${match.group(0)}"')}"';

String _escapeStringPosix(String str) {
  if (_r5.hasMatch(str)) {
    // Use ANSI-C quoting syntax.
    return '\$"${str
            .replaceAll(_r3, '\\\\')
            .replaceAll(_r7, "\\\"")
            .replaceAll(_r8, '\\n')
            .replaceAll(_r9, '\\r')
            .replaceAllMapped(_r5, (Match match) {
          var x = match.group(0)!;
          assert(x.length == 1);
          final code = x.codeUnitAt(0);
          if (code < 256) {
            // Add leading zero when needed to not care about the next character.
            return code < 16
                ? '\\x0${code.toRadixString(16)}'
                : '\\x${code.toRadixString(16)}';
          }
          final c = code.toRadixString(16);
          return '\\u${('0000$c').substring(c.length, c.length + 4)}';
        })}\$"';
  } else {
    // Use single quote syntax.
    return "\"$str\"";
  }
}

void logCurl(Response? response, Map<String, dynamic> body,
    {Platform platform = Platform.posix}) {
  // use `log` instead of `print` for a long highlight text
  log(toCurl(response, body));
}

String toCurl(Response? response, Map<String, dynamic> params,
    {Platform platform = Platform.posix}) {
  if (response == null) return "";

  dynamic body;

  var requestMethod = response.request?.method.toUpperCase() ?? 'GET';

  if (requestMethod == 'GET') {
    body = Uri(queryParameters: params).query;
  } else {
    body = params;
  }

  var command = ['curl -X'];
  var ignoredHeaders = ['host', 'method', 'path', 'scheme', 'version'];
  final escapeString =
      platform == Platform.win ? _escapeStringWindows : _escapeStringPosix;
  var data = <String>[];
  final requestHeaders = response.request?.headers;
  final requestBody = body;
  final contentType = requestHeaders?['content-type'];

  command.add(requestMethod);

  if (requestMethod == 'GET') {
    String url = escapeString("${response.request?.url}");
    command.add(url.replaceAllMapped(_r10, (match) => '\\${match.group(0)}'));
  } else {
    command.add(escapeString(
            '${response.request?.url.origin}${response.request?.url.path}')
        .replaceAllMapped(_r10, (match) => '\\${match.group(0)}'));
  }

  if (requestMethod != 'GET') {
    if (contentType != null && contentType.indexOf(_urlencoded) == 0) {
      ignoredHeaders.add('content-length');
      data.add('--data');
      data.add(escapeString(Uri.splitQueryString(response.body)
          .keys
          .map((key) =>
              '${Uri.encodeComponent(key)}=${Uri.encodeComponent(Uri.splitQueryString(
                response.body,
              )[key]!)}')
          .join('&')));
    } else if (requestBody != null && requestBody.isNotEmpty) {
      ignoredHeaders.add('content-length');
      // data.add('--data-binary');
      data.add('-d');
      data.add('"${jsonEncode(body).replaceAll("\"", "\\\"")}"');
    }
  }

  Map<String, String?>.fromIterable(
      (requestHeaders?.keys ?? []).where((k) => !ignoredHeaders.contains(k)),
      value: (k) => requestHeaders![k]).forEach((k, v) {
    command
      ..add('-H')
      ..add(escapeString('$k: $v'));
  });
  
  return (command
        ..addAll(data)
        ..add('--compressed')
        ..add('--insecure'))
      .join(' ');
}
