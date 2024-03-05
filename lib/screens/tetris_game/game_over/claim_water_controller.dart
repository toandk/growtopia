import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/utils/popup.dart';

class ClaimWaterController extends BaseController {
  RewardedAd? _rewardedAd;
  final int points;
  final String gameType;
  final RxBool loadedAds = false.obs;

  ClaimWaterController({required this.points, required this.gameType});

  @override
  void onInit() {
    super.onInit();
    _loadAds();
  }

  void _loadAds() async {
    RewardedAd.load(
        adUnitId: Constants.adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            loadedAds.value = true;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  void claimAction(bool bonus) {
    if (isLoading.value) return;
    isLoading.value = true;
    if (bonus) {
      loadedAds.listen((loaded) {
        isLoading.value = false;
        if (loaded) {
          _rewardedAd?.show(
              onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
            _doClaim(bonus);
          });
        }
      });
    } else {
      _doClaim(bonus);
    }
  }

  void _doClaim(bool bonus) async {
    try {
      final response = await SupabaseAPI.querySql(
          functionName: 'claim_water',
          params: {'points': points, 'gtype': gameType, 'bonus': bonus});
      isLoading.value = false;
      if (response != 0) {
        Get.back();
        Popup.instance.showSnackBar(
            message: LocaleKeys.claimWater_congratMessage.tr
                .replaceAll('%s', response.toString()),
            type: SnackbarType.success);
      }
    } catch (error) {
      handleError(error);
    }
  }
}
