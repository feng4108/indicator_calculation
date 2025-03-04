import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///TRIX（Triple Exponential Moving Average）指标，即三重指数平滑移动平均线，
///是一种技术分析工具，主要用于判断市场的超买超卖状态以及趋势的强弱。
///它通过三次平滑处理来消除短期波动的影响，从而更准确地反映长期趋势的变化
///
/// 下面是计算TRIX指标的基本步骤：
///
/// 1、选择一个时间周期N：通常使用15天作为标准周期，但根据不同的分析需求可以调整
///
///2、首先计算价格（通常使用收盘价）的N日指数平滑移动平均线（EMA)
///
/// 3、进行三次平滑处理：
///
/// 使用上述方法计算第一次EMA后，以这次得到的EMA结果作为新的输入数据，再次计算其N日的EMA，此为第二次平滑。
///
/// 以第二次平滑的结果作为新的输入数据，再次计算其N日的EMA，此为第三次平滑。
///
/// 4、计算TRIX指标：
///
/// 最后，计算第三次平滑得到的EMA与前一次得到的EMA的差值，得到TRIX指标。

void calcTRIX(final List<Map<String, String?>> arr,
    {final int trixPeriod = 12, final int maTrixPeriod = 9}) {
  if(arr.isEmpty){
    return;
  }
  final List<double> closeList = [];

  for (int i = 0; i < arr.length; i++) {
    double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
  }
  final List<double> emaList =
      calcEMA(calcEMA(calcEMA(closeList, trixPeriod), trixPeriod), trixPeriod);
  final List<double> trixList = [];
  for (int i = 0; i < arr.length; i++) {
    double emaToday = emaList[i];
    if(i==0){
      arr[i][FieldName.trix] = '0.00';
      trixList.add(0);
      continue;
    }
    double emaPrev = i == 0 ? 0 : emaList[i - 1];
    double trixToday = (emaToday - emaPrev) * 100 / emaPrev;
    arr[i][FieldName.trix] =
        trixToday.toStringAsFixed(2);
    trixList.add(trixToday);
  }

  final List<double> matrixList = calcMA(trixList, maTrixPeriod);
  for (int i = 0; i < arr.length; i++) {
    double matrixToday = matrixList[i];
    arr[i][FieldName.maTrix] =
        matrixToday.toStringAsFixed(2);
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

  calcTRIX(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print("${priceData[i]['date']} trix: ${priceData[i][FieldName.trix]} maTrix: ${priceData[i][FieldName.maTrix]}");
  }
}
