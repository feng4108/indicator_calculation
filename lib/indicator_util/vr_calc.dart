import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///VR（Volume Ratio）指标，即成交量比率指标，是股市技术分析中的一种量价指标。
///它通过比较一段时间内上涨日与下跌日的成交量差异来反映市场的买卖气氛。
///
///VR指标是以研究股票量与价格之间的关系为手段的技术指标，其理论基础是“量价理论”和“反市场操作理论”。
///VR指标认为，由于量先价行、量涨价增、量跌价缩、量价同步、量价背离等成交量的基本原则在市场上恒久不变，
///因此，观察上涨与下跌的成交量变化，可作为研判行情的依据。
///同时，VR指标又认为，当市场上人气开始凝聚，股价刚开始上涨和在上涨途中的时候，
///投资者应顺势操作，而当市场上人气极度旺盛或极度悲观，股价暴涨暴跌时候，
///聪明的投资者应果断离场或进场，因此，反市场操作也是VR指标所显示的一项功能。
///
///
/// 一般而言，低价区和高价区出现的买卖盘行为均可以通过成交量表现出来，
/// 因此。VR指标又带有超买超卖的研判功能。同时，VR指标是用上涨时期的量除以下跌时期的量，
/// 因此，VR指标又带有一种相对强弱概念。
///
///
/// 总之，VR指标可以通过研判资金的供需及买卖气势的强弱、设定超买超卖的标准，为投资者确定合理、及时的买卖时机提供正确的参考。
///
///VR指标是通过分析一定周期内的价格上升周期的成价量（或成交额）与价格下降周期的成交量的比值的一种中短期技术指标。
///和其他技术指标一样，由于选用的计算周期不同，VR指标也包括日VR指标、周VR指标、月VR指标、年VR指标以及分钟VR指标等很多种类型。
///经常被用于股市研判的是日VR指标和周VR指标。经常被用于股市研判的是日VR指标和周VR指标。虽然它们计算时取值有所不同，但基本的计算方法一样。
///
///
/// 以日VR指标计算为例，其具体计算如下：
///
///
/// 1、计算公式
///
///
/// VR（N日）=N日内上升日成交量总和÷N日内下降日成交量总和
///
///
/// 其中，N为计算周期，一般起始周期为26
///
///
/// 2、计算过程
///
///
/// （1）N日以来股价上涨的那一日的成交量都称为AV（Accept Volume），将N日内的AV总和相加称AVS（Accept Volume Sum）。
///
///
/// （2）N日以来股价下跌的那一日的成交量都称为BV（Bid Volume），将N日内的BV总和相加称为BVS（Bid Volume Sum）。
///
///
/// （3）N日以来股价平盘的那一日的成交量都称为CV（Compare Volume Sum)，将N日内的CV总和相加称为CVS（Compare Volume Sum)。
///
///
/// （4）最后N日的VR就可以计算出来
///
///
/// VR（N）=（AVS＋1/2CVS）÷（BVS＋1/2CVS）
void calcVR(
  final List<Map<String, String?>> arr, {
  final int vrPeriod = 26,
  final int mavrPeriod = 6,
}) {
  final List<double> closeList = [];

  final List<double> avList = [];
  final List<double> bvList = [];
  final List<double> cvList = [];
  for (int i = 0; i < arr.length; i++) {
    final double volToday = double.parse(arr[i][FieldName.vol] ?? '0');
    final double closeToday = double.parse(arr[i][FieldName.close] ?? '0');
    closeList.add(closeToday);
    if (i == 0) {
      avList.add(volToday);
      bvList.add(0);
      cvList.add(0);
      continue;
    }
    final closePrev = closeList[i - 1];
    avList.add(closeToday > closePrev?volToday:0);
    bvList.add(closeToday < closePrev?volToday:0);
    cvList.add(closeToday == closePrev?volToday:0);
  }
  final List<double> savList = calcSUM(avList, vrPeriod);
  final List<double> sbvList = calcSUM(bvList, vrPeriod);
  final List<double> scvList = calcSUM(cvList, vrPeriod);
  final List<double> vrList = [];
  for (int i = 0; i < arr.length; i++){
    final double cv=scvList[i];
    final double bcv=sbvList[i]*2+cv;
    if(bcv>0){
      final double vr =(savList[i]*2+cv)*100/bcv ;
      vrList.add(vr);
    }else{
      vrList.add(0);
    }
  }

  final List<double> mavrList = calcMA(vrList, mavrPeriod);

  for (int i = 0; i < arr.length; i++){
    arr[i][FieldName.vr] = vrList[i].toStringAsFixed(2);
    arr[i][FieldName.maVr] = mavrList[i].toStringAsFixed(2);
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

  calcVR(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print("${priceData[i]['date']} vr: ${priceData[i][FieldName.vr]} mavr: ${priceData[i][FieldName.maVr]}");
  }
}
