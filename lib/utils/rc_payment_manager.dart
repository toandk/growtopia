import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/utils/log.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RCPaymentManager {
  static RCPaymentManager instance = RCPaymentManager._();

  final supabase = Supabase.instance.client;

  RCPaymentManager._();

  RxList<Package> listProducts = <Package>[].obs;
  RxList<PromotionalOffer> listPromotionalOffers = <PromotionalOffer>[].obs;

  final RxBool userIsSubscribed = false.obs;

  Future<void> initPlatformState() async {
    if (kIsWeb) return;
    await Purchases.setLogLevel(LogLevel.debug);

    try {
      PurchasesConfiguration configuration;
      if (GetPlatform.isAndroid) {
        configuration = PurchasesConfiguration(Constants.revenueCatAPIKey);
      } else {
        configuration = PurchasesConfiguration(Constants.revenueCatAPIKey);
      }
      if (supabase.auth.currentUser?.id != null) {
        configuration.appUserID = supabase.auth.currentUser!.id;
      }

      await Purchases.configure(configuration);
    } catch (error) {
      logDebug('init payment error: $error');
    }

    // getListSubscriptions();
  }

  void setupUserId() {
    if (supabase.auth.currentUser?.id != null) {
      Purchases.logIn(supabase.auth.currentUser!.id);
    }
  }

  Future<void> _checkUserSubscription() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      userIsSubscribed.value = customerInfo.activeSubscriptions.isNotEmpty;
      // access latest customerInfo
    } on PlatformException catch (e) {
      userIsSubscribed.value = false;
      debugPrint('check failed $e');
    }
  }

  Future getListSubscriptions() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        listProducts.value = offerings.current!.availablePackages;
        await _checkUserSubscription();
        await _getListPromotionalOffers();
      }
    } catch (e) {
      // optional error handling
      logDebug('get list subscription error $e');
    }
  }

  Future _getListPromotionalOffers() async {
    try {
      for (int i = 0; i < listProducts.length; i++) {
        final discount = listProducts[i].storeProduct.discounts?.first;
        if (discount != null) {
          final promoOffer = await Purchases.getPromotionalOffer(
              listProducts[i].storeProduct, discount);
          if (promoOffer != null) {
            listPromotionalOffers.add(promoOffer);
          }
        }
      }
    } catch (e) {
      // optional error handling
      logDebug('get list promotion offer error $e');
    }
  }

  Future<bool> purchaseAPackage(
      Package package, PromotionalOffer? promoOffer) async {
    try {
      CustomerInfo purchaserInfo = promoOffer != null
          ? await Purchases.purchaseDiscountedPackage(package, promoOffer)
          : await Purchases.purchasePackage(package);
      if (purchaserInfo
              .entitlements.all[Constants.premiumEntitlement]?.isActive ==
          true) {
        userIsSubscribed.value = true;
        return true;
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        Utils.handleError(e);
      }
    }
    return false;
  }

  Future<bool> restorePurchase() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      if (restoredInfo.activeSubscriptions.isNotEmpty) {
        userIsSubscribed.value = true;
        return true;
      }
      // ... check restored purchaserInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      // Error restoring purchases
      Utils.handleError(e);
    }
    return false;
  }
}
