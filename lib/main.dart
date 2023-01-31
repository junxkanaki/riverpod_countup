import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_countup/provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Consumer(
          builder: (context, ref, child) => Text(ref.watch(titleProvider)),
        )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer(
                  builder: (context, ref, child) =>
                      Text(ref.watch(titleProvider))),
              Consumer(
                  builder: (context, ref, child) => Text(
                        ref.watch(countProvider).toString(),
                        style: Theme.of(context).textTheme.headline4,
                      )),
            ],
          ),
        ),
        floatingActionButton: Consumer(
          builder: (context, ref, child) => FloatingActionButton(
            // readは状態変更でWidgetwを更新しない
            onPressed: () => ref.read(countProvider.notifier).state++,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
