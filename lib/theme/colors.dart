import 'package:flutter/material.dart';

class GPColor {
  GPColor._();
  static const Color workPrimary = Color(0xFF30A960);

  static const Color contentPrimary = Color(0xFF212121);
  static const Color contentSecondary = Color(0xFF969696);
  static const Color contentTertiary = Color(0xFFC8CACF);
  static const Color contentInversePrimary = Color(0xFFFFFFFF);

  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xffFFF7EA);
  static const Color bgTertiary = Color(0xFFF1F2F4);
  static const Color bgInversePrimary = Color(0xFF212121);

  static const Color linePrimary = Color(0xFFDBDBDB);
  static const Color lineSecondary = Color(0xFFF6F6F6);
  static const Color lineTertiary = Color(0xFFE9EAEC);

  static const Color bgHeader = Color(0xFFF7F6F6);

  static const Color functionAccentPrimary = Color(0xFF6FBE49);
  static const Color functionAccentSecondary = Color(0xff2B2C2D);
  static const Color functionNegativePrimary = Color(0xFFE94040);
  static const Color functionAccentWorkPrimary = Color(0xFF096DD9);
  static const Color functionAccentWorkSecondary = Color(0x22096DD9);
  static const Color functionAccentWorkSecondary38 =
      Color.fromRGBO(86, 202, 118, 0.24);
  static const Color functionLinkPrimary = Color(0xFF096DD9);

  static const Color functionPositivePrimary = Color(0xff56CA76);
  static const Color functionPositiveSecondary =
      Color.fromRGBO(86, 202, 118, 0.16);
  static const Color functionCriticalSecondary =
      Color.fromRGBO(250, 140, 22, 0.12);
  static const Color functionNegativeSecondary =
      Color.fromRGBO(233, 64, 64, 0.12);
  static const Color functionCriticalPrimary = Color.fromRGBO(250, 140, 22, 1);
  static const Color functionInformativePrimary =
      Color.fromRGBO(24, 186, 255, 0.12);
  static const Color functionAlwaysDarkPrimary = Color(0xFF131416);
  static const Color functionAlwaysLightPrimary = Color(0xFFFFFFFF);

  static const informativePrimary = Color(0xFF18BAFF);
  static const informativeSecondary = Color(0x1F18BAFF);
  static const stateHoverPrimary = Color(0x0A26282C);
  static const stateHoverSecondary = Color(0x1AFFFFFF);
  static const statePressPrimary = Color(0x3D26282C);
  static const statePressSecondary = Color(0x33FFFFFF);

  static const red = Color(0xFFD14D21);
  static const teal = Color(0xFF00CFF7);
  static const orange = Color(0xFFEB6651);
  static const blue = Color(0xFF3896F6);
  static const yellow = Color(0xFFFADB14);
  static const indigo = Color(0xFF2F54EB);
  static const lime = Color(0xFFA0D911);
  static const purple = Color(0xFF722ED1);
  static const green = Color(0xFF20C950);
  static const pink = Color(0xFFFF4D82);
  static const transparent = Color(0x00000000);

  static const blackAlpha5 = Color(0x0D000000);

  static const shimmerBaseColor = Color(0xFFEDEEF0);
  static const shimmerHighlightColor = Color(0xFFF9F9F9);

  static const boxShadow = Color.fromRGBO(0, 0, 0, 0.05);
  static const bgDisabled = Color(0xffededed);
  static const Color buttonDisabled = Color(0x333966ED);

  static const gray = Color(0xff1A1A1A);
  static const border = Color.fromRGBO(0, 0, 0, 0.05);
  static const scrim = Color.fromRGBO(0, 0, 0, 0.6);

  static const calendarEventRemind = Color(0xFF722ED1);
  static const calendarEventTodo = Color(0xFFFA8C16);
  static const calendarEventEvent = Color(0xFF13C2C2);

  ///
  /// Dark colors
  ///
  static const Color darkContentPrimary = Color(0xFFFFFFFF);
  static const Color darkContentSecondary = Color(0xFFA8ABB2);
  static const Color darkContentTertiary = Color(0xFF696C77);
  static const Color darkContentInversePrimary = Color(0xFF131416);

  static const Color darkBgPrimary = Color(0xFF26282C);
  static const Color darkBgSecondary = Color.fromRGBO(225, 235, 255, 0.14);
  static const Color darkBgTertiary = Color(0xFF131416);
  static const Color darkBgInversePrimary = Color(0xFFFFFFFF);

  static const Color darkLinePrimary = Color(0xFF565961);
  static const Color darkLineSecondary = Color(0xFF43454B);
  static const Color darkLineTertiary = Color(0xFF393B40);

  static const Color darkFunctionPrimary = Color(0xFF6FBE49);
  static const Color darkFunctionNegativePrimary = Color(0xFFE94040);
  static const Color darkFunctionAccentWorkPrimary = Color(0xFF375464);
  static const Color darkFunctionAccentWorkSecondary = Color(0xFF30A960);
  static const Color darkFunctionLinkPrimary = Color(0xFF096DD9);

  static const Color darkFunctionPositivePrimary = Color(0xff20C950);
  static const Color darkFunctionPositiveSecondary =
      Color.fromRGBO(32, 201, 80, 0.24);
  static const Color darkFunctionCriticalSecondary =
      Color.fromRGBO(250, 140, 22, 0.24);
  static const Color darkFunctionNegativeSecondary =
      Color.fromRGBO(250, 140, 22, 0.24);
  static const Color darkFunctionCriticalPrimary =
      Color.fromRGBO(250, 140, 22, 1);

  static const LinearGradient buttonGradient = LinearGradient(
      colors: [Color(0xFFFFCD4E), Color(0xFFFF9958)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  static const LinearGradient buttonIncorrectGradient = LinearGradient(
      colors: [Color(0xFFE5966D), Color(0xFFDE5527)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const LinearGradient buttonCorrectGradient = LinearGradient(colors: [
    Color.fromRGBO(123, 224, 162, 1.0),
    Color.fromRGBO(81, 166, 110, 1.0)
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);

  static const RadialGradient bgGradient1 = RadialGradient(
      colors: [Color(0xFF3C9FF9), Color(0xFF226BE5)], radius: 0.8);
  static const LinearGradient bgGradient2 = LinearGradient(
      colors: [Color(0xff0093E9), Color(0xff80D0C7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  static const LinearGradient bgGradient3 = LinearGradient(
      colors: [Color(0xFFe14fad), Colors.pink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
  static const LinearGradient bgGradient4 = LinearGradient(
      colors: [Color(0xffb224ef), Color(0xff7579ff)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
  static const LinearGradient bgGradient5 = LinearGradient(
      colors: [Color(0xff667eea), Color(0xff764ba2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
