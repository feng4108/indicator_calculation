import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///EMV（Ease of Movement Value）指标，中文称为简易波动指标。它结合了价格变动和成交量，
///用来衡量价格变动的难易程度。计算步骤大致如下：
///
/// 计算中间价的变化：中间价的变化 = 今天的中间价（最高价+最低价）- 昨天的中间价。
///
/// 计算Box Ratio：成交量  / （最高价 - 最低价）
///
/// EMV值：中间价的变化除以Box Ratio
///
/// 通常会对EMV进行移动平均，比如14天的周期，得到EMV的均线。

void calcEMV(final List<Map<String, String?>> arr,
    {final int period = 14, final int period2 = 9}) {
  final List<double> volList = [];
  final List<double> midList = [];
  final List<double> midChangeList = [];
  //当天的价格变化
  final List<double> todayChangeList = [];

  for (int i = 0; i < arr.length; i++) {
    final double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    final double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    final double volToday = double.parse(arr[i][FieldName.vol] ?? '0');
    volList.add(volToday);
    //今天的中间价
    final double midToday = (highToday + lowToday);
    midList.add(midToday);
    final double midPrev = i > 0 ? midList[i - 1] : midToday;
    //计算中间价的变化
    final double midChange = (midToday - midPrev) * 100 / midToday;
    midChangeList.add(midChange);
    todayChangeList.add(highToday - lowToday);
  }
  final List<double> emaVolList = calcMA(volList, period);
  final List<double> emaTodayChangeList = calcMA(todayChangeList, period);

  final List<double> mvList = [];
  for (int i = 0; i < arr.length; i++) {
    final double mv = emaTodayChangeList[i] == 0
        ? 0
        : midChangeList[i] *
            (volList[i] == 0 ? 0 : emaVolList[i] / volList[i]) *
            todayChangeList[i] /
            emaTodayChangeList[i];
    mvList.add(mv);
  }
  //
  final List<double> emvList = calcMA(mvList, period);
  //
  final List<double> maEmvList = calcMA(emvList, period2);
  for (int i = 0; i < arr.length; i++) {
    arr[i][FieldName.emv] = emvList[i].toStringAsFixed(2);
    arr[i][FieldName.maEmv] = maEmvList[i].toStringAsFixed(2);
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

  calcEMV(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} emv:${priceData[i][FieldName.emv]} maEmv:${priceData[i][FieldName.maEmv]}");
  }
}
