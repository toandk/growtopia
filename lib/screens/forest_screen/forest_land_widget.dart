import 'package:flutter/material.dart';
import 'package:growtopia/models/token/token_manager.dart';
import 'package:growtopia/models/user/user_model.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/image_button.dart';
import 'package:growtopia/widgets/network_image.dart';

const double _landWidth = 260;

class ForestLandWidget extends StatelessWidget {
  final List trees;
  final UserModel userInfo;
  final Function(String userId) donateWaterAction;
  const ForestLandWidget(
      {super.key,
      required this.trees,
      required this.userInfo,
      required this.donateWaterAction});

  List _listTreeWidgets(double paddingLeft) {
    final List<double> posx = [35, 70, 110, 0, 35, 60];
    final List<double> posy = [100, 115, 133, 115, 133, 145];
    return trees
        .asMap()
        .entries
        .map((e) => Positioned(
              left: posx[e.key] + paddingLeft,
              top: posy[e.key],
              child: GPNetworkImage(
                url: e.value.getPhoto(e.value.getActualLevel()),
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Padding(
                padding: EdgeInsets.only(left: (width - _landWidth) / 2),
                child: Image.asset('assets/images/ground_big.png',
                    width: _landWidth, height: _landWidth * 317 / 462),
              ),
            ],
          ),
          ..._listTreeWidgets((width - _landWidth) / 2 - 45),
          Positioned(
              left: 20,
              right: 20,
              top: 400,
              child: Text(
                userInfo.id == TokenManager.userInfo.value.id
                    ? 'Your Forest'
                    : '${userInfo.name ?? ''}\'s Forest',
                textAlign: TextAlign.center,
                style: textStyle(GPTypography.body20)?.white(),
              )),
          Positioned(
              top: 460,
              left: width / 2 - 90,
              child: userInfo.id != TokenManager.userInfo.value.id
                  ? Center(
                      child: ImageButton(
                          title: 'Donate Water',
                          width: 180,
                          height: 60,
                          background: 'assets/images/ok_button_bg.png',
                          onTap: () => donateWaterAction(userInfo.id ?? '')),
                    )
                  : const SizedBox())
        ],
      ),
    );
  }
}
