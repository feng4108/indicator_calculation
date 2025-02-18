//这个文件中的函数是采用人工智能翻译新浪的js代码得到的

import 'dart:math' as math;

///计算列表元素一定周期内的和
List<double> calcSUM(List<double> arr, final int period) {
  List<double> a = [];
  if (period != 0) {
    for (int r = 0; r < arr.length; r++) {
      List<double> subList = period > r
          ? arr.sublist(0, r + 1)
          : arr.sublist(r - period + 1, r + 1);
      a.add(listSum(subList));
    }
  } else {
    double e = 0;
    for (int r = 0; r < arr.length; r++) {
      e += arr[r];
      a.add(e);
    }
  }
  return a;
}

///计算列表元素的和
double listSum(List<double> arr) {
  double sum = 0;
  for (double num in arr) {
    sum += num;
  }
  return sum;
}

///计算简单移动平均线（MA）
List<double> calcMA(List<double> arr, final int period) {
  List<double> r = [];
  double e = 0;

  for (int s = 0, h = arr.length; s < h; s++) {
    e += arr[s];

    if (s >= period - 1) {
      double a = e / period;
      e -= arr[s - period + 1];
      r.add(a);
    } else {
      double a = e / (s + 1);
      r.add(a);
    }
  }

  return r;
}

/// 计算一定周期内的最高值
List<double> calcHHV(List<double> arr, final int period) {
  final List<double> result = [];
  final int length = arr.length;

  // Dart没有直接等价于JavaScript的Math.max.apply方法，
  // 我们可以使用Iterable的reduce方法来找到最大值。
  double maxValue = arr.reduce((curr, next) => curr > next ? curr : next);

  for (int index = 0; index < length; index++) {
    List<double> slice;
    if (period > index) {
      // 当周期大于当前索引时，取从开始到当前索引的数据
      slice = arr.sublist(0, index + 1);
    } else {
      // 否则，取从当前索引减去周期加1到当前索引的数据
      slice = arr.sublist(index - period + 1, index + 1);
    }

    // 使用reduce来计算子列表中的最大值
    double maxInSlice = slice.reduce((curr, next) => curr > next ? curr : next);
    result.add(maxInSlice);
  }

  return result;
}

/// 计算一定周期内的最低值
List<double> calcLLV(List<double> arr, final int period) {
  List<double> result = [];
  int length = arr.length;

  for (int index = 0; index < length; index++) {
    if (period > index) {
      result.add(arr
          .sublist(0, index + 1)
          .reduce((value, element) => value < element ? value : element));
    } else {
      result.add(arr
          .sublist(index - period + 1, index + 1)
          .reduce((value, element) => value < element ? value : element));
    }
  }
  return result;
}

dynamic calcMAX(dynamic value1, dynamic value2) {
  if (value1 is List) {
    if (value2 is List) {
      List<double> result = [];
      int length = value1.length;
      for (int index = 0; index < length; index++) {
        result.add(math.max(value1[index].toDouble(), value2[index].toDouble()));
      }
      return result;
    } else if (value2 is num) {
      List<double> result = [];
      int length = value1.length;
      double numValue2 = value2.toDouble();
      for (int index = 0; index < length; index++) {
        result.add(math.max(value1[index].toDouble(), numValue2));
      }
      return result;
    } else {
      throw ArgumentError("Invalid argument type for Function calcMAX!");
    }
  } else if (value1 is num) {
    if (value2 is List) {
      List<double> result = [];
      int length = value2.length;
      double numValue1 = value1.toDouble();
      for (int index = 0; index < length; index++) {
        result.add(math.max(numValue1, value2[index].toDouble()));
      }
      return result;
    } else if (value2 is num) {
      return math.max(value1.toDouble(), value2.toDouble());
    } else {
      throw ArgumentError("Invalid argument type for Function calcMAX!");
    }
  } else {
    throw ArgumentError("Invalid argument type for Function calcMAX!");
  }
}
