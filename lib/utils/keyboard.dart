import 'package:get/get.dart';

class GPKeyBoard {
  static void hide() {
    Get.focusScope!.unfocus();
  }

  static bool keyboardIsVisible() {
    return Get.mediaQuery.viewInsets.bottom != 0.0;
  }
}
