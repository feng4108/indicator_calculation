import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///DMA（Different of Moving Average）指标，中文通常称为平行线差指标，是一种用于判断中短期股票价格趋势的技术分析工具。
///它基于两条不同周期的移动平均线之间的差异来评估市场的买卖能量和未来的价格走势。
///
/// DMA指标的计算步骤如下：
///
/// 1、计算短期移动平均值：选择一个较短的时间周期，例如10天。计算这段时间内每日收盘价的简单移动平均值（SMA），记作SMA_short。
///
/// 2、计算长期移动平均值：选择一个较长的时间周期，例如50天。同样地，计算这段时间内每日收盘价的简单移动平均值，记作SMA_long。
///
/// 3、计算DMA值：DMA = SMA_short - SMA_long
///
/// 4、计算DMA的移动平均值（AMA）：取DMA值的一个特定周期的移动平均值，比如10天，作为AMA值。
///
/// 指标形态：
///
///   **多头排列**：当 DMA 线在 AMA 线之上，且两条线都向上运行时，形成多头排列，表明股价处于上升趋势，短期上涨动力较强，是多头力量占优的信号。
///
///   **空头排列**：若 DMA 线在 AMA 线之下，且两条线都向下运行，为空头排列，意味着股价处于下跌趋势，空头力量占据主导，此时市场看空情绪较浓。

void calcDMA(final List<Map<String, String?>> arr,
    {final int shortPeriod = 10,
    final int longPeriod = 50,
    final int amaPeriod = 10}) {
  final List<double> closeList = [];

  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
  }
  final List<double> shortMaList = calcMA(closeList, shortPeriod);
  final List<double> longMaList = calcMA(closeList, longPeriod);

  final List<double> dmaList = [];
  for (int i = 0; i < arr.length; i++) {
    final double dma = shortMaList[i] - longMaList[i];
    dmaList.add(dma);
    arr[i][FieldName.dmaDif] = dma.toStringAsFixed(2);
  }
  final List<double> amaList = calcMA(dmaList, amaPeriod);
  for (int i = 0; i < arr.length; i++) {
    final double ama = amaList[i];
    arr[i][FieldName.dmaDifMa] = ama.toStringAsFixed(2);
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

  calcDMA(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} DIF: ${priceData[i][FieldName.dmaDif]} AMA: ${priceData[i][FieldName.dmaDifMa]}");
  }
}
