import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/logic/count_data_changed_notifier.dart';

import '../data/count_data.dart';

class ButtonAnimationLogic with CountDataChangedNotifier {
  // アニメーションの開始終了などを管理
  late AnimationController _animationController;
  // アニメーションのスケールを管理
  late Animation<double> _animationScale;
  // アニメーションの回転を管理
  late Animation<double> _animationRotation;
  late AnimationCombination _animationCombination;

  get animationCombination => _animationCombination;

  ValueChangedCondition startCondition;

  /// コンストラクタ。インスタンス生成時に実行。
  /// どのWidgetに対してアニメーションを行うか引数で渡す。StatefulWidgetを渡す。
  ButtonAnimationLogic(TickerProvider tickerProvider, this.startCondition) {
    _animationController = AnimationController(
        // アニメーションの期間
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 500));
    _animationScale = _animationController
        // 500milisecondsの内の10%~70%の間にアニメーションする
        .drive(CurveTween(curve: const Interval(0.1, 0.7)))
        // 2倍の大きさになってアニメーションが終了する
        .drive(Tween(begin: 1.0, end: 1.8));
    _animationRotation = _animationController
        // 500milisecondsの内の10%~70%の間にアニメーションする
        .drive(
            CurveTween(curve: Interval(0.4, 0.8, curve: ButtonRotateCurve())))
        // 2倍の大きさになってアニメーションが終了する
        .drive(Tween(begin: 0.0, end: 1.0));
    _animationCombination =
        AnimationCombination(_animationScale, _animationRotation);
  }

  /// インスタンスが消える際に実行される
  /// アニメーションのインスタンス生成時に作成したAnimationControllerを削除することでメモリリークを防ぐ
  @override
  void dispose() {
    _animationController.dispose();
  }

  /// アニメーション実行時に認識
  /// アニメーション終了時にコントローラーをリセットすることで1.8倍になったスケールをリセットする。
  void start() {
    _animationController
        .forward()
        .whenComplete(() => _animationController.reset());
  }

  // @overrideで親クラスにあることを示す
  @override
  void valueChanged(CountData oldValue, CountData newValue) {
    // oldValueとnewValueを渡してtrueだった場合は実行
    if (startCondition(oldValue, newValue)) {
      start();
    }
  }
}

// 回転アニメーションの調整をするクラス
class ButtonRotateCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(2 * math.pi * t) / 16;
  }
}

// スケールと回転のアニメーションを管理する。新しくアニメーションを追加したい場合は新たに変数と引数を加える。
class AnimationCombination {
  // アニメーションのスケールを管理
  final Animation<double> animationScale;
  // アニメーションの回転を管理
  final Animation<double> animationRotation;

  AnimationCombination(this.animationScale, this.animationRotation);
}
