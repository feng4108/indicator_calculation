# promote_ma_calc

基于 Flutter/Dart 的股票技术指标计算库，对 K 线数据进行各类技术分析指标计算，支持多种周期（分时、分钟、日、周、月、年）。

## 功能模块

### 核心计算模块

`DateUpdateUtil`（[lib/data_update_util.dart](lib/data_update_util.dart)）提供：

- **移动平均线 (MA)**：收盘价 MA5/10/20/30、成交量 MA5/10、成交额 MA5/10
- **MACD**：DIF、DEA、MACD 柱线
- **涨跌额与涨跌比例**：基于前一日收盘价
- **成交均价**：成交额 / 成交量

### 基础数学工具

`lib/indicator_util/ot.dart` 提供通用计算函数（源自新浪 JS 翻译）：

- MA、EMA、SMA（简单/指数/平滑移动平均）
- REF（引用值）、HHV（周期最高）、LLV（周期最低）、SUM（周期求和）
- 标准差、滚动标准差、平均绝对偏差
- SAR（抛物线转向指标）

### 技术指标

| 文件 | 指标 |
|------|------|
| boll_calc.dart | 布林线 (BOLL) |
| cci_calc.dart | 顺势指标 (CCI) |
| dmi_calc.dart | 趋向指标 (DMI) |
| dma_calc.dart | DMA |
| asi_calc.dart | ASI |
| bias_calc.dart | BIAS 乖离率 |
| brar_calc.dart | BRAR 人气意愿指标 |
| emv_calc.dart | EMV |
| expma_calc.dart | EXPMA 指数平滑 |
| obv_calc.dart | OBV 能量潮 |
| psy_calc.dart | PSY 心理线 |
| roc_calc.dart | ROC 变动率 |
| trix_calc.dart | TRIX |
| vr_calc.dart | VR 成交量比率 |
| wr_calc.dart | 威廉指标 (WR) |
| wvad_calc.dart | WVAD |

### 协议与常量

`FieldName`（[lib/procotol_constant.dart](lib/procotol_constant.dart)）定义 K 线及指标字段：open、high、low、close、vol、turnover、date 等。

### 工具类

- **utils.dart**：价格/成交量/百分比格式化、坐标转换、K 线周期类型
- **time_util.dart**：日期比较（同分钟/同天/同周/同月）、周数计算

## 数据格式

K 线数据为 `List<Map<String, dynamic>>`，每项需包含：`open`、`high`、`low`、`close`、`vol`、`turnover`、`date` 等字段。数值字段需提供 `_ori` 后缀的 double 类型副本供计算使用。

## 使用方式

```dart
import 'package:promote_ma_calc/data_update_util.dart';

// 计算 MA、MACD、涨跌幅、成交均价
await DateUpdateUtil.calcMaAndChangeRatio(data);
```

单独计算某指标：

```dart
import 'package:promote_ma_calc/indicator_util/boll_calc.dart';

calcBOLL(data, bollPeriod: 20, param: 2);
```

## 依赖

- Flutter SDK
- intl: ^0.17.0
