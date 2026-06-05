# class DateUtil

**パッケージ:** nablarch.core.util

---

```java
public final class DateUtil
```

日付ユーティリティ。

**作成者:** Miki Habu  

---

## フィールドの詳細

### YMD_SEPARATOR_PATTERN

```java
private static final Pattern YMD_SEPARATOR_PATTERN
```

年月日の区切り文字にマッチするパターン

---

## コンストラクタの詳細

### DateUtil

```java
private DateUtil()
```

privateコンストラクタ

---

## メソッドの詳細

### getDate

```java
public static Date getDate(String date)
```

日付文字列(yyyyMMdd形式)から{@link java.util.Date}クラスのインスタンスを取得する。

**パラメータ:**
- `date` - 日付文字列(yyyyMMdd形式)

**戻り値:**
日付文字列の日付が設定された、{@link java.util.Date}クラスのインスタンス

**例外:**
- `IllegalArgumentException` - 日付文字列のフォーマットが yyyyMMdd形式ではなかった場合

---

### formatDate

```java
public static String formatDate(String date, String pattern)
```

日付文字列(yyyyMMdd形式)を指定された形式でフォーマットする。

**パラメータ:**
- `date` - フォーマット対象の日付文字列(yyyyMMdd形式)
- `pattern` - 日付のフォーマットを記述するパターン(yyyy/MM/ddなど。{@link java.text.SimpleDateFormat}参照)

**戻り値:**
フォーマットされた日付文字列

**例外:**
- `IllegalArgumentException` - 日付文字列のフォーマットが yyyyMMdd形式ではなかった場合

---

### addDay

```java
public static String addDay(String date, int days)
```

指定された日付(yyyyMMdd形式)を指定された日数分加減算する。<br/>
<p/>
負の値が指定された場合は、減算を行う。
<p/>
例）addDay("19991231", 1) //--> "20000101"<br>

**パラメータ:**
- `date` - 日付文字列（yyyyMMdd形式）
- `days` - 加減算する日数（負の値の場合は、減算を行う。)

**戻り値:**
計算後の日付文字列（yyyyMMdd形式）

---

### addMonth

```java
public static String addMonth(String date, int month)
```

指定された日付(yyyyMMdd or yyyyMM形式)を指定された月数分加減算する。<br/>
<p/>
負の値が指定された場合は、減算を行う。
<p/>
例）addMonth("19991231", 1) //--> "20000131"<br>

**パラメータ:**
- `date` - 日付文字列(yyyyMMdd or yyyyMM形式)
- `month` - 加減算する月数(負の値の場合は、減算を行う。)

**戻り値:**
計算後の日付文字列

---

### getDays

```java
public static long getDays(String dateFrom, String dateTo)
```

指定された日付間の日数を取得する。<br/>
<p/>
例）getDays("19991231", "20000101") //--> 1<br>

**パラメータ:**
- `dateFrom` - 開始日付文字列（yyyyMMdd形式）
- `dateTo` - 終了日付文字列（yyyyMMdd形式）

**戻り値:**
日数（同一日であれば0、 開始日付文字列 ＞ 終了日付文字列であればマイナス値）

---

### getMonths

```java
public static int getMonths(String monthFrom, String monthTo)
```

指定された日付(yyyyMMdd or yyyyMM形式)間の月数を取得する。
<p/>
例)<br/>
<code>
DateUtil.getMonths("201102", "201103"); //--> 1
</code>

**パラメータ:**
- `monthFrom` - 開始日付文字列(yyyyMMdd or yyyyMM形式)
- `monthTo` - 終了日付文字列(yyyyMMdd or yyyyMM形式)

**戻り値:**
月数（同一日であれば0、 開始日付文字列 ＞ 終了日付文字列であればマイナス値）

---

### getMonthEndDate

```java
public static String getMonthEndDate(String date)
```

指定された日付(yyyyMMdd or yyyyMM形式)の月末日を取得する。

**パラメータ:**
- `date` - 日付(yyyyMMdd or yyyyMM形式)

**戻り値:**
指定された日付の月末日

---

### getCalendar

```java
private static Calendar getCalendar(String date)
```

与えられた日付に設定された{@link java.util.Calendar}インスタンスを返す。

**パラメータ:**
- `date` - 日付文字列(yyyyMMdd形式)

**戻り値:**
与えられた日付に設定された{@link java.util.Calendar}インスタンス

---

### isValid

```java
public static boolean isValid(String date, String format)
```

