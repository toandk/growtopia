import '../../utils/rc_payment_manager.dart';
import 'spelling_game_model.dart';

extension Payment on SpellingGameModel {
  bool isLocked() {
    return isPremium == true &&
        RCPaymentManager.instance.userIsSubscribed.value == false;
  }
}
