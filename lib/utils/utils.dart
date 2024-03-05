import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:growtopia/base/networking/base/app_exception.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/routes/routes.dart';
import 'package:growtopia/utils/analytics.dart';
import 'package:growtopia/utils/local_service.dart';
import 'package:growtopia/utils/popup.dart';
import 'package:growtopia/utils/text_element.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growtopia/widgets/alert_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import 'log.dart';

const String _languageKey = "language_key";
const String _soundKey = "sound_key";

class Utils {
  Utils._();

  static final player = AudioPlayer();

  static void logOut() {
    final supabase = Supabase.instance.client;
    supabase.auth.signOut();
    Get.offAllNamed(RouterName.accountLogin);
  }

  static void vibrateDevice() async {
    final hasVibration = await Vibration.hasVibrator() ?? false;
    if (hasVibration) {
      Vibration.vibrate();
    }
  }

  static String currentLanguage() {
    // String languageCode = LocalService.get(_languageKey, false);
    // switch (languageCode) {
    //   case "en":
    //     return LocaleKeys.account_languageEnglish.tr;
    //   case "vi":
    //     return LocaleKeys.account_languageVietnamese.tr;
    //   case "zh":
    //     return LocaleKeys.account_languageChinese.tr;
    //   default:
    //     return LocaleKeys.account_languageEnglish.tr;
    // }
    return 'English';
  }

  static String currentLanguageCode() {
    String languageCode = LocalService.get(_languageKey, false) ?? "en";
    return languageCode;
  }

  static void saveLanguage(String code) {
    LocalService.save(_languageKey, code, false);
    final locale = Locale(code);
    Get.updateLocale(locale);
  }

  static void setSound(bool on) {
    LocalService.save(_soundKey, on, false);
  }

