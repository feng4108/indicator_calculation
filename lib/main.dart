import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:promote_ma_calc/procotol_constant.dart';
import 'package:promote_ma_calc/sz000002.dart';

import 'data_update_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // static Future<int> _incrementCounter(String json) async {
  //   DateTime now = DateTime.now();
  //   List list = jsonDecode(json);
  //
  //   List<Map<String, dynamic>> newList = [];
  //   for (var element in list) {
  //     Map<String, dynamic> item = Map.from(element);
  //     item[FieldName.close + keySuffix] =
  //         double.parse(item[FieldName.close] ?? '0');
  //     item[FieldName.open + keySuffix] =
  //         double.parse(item[FieldName.open] ?? '0');
  //     item[FieldName.vol + keySuffix] =
  //         double.parse(item[FieldName.vol] ?? '0');
  //     item[FieldName.turnover + keySuffix] =
  //         double.parse(item[FieldName.turnover] ?? '0');
  //     newList.add(item);
  //   }
  //   List<Map<String, dynamic>> newList2 = [...newList, ...newList];
  //   print(
  //       '${newList2.length}个数据，读取耗时：${DateTime.now().difference(now).inMilliseconds}毫秒');
  //   now = DateTime.now();
  //   await DateUpdateUtil.calcMaAndChangeRatio(newList2);
  //   int _counter = DateTime.now().difference(now).inMilliseconds;
  //   print('${newList2.length}个数据，计算耗时：$_counter毫秒');
  //   return _counter;
  // }

  static Future<int> _wkProcess(List<String> json) async {
    DateTime now = DateTime.now();

    List<Map<String, dynamic>> newList = [];
    for (var element in json) {
      List<String>  strs = element.split(',');
      Map<String, dynamic> item = {
        FieldName.date:strs[0],
        FieldName.open:strs[1],
        FieldName.close:strs[2],
        FieldName.high:strs[3],
        FieldName.low:strs[4],
        FieldName.vol:strs[6],
        FieldName.turnover:strs[7],
        FieldName.change:strs[8],
        FieldName.changeRatio:strs[9],
      };
      item[FieldName.close + keySuffix] =
          double.parse(item[FieldName.close] ?? '0');
      item[FieldName.open + keySuffix] =
          double.parse(item[FieldName.open] ?? '0');
      item[FieldName.vol + keySuffix] =
          double.parse(item[FieldName.vol] ?? '0');
      item[FieldName.turnover + keySuffix] =
          double.parse(item[FieldName.turnover] ?? '0');
      newList.add(item);
    }
    List<Map<String, dynamic>> newList2 = [...newList];
    print(
        '${newList2.length}个数据，读取耗时：${DateTime.now().difference(now).inMilliseconds}毫秒');
    now = DateTime.now();
    await DateUpdateUtil.calcMaAndChangeRatio(newList2.sublist(0,240));
    int _counter = DateTime.now().difference(now).inMilliseconds;
    print('${newList2.length}个数据，计算耗时：$_counter毫秒');
    return _counter;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              _counter.toString(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(double.parse('120'));
          DateTime now = DateTime.now();
          String json = await DefaultAssetBundle.of(context)
              .loadString('assets/1_data.json');
          print('文件读取耗时：${DateTime.now().difference(now).inMilliseconds}毫秒');
          await _wkProcess(wkDatas.reversed.toList());
          _counter = DateTime.now().difference(now).inMilliseconds;
          print('总耗时：$_counter毫秒');
          if (mounted) {
            setState(() {});
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
