import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/models/user/user_model.dart';
import 'package:growtopia/utils/popup.dart';

class ForestController extends BaseListController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final RxList listTrees = [].obs;

  @override
  void onInit() {
    super.onInit();

    getListItems();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  @override
  Future getListItems() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      final response = await SupabaseAPI.get(table: 'profiles', body: {});
      final List users =
          response.map((value) => UserModel.fromJson(value)).toList();
      users.sort((a, b) => a.id == TokenManager.userInfo.value.id ? -1 : 1);
      final List allUsers = [];
      for (final user in users) {
        final res2 =
            await SupabaseAPI.get(table: 'trees', body: {'user_id': user.id});
        if (res2.isNotEmpty) {
          final trees = res2.map((value) => TreeModel.fromJson(value)).toList();
          allUsers.add(user);
          listTrees.add(trees);
        }
      }
      listItem.value = allUsers;
      isLoading.value = false;
    } catch (error) {
      handleError(error);
    }
  }

  void donateWaterAction(String userId) async {
    if (TokenManager.userInfo.value.waters < 100) {
      Popup.instance.showSnackBar(
          message: 'You don\'t have enough water to donate!',
          type: SnackbarType.error);
    } else {
      try {
        await SupabaseAPI.querySql(functionName: 'donate_water', params: {
          'userid': userId,
        });
        TokenManager.getNewUserInfo();
        Popup.instance.showSnackBar(
            message: 'Water donated successfully!', type: SnackbarType.success);
      } catch (error) {
        handleError(error);
      }
    }
  }

  void changePage(int index) {
    // currentPage.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void onChangePage(int page) {
    currentPage.value = page;
  }
}
