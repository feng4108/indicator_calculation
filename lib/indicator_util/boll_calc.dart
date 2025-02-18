import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

/// 布林线（Bollinger Bands，简称BOLL）是由约翰·布林格（John Bollinger）在1980年代提出的一种技术分析工具。它基于统计学中的标准差原理设计，用来衡量市场的波动性和价格走势。以下是计算布林线的基本步骤和公式：
///
/// 计算步骤
/// 选择周期N：通常使用20天作为标准的计算周期，但可以根据需要调整。
///
///中轨线=N日的移动平均线
/// 确定上下轨线：
/// 上轨线（UP）是在中轨线上方加上两倍的标准差：UP=MB+2×SD
/// 下轨线（DN）是在中轨线下方减去两倍的标准差：DOWN=MB−2×SD
void calcBOLL(final List<Map<String, String?>> arr,
    {final int bollPeriod = 20, final int param = 2}) {
  // 从数据中获取收盘价数组
  final List<double> closeList = [];
  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');

    closeList.add(closeToday);
  }
  final List<double> maList =  calcMA(closeList, bollPeriod);
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

  calcBOLL(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} wr1: ${priceData[i][FieldName.wr1]} wr2: ${priceData[i][FieldName.wr2]}");
  }
}
