import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../utils/sound_manager.dart';

class SpeakerButton extends StatelessWidget {
  final String voiceUrl;
  final double size;
  const SpeakerButton({Key? key, required this.voiceUrl, this.size = 135})
      : super(key: key);

  void _playVoice(bool slow) {
    SoundManager.playAVoice(voiceUrl, slow: slow);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Bounceable(
            onTap: () => _playVoice(false),
            child: Image.asset('assets/images/icon-speaker.png',
                width: size, height: size * 141 / 135)),
        Bounceable(
            onTap: () => _playVoice(true),
            child: Image.asset('assets/images/icon-slow-speaker.png',
                width: 48 / 135 * size, height: 50 / 135 * size))
      ],
    );
  }
}
