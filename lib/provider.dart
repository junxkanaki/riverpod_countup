import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/count_data.dart';

final titleProvider = Provider<String>((ref) {
  return 'Riverpod Demo Home Page';
});

final messageProvider = Provider<String>((ref) => 'Body message');

// 型を指定することでオブジェクト型などの場合は、補完などが利いて便利なので型をかいた方が良き
final countProvider = StateProvider<int>((ref) => 0);

final countDataProvider = StateProvider<CountData>(
    (ref) => CountData(count: 0, countUp: 0, countDown: 0));
