import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///CCI（Commodity Channel Index，商品通道指数）是一种技术分析工具，主要用于识别周期性的高点和低点，
///从而帮助判断市场趋势。它由Donald Lambert在1980年开发，并广泛应用于股票、期货等交易市场。
///
/// ### CCI的计算方法
///
/// CCI指标的计算分为以下几个步骤：
///
/// 1. **典型价格(Typical Price)**：对于每个时间段（如日、周等），计算出该时期的典型价格，
/// 这是最高价(High)、最低价(Low)与收盘价(Close)的平均值。
///
///    典型价格 = (最高价 + 最低价 + 收盘价) / 3
///
/// 2. **简单移动平均（Simple Moving Average of Typical Prices, SMATP）**：计算特定周期n天内的典型价格的简单移动平均。
///
///    简单移动平均 = 特定周期n天内典型价格的总和 / n
///
/// 3. **平均绝对偏差（Mean Deviation）**：计算每个时期典型价格与其n周期的SMATP之间的绝对偏差的平均值。
///
///    平均绝对偏差 = 特定周期n天内|典型价格 - 简单移动平均|的总和 / n
///
/// 4. **CCI计算**：最后一步是将这些信息结合起来计算CCI。公式如下：
///
///    CCI = (典型价格 - 简单移动平均) / (0.015 * 平均绝对偏差)
///
///    这里的常数0.015是为了确保大约70 - 80%的时间内CCI值位于+100到-100之间。
///
/// ### 使用说明
/// - 当CCI高于+100时，表示可能处于超买状态，市场可能过热，有回调风险。
/// - 当CCI低于-100时，表示可能处于超卖状态，市场可能被低估，有反弹机会。
///
/// 请注意，虽然CCI是一个非常有用的工具，但它应与其他技术分析工具结合使用，以获得更准确的市场预测。
/// 此外，不同市场和不同资产类别的最佳参数（即周期n）可能会有所不同，通常默认为20天。

void calcCCI(final List<Map<String, String?>> arr,
    {final int cciPeriod = 14, final double param = 0.015}) {
  final List<double> highList = [];
  final List<double> lowList = [];
  final List<double> closeList = [];

  final List<double> typicalPriceList = [];
  for (int i = 0; i < arr.length; i++) {
    double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    highList.add(highToday);
    lowList.add(lowToday);
    closeList.add(closeToday);

    typicalPriceList.add((highToday + lowToday + closeToday) / 3);
  }
  final List<double> maList = calcMA(typicalPriceList, cciPeriod);
  final List<double> avedevList =
      calcRollingAVEDEV(typicalPriceList, cciPeriod);

  for (int i = 0; i < arr.length; i++) {
    final double avedev = avedevList[i];
    final double ma = maList[i];
    final double typicalPrice = typicalPriceList[i];
    if(avedev == 0){
      arr[i][FieldName.cci] = '0';
      continue;
    }
    final double cci = (typicalPrice - ma) / (param * avedev);
    arr[i][FieldName.cci] = cci.toStringAsFixed(2);
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

  calcCCI(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} cci: ${priceData[i][FieldName.cci]}");
  }
}
