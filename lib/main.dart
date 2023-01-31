import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // refはConsumerStateに含まれている。Consumerを使用する際はbuildの引数にrefが必要。
        title: Text(ref.watch(titleProvider)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ref.watch(titleProvider)),
            Text(
              // データクラスであるCountDataをStateProviderで管理し、カウンター値をcountDataProviderを通じて取得
              ref.watch(countDataProvider).count.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    // CountData countData =
                    //     ref.read(countDataProvider.notifier).state;
                    // ref.read(countDataProvider.notifier).state =
                    //     countData.copyWith(
                    //         count: countData.count + 1,
                    //         countUp: countData.countUp + 1);
                    // stateで現在の値を取得し、それに対して値を変更し、providerのstateを変更する
                    ref.watch(countDataProvider.notifier).update((state) =>
                        state.copyWith(
                            count: state.count + 1,
                            countUp: state.countUp + 1));
                  },
                  child: const Icon(CupertinoIcons.plus),
                ),
                FloatingActionButton(
                  onPressed: () {
                    // CountData countData =
                    //     ref.read(countDataProvider.notifier).state;
                    // ref.read(countDataProvider.notifier).state =
                    //     countData.copyWith(
                    //         count: countData.count - 1,
                    //         countDown: countData.countDown + 1);
                    ref.watch(countDataProvider.notifier).update((state) =>
                        state.copyWith(
                            count: state.count - 1,
                            countDown: state.countDown + 1));
                  },
                  child: const Icon(CupertinoIcons.minus),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Text(ref.watch(countDataProvider).countUp.toString()),
                // Selectを使用してWidgetの再構築を抑える
                Text(ref
                    .watch(countDataProvider.select((value) => value.countUp))
                    .toString()),
                // Text(ref.watch(countDataProvider).countDown.toString()),
                Text(ref
                    .watch(countDataProvider.select((value) => value.countDown))
                    .toString()),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.watch(countDataProvider.notifier).state =
              const CountData(count: 0, countUp: 0, countDown: 0);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
