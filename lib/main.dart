import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/data/count_data.dart';
import 'package:riverpod_countup/provider.dart';
import 'package:riverpod_countup/view_model.dart';

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
      home: MyHomePage(ViewModel()),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  final ViewModel viewModel;
  const MyHomePage(this.viewModel, {Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

// TickerProviderStateMixinはアニメーションを使用する宣言
class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  late ViewModel _viewModel;

  // initState()はConsumerやConsumerWidgetでは使用不可のためrefを渡す際は不便
  // ConsumerStatefulWidgetはinitState()を使用できるので最初にrefを渡すことができる
  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    // refはConsumerStateに含まれている。
    _viewModel.setRef(ref, this);
  }

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
            Text(ref.watch(messageProvider)),
            Text(
              _viewModel.count,
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _viewModel.onIncrease();
                  },
                  child: ScaleTransition(
                    scale: _viewModel.animationPlus,
                    child: RotationTransition(
                        turns: _viewModel.animationPlusRotation,
                        child: const Icon(CupertinoIcons.plus)),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _viewModel.onDecrease();
                  },
                  child: ScaleTransition(
                    scale: _viewModel.animationMinus,
                    child: const Icon(CupertinoIcons.minus),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(_viewModel.countUp),
                Text(_viewModel.countDown),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _viewModel.onReset();
        },
        child: ScaleTransition(
          scale: _viewModel.animationReset,
          child: const Icon(CupertinoIcons.refresh),
        ),
      ),
    );
  }
}
