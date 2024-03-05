import 'package:growtopia/base/controller/base_controller.dart';
import 'package:get/get.dart';

class TabbarController extends BaseController {
  RxInt selectedTabIndex = 0.obs;

  void changeIndex(int index) async {
    selectedTabIndex.value = index;
  }
}