  static bool getSoundConfig() {
    return LocalService.get(_soundKey, false) ?? true;
  }

  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";
    try {
      if (GetPlatform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "";
      } else if (GetPlatform.isAndroid) {
        const androidIdPlugin = AndroidId();
        deviceId = await androidIdPlugin.getId() ?? '';
      } else if (GetPlatform.isLinux) {
        var info = await deviceInfo.linuxInfo;
        deviceId = info.machineId ?? "";
      }
    } on PlatformException {
      logDebug('Failed to get platform version');
    }
    if (deviceId == "") {
      return "ABC";
    }
    return deviceId;
  }

  static String imageThumb(String pattern, String size) {
    // ignore: unnecessary_null_comparison
    if (pattern == null || pattern.isEmpty) return "";

    String url = pattern.replaceAll("\$size\$", size);
    return url;
  }

  static bool isValidUrl(String? url) {
    url ??= "";
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  static String pluralizeMany(String string, num number) {
    int count = number.round();
    if (count == 0) {
      return "${string}_zero".tr.replaceFirst("%", count.toString());
    } else if (count == 1) {
      return "${string}_one".tr.replaceFirst("%", count.toString());
    }
    return "${string}_many".tr.replaceFirst("%", count.toString());
  }

  static String timeAgoString(int time) {
    num now = DateTime.now().millisecondsSinceEpoch;
    num elapsed = max(0, now - time);

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;
    final num months = days / 30;
    final num years = days / 365;

    if (years >= 1) {
      return pluralizeMany("time_years_ago", years);
    }
    if (months >= 1) {
      return pluralizeMany("time_months_ago", months);
    }
    if (days >= 1) {
      return pluralizeMany("time_days_ago", days);
    }
    if (hours >= 1) {
      return pluralizeMany("time_hours_ago", hours);
    }
    if (minutes >= 1) {
      return pluralizeMany("time_minutes_ago", minutes);
    }
    return LocaleKeys.time_just_now.tr;
  }

  static TextElementType? textElementType(String text) {
    if (TextElementType.hashtag.regex.hasMatch(text)) {
      return TextElementType.hashtag;
    }
    if (TextElementType.url.regex.hasMatch(text)) {
      return TextElementType.url;
    }
    if (TextElementType.phonenumber.regex.hasMatch(text)) {
      return TextElementType.phonenumber;
    }
    if (TextElementType.tag.regex.hasMatch(text)) {
      return TextElementType.tag;
    }
    return null;
  }

  /// to display file size in MB, KB, GB, etc.
  static String readableFileSize({required int bytes}) {
    var kb = bytes / 1024;
    if (kb < 0.1) {
      return '$bytes bytes';
    }
    var mb = kb / 1024;
    if (mb < 0.1) {
      return '${kb.toStringAsFixed(2)} KB';
    }
    return '${mb.toStringAsFixed(2)} MB';
  }

  static double getBottomSheetPadding() {
    // check if the user's device has a navigator button bar or not
    return Get.window.viewPadding.bottom > 0 ? 0 : 0;
  }

  static Future<bool> get isBelowIOS14 async {
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var first = ParserHelper.parseInt(iosInfo.systemVersion.split('.').first);
      if (first is int) {
        return first < 14;
      }
    }
    return false;
  }

  static void back({dynamic result, bool closeOverlays = false}) {
    if (Get.routing.route?.isFirst == true) {
      SystemNavigator.pop(animated: true);
    } else {
      Get.back(result: result, closeOverlays: closeOverlays);
    }
  }

  static String? mapRouteNameToScreenTrackingName(String routeName) {
    final dicts = {
      RouterName.accountLogin: ScreenTrackingName.login,
    };
    final value = dicts[routeName];
    if (value != null) {
      return value.stringValue;
    }
    return null;
  }

  /// return file path base on extension
  /// (external storage for android and document director for ios)
  static Future<String> getDownloadFileName(String fileName) async {
    // if (GetPlatform.isAndroid) {
    //   // mimetype là image thì lưu vào: Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)/GapoWork
    //   // mimetype là video thì lưu vào: Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)/GapoWork
    //   // mimetype là audio thì lưu vào: Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC)/GapoWork
    //   // còn lại thì lưu vào: Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)/GapoWork
    //   // public static String DIRECTORY_PICTURES = "Pictures";
    //   // public static String DIRECTORY_MOVIES = "Movies";
    //   // public static String DIRECTORY_MUSIC = "Music";
    //   // public static String DIRECTORY_DOWNLOADS = "Download";
    //   final documentDirectory = await getExternalStorageDirectory() ??
    //       await getApplicationDocumentsDirectory();
    //   final fileExtension = fileExtensionType(fileName: fileName);
    //   String folder = 'Downloads';
    //   switch (fileExtension) {
    //     case FileExtensionType.photo:
    //       folder = 'Pictures';
    //       break;
    //     case FileExtensionType.video:
    //       folder = 'Movies';
    //       break;
    //     case FileExtensionType.audio:
    //       folder = 'Music';
    //       break;
    //     default:
    //       folder = 'Download';
    //   }
    //   return documentDirectory.path + '/$folder/GapoWork/$fileName';
    // } else {
    final documentDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentDirectory.path}/$fileName'; //Gapo/images/
    return path;
    // }
  }

  static void handleError(Object error) {
    logDebug("got error ${error.toString()}");
    // isLoading.value = false;
    var message = 'Có lỗi xảy ra, vui lòng thử lại!';
    if (error is AppException) {
      message = error.toString();
    }
    Popup.instance.showSnackBar(message: message, type: SnackbarType.error);
  }

  static void dismissKeyboard() {
    // FocusScope.of(Get.context!).requestFocus(FocusNode());
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static bool isSmallDevice() {
    return !isTablet() &&
        max(Get.height / Get.width, Get.width / Get.height) < 670 / 375;
  }

  static String secondsToTimeString(int seconds) {
    if (seconds >= 86400) {
      return '${seconds ~/ 86400}d';
    }
    if (seconds >= 3600) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds - hours * 3600) ~/ 60;
      return minutes > 0
          ? '${seconds ~/ 3600}h ${minutes}m'
          : '${seconds ~/ 3600}h';
    }
    if (seconds > 60) {
      final remainSeconds = (seconds - seconds ~/ 60) % 60;
      return remainSeconds > 0
          ? '${seconds ~/ 60}m ${remainSeconds}s'
          : '${seconds ~/ 60}m';
    }
    return '${seconds}s';
  }

  static String dateTimeString(
      {required int millisecondsSinceEpoch, String format = 'dd/MM/yyyy'}) {
    final datetime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final now = DateTime.now();
    final datetimeDMY = DateTime(datetime.year, datetime.month, datetime.day);
    final nowDMY = DateTime(now.year, now.month, now.day);
    final diff = datetimeDMY.difference(nowDMY).inDays;
    if (diff == 0) {
      return LocaleKeys.time_today.tr;
    } else if (diff == 1) {
      return LocaleKeys.time_tomorrow.tr;
    } else {
      final dateFormat = DateFormat(format);
      return dateFormat.format(datetime);
    }
  }

  static String addSIfNeeded(int measurement) {
    if (Get.locale?.languageCode == 'en') {
      if (measurement > 1) {
        return 's';
      }
    }
    return '';
  }

  static String _toString(int num) {
    if (num < 10) return "0$num";
    return num.toString();
  }

  static String toTimerString(int time) {
    int hour = (time / 3600).truncate();
    int minute = ((time - (hour * 60 * 60)) / 60).truncate();
    int seconds = (time - hour * 60 * 60 - minute * 60);
    String str =
        "${_toString(hour)}:${_toString(minute)}:${_toString(seconds)}";
    return str;
  }

  static void showDialog(
      {String title = "",
      String message = "",
      String? cancelText,
      String? confirmText,
      void Function()? onCancel,
      void Function()? onConfirm}) {
    void _onCancel() {
      Get.back();
      onCancel != null ? onCancel() : () => {};
    }

    void _onConfirm() {
      Get.back();
      onConfirm != null ? onConfirm() : () => {};
    }

    Get.dialog(MJDialog(
        title: title,
        content: message,
        cancelTitle: cancelText,
        confirmTitle: confirmText,
        onCancel: _onCancel,
        onConfirm: _onConfirm));
  }

  static void trackScreen(String name) {
    // FirebaseCrashlytics.instance.log('view screen ' + name);
  }

  static bool isTablet() {
    return min(Get.width, Get.height) >= 600;
  }

  static String genGGWalletJWT(
      String type, String name, String imageUrl, String subHeader,
      {String background = '#4285f4'}) {
    const issuerId = '3388000000022320091';

    final objectSuffix = const Uuid().v4();
    final objectId = '$issuerId.$objectSuffix';
    final classId = '$issuerId.$type';

    final genericObject = {
      'id': objectId,
      'classId': classId,
      'genericType': 'GENERIC_TYPE_UNSPECIFIED',
      'hexBackgroundColor': background,
      'logo': {
        'sourceUri': {
          'uri':
              'https://dmgynbzsijutdfomkvyr.supabase.co/storage/v1/object/public/images/Icon-removebg.png',
        },
      },
      'cardTitle': {
        'defaultValue': {
          'language': 'en-US',
          'value': 'Growtopia',
        },
      },
      'subheader': {
        'defaultValue': {
          'language': 'en-US',
          'value': subHeader,
        },
      },
      'header': {
        'defaultValue': {
          'language': 'en-US',
          'value': name,
        },
      },
      'heroImage': {
        'sourceUri': {
          'uri': imageUrl,
        },
      },
    };

    final claims = {
      'iss': 'admin-789@growtopia-a4a53.iam.gserviceaccount.com',
      'aud': 'google',
      'origins': [],
      'typ': 'savetowallet',
      'payload': {
        // 'genericClasses': [classId],
        'genericObjects': [genericObject],
      },
    };
    final jwt = JWT(claims);
    final token = jwt.sign(
        RSAPrivateKey(
            '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDWoHCINu9qfAkF\nzpo7PoRXpVZmHCZm35xlP8LKZCTKauTYFWnX4cdFK/4nXIYyqPH8chRdUa3LrIho\n1pQnQGIjqkFPVE/AhGsNSHCx/SApeiJatszGf3mIGt1MKLQbTBtUDT1aOyUz8M9/\nHgVgsqDA6dlCaafNr7lKm2jSlMqlkh0be92Hsg6jCtbYyXfy+/R9a7aBUSyivLer\ntXDhx1b0mzDyLD620q+D1B8eww5bxorgDzYxRquiB3RI+f8zQ34qeGrQqWjHSXvR\nAySfdWIxsBuA9poH4gqCJmADTO+0XQWJ4C5dyO25cROEMlCBBH0zKDG8Mj+zby6/\nKX3Mm2srAgMBAAECggEAGLyCZnCjxLYUTs2yYO73pH0IftmdDhuU6ZEhC4qMjaJ8\nSvCiM6DGArxAnUYWAXNkpcp60QvqPUsz/ZadmgMwTG6sUE77Uh5GPaWtDME2b7wF\nMZytRUNz57KQ8Yd6GptO8Fpbnoaqka3zfEci1N5BliUIRpXpd9SvmmBcWHOQV5H6\n1aLyLv8NBfpstkISduNTeiQy66CUv1qOGEoHlHpS2w+6WJuP7+YnjG5hYLxW5n7O\ntOerZ98G+zkU8jSC9Qr49pJOsXFZhYHzLWwUTGVwaeiDmasYJ5CMHMZyN1TOE/Qz\nDN/QNGCKkXvEtDB0YlD39rf8VGVKpaR3Tn5tCd/E4QKBgQDvWxxXwZPSXLb1BFkf\nm9XmdPazyjjML32YNWq7Qi+eAZ7HCbLerm679OsbCM9m+UNSGbzbjzZx71m8LuOt\nX+d9mBIWxOWG8bVN5+H0COM+eal4nSI93XcRHwf9xl0nUc97XpKdxhccQzBPnbq3\nT/rIghKxDB4Krc0zop+t7uPO3QKBgQDljRzfrk5zxy6wr3g6krF5tzeEPCaZTRW5\npL4g6MffRLEgAu+StXEHq6F25c/JFza4T1jOPnkawdClJXiF1OAo1Czwi+wAJnD0\nCzpY7S+ZMGzZft/peW5UQ6AFrKI8C4fVmYOe0iUWfQrqUCBz/zFlQjw3pfJY5MPA\nLJExmfNNpwKBgH29IzqGmp0bz5EPY7JTLx8NurvgM84v9I6NITCWKGWc/EgbNDf+\n8nUSyJ8/FZVGxLLQioHczgE0d7N//mMJypYT2QzVCq7FMzVl5zFHqfkb+IdAJMjT\nGsWHw67xEeah95kbqXHwqhtSwIJSnc/G2DuU+TTA5Nc/TlkdyTyaDlqRAoGBAOHB\nHyVo4qUAvg1r9Hz+aeZ/Zuz4zykzY2tY9tect3z/rIcD/CM3qDrX84rgRrLIzrsC\n5h6n2CiVdiIEsPxFuFLPIIdNxML9C1cnd7GfSpGIy3Q3T/ToxLXAcC9EcaVF3cgX\nGxfmKi1suoBoXxJVZnnkYx6DaM095ron2n+CnYK/AoGBAIXqLF3nKLCtCqHQ6UIF\nKXjhu7Sj0fz8UYrW7RA9dzOvqOJ5xWLAl2+hg8Eyc+rzz8HJdsdiKFHVaBqS52Ya\nX4G7Nv+1cQvK+TAbNlo0/Tz+16hNAE2sQkcdivx5a04T5ucpE5vC5F35YswXkdmj\nBwVDRGvbBsZmG6ha464iEYwl\n-----END PRIVATE KEY-----\n'),
        algorithm: JWTAlgorithm.RS256);
    debugPrint('token: $token');
    return token;
  }
}

class ParserHelper {
  static int? parseInt(dynamic input) {
    if (input != null) {
      if (input is int) {
        return input;
      }
      if (input is double) {
        return input.toInt();
      }
      if (input is String) {
        return int.tryParse(input);
      }
    }
    return null;
  }

  static double? parseDouble(dynamic input) {
    if (input != null) {
      if (input is int) {
        return input.toDouble();
      }
      if (input is double) {
        return input;
      }
      if (input is String) {
        return double.tryParse(input);
      }
    }
    return null;
  }
}

extension DoubleUtil on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.h -> will take 20% of the screen's height
  double get h => this * Get.height / 100;

  double get h375 => this * min(Get.width, 700) / 375;

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.w -> will take 20% of the screen's width
  double get w => this * Get.width / 100;

  double get w375 => this * min(Get.width, 700) / 375;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double get sp => this * (min(Get.width, 700) / 375);

  String amountText({int fixed = 6}) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String number = toStringAsFixed(fixed).replaceAll(regex, '');
    return number;
  }
}
