// lib/sounds.dart
import 'package:audioplayers/audioplayers.dart';

class Sounds {
  static final AudioPlayer _fxPlayer = AudioPlayer(); // short effects
  static final AudioPlayer _bgPlayer = AudioPlayer(); // background music

  static Future<void> playClickTake() async {
    print("trying to play some musicc");
    await _fxPlayer.play(AssetSource('audio/zapThreeToneUp.mp3'));
  }

  static Future<void> playClickGive() async {
    print("trying to play some musicc");
    await _fxPlayer.play(AssetSource('audio/zapThreeToneDown.mp3'));
  }

  static Future<void> startBackgroundMusic() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.setVolume(0.4); // softer volume
    await _bgPlayer.play(AssetSource('audio/zapThreeToneDown.ogg'));
  }

  static Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }
}
