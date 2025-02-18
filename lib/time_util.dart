import 'package:intl/intl.dart';

class TimeUtil {
  TimeUtil._();

  ///[timestamp] 1970年到现在的秒数
  static String getUtcTimeStr(int timestamp,
      [String formats = "yyyy-MM-dd HH:mm:ss"]) {
//    print("秒数$timestamp");
    DateTime date =
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
//    print(date.toIso8601String());
    String formatted;
    var formatter = DateFormat(formats);
    formatted = formatter.format(date);
    return formatted;
  }

  static const int weekMilliseconds = 7 * 24 * 60 * 60 * 1000;

  ///判断是否在同一分钟
  static bool isSameMinute(String date1, String date2) {
    try {
      DateTime d1 = DateTime.parse(date1);
      DateTime d2 = DateTime.parse(date2);
      var format = DateFormat("yyyyMMdd HH:mm");
      format.format(d1) == format.format(d2);
    } catch (e) {
      print("判断是否在同一分钟日期解析失败: $e");
    }
    return false;
  }

  ///判断是否在同一天
  static bool isSameDay(String date1, String date2) {
    try {
      DateTime d1 = DateTime.parse(date1);
      DateTime d2 = DateTime.parse(date2);
      var format = DateFormat("yyyyMMdd");
      return format.format(d1) == format.format(d2);
    } catch (e) {
      print("判判断是否在同一天日期解析失败: $e");
    }
    return false;
  }

  ///判断是否在同一周
  ///
  /// 通过计算两个日期到1970-01-01的周数判断
  static bool isSameWeek(String date1, String date2) {
    //todo 暂时测试没问题，不确定是否会有问题
    try {
      DateTime d1 = DateTime.parse(date1);
      DateTime d2 = DateTime.parse(date2);
      int day1 = d1.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
      int day2 = d2.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

      // double s1 = (day1 - 3) / 7;
      // double s2 = (day2- 3) / 7;
      // int w1 = (s1).ceil();
      // int w2 = (s2).ceil();
      int w1 = (day1 - 3) ~/ 7 + 1; // 计算周数，向上取整
      int w2 = (day2 - 3) ~/ 7 + 1; // 计算周数，向上取整
      print("判断是否在同一周 $date1=$w1 ====== $date2=$w2  ${w1 == w2}");
      return w1 == w2;
    } catch (e) {
      print("判断是否在同一周日期解析失败: $e");
    }

    return false;
  }

  ///判断是否在同一月
  static bool isSameMonth(String date1, String date2) {
    try {
      DateTime d1 = DateTime.parse(date1);
      DateTime d2 = DateTime.parse(date2);
      return (d1.year == d2.year) && (d1.month == d2.month);
    } catch (e) {
      print("判断是否在同一月日期解析失败: $e");
    }
    return false;
  }

  static int weekOfYear(final DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
    // It might differ how you want to treat the first week
    if (daysInFirstWeek > 3) {
      weeks += 1;
    }
    return weeks;
  }

  ///获取上个月的最后一天
  static DateTime getLastDayOfPreviousMonth(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    return DateTime(year, month, 1).subtract(const Duration(days: 1));
  }

  ///获取上一周的最后一天
  static DateTime getLastDayOfPreviousWeek(DateTime dateTime) {
    DateTime lastWeek = dateTime.subtract(Duration(days: 7));
    DateTime lastSunday = lastWeek.subtract(Duration(days: lastWeek.weekday))
        .add(const Duration(days: 7));
    return lastSunday;
  }
}

// void main(){
//  String date1 ="1970-01-05 00:00:00";
//  String date2 ="1970-01-06 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="1970-01-05 00:00:00";
//  date2 ="1970-01-11 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="1970-01-10 00:00:00";
//  date2 ="1970-01-11 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="1970-01-11 00:00:00";
//  date2 ="1970-01-12 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//
//  date1 ="2019-04-29 00:00:00";
//  date2 ="2019-04-28 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
// date1 ="2019-04-30 00:00:00";
//  date2 ="2019-04-28 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//
//
//  date1 ="2019-04-30 00:00:00";
//   date2 ="2019-04-29 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="2019-05-01 00:00:00";
//   date2 ="2019-04-28 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="2018-12-31 00:00:00";
//   date2 ="2019-01-01 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="1999-12-31 00:00:00";
//   date2 ="2000-01-01 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//  date1 ="2006-12-31 00:00:00";
//   date2 ="2007-01-01 00:00:00";
//  print(TimeUtil.isSameWeek(date1, date2));
//
//
//
// }
