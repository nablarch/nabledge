# class CsvDataBindConfig

**パッケージ:** nablarch.common.databind.csv

**実装されたインタフェース:**
- DataBindConfig

---

```java
public class CsvDataBindConfig
implements DataBindConfig
```

CSVのフォーマットを表すクラス。
<p/>
デフォルト設定を使用する場合は、{@link #DEFAULT}オブジェクトを使用する。<br/>
独自の設定を行う場合は、{@link #CsvDataBindConfig(char, String, char, boolean, boolean, String[], String[], Charset, boolean, QuoteMode, List)}
を使用しオブジェクトを生成するか、{@link #DEFAULT}オブジェクトのセッタを実行して値を設定する。
<p/>
下記にデフォルトの設定値を示す。
<pre>
列区切り文字                          -->  ","
行区切り文字                          -->  "\r\n"(CRLF)
フィールド囲み文字                    -->  """
空行を無視するか否か                  -->  無視する(true)
ヘッダ行が必須か否か                  -->  必須(true)
ヘッダーに出力するタイトル            -->  空のString型配列
プロパティ名リスト                    -->  空のString型配列
文字コード                            -->  UTF-8
空のフィールドをnullに変換するか否か  --> 変換する(true)
フィールド囲み文字で囲む
フィールドを指定するモード            -->  NORMAL(フィールド囲み文字、フィールド区切り文字、改行が存在するフィールドが対象となる)
フィールド囲み文字で囲む
フィールドのリスト                    -->  空のリスト
</pre>

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### VALID_LINE_SEPARATOR

```java
private static final Pattern VALID_LINE_SEPARATOR
```

有効な改行文字

---

### fieldSeparator

```java
private final char fieldSeparator
```

列区切り文字

---

### lineSeparator

```java
private final String lineSeparator
```

行区切り文字

---

### quote

```java
private final char quote
```

フィールド囲み文字

---

### ignoreEmptyLine

```java
private final boolean ignoreEmptyLine
```

空行を無視するか否か

---

### requiredHeader

```java
private final boolean requiredHeader
```

ヘッダ行(タイトル行)が必須か否か

---

### charset

```java
private final Charset charset
```

文字コード

---

### quoteMode

```java
private final QuoteMode quoteMode
```

出力時にフィールド囲み文字で囲むフィールドを指定するモード

---

### emptyToNull

```java
private final boolean emptyToNull
```

空のフィールドをnullに変換するかどうか

---

### quotedColumnNames

```java
private final List<String> quotedColumnNames
```

出力時にフィールド囲み文字で囲むフィールドのリスト

---

### headerTitles

```java
private final String[] headerTitles
```

ヘッダーレコードに出力するタイトルリスト

---

### properties

```java
private final String[] properties
```

プロパティ名リスト

---

### DEFAULT

```java
public static final CsvDataBindConfig DEFAULT
```

デフォルトのフォーマット定義

---

### RFC4180

```java
public static final CsvDataBindConfig RFC4180
```

RFC4180準拠のフォーマット定義

---

### EXCEL

```java
public static final CsvDataBindConfig EXCEL
```

EXCEL形式のCSVフォーマット定義

---

### TSV

```java
public static final CsvDataBindConfig TSV
```

タブ区切り(TSV)のフォーマット定義

---

## コンストラクタの詳細

### CsvDataBindConfig

```java
public CsvDataBindConfig(char fieldSeparator, String lineSeparator, char quote, boolean ignoreEmptyLine, boolean requiredHeader, String[] headerTitles, Charset charset, boolean emptyToNull, QuoteMode quoteMode, List<String> quotedColumnNames)
```

CSVのフォーマット定義を生成する。

**パラメータ:**
- `fieldSeparator` - 列区切り文字
- `lineSeparator` - 行区切り文字(\r\n(CRLF) or \r(CR) or \n(LF)であること)
- `quote` - フィールド囲み文字
- `ignoreEmptyLine` - 空行を無視するか否か
- `requiredHeader` - ヘッダ行(タイトル行)が必須か否か
- `headerTitles` - ヘッダーに出力するタイトル
- `charset` - 文字コード
- `emptyToNull` - 空のフィールドをnullに変換するかどうか
- `quoteMode` - 出力時にフィールド囲み文字で囲むフィールドを指定するモード
- `quotedColumnNames` - フィールド囲み文字で囲むフィールドのリスト

**例外:**
- `IllegalArgumentException` - 行区切り文字が「\r\n(CRLF)・\r(CR)・\n(LF)」以外の場合

---

### CsvDataBindConfig

```java
public CsvDataBindConfig(char fieldSeparator, String lineSeparator, char quote, boolean ignoreEmptyLine, boolean requiredHeader, String[] headerTitles, String[] properties, Charset charset, boolean emptyToNull, QuoteMode quoteMode, List<String> quotedColumnNames)
```

CSVのフォーマット定義を生成する。

**パラメータ:**
- `fieldSeparator` - 列区切り文字
- `lineSeparator` - 行区切り文字(\r\n(CRLF) or \r(CR) or \n(LF)であること)
- `quote` - フィールド囲み文字
- `ignoreEmptyLine` - 空行を無視するか否か
- `requiredHeader` - ヘッダ行(タイトル行)が必須か否か
- `headerTitles` - ヘッダーに出力するタイトル
- `properties` - プロパティ名リスト
- `charset` - 文字コード
- `emptyToNull` - 空のフィールドをnullに変換するかどうか
- `quoteMode` - 出力時にフィールド囲み文字で囲むフィールドを指定するモード
- `quotedColumnNames` - フィールド囲み文字で囲むフィールドのリスト

**例外:**
- `IllegalArgumentException` - 行区切り文字が「\r\n(CRLF)・\r(CR)・\n(LF)」以外の場合

---

## メソッドの詳細

### getFieldSeparator

```java
public char getFieldSeparator()
```

列区切り文字を取得する。

**戻り値:**
列区切り文字

---

### withFieldSeparator

```java
public CsvDataBindConfig withFieldSeparator(char newFieldSeparator)
```

列区切り文字を設定する。

**パラメータ:**
- `newFieldSeparator` - 新しい列区切り文字

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getLineSeparator

```java
public String getLineSeparator()
```

行区切り文字を取得する。

**戻り値:**
行区切り文字

---

### withLineSeparator

```java
public CsvDataBindConfig withLineSeparator(String newLineSeparator)
```

改行文字を設定する。
<p/>
改行文字が(CR|LF|CRLF)以外の場合はエラーとする。

**パラメータ:**
- `newLineSeparator` - 改行文字

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getQuote

```java
public char getQuote()
```

フィールド囲み文字を取得する。

**戻り値:**
フィールド囲み文字

---

### withQuote

```java
public CsvDataBindConfig withQuote(char newQuote)
```

フィールド囲み文字を設定する。

**パラメータ:**
- `newQuote` - フィールド囲み文字

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### isIgnoreEmptyLine

```java
public boolean isIgnoreEmptyLine()
```

空行を無視するか否かを取得する。

**戻り値:**
空行を無視する場合{@code true}

---

### withIgnoreEmptyLine

```java
public CsvDataBindConfig withIgnoreEmptyLine()
```

空行を無視する。

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### withIgnoreEmptyLine

```java
public CsvDataBindConfig withIgnoreEmptyLine(boolean newOption)
```

空行を無視するか否かを設定する。

**パラメータ:**
- `newOption` - 空行を無視する場合{@code true}

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### isRequiredHeader

```java
public boolean isRequiredHeader()
```

ヘッダー行(タイトル行)が必須か否か。

**戻り値:**
ヘッダー行(タイトル行)が必須の場合{@code true}

---

### withRequiredHeader

```java
public CsvDataBindConfig withRequiredHeader()
```

ヘッダー行(タイトル行)を必須に設定する。

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### withRequiredHeader

```java
public CsvDataBindConfig withRequiredHeader(boolean newOption)
```

ヘッダー行(タイトル行)を必須とするか否かを設定する。

**パラメータ:**
- `newOption` - ヘッダーが必須な場合{@code true}

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getHeaderTitles

```java
public String[] getHeaderTitles()
```

ヘッダー行(タイトル行)に出力するタイトルのリスト。

**戻り値:**
ヘッダー行に出力するタイトル

---

### withHeaderTitles

```java
public CsvDataBindConfig withHeaderTitles(String newHeaderTitles)
```

ヘッダー行(タイトル行)に出力するタイトルを設定する。

**パラメータ:**
- `newHeaderTitles` - ヘッダー行(タイトル行)に出力するタイトル

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getProperties

```java
public String[] getProperties()
```

プロパティ名リストを取得する。

**戻り値:**
プロパティ名リスト

---

### withProperties

```java
public CsvDataBindConfig withProperties(String newProperties)
```

プロパティ名リストを設定する。

**パラメータ:**
- `newProperties` - プロパティ名リスト

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getKeys

```java
public String[] getKeys()
```

オブジェクトにマッピングする際に使用するキーのリストを取得する。
<p>
{@link #properties}が設定されていれば、{@link #properties}をキーとして返す。<br>
{@link #properties}が設定されていなければ、{@link #headerTitles}をキーとして返す。

**戻り値:**
キーのリスト

---

### getCharset

```java
public Charset getCharset()
```

文字コードを取得する。

**戻り値:**
文字コード

---

### withCharset

```java
public CsvDataBindConfig withCharset(String newCharset)
```

文字コードを設定する。

**パラメータ:**
- `newCharset` - 文字コード

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### withCharset

```java
public CsvDataBindConfig withCharset(Charset newCharset)
```

文字コードを設定する。

**パラメータ:**
- `newCharset` - 文字コード

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### isEmptyToNull

```java
public boolean isEmptyToNull()
```

空フィールドをnullに置き換えるか否か。

**戻り値:**
置き換える場合は{@code true}

---

### withEmptyToNull

```java
public CsvDataBindConfig withEmptyToNull(boolean newEmptyToNull)
```

空フィールドをnullに置き換えるか否かを設定する。

**パラメータ:**
- `newEmptyToNull` - nullに置き換える場合は{@code true}

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getQuoteMode

```java
public QuoteMode getQuoteMode()
```

フィールド囲み文字で囲むフィールドを取得する。

**戻り値:**
フィールド囲み文字で囲むフィールド

---

### withQuoteMode

```java
public CsvDataBindConfig withQuoteMode(QuoteMode newQuoteMode)
```

出力時にフィールド囲み文字で囲むフィールドを設定する。

**パラメータ:**
- `newQuoteMode` - フィールド囲み文字で囲むフィールドを指定するモード

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### getQuotedColumnNames

```java
public List<String> getQuotedColumnNames()
```

出力時にフィールド囲み文字({@link #getQuote()})で囲むフィールドのリストを取得する。

**戻り値:**
フィールド囲み文字で囲むフィールドのリスト

---

### withQuotedColumnNames

```java
public CsvDataBindConfig withQuotedColumnNames(String fieldNames)
```

フィールド囲み文字({@link #getQuote()}で囲むフィールドのリストを設定する。
<p/>
{@link #getQuoteMode()}が{@link CsvDataBindConfig.QuoteMode#CUSTOM}の場合に、
設定したフィールドがフィールド囲み文字で囲まれる。

**パラメータ:**
- `fieldNames` - フィールド囲み文字で囲むフィールド名称

**戻り値:**
新しい{@link CsvDataBindConfig}

---

### verify

```java
public void verify()
```

コンフィグの妥当性検証を行う。
<p/>
以下の場合に検証エラーとする。
<ul>
    <li>ヘッダが必須でヘッダタイトルが未設定</li>
    <li>ヘッダが任意でプロパティ名が未設定</li>
    <li>ヘッダが必須でヘッダタイトルとプロパティ名のサイズが一致しない</li>
</ul>

---
