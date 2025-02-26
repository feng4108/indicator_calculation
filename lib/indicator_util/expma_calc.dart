import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///EXPMA（Exponential Moving Average，指数移动平均线）是一种技术分析工具，
///它赋予近期价格更高的权重，因此对价格变动的反应比简单移动平均线（SMA）更快。

void calcEXPMA(final List<Map<String, String?>> arr,
    {final List<int> periods = const [12,50]}) {
  final List<double> closeList = [];
  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
  }
  for (int period in periods) {
    final List<double>  list = calcEMA(closeList, period);
    for (int i = 0; i < arr.length; i++) {
      arr[i]['${FieldName.expma}$period'] = list[i].toStringAsFixed(2);
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

  calcEXPMA(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} expma12: ${priceData[i]['${FieldName.expma}12']}, expma50: ${priceData[i]['${FieldName.expma}50']}");
  }
}
