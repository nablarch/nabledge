# class StringUtil

**パッケージ:** nablarch.core.util

---

```java
public final class StringUtil
```

文字列ユーティリティクラス。<br/>
文字列に関する汎用的な処理を提供する。
<p/>
本クラスのメソッドには、{@link #insert(String, String, int...)}のように
文字列編集用途に使用するメソッドも用意されている。これらのメソッドは、
例えば、電話番号をハイフン区切りに整形する等のフォーマット処理用に使用されることを想定している。
プロジェクトでフォーマット用のユーティリティを作成する場合、これらのメソッドを使用するとよい。

本クラスはサロゲートペアに対応している。

**作成者:** Hisaaki Sioiri  

---

## コンストラクタの詳細

### StringUtil

```java
private StringUtil()
```

privateコンストラクタ。

---

## メソッドの詳細

### lpad

```java
public static String lpad(String string, int length, char padChar)
```

文字列の左側に、指定された文字を指定された文字列長に到達するまで加える。
<p/>
{@code string}の文字数 >= {@code length} の場合は{@code string}の文字列をそのまま返却。<br/>
例:
<code><pre>
StringUtil.lpad("100", 10, '0'); //--> "0000000100"
</pre></code>

**パラメータ:**
- `string` - 文字列({@code null}不可)
- `length` - 変換後文字列のサイズ(0以上)
- `padChar` - 加える文字

**戻り値:**
フォーマット後文字列

---

### rpad

```java
public static String rpad(String string, int length, char padChar)
```

文字列の右側に、指定された文字を指定された文字列長に到達するまで加える。
<p/>
{@code string}の文字数 >= {@code length} の場合は{@code string}の文字列をそのまま返却。<br/>
例:
<code><pre>
StringUtil.rpad("100", 10, '0'); //--> "1000000000"
</pre></code>

**パラメータ:**
- `string` - 文字列({@code null}不可)
- `length` - 変換後文字列のサイズ(0以上)
- `padChar` - 加える文字

**戻り値:**
フォーマット後文字列

---

### isNullOrEmpty

```java
public static boolean isNullOrEmpty(String string)
```

{@code null}または空文字列判定を行う。
<pre>
|引数                | 戻り値
+--------------------+--------
| null               | true
| ""                 | true
| "hoge"             | false
| " " (半角スペース) | false
| "　"(全角スペース) | false
</pre>

**パラメータ:**
- `string` - 文字列

**戻り値:**
{@code null}または空文字列の場合は{@code true}

---

### isNullOrEmpty

```java
public static boolean isNullOrEmpty(String strings)
```

{@code null}または空文字列判定を行う。
<p/>
与えられた文字列配列内の要素全てが{@code null}または空文字であれば{@code true}を返却する。
<pre>
|引数                | 戻り値
+--------------------+--------
| null               | true
| {}                 | true
| {"", null}         | true
| { null, "a" }      | false
| " " (半角スペース) | false
| "　"(全角スペース) | false
</pre>

**パラメータ:**
- `strings` - 文字列配列

**戻り値:**
全要素が{@code null}または空文字の時、{@code true}

---

### isNullOrEmpty

```java
public static boolean isNullOrEmpty(Collection<String> strings)
```

{@code null}または空文字列判定を行う。
<p/>
与えられたコレクション内の要素全てが{@code null}または空文字であれば{@code true}を返却する。
<pre>
|引数                | 戻り値
+--------------------+--------
| null               | true
| {}                 | true
| {"", null}         | true
| { null, "a" }      | false
| " " (半角スペース) | false
| "　"(全角スペース) | false
</pre>

**パラメータ:**
- `strings` - 文字列を格納したコレクション

**戻り値:**
全要素が{@code null}または空文字の時、{@code true}

---

### hasValue

```java
public static boolean hasValue(String string)
```

Stringインスタンスが何らかの文字を含んでいるか判定する。
<p/>
{@link StringUtil#isNullOrEmpty(String)}と逆の真偽値を返却する。
否定演算子を使用することで可読性が劣る場合は本メソッドを使用すると良い。<br/>
例を以下に示す。
<code>
<pre>
private String something;

public void hasSomething() {
    return (!StringUtil.isNullOrEmpty(this.something)) {
}
</pre>
</code>
以下のように書き換えることで、単純に読み下すことができる。
<code>
<pre>
public void hasSomething() {
    return StringUtil.hasValue(this.something);
}
</pre>
</code>

**パラメータ:**
- `string` - 文字列

**戻り値:**
なんらかの文字が含まれている場合は{@code true}

---

### hasValue

```java
public static boolean hasValue(String strings)
```

文字列配列が何らかの文字列を含んでいるか判定する。
<p/>
{@link StringUtil#isNullOrEmpty(String...)}と逆の真偽値を返却する。
否定演算子を使用することで可読性が劣る場合は本メソッドを使用すると良い。

**パラメータ:**
- `strings` - 調査対象となる文字列配列

**戻り値:**
何らかの文字列を含む場合、{@code true}

---

### hasValue

```java
public static boolean hasValue(Collection<String> strings)
```

コレクションが何らかの文字列を含んでいるか判定する。
<p/>
{@link StringUtil#isNullOrEmpty(Collection)}と逆の真偽値を返却する。
否定演算子を使用することで可読性が劣る場合は本メソッドを使用すると良い。

**パラメータ:**
- `strings` - 調査対象となるコレクション

**戻り値:**
何らかの文字列を含む場合、{@code true}

---

### toString

```java
public static String toString(byte[] bytes, Charset charset)
```

指定された文字セットでバイト配列をデコードする。
<p/>
JDK1.6以上を使用する場合は、<code>java.lang.String(byte[], Charset)</code>を使用すること。<br/>
{@code bytes}が{@code null}だった場合、{@code null}を返す。

**パラメータ:**
- `bytes` - バイト配列
- `charset` - 文字セット

**戻り値:**
文字列

---

### toString

```java
public static String toString(Object value)
```

指定された値を文字列に変換する。
<p>
指定された値が{@link java.math.BigDecimal}の場合には、
{@link BigDecimal#toPlainString()}を使用して文字列に変換する。
それ以外のオブジェクトの場合には、{@code toString()}により文字列化を行う。

**パラメータ:**
- `value` - 文字列に変換する値

**戻り値:**
文字列に変換した値

---

### getBytes

```java
public static byte[] getBytes(String string, Charset charset)
```

指定された文字セットで文字列をエンコードする。
<p/>
JDK1.6以上を使用する場合は、<code>java.lang.String#getBytes(Charset)</code>を使用すること。<br/>
{@code string}が{@code null}だった場合、{@code null}を返す。
{@code string}が空文字だった場合、空のバイト配列を返す。

**パラメータ:**
- `string` - 文字列
- `charset` - 文字セット

**戻り値:**
バイト配列

---

### repeat

```java
public static String repeat(Object repeated, int times)
```

文字列を繰り返す。
<p/>
引数が文字列でない場合は、{@link String#valueOf(Object)}された文字列が繰り返される。

**パラメータ:**
- `repeated` - 繰り返し文字列({@code null}不可)
- `times` - 繰り返し回数(0以上)

**戻り値:**
文字列

---

### insert

```java
public static String insert(String target, String delimiter, int intervals)
```

区切り文字を文字列先頭から挿入する。
<p/>
例:
<code><pre>
StringUtil.insert("あいうえお", ",", 1, 1, 1); //-->あ,い,う,えお
</pre></code>

**パラメータ:**
- `target` - 対象文字列({@code null}不可)
- `delimiter` - 区切り文字({@code null}不可)
- `intervals` - 挿入間隔({@code null}不可・0不可)

**戻り値:**
区切り文字挿入後の文字列

---

### insertFromRight

```java
public static String insertFromRight(String target, String delimiter, int intervals)
```

区切り文字を右側から挿入する。
<p/>
例:
<code><pre>
StringUtil.insertFromRight("あいうえお", ",", 1, 1, 1); //-->あい,う,え,お
</pre></code>

**パラメータ:**
- `target` - 対象文字列({@code null}不可)
- `delimiter` - 区切り文字({@code null}不可)
- `intervals` - 文字列後ろからの挿入間隔({@code null}不可・0不可)

**戻り値:**
区切り文字挿入後の文字列

---

### insertRepeatedly

```java
public static String insertRepeatedly(String target, String delimiter, int interval)
```

区切り文字を等間隔で挿入する。
<p/>
例:
<code><pre>
StringUtil.insertRepeatedly("あいうえお", ",", 1) //-->あ,い,う,え,お
</pre></code>

**パラメータ:**
- `target` - 対象文字列({@code null}不可)
- `delimiter` - 区切り文字({@code null}不可)
- `interval` - 間隔(0不可)

**戻り値:**
区切り文字挿入後の文字列

---

### insertRepeatedlyFromRight

```java
public static String insertRepeatedlyFromRight(String target, String delimiter, int interval)
```

区切り文字を右側から等間隔で挿入する。
<p/>
例：
<code><pre>
StringUtil.insertRepeatedlyFromRight("あいうえお", ",", 1) //-->あ,い,う,え,お
</pre></code>

**パラメータ:**
- `target` - 対象文字列
- `delimiter` - 区切り文字
- `interval` - 間隔(0不可)

**戻り値:**
区切り文字挿入後の文字列

---

### insertAtRegularInterval

```java
private static StringBuilder insertAtRegularInterval(String delimiter, int interval, StringIterator itr)
```

区切り文字を等間隔で挿入する。

**パラメータ:**
- `delimiter` - 区切り文字({@code null}不可)
- `interval` - 間隔
- `itr` - 文字列走査に使用するイテレータ

**戻り値:**
区切り文字挿入後の文字列

---

### assertNotTrue

```java
private static void assertNotTrue(boolean conditionThatMustNotBeTrue, String msgWhenTrue)
```

条件式が成り立たないことを表明する。<br/>

**パラメータ:**
- `conditionThatMustNotBeTrue` - {@code true}であってはならない条件
- `msgWhenTrue` - 条件式が{@code true}であった場合のメッセージ

---

### assertNotNull

```java
private static void assertNotNull(Object argumentThatMustNotBeNull, String argumentName)
```

引数が{@code null}でないことを表明する。

**パラメータ:**
- `argumentThatMustNotBeNull` - {@code null}であってはならない引数
- `argumentName` - 引数の名前

---

### checkIntervals

```java
private static void checkIntervals(int[] intervals)
```

文字列挿入の間隔チェックする。<br/>
以下の場合、例外を送出する。
<ul>
<li>引数が{@code null}または要素数が0の場合</li>
<li>要素のうち、いずれかが0以下である場合</li>
</ul>

**パラメータ:**
- `intervals` - 間隔

---

### checkInterval

```java
private static void checkInterval(int interval)
```

文字列挿入の間隔をチェックする。
0以下の場合は例外を送出する。

**パラメータ:**
- `interval` - 間隔

---

### chomp

```java
public static String chomp(String target, String end)
```

行末の文字列を切り落とす。

**パラメータ:**
- `target` - 文字列({@code null}不可)
- `end` - 取り除く文字列({@code null}不可)

**戻り値:**
行末を取り除いた文字列

**例外:**
- `{@link` - IllegalArgumentException} 引数が{@code null}の場合

---

### merge

```java
public static String[] merge(String[] arrays)
```

文字列配列を連結する。

**パラメータ:**
- `arrays` - 配列({@code null}不可)

**戻り値:**
連結後の配列

**例外:**
- `{@link` - IllegalArgumentException} 配列が{@code null}の場合

---

### toArray

```java
public static String[] toArray(Collection<String> collection)
```

コレクションを配列に変換する。

**パラメータ:**
- `collection` - 変換対象のコレクション({@code null}不可)

**戻り値:**
変換後の配列

**例外:**
- `{@link` - IllegalArgumentException} 変換対象のコレクションが{@code null}の場合

---

### lowerAndTrimUnderScore

```java
public static String lowerAndTrimUnderScore(String value)
```

大文字を小文字にし、アンダースコアを削除する。
<p/>

**パラメータ:**
- `value` - 変換対象の文字列({@code null}不可)

**戻り値:**
変換後の文字列

---

### nullToEmpty

```java
public static String nullToEmpty(String value)
```

引数で渡された値が{@code null}の場合、空文字を返却する。<br/>
そうでない場合は、引数をそのまま返却する。
<pre>
{@code
StringUtil.nullToEmpty(null);   //--> ""
StringUtil.nullToEmpty("");     //--> ""
StringUtil.nullToEmpty("hoge"); //--> "hoge"
}
</pre>

**パラメータ:**
- `value` - 変換対象の値

**戻り値:**
変換後の値

---

### join

```java
public static String join(String separator, List<String> params)
```

複数の文字列をセパレータを挟んで結合する。

**パラメータ:**
- `separator` - セパレータ
- `params` - 結合する文字列

**戻り値:**
セパレータで結合した文字列

---

### join

```java
public static String join(String separator, List<String> params, String nullToString)
```

複数の文字列をセパレータを挟んで結合する。

**パラメータ:**
- `separator` - セパレータ
- `params` - 結合する文字列
- `nullToString` - 結合する文字列がnullの場合に使用する文字列

**戻り値:**
セパレータで結合した文字列

---

### split

```java
public static List<String> split(String str, String separator)
```

文字列をセパレータで分割する。

**パラメータ:**
- `str` - 分割対象文字列
- `separator` - セパレータ

**戻り値:**
分割された文字列

---

### split

```java
public static List<String> split(String str, String separator, boolean trim)
```

文字列をセパレータで分割する。

**パラメータ:**
- `str` - 文字列
- `separator` - セパレータ
- `trim` - 分割後の文字列をトリムする場合、{@code true}

**戻り値:**
分割された文字列

---
