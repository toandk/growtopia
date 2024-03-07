import 'package:get/get.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/shop_item/shop_item_model.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/screens/home/home_controller.dart';
import 'package:growtopia/utils/popup.dart';

class ShopController extends BaseListController {
  @override
  void onInit() {
    super.onInit();
    getListItems();
  }

  @override
  Future getListItems() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response =
          await SupabaseAPI.get(table: 'shop', body: {'type': 'tree'});
      final items =
          response.map((value) => ShopItemModel.fromJson(value)).toList();
      handleResponse(items, listItem.isEmpty);
    } catch (error) {
      handleError(error);
    }
  }

  void onSelectAnItem(int index) async {
    final result = await Popup.instance.showAlert(
        title: LocaleKeys.shop_buyConfirmTitle.tr,
        message: LocaleKeys.shop_buyConfirmMessage.tr,
        cancelTitle: LocaleKeys.alert_cancel.tr);
    if (result != null && result == true) {
      try {
        final ShopItemModel item = listItem[index];
        final response = await SupabaseAPI.querySql(
            functionName: 'buy_item', params: {'item_id_param': item.id});
        final newTree = TreeModel.fromJson(response);
        Popup.instance.showSnackBar(
            message: LocaleKeys.shop_buyTreeSuccess.tr,
            type: SnackbarType.success);
        _getTreeInfo(newTree.id ?? 0);
        TokenManager.getNewUserInfo();
      } catch (error) {
        handleError(error);
      }
    }
  }

  void _getTreeInfo(int treeId) async {
    try {
      final response = await SupabaseAPI.querySql(
          functionName: 'get_a_tree_info', params: {'tid': treeId});
      if (response.isNotEmpty) {
        final TreeModel tree = TreeModel.fromJson(response.first);
        Get.find<HomeController>().boughtNewTree(tree);
      }
    } catch (error) {
      handleError(error);
    }
  }
}
