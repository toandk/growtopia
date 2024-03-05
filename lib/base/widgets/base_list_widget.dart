import 'package:flutter/material.dart';
import 'package:growtopia/base/controller/base_controller.dart';
import 'package:growtopia/widgets/error_view.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

/// Base list widget which support most of listview states:
/// [loadingWidget] for showing loading such as Shimmer, Progress or something like that.
/// [listWidget] for showing listview.
/// [errorWidget] for showing error such as http error: 400, 404, 500, 501, 502, 503, timeout....
/// [emptyWidget] for showing empty view, connected to server, and list do not have any data.
class BaseListWidget<T extends BaseListController> extends GetView<T> {
  const BaseListWidget({
    required this.listWidget,
    this.errorWidget,
    this.loadingWidget,
    this.emptyWidget,
    Key? key,
  }) : super(key: key);

  final Widget listWidget;
  final Widget Function(String? error)? errorWidget;
  final Widget? loadingWidget;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isSuccessState) {
        return listWidget;
      } else if (controller.isLoadingState) {
        return loadingWidget ??
            const Center(child: CircularProgressIndicator());
      } else if (controller.isErrorState) {
        return errorWidget != null
            ? errorWidget!(controller.errorStr.value)
            : ErrorView(controller.errorStr.value);
      } else if (controller.showEmptyState.value) {
        return emptyWidget ?? const SizedBox();
      }
      return emptyWidget ?? const SizedBox();
    });
  }
}
