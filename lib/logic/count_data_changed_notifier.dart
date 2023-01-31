import 'package:flutter/material.dart';
import 'package:riverpod_countup/data/count_data.dart';

// 条件式用の関数
typedef ValueChangedCondition = bool Function(
    CountData oldValue, CountData newValue);

abstract class CountDataChangedNotifier {
  void valueChanged(CountData oldValue, CountData newValue);
}
