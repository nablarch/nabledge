# class SignedNumberStringDecimal

**パッケージ:** nablarch.core.dataformat.convertor.datatype

**継承階層:**
```
java.lang.Object
  └─ NumberStringDecimal
      └─ nablarch.core.dataformat.convertor.datatype.SignedNumberStringDecimal
```

---

```java
public class SignedNumberStringDecimal
extends NumberStringDecimal
```

符号付き数値のデータタイプ。
<p>
入力時にはバイトデータを数値（BigDecimal）に変換し、
出力時にはオブジェクトをバイトデータに変換して返却する。
<p>
{@link NumberStringDecimal}を継承し、符号付き数値を読み書きする機能を追加している。
</p>
<b>データタイプの引数として設定可能なパラメータ</b>
<p>
データタイプの第1引数にはバイト長を指定する。必須項目である。
</p>
<p>
データタイプの第2引数には小数点位置を指定する。ここで指定された小数点位置に従い、データの読み書きを行う。<br/>
ただし、入力データに小数点が含まれている場合（例：123.45）は、ここで指定した小数点位置は無視され、入力データ内の小数点をもとにデータの読み込みが行われる。
</p>
<p>
本データタイプは符号付き数値の入出力データを扱うことを前提として設計されている。<br/>
入出力データとして符号なし数値のみを扱う場合は、{@link NumberStringDecimal}を使用すること。
</p>
<p>
データタイプの引数の一覧を以下に示す。</br>
<table border="1">
<tr bgcolor="#cccccc">
<th>引数</th>
<th>パラメータ名</th>
<th>パラメータの型</th>
<th>必須/任意</th>
<th>デフォルト値</th>
</tr>
<tr>
<td>第1引数</td>
<td>バイト長</td>
<td>Integer</td>
<td>必須</td>
<th>-</th>
</tr>
<tr>
<td>第2引数</td>
<td>小数点位置</td>
<td>Integer</td>
<td>任意</td>
<td>0</td>
</tr>
</table>
</p>
<b>セッターを使用して設定可能なパラメータ</b>
<p>
小数点の要否は#setRequiredDecimalPoint(boolean)によって指定できる。<br/>
trueを設定した場合、出力データに小数点が付与される。
</p>
<p>
符号位置は#setFixedSignPosition(boolean)によって指定できる。<br/>
trueを設定した場合、符号位置は固定となる。<br/>
符号位置が固定の場合、入力データの先頭に符号が存在すると想定してデータを読み込み、また、符号を先頭に付与した出力データを書き込む。
</p>
<p>
正の符号の要否は#setFixedSignPosition(boolean)によって指定できる。<br/>
trueを設定した場合、正の符号は必須となる。<br/>
正の符号が必須の場合、入力データに正の符号が含まれないと例外をスローし、また出力データの先頭に正の符号を付与する。
</p>
<p>
セッターを使用して設定可能なパラメータの一覧を以下に示す。これらのパラメータはディレクティブを使用して設定することを想定している。
<table border="1">
<tr bgcolor="#cccccc">
<th>パラメータ名</th>
<th>パラメータの型</th>
<th>必須/任意</th>
<th>デフォルト値</th>
</tr>
<tr>
<td>小数点の要否</td>
<td>boolean</td>
<td>任意</td>
<td>true</td>
</tr>
<tr>
<td>符号位置の固定/非固定</td>
<td>boolean</td>
<td>任意</td>
<td>true</td>
</tr>
<tr>
<td>正の符号の要否</td>
<td>boolean</td>
<td>任意</td>
<td>false</td>
</tr>
</table>
</p>
<p>
入力時にはトリム処理を、出力時にはパディング処理を行う。<br/>
パディング/トリム文字として、デフォルトでは"0"を使用するが、個別にパディング/トリム文字を使用することもできる。<br/>
（※パディング/トリム文字として指定できるのは1バイトの文字のみである。また、パディング/トリム文字として1～9の文字を使用することはできない）
</p>
<b>設定例</b>
<p>
入力データを読み込む場合の設定例を以下に示す。</br>
<table border="1">
<tr bgcolor="#cccccc">
<th>入力データ</th>
<th>バイト長</th>
<th>小数点位置</th>
<th>符号位置の固定/非固定</th>
<th>正の符号の要否</th>
<th>パディング/トリム文字</th>
<th>入力データ変換後の値（BigDecimal）</th>
</tr>
<tr>
<td>0000012345</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>不要</td>
<td>0</td>
<td>12345</td>
</tr>
<tr>
<td>+000012345</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>必要</td>
<td>0</td>
<td>12345</td>
</tr>
<tr>
<td>-000012345</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>不要</td>
<td>0</td>
<td>-12345</td>
</tr>
<tr>
<td>0000+12345</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>必要</td>
<td>0</td>
<td>12345</td>
</tr>
<tr>
<td>0000-12345</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>不要</td>
<td>0</td>
<td>-12345</td>
</tr>
<tr>
<td>(半角スペース4個)+12345</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>不要</td>
<td>半角スペース</td>
<td>12345</td>
</tr>
<tr>
<td>-000012345</td>
<td>10</td>
<td>2</td>
<td>固定</td>
<td>不要</td>
<td>0</td>
<td>-123.45</td>
</tr>
</table>
</p>
<p>
出力データを書き込む場合の設定例を以下に示す。</br>
<table border="1">
<tr bgcolor="#cccccc">
<th>出力データ</th>
<th>出力データの型</th>
<th>バイト長</th>
<th>小数点位置</th>
<th>符号位置の固定/非固定</th>
<th>正の符号の要否</th>
<th>パディング/トリム文字</th>
<th>出力データ変換後の値（byte[]）</th>
</tr>
<tr>
<td>12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>不要</td>
<td>0</td>
<td>0000012345</td>
</tr>
<tr>
<td>12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>必要</td>
<td>0</td>
<td>+000012345</td>
</tr>
<tr>
<td>-12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>固定</td>
<td>不要</td>
<td>0</td>
<td>-000012345</td>
</tr>
<tr>
<td>12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>必要</td>
<td>0</td>
<td>0000+12345</td>
</tr>
<tr>
<td>-12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>不要</td>
<td>0</td>
<td>0000-12345</td>
</tr>
<tr>
<td>12345</td>
<td>String</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>必要</td>
<td>半角スペース</td>
<td>(半角スペース4個)+12345</td>
</tr>
<tr>
<td>12345</td>
<td>BigDecimal</td>
<td>10</td>
<td>0</td>
<td>非固定</td>
<td>必要</td>
<td>0</td>
<td>0000+12345</td>
</tr>
<tr>
<td>12345</td>
<td>BigDecimal</td>
<td>10</td>
<td>2</td>
<td>非固定</td>
<td>必要</td>
<td>0</td>
<td>000+123.45</td>
</tr>
</table>
<br/>
小数点の要否の設定例については、親クラス{@link NumberStringDecimal}のjavadocを参照すること。
</p>

