import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart';

class ColorsUtil {
  static material.Color increaseColor = material.Colors.red;
  static material.Color decreaseColor = material.Colors.green;
}

class Transformer {
  double? max;
  late double min;
  late material.Rect rect;
  late double heightRatio;
  late double scale;
  late double rectWidth;
  late double offset;
  late double lineWidth;

  void update(material.Rect rect, double max, double min, double scale) {
    this.max = max;
    this.min = min;
    this.rect = rect;
    heightRatio = rect.height / (max - min);
  }

  ///
  material.Rect pointValuesToPixel(int pos, Vector2 input) {
    double off = offset * scale;
    double left = ((pos * rectWidth * scale) + lineWidth) + off + rect.left;
    double right =
        (((pos + 1) * rectWidth * scale) - lineWidth) + off + rect.left;
    double top = rect.height - (input[0] - min) * heightRatio;
    double bottom = rect.height - (input[1] - min) * heightRatio;
    return material.Rect.fromLTRB(left, top, right, bottom);
  }
}

 const int tenThousands = 10000;
 const int oneHundredThousand = 100000;
 const int million = 100*10000;
 const int hundredMillion = 10000*10000;
///价格格式化
class ValueFormatter {
  ///价格格式化
  String priceFormat(double price, {int fractionDigits = 2}) {
    if (price == 0.0) {
      return '--';
    }
    if(price<oneHundredThousand){
      return price.toStringAsFixed(fractionDigits);
    }else if(price <hundredMillion){
      return "${(price/tenThousands).toStringAsFixed(fractionDigits)}万";
    }else{
      return "${(price/hundredMillion).toStringAsFixed(fractionDigits)}亿";
    }
  }

  ///百分比格式化
  String percentFormat(double percent, {int fractionDigits = 2}) {
    return percent.toStringAsFixed(fractionDigits);
  }

  ///成交量格式化
  String volumeFormat(double volume, {int fractionDigits = 0}) {
    if(volume<oneHundredThousand){
      return volume.toStringAsFixed(fractionDigits);
    }else if(volume <hundredMillion){
      return "${(volume/tenThousands).toStringAsFixed(2)}万";
    }else{
      return "${(volume/hundredMillion).toStringAsFixed(2)}亿";
    }
  }

  ///通用的格式化
  String format(double value, {int fractionDigits = 2}) {
    if(value<oneHundredThousand){
      return value.toStringAsFixed(fractionDigits);
    }else if(value <hundredMillion){
      return "${(value/tenThousands).toStringAsFixed(fractionDigits)}万";
    }else{
      return "${(value/hundredMillion).toStringAsFixed(fractionDigits)}亿";
    }
  }
}

///时间格式化
class TimeFormatter {
  ///时间格式化
  String formatMillisecondsSinceEpoch(int milliseconds,
      {String newPattern = 'HH:mm'}) {
    var format = DateFormat(newPattern);
    return format.format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }

  ///时间格式化
  String formatDateTime(DateTime date, {String newPattern = 'HH:mm'}) {
    var format = DateFormat(newPattern);
    return format.format(date);
  }

  ///时间格式化
  String format(String formattedString, {String? newPattern = 'HH:mm'}) {
    var format = DateFormat(newPattern);
    return format.format(DateTime.parse(formattedString));
  }
}

class TimeFormatPattern {
  /// 工厂模式
  factory TimeFormatPattern() => _getInstance()!;

  static TimeFormatPattern? get instance => _getInstance();
  static TimeFormatPattern? _instance;

  ///单例模式
  static TimeFormatPattern? _getInstance() {
    _instance ??= TimeFormatPattern._internal();
    return _instance;
  }

  static const String dayPattern = 'yyyy/MM/dd';
  static const String timePattern = 'HH:mm';
  static const String timeKPattern = 'yyyy/MM/dd HH:mm';
  late Map<String, String> _map;

