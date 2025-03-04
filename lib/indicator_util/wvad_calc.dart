import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///WVAD（Williams Variable Accumulation Distribution，威廉变异的累积分布）指标是由Larry Williams提出的一种技术分析工具，
///用于衡量市场情绪的变化。它通过考虑价格变动与成交量之间的关系来评估市场的买卖压力。
///
/// 1.A=当天收盘价-当天开盘价
///
/// 2.B=当天最高价-当天最低价
///
/// 3.C=A/B*成交量
///
/// 4.WVAD=N日ΣC
///
/// 5.MAWVAD=WVAD的M日简单移动平均
///
/// 6.参数N=24，M=6
///
/// 算法：(收盘价－开盘价)/(最高价－最低价)×成交量

void calcWVAD(final List<Map<String, String?>> arr,
    {final int wvadPeriod = 24, final int maPeriod = 6}) {
  if(arr.isEmpty){
    return;
  }
  final List<double> wvadList = [];

  for (int i = 0; i < arr.length; i++) {
    double openToday = double.parse(arr[i][FieldName.open]?? '0');
    double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    double volToday = double.parse(arr[i][FieldName.vol]?? '0');
    double wvad = ((closeToday-openToday)/(highToday-lowToday))*volToday;
    wvadList.add(wvad);
  }
  final List<double> swvadList = calcSUM(wvadList, wvadPeriod);
  final List<double> maList = calcMA(swvadList.map((e) => e / 1e6).toList(), maPeriod);
  for (int i = 0; i < arr.length; i++) {
    double ad = swvadList[i]/1e6;
    arr[i][FieldName.wvad] = ad.toStringAsFixed(2);
    arr[i][FieldName.wvadMa] = maList[i].toStringAsFixed(2);
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

  calcWVAD(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} wvad: ${priceData[i][FieldName.wvad]} wvadMa: ${priceData[i][FieldName.wvadMa]}");
  }
}
