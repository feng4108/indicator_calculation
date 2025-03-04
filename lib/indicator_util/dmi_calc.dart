import 'dart:math';

import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///DMI（Directional Movement Index，趋向指标）是一种技术分析工具，用于衡量价格趋势的强度和方向。
///DMI由美国技术分析师Welles Wilder开发，并在1978年出版的《New Concepts in Technical Trading Systems》一书中介绍。
///
/// DMI指标包括以下几个部分：
///
/// +DI (Positive Directional Indicator)：表示上升动向。
///
/// -DI (Negative Directional Indicator)：表示下降动向。
///
/// ADX (Average Directional Index)：显示趋势的强度，不指示趋势的方向。
///
/// ADXR (Average Directional Index Rating)：ADX的平滑处理，通常为ADX与其前一天ADX的平均值。
///
///
/// 计算方法：
///
/// 1.计算真实波幅（TR）、上升动向（+DM）和下降动向（-DM）。
///
/// 2.平滑处理TR、+DM和-DM，通常使用14天的周期。
///
/// 3.计算+DI和-DI，分别为（平滑后的+DM / 平滑后的TR）*100 和（平滑后的-DM / 平滑后的TR）*100。
///
/// 4.计算DX（动向指数），即（+DI和-DI的绝对差）/（+DI和-DI的和）*100。
///
/// 5.计算ADX作为DX的移动平均，通常6天。
///
/// 6.ADXR是ADX的移动平均，通常6天。

void calcDMI(final List<Map<String, String?>> arr,
    {final int dmPeriod = 14, final int dxPeriod = 6}) {
  if(arr.isEmpty){
    return;
  }
  final List<double> highList = [];
  final List<double> lowList = [];
  final List<double> closeList = [];
  // 真实波幅
  final List<double> trList = [];
  // +DM
  final List<double> plusDmList = [];
  // -DM
  final List<double> minusDmList = [];

  for (int i = 0; i < arr.length; i++) {
    final double highToday = double.parse(arr[i][FieldName.high] ?? '0');
    final double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
    final double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    highList.add(highToday);
    lowList.add(lowToday);
    closeList.add(closeToday);

    final double closeYesterday = i > 0 ? closeList[i - 1] : closeToday;

    // 计算真实波幅（TR）
    final double tr = max(
        highToday - lowToday,
        max((highToday - closeYesterday).abs(),
            (lowToday - closeYesterday).abs()));
    trList.add(tr);

    // 计算方向运动（+DM和-DM）
    double upMove = highToday - highList[i > 0 ? i - 1 : i];
    double downMove = lowList[i > 0 ? i - 1 : i] - lowToday;

    plusDmList.add(upMove > downMove && upMove > 0 ? upMove : 0);
    minusDmList.add(downMove > upMove && downMove > 0 ? downMove : 0);
  }
  //平滑处理TR、+DM和-DM，通常使用14天的周期
  final List<double> emaTrList = calcEMA(trList, dmPeriod);
  final List<double> emaPdmList = calcEMA(plusDmList, dmPeriod);
  final List<double> emaMdmList = calcEMA(minusDmList, dmPeriod);

  final List<double> pdiList = [];
  final List<double> mdiList = [];
  final List<double> dxList = [];
  for (int i = 0; i < arr.length; i++) {
    final double emaTr = emaTrList[i];
    final double pdi = emaTr == 0 ? 0 : (emaPdmList[i] * 100 / emaTrList[i]);
    final double mdi = emaTr == 0 ? 0 : (emaMdmList[i] * 100 / emaTrList[i]);
    arr[i][FieldName.dmiPdi] = pdi.toStringAsFixed(2);
    arr[i][FieldName.dmiMdi] = mdi.toStringAsFixed(2);
    pdiList.add(pdi);
    mdiList.add(mdi);
    //计算DX（动向指数），即（+DI和-DI的绝对差）/（+DI和-DI的和）*100
    final double dx =
        pdi + mdi == 0 ? 0 : (pdi - mdi).abs() * 100 / (pdi + mdi).abs();
    dxList.add(dx);
  }
  //计算ADX作为DX的移动平均，通常6天
  final List<double> adxList = calcEMA(dxList, dxPeriod);
  //ADXR是ADX的移动平均，通常6天
  final List<double> adxrList = calcEMA(adxList, dxPeriod);
  for (int i = 0; i < arr.length; i++) {
    arr[i][FieldName.dmiAdx] = adxList[i].toStringAsFixed(2);
    arr[i][FieldName.dmiAdxr] = adxrList[i].toStringAsFixed(2);
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

  calcDMI(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} +DI: ${priceData[i][FieldName.dmiPdi]}, -DI: ${priceData[i][FieldName.dmiMdi]}, ADX: ${priceData[i][FieldName.dmiAdx]}, ADXR: ${priceData[i][FieldName.dmiAdxr]}");
  }
}