**作成者:** Masato Inoue  

---

## フィールドの詳細

### PLUS_SIGN

```java
private static final String PLUS_SIGN
```

正の符号

---

### MINUS_SIGN

```java
private static final String MINUS_SIGN
```

負の符号

---

### NUMBER_PATTERN

```java
private static final String NUMBER_PATTERN
```

数値のパターン

---

### isFixedSignPosition

```java
private boolean isFixedSignPosition
```

符号位置が固定かどうか

---

### isRequiredPlusSign

```java
private boolean isRequiredPlusSign
```

正の符号が必要かどうか

---

### plusSignBytes

```java
private byte[] plusSignBytes
```

正の符号のバイトデータ

---

### minusSignBytes

```java
private byte[] minusSignBytes
```

負の符号のバイトデータ

---

### dataPatternFixedSign

```java
private Pattern dataPatternFixedSign
```

符号位置固定、正の符号不要の数値のパターン

---

### dataPatternFixedAndRequiredPlusSign

```java
private Pattern dataPatternFixedAndRequiredPlusSign
```

符号位置固定、正の符号必要の数値のパターン

---

### dataPatternNonFixedSign

```java
private Pattern dataPatternNonFixedSign
```

符号位置非固定、正の符号不要の数値のパターン

---

### dataPatternNonFixedAndRequiredPlusSign

