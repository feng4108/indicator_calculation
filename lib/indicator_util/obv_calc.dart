import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///OBV（On-Balance Volume，平衡交易量）指标是一种技术分析工具，通过累计每日的成交量来反映市场资金流向的变化，
///以此预测股价变动趋势。其计算方法相对简单，主要基于一个核心理念：成交量是股票价格变动的主要驱动力。
///以下是OBV的基本计算步骤：
///
/// 1. **初始值设定**：选择一个起始日期，并将该日期的OBV值设定为某个固定数值（通常为0或当日的成交量）。
///
/// 2. **计算每日OBV变化**：
///
///    - 如果当天的收盘价高于前一天的收盘价，则当天的OBV值等于前一天的OBV值加上当天的成交量。
///    - 如果当天的收盘价低于前一天的收盘价，则当天的OBV值等于前一天的OBV值减去当天的成交量。
///    - 如果当天的收盘价与前一天相同，则当天的OBV值等于前一天的OBV值不变。
///
/// 用公式表示就是：
///
/// - 当今日收盘价 > 昨日收盘价时，OBV = 前一日OBV + 今日成交量
///
/// - 当今日收盘价 < 昨日收盘价时，OBV = 前一日OBV - 今日成交量
///
/// - 当今日收盘价 = 昨日收盘价时，OBV = 前一日OBV
///
/// 3. **绘制OBV曲线**：根据上述规则计算出一系列OBV值后，可以将这些值绘制成图表，
/// 以便观察其走势以及与股价之间的关系。
void calOBV(final List<Map<String, String?>> arr, {final int obvPeriod = 30}) {
  if (arr.isEmpty) {
    return;
  }
  final List<double> closeList = [];
  final List<double> volList = [];
  final List<double> obvList = [];
  num s = 0, a = 0, r = 0;
  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    double volToday = double.parse(arr[i][FieldName.vol] ?? '0');
    closeList.add(closeToday);
    volList.add(volToday);

    if (i > 0) {
      s = closeToday > closeList[i - 1]
          ? volToday
          : (closeToday == closeList[i - 1] ? 0 : -volToday);
      a = s + obvList[i - 1];
      arr[i][FieldName.obv] = a.toStringAsFixed(2);
      obvList.add(a.toDouble());
      r += a;
      if (i >= obvPeriod) {
        r = r - obvList[i - obvPeriod];
        arr[i][FieldName.maObv] = (r / obvPeriod).toStringAsFixed(2);
      } else {
        arr[i][FieldName.maObv] = (r / (i + 1)).toStringAsFixed(2);
      }
    } else {
      s = volToday;
      a = s;
      r = a;
      arr[i][FieldName.obv] = s.toStringAsFixed(2);
      arr[i][FieldName.maObv] = a.toStringAsFixed(2);
      obvList.add(s.toDouble());
    }
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

  calOBV(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} OBV: ${priceData[i][FieldName.obv]}, MAOBV: ${priceData[i][FieldName.maObv]}");
  }
}
