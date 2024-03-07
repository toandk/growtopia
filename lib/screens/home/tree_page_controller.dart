import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/home_controller.dart';
import 'package:growtopia/screens/home/level_up_finish_popup.dart';
import 'package:growtopia/screens/home/max_level_popup.dart';
import 'package:growtopia/screens/home/tree_info_popup.dart';
import 'package:growtopia/screens/tabbar/tabbar_controller.dart';
import 'package:growtopia/utils/popup.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

class TreePageController extends BaseController {
  final TreeModel tree;
  final int index;
  final RxBool isPlanted = false.obs;
  final RxInt level = 0.obs;
  final RxBool isDead = false.obs;
  final Rx<DateTime> levelUpTime =
      (DateTime.now().add(const Duration(seconds: -1000))).obs;
  Timer? _timer;
  RxInt levelUpRemainTime = 0.obs;
  RxInt levelUpTotalTime = (-1).obs;

  String get tag => tree.id!.toString();

  final confettiController =
      ConfettiController(duration: const Duration(seconds: 10));

  final googleWallet = GoogleWallet();

  TreePageController({required this.tree, required this.index});

  @override
  void onInit() {
    super.onInit();
    isPlanted.value = tree.plantedAt != null;
    level.value = tree.getActualLevel();
    isDead.value = tree.health == -1;
    levelUpTime.value =
        tree.levelUpTime ?? DateTime.now().add(const Duration(seconds: -1000));

    if (tree.isLevelingUp()) {
      levelUpRemainTime.value =
          tree.levelUpTime!.difference(DateTime.now()).inSeconds;
      levelUpTotalTime.value = tree.levelUpTimes != null &&
              tree.levelUpTimes!.length > level.value - 2 &&
              level.value != 0
          ? tree.levelUpTimes![level.value - 2]
          : 0;
      _startTimer();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    _timer = null;
    confettiController.dispose();
  }

  void waterTheTree() async {
    if (tree.isLevelingUp() || _timer?.isActive == true) {
      Popup.instance
          .showSnackBar(message: LocaleKeys.home_waitLevelingMessage.tr);
      return;
    }
    if (tree.level == tree.waterList!.length) {
      Popup.instance.showSnackBar(message: LocaleKeys.home_treeMaxLevel.tr);
      return;
    }
    final userDrops = TokenManager.userInfo.value.waters;
    final waters =
        tree.waterList?[min(level.value - 1, tree.waterList!.length - 1)] ?? 0;
    if (userDrops < waters) {
      Popup.instance.showSnackBar(
          message: LocaleKeys.home_dontHaveEnoughWater.tr,
          type: SnackbarType.error);
      return;
    }
    try {
      final response = await SupabaseAPI.querySql(
          functionName: 'water_a_tree',
          params: {'treeid': tree.id, 'shopitemid': tree.itemId});

      _startLevelingUp();
      Popup.instance.showSnackBar(
          message: LocaleKeys.home_waterSuccess.tr.replaceAll(
              '%', Utils.secondsToTimeString(levelUpTotalTime.value)),
          type: SnackbarType.success);

      TokenManager.getNewUserInfo();
      debugPrint('water success $response');
    } catch (error) {
      debugPrint('water error $error');
      Popup.instance
          .showSnackBar(message: (error as PostgrestException).message);
    }
  }

  void plantAction() async {
    try {
      await SupabaseAPI.querySql(
          functionName: 'plant_a_tree',
          params: {'treeid': tree.id, 'landindex': 0});
      tree.plantedAt = DateTime.now().millisecondsSinceEpoch.toString();
      tree.levelUp(0);
      isPlanted.value = true;
      Get.dialog(LevelUpFinishPopup(
          imageUrl: tree.getPhoto(1),
          isPlanting: true,
          level: 1,
          confettiController: confettiController,
          hideAction: Get.back));
      confettiController.play();
    } catch (error) {
      debugPrint('plant error $error');
      handleError(error);
    }
  }

  void showTreeInfo() {
    Get.dialog(TreeInfoPopup(tree: tree, index: index));
  }

  void _startLevelingUp() {
    tree.levelUp(tree.waterList![level.value - 1]);
    // level.value = level.value + 1;
    isPlanted.value = true;
    levelUpRemainTime.value = tree.levelUpTimes![level.value - 1];
    tree.levelUpTime =
        DateTime.now().add(Duration(seconds: levelUpRemainTime.value));
    levelUpTotalTime.value = tree.levelUpTimes![level.value - 1];

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      if (levelUpRemainTime.value > 0) {
        levelUpRemainTime.value = levelUpRemainTime.value - 1;
      } else {
        t.cancel();
        _timer = null;
        level.value = level.value + 1;
        if (level.value == tree.waterList!.length - 1) {
          Get.dialog(
              MaxLevelPopup(
                  imageUrl: tree.rewardCard ?? '',
                  level: tree.getActualLevel() - 1,
                  confettiController: confettiController,
                  hideAction: Get.back,
                  addToWalletAction: _addToWalletAction),
              useSafeArea: false);
        } else {
          Get.dialog(
              LevelUpFinishPopup(
                  imageUrl: tree.getPhoto(tree.getActualLevel()),
                  level: level.value - 1,
                  confettiController: confettiController,
                  hideAction: Get.back),
              useSafeArea: false);
        }
        confettiController.play();
        Get.find<HomeController>().scrollToTree(tree);
      }
    });
  }

  void _addToWalletAction() async {
    final type =
        ['birch_card', 'pine_card', 'apple_card', 'blossom_card'][tree.id! % 4];
    final jwt = Utils.genGGWalletJWT(
        type, tree.name ?? '', tree.rewardCard ?? '', 'Reached max level');
    try {
      final available = await googleWallet.isAvailable();
      if (available == true) {
        await googleWallet.savePassesJwt(jwt);
        Popup.instance.showSnackBar(message: 'Added to Google Wallet');
        Get.back();
      } else {
        launchUrl(Uri.parse('https://pay.google.com/gp/v/save/$jwt'));
      }
    } on PlatformException catch (e) {
      handleError(e);
    }
  }

  void openGames() {
    Get.find<TabbarController>().changeIndex(2);
  }
}
