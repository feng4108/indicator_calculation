import 'package:flutter/foundation.dart';
import 'package:promote_ma_calc/procotol_constant.dart';

class DateUpdateUtil {
  static bool printLog = true;

  ///计算移动平均线
  ///
  ///valKey 要计算ma的值key
  ///
  ///maValKey 计算的ma值存储的key
  ///
  ///ma 要计算的ma天数
  static void calculateMa(List<Map<String, dynamic>> data, String valKey,
      String maValKey, List<int> maList) {
    final int length = data.length;
    // if (length < ma) {
    //   return;
    // }
    DateTime now = DateTime.now();

    for (int i = length - 1; i >= 0; i--) {
      for (int j = 0; j < maList.length; j++) {
        final int ma = maList[j];
        if (length < ma) {
          continue;
        }
        if (i < (data.length - ma)) {
          double avg = data[i + 1][maValKey + keySuffix] +
              data[i][valKey + keySuffix] / ma -
              data[i + ma][valKey + keySuffix] / ma;

          data[i][maValKey + keySuffix] = avg;
          data[i][maValKey] = avg.toString();
        } else if ((data.length - ma) == i) {
          double sum = 0.0;
          for (int j = 0; j < ma; j++) {
            // sum += double.parse(data[i + j][valKey]!);
            sum += data[i + j][valKey + keySuffix];
          }
          double avg = sum / ma;
          data[i][maValKey + keySuffix] = avg;
          data[i][maValKey] = avg.toString();
        }
      }
    }
    print(
        "calculate Ma:$maValKey end  ${DateTime.now().difference(now).inMilliseconds}");
  }

  ///计算MACD
  static void calculateMacd(List<Map<String, dynamic>> data,
      {String valKey = FieldName.close,
      String difKey = FieldName.diff,
      String deaKey = FieldName.dea,
      String macdKey = FieldName.macd}) async {
    double ema12 = 0.0, ema26 = 0.0, dif = 0.0, macd = 0.0, dea = 0.0;
    DateTime now = DateTime.now();
    final int length = data.length;
    for (int i = length - 1; i >= 0; --i) {
      if (length - 1 == i) {
        ema12 = 0.0;
        ema26 = 0.0;
        dea = 0.0;
      } else {
        double clos = data[i][valKey + keySuffix];
        //EMA（12）= 前一日EMA（12）×11/13＋今日收市价×2/13
        ema12 = ema12 * 11 / 13 + clos * 2 / 13;
        //EMA（26）= 前一日EMA（26）×25/27＋今日收市价×2/27
        ema26 = ema26 * 25 / 27 + clos * 2 / 27;
      }
      //今日EMA（12）- 今日EMA（26）
      dif = ema12 - ema26;
      data[i][difKey] = dif.toString();
      //DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
      dea = dea * 8 / 10 + dif * 2 / 10;
      data[i][deaKey] = dea.toString();
      //MACD柱线 = 2 * (DIF-DEA)
      macd = 2 * (dif - dea);
      data[i][macdKey] = macd.toString();
      print("$i--->>>${data[i]}");
    }
    print('MACD计算耗时:${DateTime.now().difference(now).inMilliseconds}');
    print(data.first);
  }

  static const double ema12Prev = 11 / 13;
  static const double ema12Now = 2 / 13;

  static const double ema26Prev = 25 / 27;
  static const double ema26Now = 2 / 27;

  ///计算MACD
  static void calculateMacd2(List<Map<String, dynamic>> data,
      {String valKey = FieldName.close,
      String difKey = FieldName.diff,
      String deaKey = FieldName.dea,
      String macdKey = FieldName.macd}) async {
    DateTime now = DateTime.now();
    double ema12 = 0.0, ema26 = 0.0, dif = 0.0, macd = 0.0, dea = 0.0;
    final int length = data.length;
    for (int i = length - 1; i >= 0; i--) {
      if (length - 1 == i) {
        ema12 = 0.0;
        ema26 = 0.0;
        dea = 0.0;
      } else {
        //EMA（12）= 前一日EMA（12）×11/13＋今日收市价×2/13
        ema12 = ema12 * ema12Prev + double.parse(data[i][valKey]!) * ema12Now;
        //EMA（26）= 前一日EMA（26）×25/27＋今日收市价×2/27
        ema26 = ema26 * ema26Prev + double.parse(data[i][valKey]!) * ema26Now;
      }
      //今日EMA（12）- 今日EMA（26）
      dif = ema12 - ema26;
      data[i][difKey] = dif.toString();
      //DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
      dea = dea * 0.8 + dif * 0.2;
      data[i][deaKey] = dea.toString();
      //MACD柱线 = 2 * (DIF-DEA)
      macd = 2 * (dif - dea);
      data[i][macdKey] = macd.toString();
    }
    print('MACD_2计算耗时:${DateTime.now().difference(now).inMilliseconds}');
  }

  ///计算k线均价等指标
  static Future<List<Map<String, dynamic>>> calcMaAndChangeRatio(
      List<Map<String, dynamic>> data) async {
    calculateMa(data, FieldName.close, FieldName.ma5, [5, 10, 20, 30]);

    calculateMa(data, FieldName.vol, FieldName.ma5Vol, [5, 10]);

    calculateMa(data, FieldName.turnover, FieldName.ma5Turnover, [5, 10]);

    calculateMacd(data);

    calcChangeRatio(data);

    for (var element in data) {
      num? vol = num.tryParse(element[FieldName.vol] ?? '0');
      num? turnover = num.tryParse(element[FieldName.turnover] ?? '0');
      if (turnover == null || vol == null || vol == 0) {
        element[FieldName.avgTrasPrice] = "0";
      } else {
        element[FieldName.avgTrasPrice] = (turnover / vol).toString();
      }
    }
    return data;
  }

  static void calcChangeRatio(List<Map<String, dynamic>> data) async {
    DateTime now = DateTime.now();
    for (int i = 0; i < data.length; i++) {
      Map<String, dynamic> item = data[i];
      double close = item[FieldName.close + keySuffix];
      if (i == data.length - 1) {
        double open = item[FieldName.open + keySuffix];
        if (open == 0) {
          item[FieldName.change] = "0.0";
          item[FieldName.changeRatio] = "0.0";
        } else {
          double change = close - open;
          item[FieldName.change] = change.toString();
          item[FieldName.changeRatio] = (change / open * 100).toString();
        }
      } else {
        double yclose = data[i + 1][FieldName.close + keySuffix];
        if (yclose == 0) {
          item[FieldName.change] = "0.0";
          item[FieldName.changeRatio] = "0.0";
        } else {
          double change = close - yclose;
          item[FieldName.change] = change.toString();
          item[FieldName.changeRatio] = (change / yclose * 100).toString();
        }
      }
    }
    print('涨跌幅计算耗时:${DateTime.now().difference(now).inMilliseconds}');
  }
}

const String keySuffix = "_ori";
