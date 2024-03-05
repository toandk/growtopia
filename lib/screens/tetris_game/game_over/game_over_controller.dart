import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:google_wallet/google_wallet.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/played_game/played_game_model.dart';
import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:growtopia/routes/router_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_controller.dart';
import 'package:growtopia/screens/tetris_game/game_over/claim_water_popup.dart';
import 'package:growtopia/screens/tetris_game/game_over/top_rank_collectiable_card_popup.dart';
import 'package:growtopia/utils/local_service.dart';
import 'package:growtopia/utils/popup.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TetrisGameOverController extends BaseListController {
  Rx<PlayedGameModel> gameModel = PlayedGameModel().obs;
  RxInt userRank = 0.obs;
  RxBool isLoadingRank = false.obs;
  RxBool showClaimPopup = false.obs;
  final SpellingGameModel game;
  final Map<String, dynamic> gameResult;
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 10));
  final confettiController2 =
      ConfettiController(duration: const Duration(seconds: 10));
  final googleWallet = GoogleWallet();
  Timer? _timer;
  final bool redirectedFromGame;

  TetrisGameOverController(Map<String, dynamic> map,
      {this.redirectedFromGame = true})
      : game = map['game'],
        gameResult = map['result'];

  @override
  void onInit() {
    super.onInit();
    getListItems();
    _getRankInfo();
    confettiController.play();
    showClaimWater();
  }

  void showClaimWater() {
    if (!redirectedFromGame || gameResult['points'] < 20) return;
    _timer = Timer(const Duration(seconds: 3), () {
      _timer?.cancel();
      Get.lazyPut(() => ClaimWaterController(
          points: gameResult['points'], gameType: 'tetris'));
      showClaimPopup.value = true;
      Get.dialog(const ClaimWaterPoup(), barrierDismissible: true);
    });
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    confettiController.dispose();
    confettiController2.dispose();
  }

  @override
  Future getListItems() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      final list = await SupabaseAPI.querySql(
          functionName: 'get_game_leaderboard', params: {'gid': game.id});
      final models = list.map((e) => PlayedGameModel.fromJson(e)).toList();
      for (int i = 0; i < models.length; i++) {
        models[i].rank = i;
      }
      listItem.addAll(models);
      isLoading.value = false;
    } catch (error) {
      handleError(error);
    }
  }

  void playAgain() async {
    Get.offNamed(RouterName.gameTetris, arguments: game);
  }

  void _getRankInfo() async {
    isLoadingRank.value = true;
    try {
      final data = await SupabaseAPI.querySql(
          functionName: 'get_played_game_rank', params: {'gid': 'tetris'});
      if (data.isNotEmpty) {
        final gmodel = PlayedGameModel.fromJson(data.first);
        userRank.value = gmodel.rank ?? 0;
        gameModel.value = gmodel;
        if (userRank.value <= 10 && redirectedFromGame) {
          _showCollectiableCard(userRank.value);
        }
      }

      isLoadingRank.value = false;
    } catch (error) {
      isLoadingRank.value = false;
      debugPrint('get rank error {${error.toString()}}');
    }
  }

  void _showCollectiableCard(int rank) {
    if (_hasShownCollectiableCard(rank)) return;
    Get.dialog(
        TopRankColectiableCardPopup(
            confettiController: confettiController,
            hideAction: Get.back,
            addToWalletAction: _addToWalletAction,
            rank: rank),
        useSafeArea: false);
    _saveShownCollectiableCard(rank);
  }

  bool _hasShownCollectiableCard(int rank) {
    final key = rank <= 1 ? 'rank_1' : (rank <= 3 ? 'rank_3' : 'rank_10');
    return LocalService.get(key, false) ?? false;
  }

  void _saveShownCollectiableCard(int rank) {
    final key = rank <= 1 ? 'rank_1' : (rank <= 3 ? 'rank_3' : 'rank_10');
    LocalService.save(key, true, false);
  }

  void _addToWalletAction() async {
    final type = userRank.value <= 1
        ? 'tetris_top_1'
        : (userRank.value <= 3 ? 'tetris_top_3' : 'tetris_top_10');
    final imgUrl = userRank.value <= 1
        ? 'https://dmgynbzsijutdfomkvyr.supabase.co/storage/v1/object/public/images/tetris_top1.png'
        : (userRank.value <= 3
            ? 'https://dmgynbzsijutdfomkvyr.supabase.co/storage/v1/object/public/images/tetris_top3.png'
            : 'https://dmgynbzsijutdfomkvyr.supabase.co/storage/v1/object/public/images/tetris_top10.png');
    final subHeader = userRank.value <= 1
        ? 'Top 1 highest score'
        : (userRank.value <= 3
            ? 'Top 3 highest score'
            : 'Top 10 highest score');
    final jwt = Utils.genGGWalletJWT(type, 'Tetris', imgUrl, subHeader,
        background: '#ffd60a');
    try {
      final available = await googleWallet.isAvailable();
      if (available == true) {
        await googleWallet.savePassesJwt(jwt);
        Popup.instance.showSnackBar(message: 'Added to Google Wallet');
      } else {
        launchUrl(Uri.parse('https://pay.google.com/gp/v/save/$jwt'));
      }
    } on PlatformException catch (e) {
      handleError(e);
    }
  }
}