```java
private Pattern dataPatternNonFixedAndRequiredPlusSign
```

符号位置非固定、正の符号必要の数値のパターン

---

## メソッドの詳細

### initialize

```java
public DataType<BigDecimal,byte[]> initialize(Object args)
```

{@inheritDoc}

---

### createPattern

```java
private Pattern createPattern(Object elements)
```

パターンを生成する。

**パラメータ:**
- `elements` - 要素

**戻り値:**
パターン

---

### getPlusOrMinusPattern

```java
private String getPlusOrMinusPattern()
```

正負の符号を結合したパターンを返却する。

**戻り値:**
正負の符号を結合したパターン

---

### validateReadDataFormat

```java
protected void validateReadDataFormat(String strData)
```

入力データフォーマットの妥当性を検証する。

**パラメータ:**
- `strData` - 入力データ

---

### validateFormat

```java
private void validateFormat(String strData, Pattern pattern)
```

入力データの妥当性を検証する。

**パラメータ:**
- `strData` - 入力データ
- `pattern` - パターン

---

### trim

```java
protected String trim(String str)
```

トリム処理を行う。

**パラメータ:**
- `str` - トリム対象の文字列

**戻り値:**
トリム後の文字列

---

### convertOnWrite

```java
public byte[] convertOnWrite(Object data)
```

出力時に書き込むデータの変換を行う。
<p/>
この実装では、出力データ（数値）をバイトデータに変換する。

**パラメータ:**
- `data` - 書き込みを行うデータ

**戻り値:**
変換後のバイトデータ

---

### convertToBytes

```java
protected byte[] convertToBytes(String strData, boolean isMinus)
```

文字列をエンコーディングに従いバイトデータに変換する。
<p/>
負数の場合は符号を削除したバイトデータを返却する。

**パラメータ:**
- `strData` - 文字列
- `isMinus` - 負数かどうか

**戻り値:**
文字列を変換したバイトデータ

---

### padding

```java
private byte[] padding(byte[] bytes, boolean isMinus)
```

パディングを行う。

**パラメータ:**
- `bytes` - 出力データのバイトデータ
- `isMinus` - 負数かどうか

**戻り値:**
パディング後のバイトデータ

---

### margeBytes

```java
private byte[] margeBytes(byte[] sign, byte[] data)
```

符号とデータをマージする。

**パラメータ:**
- `sign` - 符号
- `data` - データ

**戻り値:**
符号とデータをマージしたバイトデータ

---

### getPlusSign

```java
protected String getPlusSign()
```

正の符号を取得する。
<p/>
本メソッドをオーバーライドすることで正の符号を変更することが可能である。

**戻り値:**
正の符号

---

### getMinusSign

```java
protected String getMinusSign()
```

負の符号を取得する。
<p/>
本メソッドをオーバーライドすることで負の符号を変更することが可能である。
たとえば、本メソッドを「▲」を返却するようにオーバーライドすれば、負の符号として▲が使用される。

**戻り値:**
負の符号

---

### setRequiredPlusSign

```java
public SignedNumberStringDecimal setRequiredPlusSign(boolean isRequiredPlusSign)
```

正の符号の要否を設定する。

**パラメータ:**
- `isRequiredPlusSign` - 正の符号の要否（trueの場合、必要）

**戻り値:**
このオブジェクト自体

---

### setFixedSignPosition

```java
public SignedNumberStringDecimal setFixedSignPosition(boolean isFixedSignPosition)
```

符号位置の固定/非固定を設定する。

**パラメータ:**
- `isFixedSignPosition` - 符号位置の固定/非固定（trueの場合、固定）

**戻り値:**
このオブジェクト自体

---
