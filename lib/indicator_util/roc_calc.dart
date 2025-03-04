import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///ROC（Rate of Change）指标，即变动率指标，是技术分析中的一种动量指标，用于衡量价格的变化速度。
///它通过比较当前的价格与过去某个时间点的价格来计算价格变化的百分比，以此帮助交易者判断市场趋势和可能的反转点。
///
/// ROC指标的计算方法
///
/// 1、选择一个时间周期：首先需要确定一个时间周期n，这个周期可以是天、周等，具体取决于你的分析需求。
/// 例如，如果你使用的是日线图，且希望计算过去14天的价格变动率，那么n=14。
///
/// 2、获取价格数据：通常使用收盘价进行计算，但也可以根据分析需求选用开盘价、最高价或最低价。
///
/// 应用公式： ROC = (今日收盘价 - n日前的收盘价) / n日前的收盘价 * 100 或者更简洁地表示为：
/// ROC = (P - P_n) / P_n * 100 其中，P代表当前价格，P_n代表n天前的价格。
/// 这个公式的含义是计算从n天前到今天的价格变化百分比。结果可能是正值也可能是负值，正值表示价格上涨，负值表示价格下跌。

void calcROC(final List<Map<String, String?>> arr,
    {final int rocPeriod = 12, final int maRocPeriod = 6,}) {
  if(arr.isEmpty){
    return;
  }
  final List<double> closeList = [];

  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
  }

  final List<double> pastCloseList = calcREF(closeList, rocPeriod);
  final List<double> rocList = [];
  for (int i = 0; i < arr.length; i++) {
    double closeToday = closeList[i];
    double closePast = pastCloseList[i];
    if(closePast == 0) {
      rocList.add(0);
      continue;
    }
    double roc = ((closeToday - closePast) / closePast) * 100;
    rocList.add(roc);
  }
  final List<double> maRocList = calcMA(rocList, maRocPeriod);
  for (int i = 0; i < arr.length; i++) {
    double roc = rocList[i];
    double maRoc = maRocList[i];
    arr[i][FieldName.roc] = roc.toStringAsFixed(2);
    arr[i][FieldName.maRoc] = maRoc.toStringAsFixed(2);
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

  calcROC(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} roc: ${priceData[i][FieldName.roc]}, maRoc: ${priceData[i][FieldName.maRoc]}");
  }
}
