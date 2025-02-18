import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

/// BRAR指标，也称为人气意愿指标或能量指标，由两个部分组成：AR（人气指标）和BR（意愿指标）。
/// 这两个指标都是基于历史股价分析来反映市场多空双方力量的对比。以下是它们各自的计算方法：
///
/// AR（人气指标）的计算方法
/// AR指标通过比较一段周期内的开盘价在该周期价格中的高低，来反映市场买卖人气。
/// 以日为计算周期，计算公式如下：
/// N日AR = (N日内(H - O)之和 / N日内(O - L)之和) × 100
/// 其中：
/// H：当日最高价
/// L：当日最低价
/// O：当日开盘价
/// N：设定的时间参数，通常默认设置为26日
/// 此公式反映了从开盘到最高价之间的距离（看多者追高的气势）与从开盘到最低价之间的距离（看空者杀低的气势）的比例关系。
///
/// BR（意愿指标）的计算方法
/// BR指标通过比较一段周期内的收盘价在该周期价格波动中的地位，来反映市场买卖意愿程度。
/// 以日为计算周期，计算公式如下：
/// N日BR = N日内(H - CY)之和 / N日内(CY - L)之和
/// 其中：
/// H：当日最高价
/// L：当日最低价
/// CY：前一交易日的收盘价
/// N：设定的时间参数，通常也是26日
/// H - CY 表示当前周期内愿意追高的力量，CY - L 则表示愿意卖出的力量。
///
/// 使用原则
/// 1. 当 BR < AR，且 BR < 100 时，可以考虑逢低买进。
/// 2. 当 BR < AR，而 AR < 50 时，是买入信号。
/// 3. 如果 AR 和 BR 同时急剧上升，意味着股价接近顶部，持股者应考虑获利了结。
/// 4. 当 BR 急剧上升而 AR 处于盘整或小幅回落时，应该逢高卖出。
/// 这些规则有助于投资者识别市场的超买或超卖状态，并据此作出投资决策。
///
/// 注意：实际应用中，多数金融软件或交易平台会自动计算并显示这些指标值。
/// 了解公式背后的逻辑，有助于更好地理解和运用这些技术分析工具。

void calcBRAR(final List<Map<String, String?>> arr,
    {final int brarPeriod = 26}) {
  final List<double> highList = [];
  final List<double> lowList = [];
  final List<double> openList = [];
  final List<double> closeList = [];

  final List<double> hoList = [];
  final List<double> olList = [];
  for (int i = 0; i < arr.length; i++) {
    double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    double openToday = double.parse(arr[i][FieldName.open] ?? '0');
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    highList.add(highToday);
    lowList.add(lowToday);
    openList.add(openToday);
    closeList.add(closeToday);

    hoList.add(highToday - openToday);
    olList.add(openToday - lowToday);
  }
  final List<double> hPrevCList = [];
  final List<double> prevCLList = [];
  hPrevCList.add(0);
  prevCLList.add(0);
  for (int i = 1; i < arr.length; i++) {
    hPrevCList.add(highList[i] - closeList[i - 1]);
    prevCLList.add(closeList[i - 1] - lowList[i]);
  }

  final List<double> hPrevCSumList =
      calcSUM(calcMAX(0, hPrevCList), brarPeriod);
  final List<double> prevCLSumList =
      calcSUM(calcMAX(0, prevCLList), brarPeriod);
  for (int i = 0; i < arr.length; i++) {
    if (prevCLSumList[i] == 0) {
      arr[i][FieldName.br] = '0';
      continue;
    }
    arr[i][FieldName.br] =
        (hPrevCSumList[i] / prevCLSumList[i] * 100).toStringAsFixed(2);
  }

  final List<double> hoSumList = calcSUM(hoList, brarPeriod);
  final List<double> olSumList = calcSUM(olList, brarPeriod);

  for (int i = 0; i < arr.length; i++) {
    if (olSumList[i] == 0) {
      arr[i][FieldName.ar] = '0';
      continue;
    }
    arr[i][FieldName.ar] =
        (hoSumList[i] / olSumList[i] * 100).toStringAsFixed(2);
  }
}

void main() {
  // 示例数据（每个字典代表一天的交易数据）
  List<Map<String, String?>> priceData = [];
  weekDataStr
      .split(';')
      .where((element) => element.isNotEmpty)
      .forEach((element) {
    List<String> strs = element.split(',');
    priceData.add({
      FieldName.date: strs[0].trim(),
      FieldName.vol: strs[1].trim(),
      FieldName.open: strs[2].trim(),
      FieldName.high: strs[3].trim(),
      FieldName.low: strs[4].trim(),
      FieldName.close: strs[5].trim(),
    });
  });

  calcBRAR(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} br: ${priceData[i][FieldName.br]} ar: ${priceData[i][FieldName.ar]}");
  }
}

// class IndicatorBRAR {
//   List<Map<String, dynamic>> DEFAULT_ARR = [
//     {"v": 26, "color": "#E297FF", "prop": "br", "idct": "BR"},
//     {"color": "#666666", "prop": "ar", "idct": "AR"}
//   ];
//
//   String name = "BRAR";
//   Map<String, dynamic> vaObj = {"glv": 150};
//   List<Map<String, dynamic>> customArr;
//   List<dynamic> oriArr;
//   List<dynamic> datas = [];
//   List<Map<String, dynamic>> selfArr = [];
//
//   IndicatorBRAR(i, r) {
//     // Assuming 'a.call(this, i, r)' is a constructor call or initialization.
//     // In Dart, you would typically initialize members directly or through an init function.
//
//     // Placeholder for the actual logic that might be in 'a.call'
//   }
//
//   void initAndCalcAll(List<dynamic> i) {
//     var customArr = this.customArr;
//     int r = customArr.isNotEmpty ? customArr[0]['v'] : 26; // Default value if customArr is empty
//
//     var n = getArr(i, "high");
//     var c = getArr(i, "close");
//     var f = getArr(i, "open");
//     var d = getArr(i, "low");
//
//     var u = calcREF(c, 1);
// var A = operateArr(operateArr(calcSUM(operateArr(n, u, "-"), r), calcSUM(operateArr(u, d, "-"), r), "/"), 100, "*");
// var p = operateArr(operateArr(calcSUM(operateArr(n, f, "-"), r), calcSUM(operateArr(f, d, "-"), r), "/"), 100, "*");
//
//     oriArr = i;
//     if (datas.isEmpty) {
//       datas = [];
//     }
//     selfArr.clear();
//
//     for (int v = 0; v < i.length; v++) {
//       selfArr.add({
//         "br": A[v],
//         "ar": p[v]
//       });
//     }
//   }
//
//   // Placeholder functions for those used but not defined in the snippet.
//   // These need to be implemented according to their actual logic.
//   dynamic getArr(List<dynamic> arr, String prop) => null;
//   dynamic calcREF(List<dynamic> arr, int period) => null;
//   dynamic calcSUM(List<dynamic> arr, int period) => null;
//   dynamic calcMAX(int a, List<dynamic> arr) => null;
//   dynamic operateArr(dynamic arr1, dynamic arr2, String op, [dynamic factor]) => null;
// }
