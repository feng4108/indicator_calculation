import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

/// 威廉指标（Williams %R，简称WR或W%R）是一种技术分析工具，用于衡量市场在特定周期内的超买或超卖状态。
/// 它是由Larry Williams于1973年首次提出的，并被广泛应用于股票、期货和外汇市场的技术分析中。
/// 威廉指标的计算方法基于最高价、最低价以及收盘价之间的关系，具体公式如下：
///
/// 𝑊𝑅=100×(HHV−Close)/(HHV−LLV)
///
/// 这里，HHV 表示在选定的时间周期内（例如10天）的最高价。
/// LLV 表示在同一时间周期内的最低价。
/// Close 是指当前周期的收盘价。
///
/// 根据这个公式，如果当前的收盘价接近周期内的最高价，则WR值将趋向于0；
/// 如果收盘价接近周期内的最低价，则WR值将趋向于100。
/// 这意味着WR值越低，表示市场越可能处于超买状态，而WR值越高则表明市场可能处于超卖状态
void calcWR(final List<Map<String, String?>> arr,
    {final int wr1Period = 10, final int wr2Period = 6}) {
  if(arr.isEmpty){
    return;
  }
  // 从数据中获取收盘价数组
  final List<double> closeList = [];
  // 从数据中获取最高价数组
  final List<double> highList = [];
  // 从数据中获取最低价数组
  final List<double> lowList = [];
  for (int i = 0; i < arr.length; i++) {
    double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');

    closeList.add(closeToday);
    highList.add(highToday);
    lowList.add(lowToday);
  }
  final List<double> hhpList = calcHHV(highList, wr1Period);
  final List<double> llpList = calcLLV(lowList, wr1Period);
  for (int i = 0; i < hhpList.length; i++) {
    if(hhpList[i] - llpList[i]==0){
      arr[i][FieldName.wr1] = '0';
      continue;
    }
    double wr1 =
        100 * (hhpList[i] - closeList[i]) / (hhpList[i] - llpList[i]);
    arr[i][FieldName.wr1] = wr1.toStringAsFixed(2);
  }
  final List<double> hhpList2 = calcHHV(highList, wr2Period);
  final List<double> llpList2 = calcLLV(lowList, wr2Period);
  for (int i = 0; i < hhpList2.length; i++) {
    if(hhpList2[i] - llpList2[i]==0){
      arr[i][FieldName.wr2] = '0';
      continue;
    }
    double wr2 =
        100 * (hhpList2[i] - closeList[i]) / (hhpList2[i] - llpList2[i]);
    arr[i][FieldName.wr2] = wr2.toStringAsFixed(2);
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

  calcWR(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} wr1: ${priceData[i][FieldName.wr1]} wr2: ${priceData[i][FieldName.wr2]}");
  }
}
