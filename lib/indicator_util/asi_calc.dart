import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

class ASI {
  /// 计算SI指标
  static double _calcSI(
      {required double openPrev,
      required double highPrev,
      required double lowPrev,
      required double closePrev,
      required double openToday,
      required double highToday,
      required double lowToday,
      required double closeToday}) {
    // 计算A、B、C、D
    double A = (highToday - closePrev).abs();
    double B = (lowToday - closePrev).abs();
    double C = (highToday - lowPrev).abs();
    double D = (closePrev - openPrev).abs();

    // 计算R
    double R;
    if (A >= B && A >= C) {
      R = A + (B / 2) + (D / 4);
    } else if (B >= A && B >= C) {
      R = B + (A / 2) + (D / 4);
    } else {
      R = C + (D / 4);
    }

    // 计算E、F、G
    double E = closeToday - closePrev;
    double F = closeToday - openToday;
    double G = closePrev - openPrev;

    // 计算X
    double X = E + (F / 2) + G;

    // 计算K
    double K = (A > B) ? A : B;

     if(R==0){
       return 0;
     }
    // 计算SI
    double SI = 16 * X * K / R;

    return SI;
  }

  /// 计算累计ASI值
  ///
  /// 振动升降指标(ASI)，由威尔斯·王尔德（Welles Wilder）所创。ASI指标以开盘、最高、最低、收盘价与前一交易日的各种价格相比较作为计算因子，研判市场的方向性。
  ///
  /// 二、计算公式
  /// 1、A=∣当天最高价-前一天收盘价∣
  ///
  ///    B=∣当天最低价-前一天收盘价∣
  ///
  ///    C=∣当天最高价-前一天最低价∣
  ///
  ///    D=∣前一天收盘价-前一天开盘价∣
  ///
  /// 2、比较A、B、C三数值：
  ///
  ///       若A最大，R＝A＋(B/2)＋(D／4)；
  ///
  ///       若B最大，R＝B＋(A／2)十(D／4)；
  ///
  ///       若C最大，R=C＋(D／4)
  ///
  /// 3、E=当天收盘价-前一天收盘价
  ///
  ///    F=当天收盘价-当天开盘价
  ///
  ///    G=前一天收盘价-前一天开盘价
  ///
  /// 4、X＝E＋1／2F＋G
  ///
  /// 5、K=A、B之间的最大值
  ///
  /// 6、L＝3；
  ///
  /// SI=50*X*K／R／L  快捷计算约等于 16*X*K／R；
  ///
  /// ASI=累计每日之SI值
  static void calcASI(List<Map<String, String?>> arr,
      {final int asiPeriod = 26, final int asitPeriod = 10}) {
    if(arr.isEmpty){
      return;
    }
    List<double> siList = [];
    siList.add(0);
    final List<double> highList = [];
    final List<double> lowList = [];
    final List<double> openList = [];
    final List<double> closeList = [];
    for (int i = 0; i < arr.length; i++) {
      double highToday = double.parse(arr[i][FieldName.high] ?? '0');
      double lowToday = double.parse(arr[i][FieldName.low] ?? '0');
      double openToday = double.parse(arr[i][FieldName.open] ?? '0');
      double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
      highList.add(highToday);
      lowList.add(lowToday);
      openList.add(openToday);
      closeList.add(closeToday);
    }
    for (int i = 1; i < arr.length; i++) {
      double openPrev = openList[i - 1];
      double highPrev = highList[i - 1];
      double lowPrev = lowList[i - 1];
      double closePrev = closeList[i - 1];

      double openToday = openList[i];
      double highToday = highList[i];
      double lowToday = lowList[i];
      double closeToday = closeList[i];

      double si = _calcSI(
          openPrev: openPrev,
          highPrev: highPrev,
          lowPrev: lowPrev,
          closePrev: closePrev,
          openToday: openToday,
          highToday: highToday,
          lowToday: lowToday,
          closeToday: closeToday);
      siList.add(si);
    }
    List<double> asiList = calcSUM(siList, asiPeriod);
    List<double> asitList = calcMA(asiList, asitPeriod);
    for (int i = 0; i < asitList.length; i++) {
      arr[i]['ASI'] = asiList[i].toStringAsFixed(2);
      arr[i]['ASIT'] = asitList[i].toStringAsFixed(2);
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

  ASI.calcASI(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} ASI: ${priceData[i]['ASI']} ASIT: ${priceData[i]['ASIT']}");
  }
}
