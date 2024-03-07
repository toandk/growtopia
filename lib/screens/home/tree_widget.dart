import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:growtopia/models/tree/tree_model.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TreePhoto extends StatelessWidget {
  final String url;
  final Function()? onTap;
  final double width, height;
  final double? progress;
  final BorderRadius? borderRadius;
  final int index;
  const TreePhoto(
      {Key? key,
      required this.url,
      this.onTap,
      required this.width,
      required this.height,
      this.progress,
      this.borderRadius,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img = 'assets/images/ground${index % 4 + 1}.png';
    return Bounceable(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.all(30),
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: const RadialGradient(colors: [
              Color(0xFFfff3b0),
              Color(0xFFb2d399),
            ]),
            border: Border.all(width: 8, color: Colors.yellow),
            borderRadius: BorderRadius.circular(width / 2)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Image.asset(
              img,
              fit: BoxFit.contain,
              width: width - 40,
              height: width - 40,
            ),
            GPNetworkImage(
              url: url,
              width: width - 40,
              height: width - 40,
              placeholder: Image.asset('assets/images/tree_placeholder.png'),
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class TreeWidget extends StatelessWidget {
  final TreeModel tree;
  final int index;
  const TreeWidget({Key? key, required this.tree, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = tree.health == -1 ? '' : tree.photos?.first;
    return Column(
      children: [
        TreePhoto(
          url: url,
          index: index,
          width: 240,
          height: 240,
        ),
      ],
    );
  }
}
