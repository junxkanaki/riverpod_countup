import 'package:audioplayers/audioplayers.dart';

class SoundLogic {
  // static const SOUND_DATA_UP = 'assets/sounds/sound1.mp3';
  // static const SOUND_DATA_DOWN = 'assets/sounds/sound2.mp3';
  // static const SOUND_DATA_RESET = 'assets/sounds/sound3.mp3';
  static const SOUND_DATA_UP = 'sounds/sound1.mp3';
  static const SOUND_DATA_DOWN = 'sounds/sound2.mp3';
  static const SOUND_DATA_RESET = 'sounds/sound3.mp3';

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(),
  );
  void load() {
    _cache.loadAll([SOUND_DATA_UP, SOUND_DATA_DOWN, SOUND_DATA_RESET]);
  }

  void playUpSound() {
    _cache.play(SOUND_DATA_UP);
  }

  void playDownSound() {
    _cache.play(SOUND_DATA_DOWN);
  }

  void playResetSound() {
    _cache.play(SOUND_DATA_RESET);
  }
}
