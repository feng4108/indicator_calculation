//这个文件中的函数是采用人工智能翻译新浪的js代码得到的

import 'dart:math' as math;

/// 获取数组中指定属性值的数组
List<T> getArr<T>(List<Map<String, dynamic>> data, String property,
    [T Function(dynamic)? mapper]) {
  if (property.isNotEmpty) {
    List<T> result = [];
    for (var item in data) {
      final value = item[property];
      if (mapper != null) {
        result.add(mapper(value));
      } else {
        // Ensuring type safety here. This might require value to be casted properly.
        result.add(value as T);
      }
    }
    return result;
  }
  // If property is empty or null, the behavior differs from JS version since we can't return a List<Map<String, dynamic>> as List<T>.
  // Depending on use case, you may want to handle this differently.
  throw ArgumentError("Property cannot be null or empty.");
}

///计算简单移动平均线（MA）
List<double> calcMA(final List<double> arr, final int period) {
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

///计算指数移动平均线（EMA）
List<double> calcEMA(List<double> data, double multiplier) {
  List<double> result = [];
  if (data.isNotEmpty) {
    result.add(data[0]);
  }

  for (int index = 1; index < data.length; index++) {
    result.add((2 * data[index] + (multiplier - 1) * result[index - 1]) /
        (multiplier + 1));
  }

  return result;
}

/// 计算平滑移动平均线（SMA）
List<double> calcSMA(List<double> data, double totalWeight, double weight) {
  List<double> result = [];
  if (data.isNotEmpty) {
    result.add(data[0]);
  }

  for (int index = 1; index < data.length; index++) {
    result.add(
        (weight * data[index] + (totalWeight - weight) * result[index - 1]) /
            totalWeight);
  }

  return result;
}

/// 计算引用值
List<double?> calcREF(List<double> data, int period) {
  List<double?> result = List<double?>.filled(period, null, growable: true);

  for (int index = data.length - 1; index >= period; index--) {
    result.add(data[index - period]);
  }

  return result;
}

/// 计算平均值
double calcA(final List<double> data) {
  if (data.isEmpty) {
    return 0;
  }
  double sum = 0;
  for (double value in data) {
    sum += value;
  }
  return sum / data.length;
}

/// 计算标准差
///
/// 标准差是统计学中用来衡量一组数值分散度的指标，它显示了这组数值中的各个数值相对于平均数的离散程度。
/// 计算标准差的过程分为以下几个步骤：
///
/// 1、计算平均值：首先计算所有数据点的平均值（均值）。
///
/// 2、计算每个数据点与平均值的差的平方：对于每个数据点，减去平均值然后将结果平方。
/// 这样做是为了确保所有的差值都是正数，并放大远离平均值的数据点的影响。
///
///3、计算这些平方差的平均值：将上一步得到的所有平方差加起来，
///然后除以数据点的数量（对于样本标准差，则是数量减一，即使用所谓的贝塞尔校正）。
///
/// 4、取平方根：最后一步是取上一步结果的平方根，从而获得原始数据集的标准差。
double calcSD(final List<double> arr, {final int? degreesOfFreedom}) {
  double average = calcA(arr);
  final int length = arr.length;
  double sumOfSquaredDifferences = 0;
  for (var index = 0; index < length; index++) {
    sumOfSquaredDifferences += math.pow(arr[index] - average, 2);
  }
  int len = (degreesOfFreedom != null ? length - degreesOfFreedom : length);
  len = len > 0 ? len : 1;
  return math.sqrt(sumOfSquaredDifferences / len);
}

/// 计算滚动标准差
List<double> calcSTD(final List<double> data, final int period) {
  List<double> result = [];
  for (int index = 0; index < data.length; index++) {
    List<double> subData = period > index
        ? data.sublist(0, index + 1)
        : data.sublist(index - period + 1, index + 1);
    result.add(calcSD(subData, degreesOfFreedom: 1));
  }
  return result;
}

/// 计算平均绝对偏差
double calcAVEDEV(final List<double> arr) {
  double average = calcA(arr);
  double sumOfAbsoluteDifferences = 0;
  int length = arr.length;
  for (int index = 0; index < length; index++) {
    sumOfAbsoluteDifferences += (arr[index] - average).abs();
  }
  return sumOfAbsoluteDifferences / length;
}

/// 计算滚动平均绝对偏差
List<double> calcRollingAVEDEV(final List<double> arr, final int period) {
  List<double> result = [];
  for (int index = 0; index < arr.length; index++) {
    if (period > index) {
      result.add(calcAVEDEV(arr.sublist(0, index + 1)));
    } else {
      result.add(calcAVEDEV(arr.sublist(index - period + 1, index + 1)));
    }
  }
  return result;
}

/// 计算一定周期内的最高值
List<double> calcHHV(final List<double> arr, final int period) {
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
List<double> calcLLV(final List<double> arr, final int period) {
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

/// 计算绝对值
List<double> calcABS(final List<double> arr) {
  List<double> result = [];
  for (var index = 0; index < arr.length; index++) {
    result.add(arr[index].abs());
  }
  return result;
}

/// 计算最大值
dynamic calcMAX(dynamic value1, dynamic value2) {
  if (value1 is List) {
    if (value2 is List) {
      List<double> result = [];
      int length = value1.length;
      for (int index = 0; index < length; index++) {
        result
            .add(math.max(value1[index].toDouble(), value2[index].toDouble()));
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

///计算列表元素一定周期内的和
List<double> calcSUM(final List<double> arr, final int period) {
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
double listSum(final List<double> arr) {
  double sum = 0;
  for (double num in arr) {
    sum += num;
  }
  return sum;
}

void calculateDownward(
  int index, {
  required final int dataLength,
  required final int period,
  required final double acceleration,
  required final double maximumAcceleration,
  required final List<double> highPrices,
  required final List<double> lowPrices,
  required final List<double> sarValues,
  required final List<double> accelerations,
  required final List<double> extremePoints,
  required final List<int> directions,
}) {
  if (index < dataLength) {
    sarValues[index] = highPrices
        .getRange(index - period, index)
        .reduce((a, b) => a > b ? a : b);
    directions[index] = 0;
    if (sarValues[index] < highPrices[index]) {
      calculateUpward(
        index + 1,
        dataLength: dataLength,
        period: period,
        acceleration: acceleration,
        maximumAcceleration: maximumAcceleration,
        highPrices: highPrices,
        lowPrices: lowPrices,
        sarValues: sarValues,
        accelerations: accelerations,
        extremePoints: extremePoints,
        directions: directions,
      );
      return;
    }
    extremePoints[index] = lowPrices
        .getRange(index - period + 1, index + 1)
        .reduce((a, b) => a < b ? a : b);
    accelerations[index] = acceleration;
    for (; index < dataLength - 1; index++) {
      sarValues[index + 1] = sarValues[index] +
          accelerations[index] *
              (extremePoints[index] - sarValues[index]) /
              100;
      directions[index + 1] = 0;
      if (sarValues[index + 1] < highPrices[index + 1]) {
        calculateUpward(
          index + 2,
          dataLength: dataLength,
          period: period,
          acceleration: acceleration,
          maximumAcceleration: maximumAcceleration,
          highPrices: highPrices,
          lowPrices: lowPrices,
          sarValues: sarValues,
          accelerations: accelerations,
          extremePoints: extremePoints,
          directions: directions,
        );
        return;
      }
      extremePoints[index + 1] = lowPrices
          .getRange(index - period + 2, index + 2)
          .reduce((a, b) => a < b ? a : b);
      if (lowPrices[index + 1] < extremePoints[index]) {
        accelerations[index + 1] = accelerations[index] + acceleration;
        if (accelerations[index + 1] > maximumAcceleration) {
          accelerations[index + 1] = maximumAcceleration;
        }
      } else {
        accelerations[index + 1] = accelerations[index];
      }
    }
  }
}

void calculateUpward(
  int index, {
  required final int dataLength,
  required final int period,
  required final double acceleration,
  required final double maximumAcceleration,
  required final List<double> highPrices,
  required final List<double> lowPrices,
  required final List<double> sarValues,
  required final List<double> accelerations,
  required final List<double> extremePoints,
  required final List<int> directions,
}) {
  if (index < dataLength) {
    sarValues[index] = lowPrices
        .getRange(index - period, index)
        .reduce((a, b) => a < b ? a : b);
    directions[index] = 1;
    if (sarValues[index] > lowPrices[index]) {
      calculateDownward(
        index + 1,
        dataLength: dataLength,
        period: period,
        acceleration: acceleration,
        maximumAcceleration: maximumAcceleration,
        highPrices: highPrices,
        lowPrices: lowPrices,
        sarValues: sarValues,
        accelerations: accelerations,
        extremePoints: extremePoints,
        directions: directions,
      );
      return;
    }
    extremePoints[index] = highPrices
        .getRange(index - period + 1, index + 1)
        .reduce((a, b) => a > b ? a : b);
    accelerations[index] = acceleration;
    for (; index < dataLength - 1; index++) {
      sarValues[index + 1] = sarValues[index] +
          accelerations[index] *
              (extremePoints[index] - sarValues[index]) /
              100;
      directions[index + 1] = 1;
      if (sarValues[index + 1] > lowPrices[index + 1]) {
        calculateDownward(
          index + 2,
          dataLength: dataLength,
          period: period,
          acceleration: acceleration,
          maximumAcceleration: maximumAcceleration,
          highPrices: highPrices,
          lowPrices: lowPrices,
          sarValues: sarValues,
          accelerations: accelerations,
          extremePoints: extremePoints,
          directions: directions,
        );
        return;
      }
      extremePoints[index + 1] = highPrices
          .getRange(index - period + 2, index + 2)
          .reduce((a, b) => a > b ? a : b);
      if (highPrices[index + 1] > extremePoints[index]) {
        accelerations[index + 1] = accelerations[index] + acceleration;
        if (accelerations[index + 1] > maximumAcceleration) {
          accelerations[index + 1] = maximumAcceleration;
        }
      } else {
        accelerations[index + 1] = accelerations[index];
      }
    }
  }
}

///计算抛物线转向指标（SAR）
dynamic calcSAR(List<Map<String, double>> data,
    {required final int period,
    required final double acceleration,
    required final double maximumAcceleration}) {
  List<double> highPrices = getArr(data, "high");
  List<double> lowPrices = getArr(data, "low");
  final int dataLength = data.length;
  List<double> sarValues = List.filled(dataLength, 0, growable: true);
  List<double> accelerations = List.filled(dataLength, 0, growable: true);
  List<double> extremePoints = List.filled(dataLength, 0, growable: true);
  List<int> directions = List.filled(dataLength, 0, growable: true);

  if (highPrices[period] > highPrices[0] || lowPrices[period] > lowPrices[0]) {
    calculateUpward(
      period,
      dataLength: dataLength,
      period: period,
      acceleration: acceleration,
      maximumAcceleration: maximumAcceleration,
      highPrices: highPrices,
      lowPrices: lowPrices,
      sarValues: sarValues,
      accelerations: accelerations,
      extremePoints: extremePoints,
      directions: directions,
    );
  } else {
    calculateDownward(
      period,
      dataLength: dataLength,
      period: period,
      acceleration: acceleration,
      maximumAcceleration: maximumAcceleration,
      highPrices: highPrices,
      lowPrices: lowPrices,
      sarValues: sarValues,
      accelerations: accelerations,
      extremePoints: extremePoints,
      directions: directions,
    );
  }

  return {
    'data': sarValues.where((value) => value != null).cast<double>().toList(),
    'direction': directions
  };
}
