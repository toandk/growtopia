import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:growtopia/theme/colors.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  void _checkLogin() async {
    if (TokenManager.isLoggedIn()) {
      TokenManager.getNewUserInfo();
      Get.offNamed(RouterName.tabbar);
    } else {
      await TokenManager.autoGuestLogin();
      TokenManager.getNewUserInfo();
      Get.offNamed(RouterName.tabbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPColor.bgPrimary,
      body: Center(
          child:
              Image.asset("assets/images/Logo1.png", width: 180, height: 180)),
    );
  }
}
