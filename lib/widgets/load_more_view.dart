import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoadMoreView extends StatelessWidget {
  final double width;
  final double height;
  const LoadMoreView({Key? key, this.width = 72, this.height = 90})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
        builder: (context, mode) => SizedBox(
            width: width,
            height: height,
            child: Center(
                child: mode == LoadStatus.loading
                    ? const CupertinoActivityIndicator(color: Colors.white)
                    : Container())));
  }
}
