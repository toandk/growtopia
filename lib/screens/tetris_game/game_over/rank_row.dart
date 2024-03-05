import 'package:growtopia/configs/constants.dart';
import 'package:growtopia/generated/locales.g.dart';
import 'package:growtopia/models/played_game/played_game_model.dart';
import 'package:growtopia/theme/colors.dart';
import 'package:growtopia/theme/text_theme.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RankRow extends StatelessWidget {
  final PlayedGameModel gameModel;
  final int index;
  final bool isMe;
  const RankRow(
      {Key? key,
      required this.gameModel,
      required this.index,
      this.isMe = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isMe
        ? Colors.white12
        : (index == 0
            ? Colors.white
            : (index == 1
                ? Colors.orange
                : index == 2
                    ? Colors.blue
                    : Colors.transparent));
    final textColor = isMe
        ? Colors.white
        : (index == 0
            ? GPColor.contentPrimary
            : (index == 1
                ? GPColor.contentInversePrimary
                : index == 2
                    ? GPColor.contentInversePrimary
                    : GPColor.contentInversePrimary));
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20),
            Text(
              (index + 1).toString(),
              style:
                  textStyle(GPTypography.body16)?.bold().mergeColor(textColor),
            ),
            const SizedBox(width: 12),
            GPNetworkImage(
              url: gameModel.user?.avatarUrl ?? '',
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(20),
              placeholder: Constants.defaultAvatar,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                gameModel.user?.id ==
                        Supabase.instance.client.auth.currentUser?.id
                    ? LocaleKeys.game_tetris_you.tr
                    : gameModel.user?.name ?? '',
                maxLines: 1,
                style: textStyle(GPTypography.body16)
                    ?.bold()
                    .mergeColor(textColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              gameModel.score?.toString() ?? '',
              style:
                  textStyle(GPTypography.body16)?.bold().mergeColor(textColor),
            ),
            const SizedBox(width: 4),
            Text(
              LocaleKeys.game_tetris_pointShort.tr,
              style: textStyle(GPTypography.body16)
                  ?.mergeFontSize(14)
                  .mergeColor(textColor),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
