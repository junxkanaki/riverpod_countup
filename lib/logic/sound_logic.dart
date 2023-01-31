import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_countup/data/count_data.dart';

class SoundLogic {
  static const SOUND_DATA_UP = 'sounds/sound1.mp3';
  static const SOUND_DATA_DOWN = 'sounds/sound2.mp3';
  static const SOUND_DATA_RESET = 'sounds/sound3.mp3';

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(),
  );
  void load() {
    _cache.loadAll([SOUND_DATA_UP, SOUND_DATA_DOWN, SOUND_DATA_RESET]);
  }

  /**
   * ViewModelではなくLogicの中で音の鳴る条件を管理する
   */
  void valueChanged(CountData oldData, CountData newData) {
    if (newData.countUp == 0 && newData.countDown == 0 && newData.count == 0) {
      playResetSound();
    } else if (oldData.countUp + 1 == newData.countUp) {
      playUpSound();
    } else if (oldData.countDown + 1 == newData.countDown) {
      playDownSound();
    }
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
