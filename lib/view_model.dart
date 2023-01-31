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
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  // Riverpodにアクセスできる。外部から参照しないのでプライベート。
  late WidgetRef _ref;

  List<CountDataChangedNotifier> notifiers = [];

  // setRefで外から渡す。
  void setRef(WidgetRef ref, TickerProvider tickerProvider) {
    this._ref = ref;

    // インスタンス作成時に条件分岐する
    // ①外で宣言する方法
    ValueChangedCondition conditionPlus =
        (CountData oldValue, CountData newValue) {
      return oldValue.countUp + 1 == newValue.countUp;
    };
    _buttonAnimationLogicPlus =
        ButtonAnimationLogic(tickerProvider, conditionPlus);
    // ②引数内に直接関数を渡す方法
    _buttonAnimationLogicMinus = ButtonAnimationLogic(tickerProvider,
        (CountData oldValue, CountData newValue) {
      return oldValue.countDown + 1 == newValue.countDown;
    });
    // ③アロー関数で引数内に直接渡す方法
    _buttonAnimationLogicReset = ButtonAnimationLogic(
        tickerProvider,
        (oldValue, newValue) =>
            newValue.countUp == 0 && newValue.countDown == 0);

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset
    ];

    // 音声ファイルをキャッシュに入れる
    _soundLogic.load();
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp =>
      _ref.watch(countDataProvider.select((value) => value.countUp)).toString();
  get countDown => _ref
      .watch(countDataProvider.select((value) => value.countDown))
      .toString();

  // 現在のアニメーションの倍率を取得
  get animationPlus => _buttonAnimationLogicPlus.animationScale;
  get animationMinus => _buttonAnimationLogicMinus.animationScale;
  get animationReset => _buttonAnimationLogicReset.animationScale;

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
