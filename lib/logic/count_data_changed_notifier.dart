import 'package:riverpod_countup/data/count_data.dart';

abstract class CountDataChangedNotifier {
  void valueChanged(CountData oldValue, CountData newValue);
}
