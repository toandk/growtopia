import 'package:flutter/widgets.dart';
import 'package:flutter_google_wallet/flutter_google_wallet_plugin.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:get/get.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/tree_page_controller.dart';
import 'package:growtopia/screens/tabbar/tabbar_controller.dart';
import 'package:growtopia/utils/popup.dart';

class HomeController extends BaseListController {
  final RxInt currentPage = 0.obs;
  final RxInt userWaters = 0.obs;
  final PageController pageController = PageController();

  final flutterGoogleWalletPlugin = FlutterGoogleWalletPlugin();

  @override
  void onInit() {
    super.onInit();
    flutterGoogleWalletPlugin.initWalletClient();

    getListItems();
    userWaters.value = TokenManager.userInfo.value.waters;
    TokenManager.userInfo.listen((p0) {
      userWaters.value = p0.waters;
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  void onChangePage(int page) {
    currentPage.value = page;
  }

  void changePage(int index) {
    // currentPage.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void scrollToTree(TreeModel tree) {
    final index = listItem.indexWhere((element) => element.id == tree.id);
    if (index != -1) {
      changePage(index);
    }
  }

  void boughtNewTree(TreeModel tree) {
    Get.put(TreePageController(tree: tree), tag: tree.id.toString());
    listItem.add(tree);
  }

  @override
  Future reload() async {
    currentPage.value = 0;
    super.reload();
  }

  @override
  Future getListItems() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response =
          await SupabaseAPI.querySql(functionName: 'get_user_trees');
      final List trees =
          response.map((json) => TreeModel.fromJson(json)).toList();

      for (TreeModel tree in trees) {
        Get.put(TreePageController(tree: tree), tag: tree.id.toString());
      }
      handleResponse(trees, listItem.isEmpty);
    } catch (error) {
      handleError(error);
    }
  }

  void openShop() {
    Get.find<TabbarController>().changeIndex(1);
  }
}
