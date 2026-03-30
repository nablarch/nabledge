# ユーティリティ

## 日付ユーティリティ

**クラス**: `nablarch.common.date.DateUtil`

> **注意**: パラメータで指定される日付の妥当性チェック（形式や実在日チェック）は行わない。呼び出し元で正しい日付形式であることを検証してから使用すること。これは、本機能は繰り返し呼び出される機能であるため、都度実在日チェックなどを実施すると性能に与える影響が大きくなるためである。不正な形式や非実在日が指定された場合の実行結果は保証しない。

### 日付オブジェクト変換

`java.util.Date getDate(String date)`

- `date`: 日付（yyyyMMdd形式）
- 戻り値: `java.util.Date`

```java
DateUtil.getDate("20110302"); // -> java.util.Dateオブジェクト
```

### 日付フォーマット変換

`String formatDate(String date, String pattern)`

- `date`: 日付（yyyyMMdd形式）
- `pattern`: フォーマット（SimpleDateFormatの仕様に準拠）
- 戻り値: 指定フォーマットに変換した値

```java
DateUtil.formatDate("20110302", "yyyy/MM/dd"); // -> 2011/03/02
DateUtil.formatDate("20110302", "yyyy-MM-dd"); // -> 2011-03-02
```

### 日数の加減算

`String addDay(String date, int days)`

- `date`: 日付（yyyyMMdd形式）
- `days`: 加算する日付（負の値の場合は、減算が行われる。）
- 戻り値: 計算後の日付（yyyyMMdd形式）

```java
DateUtil.addDay("20110302", 10);  // -> 20110312
DateUtil.addDay("20110302", -10); // -> 20110220
```

### 月数の加減算

`String addMonth(String date, int month)`

- `date`: 日付（yyyyMMdd or yyyyMM形式）
- `month`: 月数（負の値の場合は減算）
- 戻り値: 計算後の日付（yyyyMMdd or yyyyMM形式）

```java
DateUtil.addMonth("20110302", 1);  // -> 20110402
DateUtil.addMonth("201103", 1);    // -> 201104
DateUtil.addMonth("20110302", -1); // -> 20110202
DateUtil.addMonth("201103", 1);    // -> 201102
```

### 日付間の日数取得

`long getDays(String dateFrom, String dateTo)`

- `dateFrom`: 被演算日付（yyyyMMdd形式）
- `dateTo`: 演算日付（yyyyMMdd形式）
- 戻り値: 2つの日付間の日数（同日の場合は0、`dateFrom > dateTo` の場合は負の値）

```java
DateUtil.getDate("20110302", "20110302"); // -> 0
DateUtil.getDays("20120229", "20120331"); // -> 31
DateUtil.getDays("20120401", "20120101"); // -> -91
```

### 日付間の月数取得

`int getMonths(String monthFrom, String monthTo)`

- `dateFrom`: 被演算日付（yyyyMMdd or yyyyMM形式）
- `dateTo`: 演算日付（yyyyMMdd or yyyyMM形式）
- 戻り値: 2つの日付間の月数（同日・同月の場合は0、`dateFrom > dateTo` の場合は負の値）

```java
DateUtil.getMonths("20110302", "20110302"); // -> 0
DateUtil.getMonths("201103", "201103");     // -> 0
DateUtil.getMonths("20120229", "20120331"); // -> 1
DateUtil.getMonths("201202", "201203");     // -> 1
DateUtil.getMonths("20120401", "20120101"); // -> -3
DateUtil.getMonths("201204", "201201");     // -> -3
DateUtil.getMonths("20110331", "201104");   // -> 1
DateUtil.getMonths("201103", "20100315");   // -> -12
```

### 月末日取得

`String getMonthEndDate(String date)`

- `date`: 日付（yyyyMMdd or yyyyMM形式）
- 戻り値: 月末日（yyyyMMdd形式）

```java
DateUtil.getMonthEndDate("201103"); // -> 20110331
DateUtil.getMonthEndDate("201104"); // -> 20110431
DateUtil.getMonthEndDate("200802"); // -> 20080229
```

<details>
<summary>keywords</summary>

DateUtil, nablarch.common.date.DateUtil, getDate, formatDate, addDay, addMonth, getDays, getMonths, getMonthEndDate, SimpleDateFormat, 日付ユーティリティ, 日付オブジェクト変換, 日付フォーマット変換, 日数加減算, 月数加減算, 月末日取得, 日付間日数取得, 日付間月数取得, yyyyMMdd, yyyyMM

</details>
