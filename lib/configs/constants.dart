import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Environment { staging, production }

Environment env = Environment.staging;

class Constants {
  /// APP CONFIG
  static const String appName = "Growtopia";

  static const String appSchema = "com.growtopia.game://";

  static const String appUrl = "https://growtopia.com/install";
  static const String authRedirectUri = "com.growtopia.game://login-callback/";

  static const supportEmail = "growtopiacontact@gmail.com";

  static final double? screenWidth = GetPlatform.isWeb ? 500 : null;

  static String revenueCatAPIKey = GetPlatform.isAndroid
      ? 'goog_FJjgZVJzizwVeKDNklNwncgeDPa'
      : 'appl_wVXxqQTdaVTTAZpMTcnKeAcUVJg';

  // TODO: replace this test ad unit with your own ad unit.
  static final adUnitId = GetPlatform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  static const String premiumEntitlement = 'premium';

  static final Image lessonPlaceholder =
      Image.asset('assets/images/lesson3.jpg', fit: BoxFit.cover);
  static final Image lessonPlaceholder2 =
      Image.asset('assets/images/lesson4.jpg', fit: BoxFit.cover);
  static final Image collectionPlaceholder =
      Image.asset('assets/images/learn1.jpg', fit: BoxFit.cover);
  static final Image categoryPlaceholder =
      Image.asset('assets/images/learn1.jpg', fit: BoxFit.cover);
  static final Image spellingGamePlaceholder =
      Image.asset('assets/images/spelling_game.jpg', fit: BoxFit.cover);
  static final Image listeningGamePlaceholder =
      Image.asset('assets/images/listening_game.jpg', fit: BoxFit.cover);
  static final Image tetrisGamePlaceholder =
      Image.asset('assets/images/tetris_game.jpg', fit: BoxFit.cover);
  static final Image defaultAvatar =
      Image.asset('assets/images/spelling_game.jpg', fit: BoxFit.cover);

  static Image getLessonPlaceholder(String id) {
    if (id.substring(0, 1).toLowerCase().compareTo('i') == -1) {
      return lessonPlaceholder;
    }
    return lessonPlaceholder2;
  }

  static const double kLoadMoreOffset = 100;

  static const int maxTipShowForEachExercise = 4;

  static const int maxFreeCreatableGames = 3;
  static const int maxFreeCreatableLessons = 2;

  static const String agreementUrl = 'https://growtopia-landing.web.app/terms';
  static const String policyUrl = 'https://growtopia-landing.web.app/privacy';

  /// CUSTOM CONFIG APP
  static const String languageKey = 'LANGUAGE';

  static String apiDomain = '';

  static int maxOTPTime = 60;

  static int minPasswordLength = 6;

  static int maxLevel = 30;
}
