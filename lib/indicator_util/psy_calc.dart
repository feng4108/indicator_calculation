import 'package:promote_ma_calc/indicator_util/ot.dart';
import 'package:promote_ma_calc/sz301536.dart';

import '../procotol_constant.dart';

///PSY指标，全称为Psychological Line，中文通常译为心理线指标，是一种技术分析工具，用于衡量市场在一段时间内的上涨或下跌的心理状态。它通过计算价格上涨的次数占总观察期的比例来反映市场的乐观或悲观情绪。
///
/// PSY指标的计算方法
///
/// 1、选择一个时间周期：首先需要确定一个时间周期n，这代表你想要评估的过去天数。
/// 例如，如果你选择n=12，则意味着你将评估过去12天内价格上涨的天数比例。
///
/// 2、获取价格数据：通常使用每日收盘价进行计算。对于每个交易日，比较当天的收盘价与前一日的收盘价。
///
/// 3、应用公式：
///
/// 对于选定的时间周期内的每一天，如果当天的收盘价高于前一天的收盘价，则记为1（表示上涨）；否则记为0（表示没有上涨或者下跌）。
/// 然后，计算这些值中1的数量（即价格上涨的天数），并除以总天数n，再乘以100得到百分比形式的PSY值。
/// 公式表达如下：
///
/// PSY(n) = (上涨天数 / n) * 100 这里的“上涨天数”指的是在过去n天里，收盘价高于前一天收盘价的天数。
///
/// 4、绘制PSY曲线：根据上述计算结果，可以将每个计算周期的PSY值绘制成图表。
/// 这样可以帮助识别市场的超买或超卖状态。一般来说，PSY值超过75可能表示市场处于超买状态，而低于25则可能表示市场处于超卖状态。
///
/// 5、分析PSY曲线：当PSY值过高时，表明市场情绪过于乐观，可能是卖出信号；
/// 相反，当PSY值过低时，表明市场情绪过于悲观，可能是买入信号。不过需要注意的是，
/// 单凭PSY指标不足以做出完整的投资决策，通常建议与其他技术指标结合使用。

void calPSY(final List<Map<String, String?>> arr,
    {final int psyPeriod = 12,final int maPsyPeriod = 6}) {
  if(arr.isEmpty){
    return;
  }
  final List<double> closeList = [];
  List<int> upList = [];
  int e = 1;
  upList.add(e);
  int h=e;
  num l = (e*100/psyPeriod);
  arr[0][FieldName.psy] = l.toStringAsFixed(2);
  arr[0][FieldName.maPsy] = l.toStringAsFixed(2);
  num o=l;
  for (int c = 0; c < arr.length; c++) {
    double closeToday = double.parse(arr[c][FieldName.close] ?? '0');
    closeList.add(closeToday);

    if (c > 0) {
      e = closeToday > closeList[c - 1] ? 1 : 0;
      upList.add(e);
      h=h+e;
      if (c >= psyPeriod) {
        h=h-upList[c-psyPeriod];
      }
      l = (h*100/psyPeriod);
      arr[c][FieldName.psy] = l.toStringAsFixed(2);
      o+=l;
      if(c>=maPsyPeriod){
        o=o-num.parse(arr[c-maPsyPeriod][FieldName.psy]!);
        arr[c][FieldName.maPsy] = (o/maPsyPeriod).toStringAsFixed(2);
      }else{
        arr[c][FieldName.maPsy] = (o/(c+1)).toStringAsFixed(2);
      }
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

  calPSY(priceData);
  for (int i = 0; i < priceData.length; i++) {
    print(
        "${priceData[i]['date']} PSY: ${priceData[i][FieldName.psy]} MA_PSY: ${priceData[i][FieldName.maPsy]}");
  }
}