このメソッドはロケールに{@link Locale#getDefault()}を使用して、{@link #isValid(String, String, Locale)}を呼び出す。 <br/>

**パラメータ:**
- `date` - バリデーション対象日付文字列
- `format` - フォーマット

**戻り値:**
dateがformat形式で、実在する日であれば{@code true}

**例外:**
- `IllegalArgumentException` - dateが{@code null}か、formatが{@code null}または空文字の場合

---

### isValid

```java
public static boolean isValid(String date, String format, Locale locale)
```

指定された日付文字列がフォーマットどおりであり、実在する日であることをバリデーションする。<br>
フォーマットには{@link SimpleDateFormat}にて定められたフォーマットを指定する。</br>
例)<br/>
<code><pre>
//2016年3月31日は存在するため、true。
DateUtil.isValid("20160331", "yyyyMMdd"); //--> true

//2016年3月32日は存在しないため、false。
DateUtil.isValid("20160332", "yyyyMMdd"); //--> false
</pre></code>

**パラメータ:**
- `date` - バリデーション対象日付文字列
- `format` - フォーマット
- `locale` - フォーマットに使用するロケール

**戻り値:**
dateがformat形式で、実在する日であれば{@code true}

**例外:**
- `IllegalArgumentException` - dateが{@code null}か、formatが{@code null}または空文字の場合

---

### getParsedDate

```java
public static Date getParsedDate(String date, String format)
```

このメソッドはロケールに{@link Locale#getDefault()}を使用して {@link #getParsedDate(String, String, Locale)}を呼び出す。

**パラメータ:**
- `date` - パース対象日付文字列
- `format` - 日付文字列フォーマット

**戻り値:**
dateをformat形式でパースした結果の{@link java.util.Date}インスタンス

**例外:**
- `IllegalArgumentException` - dateが{@code null}か、formatが{@code null}または空文字の場合

---

### getParsedDate

```java
public static Date getParsedDate(String date, String format, Locale locale)
```

dateをformat形式でパースした結果の{@link java.util.Date}インスタンスを返却する。</br>
dateがformat形式ではない場合、または実在しない日付である場合、{@code null}を返却する。</br>
例)<br/>
<pre><code>
//正常処理
DateUtil.getParsedDate("20160307160112", "yyyyMMddHHmmss", Locale.JAPANESE); // Mon Mar 07 12:12:12 JST 2016

//20160304(date)の形式が、yyyymm形式でないため、null。
DateUtil.getParsedDate("20160304", "yyyyMM", Locale.JAPANESE); //--> null

//2016年3月32日が存在しない日付のため、null。
DateUtil.getParsedDate("20160332", "yyyyMMdd", Locale.JAPANESE); //--> null
</pre></code>

**パラメータ:**
- `date` - パース対象日付文字列
- `format` - 日付文字列フォーマット
- `locale` - フォーマットに使用するロケール

**戻り値:**
dateをformat形式でパースした結果の{@link java.util.Date}インスタンス

**例外:**
- `IllegalArgumentException` - dateが{@code null}か、formatが{@code null}または空文字の場合

---

### getNumbersOnlyFormat

```java
public static String getNumbersOnlyFormat(String yyyyMMddFormat)
```

フォーマット文字列から年月日の区切り文字を取り除いた値を返す。
<pre>
フォーマットのパターン文字は、y(年)、M(月)、d(月における日)のみ指定可能。

フォーマット文字列に年月日の区切り文字が含まれない場合は{@code null}を返す。
下記に「フォーマット文字列 //--> 戻り値」形式で例を示す。

"yyyy/MM/dd" //--> "yyyyMMdd"
"yyyy-MM-dd" //--> "yyyyMMdd"
"MM/dd/yyyy" //--> "MMddyyyy"
"yyyyMMdd"   //--> {@code null}

</pre>

**パラメータ:**
- `yyyyMMddFormat` - フォーマット文字列

**戻り値:**
フォーマット文字列から年月日の区切り文字を取り除いた値

---

### formatDate

```java
public static String formatDate(Date date, String format)
```

このメソッドは{@link ThreadContext}から取得したロケールを指定して
{@link #formatDate(Date, String, Locale)}を呼び出す。

**パラメータ:**
- `date` - 日付({@code null}不可)
- `format` - フォーマット({@code null}不可)

**戻り値:**
変換した値

---

### formatDate

```java
public static String formatDate(Date date, String format, Locale locale)
```

指定されたフォーマットとロケールを使用して日付を変換する。
<p/>
指定するフォーマットは{@link SimpleDateFormat}の仕様に準拠すること。
<p/>
例:
<code><pre>
Date date = Calendar.getInstance().getTime();              //--> 2012/11/13

I18NUtil.formatDate(date, "yyyy/MMM/dd", Locale.JAPANESE); //--> 2012/11/13
I18NUtil.formatDate(date, "dd MMM yyyy", Locale.ENGLISH);  //--> 13 Nov 2012
</pre></code>

**パラメータ:**
- `date` - 日付
- `format` - フォーマット
- `locale` - ロケール

**戻り値:**
変換した値

**例外:**
- `IllegalArgumentException` - 日付、フォーマット、ロケールが{@code null}の場合、または日付の変換に失敗した場合

---
