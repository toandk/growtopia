import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

void logDebug(Object message) {
  if (kDebugMode) {
    if (message is Map) {
      log(json.encode(message));
    } else {
      log(message.toString());
    }
  }
}
