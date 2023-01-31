import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/logic/button_animation_logic.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';
import 'package:riverpod_countup/logic/logic.dart';
import 'package:riverpod_countup/provider.dart';

import 'logic/sound_logic.dart';

class ViewModel {
  Logic _logic = Logic();

  SoundLogic _soundLogic = SoundLogic();

  // ViewのStatefulWidgetの値を渡すことで初期化可能なのでlate
  late ButtonAnimationLogic _buttonAnimationLogicPlus;

  // Riverpodにアクセスできる。外部から参照しないのでプライベート。
  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  // setRefで外から渡す。
  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;

    // 音声ファイルをキャッシュに入れる
    _soundLogic.load();
    _buttonAnimationLogicPlus = ButtonAnimationLogic(tickerProvider);

    notifiers = [_soundLogic, _buttonAnimationLogicPlus];
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  // 現在のアニメーションの倍率を取得
  get animationPlus => _buttonAnimationLogicPlus.animationScale;

  void onIncrease() {
    _logic.increase();
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();
    update();
  }

  void update() {
    CountData oldValue = _ref.watch(countDataProvider.notifier).state;
    _ref.watch(countDataProvider.notifier).state = _logic.countData;
    CountData newValue = _ref.watch(countDataProvider.notifier).state;
    // 音とアニメーションの起点を同じにする
    // _soundLogic.valueChanged(oldValue, newValue);
    // _buttonAnimationLogicPlus.valueChanged(oldValue, newValue);
    // ポリモーフィズムを使用しなければ67行目のコードをマイナス、リセットごとに追加しなけばならくなる
    // ポリモーフィズムを使用することで33行目にロジックを追加するだけでよくなる。
    notifiers.forEach((element) => element.valueChanged(oldValue, newValue));
  }
}
