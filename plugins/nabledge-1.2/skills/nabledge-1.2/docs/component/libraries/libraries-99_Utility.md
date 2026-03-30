# ユーティリティ

## 日付ユーティリティ

**クラス**: `nablarch.common.date.DateUtil`

> **注意**: パラメータで指定される日付の妥当性チェック(形式や実在日チェック)は行わない。呼び出し元で正しい日付形式であることを検証してから使用すること。不正な形式や非実在日が指定された場合の実行結果は保証しない。

| 機能 | メソッドシグネチャ | 説明 |
|---|---|---|
| 日付オブジェクト変換 | `java.util.Date getDate(String date)` | yyyyMMdd形式の文字列をjava.util.Dateに変換 |
| 日付フォーマット変換 | `String formatDate(String date, String pattern)` | yyyyMMdd形式の日付を指定フォーマット(SimpleDateFormat仕様)に変換 |
| 日数の加減算 | `String addDay(String date, int days)` | yyyyMMdd形式の日付に日数を加算(負の値で減算)。結果はyyyyMMdd形式 |
| 月数の加減算 | `String addMonth(String date, int month)` | yyyyMMdd or yyyyMM形式の日付に月数を加算(負の値で減算) |
| 日付間の日数取得 | `long getDays(String dateFrom, String dateTo)` | 2日付間の日数を取得。同日は0、dateFrom > dateToの場合は負の値 |
| 日付間の月数取得 | `int getMonths(String monthFrom, String monthTo)` | 2日付間の月数を取得。同日/同月は0、dateFrom > dateToの場合は負の値 |
| 月末日取得 | `String getMonthEndDate(String date)` | yyyyMMdd or yyyyMM形式の日付の月末日をyyyyMMdd形式で返す |

```java
// 日付オブジェクト変換
String updateDateStr = "20110302";
DateUtil.getDate(updateDateStr); // -> java.util.Dateオブジェクト

// 日付フォーマット変換
DateUtil.formatDate("20110302", "yyyy/MM/dd"); // -> 2011/03/02
DateUtil.formatDate("20110302", "yyyy-MM-dd"); // -> 2011-03-02

// 日数加減算
DateUtil.addDay("20110302", 10);  // -> 20110312
DateUtil.addDay("20110302", -10); // -> 20110220

// 月数加減算（年月日形式）
DateUtil.addMonth("20110302", 1);  // -> 20110402
DateUtil.addMonth("20110302", -1); // -> 20110202
// 月数加減算（年月形式）
DateUtil.addMonth("201103", 1);    // -> 201104
// 1ヶ月減算する場合(年月指定)
DateUtil.addMonth("201103", 1);    // -> 201102

// 日数取得（同日の場合）
DateUtil.getDate("20110302", "20110302"); // -> 0
// 日数取得
DateUtil.getDays("20120229", "20120331"); // -> 31
DateUtil.getDays("20120401", "20120101"); // -> -91

// 月数取得
DateUtil.getMonths("20120229", "20120331"); // -> 1
DateUtil.getMonths("20120401", "20120101"); // -> -3
// 月数取得（混合形式）
DateUtil.getMonths("20110331", "201104");   // -> 1
DateUtil.getMonths("201103", "20100315");   // -> -12

// 月末日取得
DateUtil.getMonthEndDate("201103"); // -> 20110331
DateUtil.getMonthEndDate("201104"); // -> 20110431
DateUtil.getMonthEndDate("200802"); // -> 20080229
```

<details>
<summary>keywords</summary>

DateUtil, nablarch.common.date.DateUtil, getDate, formatDate, addDay, addMonth, getDays, getMonths, getMonthEndDate, 日付ユーティリティ, 日付計算, 日付フォーマット変換, 月末日取得, 日数計算, 月数計算

</details>
