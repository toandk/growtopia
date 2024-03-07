import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_wallet/generated/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/screens/doodle_jump/assets.dart';
import 'package:growtopia/screens/doodle_jump/high_scores.dart';
import 'package:growtopia/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/locales.g.dart';
import 'routes/routes.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async {
  await GetStorage.init();
  await initSupabase();
  // await RCPaymentManager.instance.initPlatformState();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }
  FlameAudio.updatePrefix('assets/');
  await _loadDoodleJumpGame();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(savedThemeMode: savedThemeMode));
  configLoading();
}

Future _loadDoodleJumpGame() async {
  await Flame.device.fullScreen();

  await HighScores.load();
  await Assets.load();
}

Future<void> initSupabase() async {
  await Supabase.initialize(
      url: 'https://dmgynbzsijutdfomkvyr.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRtZ3luYnpzaWp1dGRmb21rdnlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDUzOTQzMDAsImV4cCI6MjAyMDk3MDMwMH0.ig6AipH0f50GaUrSe-R_UF5k8KRAqeYYnaq0YPRap6A',
      // authFlowType: AuthFlowType.pkce,
      authCallbackUrlHostname: 'login-callback');
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Constants.screenWidth,
        child: AdaptiveTheme(
            light: AppThemes.lightTheme(),
            dark: AppThemes.darktheme(),
            debugShowFloatingThemeButton: false,
            initial: savedThemeMode ?? AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => RefreshConfiguration(
                hideFooterWhenNotFull: true,
                child: RefreshConfiguration(
                    headerBuilder: () => const WaterDropMaterialHeader(
                          color: Colors.white,
                          backgroundColor: Colors.orange,
                        ),
                    child: GetMaterialApp(
                      theme: theme,
                      darkTheme: darkTheme,
                      locale: Locale(Utils.currentLanguageCode()),
                      fallbackLocale: const Locale("en"),
                      supportedLocales: const [
                        Locale("en"),
                        Locale("vi"),
                      ],
                      localizationsDelegates: const [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        I18nGoogleWallet.delegate,
                      ],
                      translationsKeys: AppTranslation.translations,
                      initialRoute: RouterName.loading,
                      debugShowCheckedModeBanner: false,
                      navigatorObservers: [routeObserver],
                      getPages: Pages.pages,
                      routingCallback: (value) {
                        if (value == null ||
                            value.isBottomSheet == true ||
                            value.isDialog == true) return;
                        Utils.trackScreen(value.current);
                      },
                      builder: EasyLoading.init(),
                    )))),
      ),
    );
  }
}
