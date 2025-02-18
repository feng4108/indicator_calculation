import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

/// 乖离率（BIAS）是技术分析中的一种指标，它用来衡量价格与移动平均线之间的偏离程度。
/// 通过计算乖离率，投资者可以判断当前的价格是否远离了其长期或短期的趋势，从而预测未来可能的价格回调或反弹。
///
/// 乖离率的计算方法相对直接，主要基于收盘价与某一周期的移动平均价之间的差异百分比。具体的计算公式如下：
///
/// BIAS=(当日收盘价−N日移动平均价)/N日移动平均价×100%
///
/// 这里，当日收盘价指的是股票在交易日结束时的价格。
/// N日移动平均价是指过去N天内的收盘价的算术平均值。
/// 这里的N可以根据需要选择不同的天数，如6日、12日、24日等，分别用于短期、中期和长期趋势的分析
void calcBIAS(final List<Map<String, String?>> arr,
    {final int bias1Period = 6,
    final int bias2Period = 12,
    final int bias3Period = 24}) {
  // 从数据中获取收盘价数组
  final List<double> closeList = [];
  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
  }
  final List<double> ma1List = calcMA(closeList, bias1Period);
  final List<double> ma2List = calcMA(closeList, bias2Period);
  final List<double> ma3List = calcMA(closeList, bias3Period);
  for (int i = 0; i < arr.length; i++) {
    double bias1 = (closeList[i] - ma1List[i]) / ma1List[i] * 100;
    arr[i][FieldName.bias1] = bias1.toStringAsFixed(2);
    double bias2 = (closeList[i] - ma2List[i]) / ma2List[i] * 100;
    arr[i][FieldName.bias2] = bias2.toStringAsFixed(2);
    double bias3 = (closeList[i] - ma3List[i]) / ma3List[i] * 100;
    arr[i][FieldName.bias3] = bias3.toStringAsFixed(2);
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

  calcBIAS(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} bias1: ${priceData[i][FieldName.bias1]} bias2: ${priceData[i][FieldName.bias2]} bias3: ${priceData[i][FieldName.bias3]}");
  }
}
