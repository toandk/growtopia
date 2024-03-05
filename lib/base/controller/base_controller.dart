import 'package:flutter/material.dart';
import 'package:growtopia/base/networking/base/app_exception.dart';
import 'package:growtopia/utils/log.dart';
import 'package:growtopia/utils/popup.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BaseController extends GetxController {
  RxBool isLoading = false.obs;

  void handleError(Object error) {
    debugPrint("handle got error ${error.toString()}");
    isLoading.value = false;
    var message = 'Có lỗi xảy ra, vui lòng thử lại!';
    if (error is AppException) {
      message = error.toString();
    } else if (error is AuthException) {
      message = error.toString();
    } else if (error is PostgrestException) {
      message = error.message;
    }
    Popup.instance.showSnackBar(message: message, type: SnackbarType.error);
  }

  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }
}

abstract class BaseListController<T> extends BaseController {
  bool canLoadMore = true;
  String nextLink = "";
  int page = 0;
  RxBool showEmptyState = false.obs;
  RxList<T> listItem = RxList<T>();

  RxString errorStr = "".obs;

  bool get isSuccessState => listItem.isNotEmpty;

  bool get isLoadingState => isLoading.value && errorStr.isEmpty;

  bool get isErrorState => errorStr.isNotEmpty;

  Future getListItems() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorStr.value = "";
    // Call API here
  }

  Future<bool> loadMoreItems() async {
    logDebug("load more items ${listItem.length}");
    if (!canLoadMore || isLoading.value) return false;
    await getListItems();
    return true;
  }

  Future reload() async {
    nextLink = "";
    page = 0;
    listItem.value = [];
    await getListItems();
  }

  void handleResponse(List<T> items, bool isReload) {
    page += 1;
    isLoading.value = false;

    canLoadMore = items.isNotEmpty;
    _checkEmptyState(items, isReload);
  }

  void buildListItem(List<T> items, bool isReload) {
    if (isReload) {
      listItem.value = items;
    } else {
      listItem.addAll(items);
    }
  }

  void _checkEmptyState(List<T> items, bool isReload) {
    if (isReload && items.isEmpty) {
      showEmptyState.value = true;
    } else {
      showEmptyState.value = false;
      buildListItem(items, isReload);
    }
  }
}
