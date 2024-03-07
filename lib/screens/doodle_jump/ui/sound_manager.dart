import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';

class DJSoundManager {
  DJSoundManager._();

  //  late AudioPool pool = await FlameAudio.createPool(
  //     'sfx/fire_2.mp3',
  //     minPlayers: 4,
  //     maxPlayers: 6,
  //   );

  static Future playJumpSound() async {
    await FlameAudio.play('sounds/jump-arcade.mp3');
  }

  static Future playFallSound() async {
    await FlameAudio.play('sounds/jumponmonster.mp3');
  }

  static Future playEffectSound(String sound) async {
    await FlameAudio.play(sound);
  }

  static Future playCollectWaterSound() async {
    await FlameAudio.play('sounds/collect.mp3');
  }

  static Future playShotSound() async {
    await FlameAudio.play('sounds/shotgun_shoot.mp3');
  }
}
