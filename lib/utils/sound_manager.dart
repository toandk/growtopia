import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as JustAudio;
import 'package:just_audio_cache/just_audio_cache.dart';

class SoundManager {
  static final _remotePlayer = JustAudio.AudioPlayer();
  static final RxDouble downloadingProgress = 0.0.obs;

  static void playWrongSound() async {
    await playLocalSound('sounds/incorrect.wav');
  }

  static void playCorrectSound() async {
    await playLocalSound('sounds/correct.wav');
  }

  static void playFinishGameSound() async {
    await playLocalSound('sounds/congrat.wav');
  }

  static void playTetrisStart(bool isMuted) async {
    if (isMuted) return;
    await playLocalSound('sounds/start.mp3');
  }

  static void playTetrisClear(bool isMuted) async {
    if (isMuted) return;
    await playLocalSound('sounds/clean.mp3');
  }

  static void playTetrisFall(bool isMuted) async {
    if (isMuted) return;
    await playLocalSound('sounds/drop.mp3');
  }

  static void playTetrisRotate(bool isMuted) async {
    if (isMuted) return;
    await playLocalSound('sounds/rotate.mp3');
  }

  static void playTetrisMove(bool isMuted) async {
    if (isMuted) return;
    await FlameAudio.play('sounds/move.mp3');
  }

  static Future playLocalSound(String sound) async {
    await FlameAudio.play(sound);
  }

  static void playAVoice(String url, {bool slow = false}) async {
    await _remotePlayer.dynamicSet(url: url);
    if (slow) {
      await _remotePlayer.setSpeed(0.6);
    } else {
      await _remotePlayer.setSpeed(1.0);
    }
    _remotePlayer.play();
  }

  static Future downloadAllResources(List voices) async {
    downloadingProgress.value = 0;
    for (var voice in voices) {
      if (!await _remotePlayer.existedInLocal(url: voice)) {
        await _remotePlayer.cacheFile(url: voice);
      }
      downloadingProgress.value =
          downloadingProgress.value + 1.0 / voices.length;
    }
  }

  static Future clearCache() async {
    await _remotePlayer.clearCache();
  }
}