  TimeFormatPattern._internal() {
    // 初始化
    _map = {};
    _map[LineType.time] = timePattern;
    _map[LineType.oneMinute] = timeKPattern;
    _map[LineType.fiveMinute] = timeKPattern;
    _map[LineType.tenMinute] = timeKPattern;
    _map[LineType.fifteenMinute] = timeKPattern;
    _map[LineType.twentyMinute] = timeKPattern;
    _map[LineType.thirtyMinute] = timeKPattern;
    _map[LineType.sixtyMinute] = timeKPattern;
    _map[LineType.oneHunAndTwentyMinute] = timeKPattern;
    _map[LineType.day] = dayPattern;
    _map[LineType.week] = dayPattern;
    _map[LineType.month] = dayPattern;
    _map[LineType.year] = dayPattern;
  }

  String? getPatter(String lineType) {
    return _map[lineType];
  }
}

///分时k线显示的名称
class LineTypeName {
  /// 工厂模式
  factory LineTypeName() => _getInstance()!;

  static LineTypeName? get instance => _getInstance();
  static LineTypeName? _instance;

  ///单例模式
  static LineTypeName? _getInstance() {
    _instance ??= LineTypeName._internal();
    return _instance;
  }

  static const String dayTimePattern = '';
  late Map<String, String> _mapTabName;
  late Map<String, String> _mapLabelName;

  LineTypeName._internal() {
    // 初始化
    _mapTabName = {};
    _mapTabName[LineType.time] = "分时";
    _mapTabName[LineType.oneMinute] = "1分";
    _mapTabName[LineType.fiveMinute] = "5分";
    _mapTabName[LineType.tenMinute] = "10分";
    _mapTabName[LineType.fifteenMinute] = "15分";
    _mapTabName[LineType.twentyMinute] = "20分";
    _mapTabName[LineType.thirtyMinute] = "30分";
    _mapTabName[LineType.sixtyMinute] = "60分";
    _mapTabName[LineType.oneHunAndTwentyMinute] = "120分";
    _mapTabName[LineType.day] = "日";
    _mapTabName[LineType.week] = "周";
    _mapTabName[LineType.month] = "月";
    _mapTabName[LineType.year] = "年";

    _mapLabelName = {};
    _mapLabelName[LineType.time] = "分时";
    _mapLabelName[LineType.oneMinute] = "1分";
    _mapLabelName[LineType.fiveMinute] = "5分";
    _mapLabelName[LineType.tenMinute] = "10分";
    _mapLabelName[LineType.fifteenMinute] = "15分";
    _mapLabelName[LineType.twentyMinute] = "20分";
    _mapLabelName[LineType.thirtyMinute] = "30分";
    _mapLabelName[LineType.sixtyMinute] = "60分";
    _mapLabelName[LineType.oneHunAndTwentyMinute] = "120分";
    _mapLabelName[LineType.day] = "日线";
    _mapLabelName[LineType.week] = "周线";
    _mapLabelName[LineType.month] = "月线";
    _mapLabelName[LineType.year] = "年线";
  }

  String? getTabShowName(String lineType) {
    return _mapTabName[lineType];
  }

  String? getLabelShowName(String lineType) {
    return _mapLabelName[lineType];
  }
}

class LineType {
  ///分时
  static const time = "time";

  ///1分k
  static const oneMinute = "1";

  ///5分k
  static const fiveMinute = "5";

  ///5分k
  static const tenMinute = "10";

  ///15分k
  static const fifteenMinute = "15";

  ///20分k
  static const twentyMinute = "20";

  ///30分k
  static const thirtyMinute = "30";

  ///60分k
  static const sixtyMinute = "60";

  ///120分k
  static const oneHunAndTwentyMinute = "120";

  ///日k
  static const day = "D";

  ///周k
  static const week = "W";

  ///月k
  static const month = "M";

  ///年k
  static const year = "year";
}
