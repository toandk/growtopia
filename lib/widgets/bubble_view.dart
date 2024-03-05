import 'package:growtopia/utils/sound_manager.dart';
import 'package:growtopia/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class BubbleView extends StatelessWidget {
  final String? voiceUrl;
  final double size;
  final String iconUrl;
  final Function()? onTap;
  final bool isSelected;
  const BubbleView({
    Key? key,
    this.voiceUrl,
    required this.size,
    required this.iconUrl,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  void _playVoice(bool slow) {
    if (voiceUrl != null) {
      SoundManager.playAVoice(voiceUrl!, slow: slow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIcon = iconUrl.contains('public/icons/');
    final color = isIcon ? Colors.white : null;
    final imageRatio = isIcon ? 0.7 : 1.0;
    final imageSize = size * 0.8 * imageRatio;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                color: const Color(0x4D01D1F7),
                borderRadius: BorderRadius.circular(size / 2)),
            child: Bounceable(
              onTap: onTap ?? () => _playVoice(false),
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                            width: size * 0.8,
                            height: size * 0.8,
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFEB6651)
                                    : const Color(0xFF00C2E5),
                                borderRadius:
                                    BorderRadius.circular(size * 0.8 / 2)))),
                    Container(
                      width: size * 0.8,
                      height: size * 0.8,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: isSelected
                                  ? const [Color(0xFFFFCD4E), Color(0xFFFF9958)]
                                  : const [
                                      Color(0xFF11EDF1),
                                      Color(0xFF00D0F6)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.center),
                          borderRadius: BorderRadius.circular(size * 0.8 / 2)),
                      child: Center(
                          child: GPNetworkImage(
                        borderRadius: BorderRadius.circular(imageSize / 2),
                        url: iconUrl,
                        // fit: BoxFit.contain,
                        color: color,
                        width: imageSize,
                        height: imageSize,
                      )),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
