# promote_ma_calc

A Flutter/Dart stock technical indicator calculation library for computing various technical analysis indicators from candlestick (K-line) data. Supports multiple timeframes (intraday, minute, daily, weekly, monthly, yearly).

## Features

### Core Calculation Module

`DateUpdateUtil` ([lib/data_update_util.dart](lib/data_update_util.dart)) provides:

- **Moving Average (MA)**: Close price MA5/10/20/30, volume MA5/10, turnover MA5/10
- **MACD**: DIF, DEA, MACD histogram
- **Change amount and change ratio**: Based on previous close price
- **Average transaction price**: Turnover / Volume

### Base Math Utilities

`lib/indicator_util/ot.dart` provides common calculation functions (translated from Sina JS):

- MA, EMA, SMA (Simple/Exponential/Smoothed Moving Average)
- REF (reference value), HHV (period high), LLV (period low), SUM (period sum)
- Standard deviation, rolling standard deviation, mean absolute deviation
- SAR (Parabolic SAR)

### Technical Indicators

| File | Indicator |
|------|-----------|
| boll_calc.dart | Bollinger Bands (BOLL) |
| cci_calc.dart | Commodity Channel Index (CCI) |
| dmi_calc.dart | Directional Movement Index (DMI) |
| dma_calc.dart | DMA |
| asi_calc.dart | ASI |
| bias_calc.dart | BIAS |
| brar_calc.dart | BRAR (Sentiment & Willingness) |
| emv_calc.dart | EMV |
| expma_calc.dart | EXPMA |
| obv_calc.dart | On Balance Volume (OBV) |
| psy_calc.dart | Psychological Line (PSY) |
| roc_calc.dart | Rate of Change (ROC) |
| trix_calc.dart | TRIX |
| vr_calc.dart | Volume Ratio (VR) |
| wr_calc.dart | Williams %R (WR) |
| wvad_calc.dart | WVAD |

### Protocol & Constants

`FieldName` ([lib/procotol_constant.dart](lib/procotol_constant.dart)) defines candlestick and indicator field keys: open, high, low, close, vol, turnover, date, etc.

### Utilities

- **utils.dart**: Price/volume/percentage formatting, coordinate transformation, K-line period types
- **time_util.dart**: Date comparison (same minute/day/week/month), week number calculation

## Data Format

Candlestick data is `List<Map<String, dynamic>>`. Each item must include: open, high, low, close, vol, turnover, date. Numeric fields require an `_ori`-suffixed double copy for calculation.

## Usage

```dart
import 'package:promote_ma_calc/data_update_util.dart';

// Compute MA, MACD, change ratio, average transaction price
await DateUpdateUtil.calcMaAndChangeRatio(data);
```

Compute a single indicator:

```dart
import 'package:promote_ma_calc/indicator_util/boll_calc.dart';

calcBOLL(data, bollPeriod: 20, param: 2);
```

## Dependencies

- Flutter SDK
- intl: ^0.17.0
