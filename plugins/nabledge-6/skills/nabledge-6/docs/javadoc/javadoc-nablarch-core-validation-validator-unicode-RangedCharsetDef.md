# class RangedCharsetDef

**パッケージ:** nablarch.core.validation.validator.unicode

**継承階層:**
```
java.lang.Object
  └─ CharsetDefSupport
      └─ nablarch.core.validation.validator.unicode.RangedCharsetDef
```

---

```java
public class RangedCharsetDef
extends CharsetDefSupport
```

Unicodeコードポイントの範囲による許容文字集合定義クラス。<br/>
コードポイントの開始位置と終了位置の範囲内が許容文字の集合となる。
コードポイントは、Unicode標準の U+n 表記で指定する。
<p>
例えば、制御文字を除くASCII文字を定義したい場合、以下のようにプロパティを設定する。
<pre>
// \u0020-\u007E
{@code
Charset asciiWithoutControlCode = new RangedCharsetDef();
asciiWithoutControlCode.setStartCodePoint("U+0020");
asciiWithoutControlCode.setEndCodePoint("U+007F");
}
</pre>
<p/>
コンポーネント設定ファイルに定義する場合、以下の記述が等価となる。
<pre>
{@literal
<component name="asciiWithoutControlCode" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007F" />
</component>
}
</pre>
<p/>
実行例を以下に示す。
<pre>
asciiWithoutControlCode.contains("abc012"); // -> true
asciiWithoutControlCode.contains("\t");     // -> false
</pre>
</p>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### NOT_SET_YET

```java
private static final int NOT_SET_YET
```

インスタンス変数が初期化前であることを示すための定数

---

### start

```java
private int start
```

開始位置

---

### end

```java
private int end
```

終了位置

---

### UNICODE_CODE_POINT_EXP

```java
private static final Pattern UNICODE_CODE_POINT_EXP
```

コードポイント記法の正規表現 (U+n)

---

## メソッドの詳細

### setStartCodePoint

```java
public void setStartCodePoint(String start)
                       throws IllegalArgumentException, IllegalStateException
```

開始位置のコードポイントを設定する。

**パラメータ:**
- `start` - 開始位置(U+n表記)

**例外:**
- `IllegalArgumentException` - コードポイントが範囲外の場合
- `IllegalStateException` - 開始終了位置の大小関係が逆転している場合

---

### setEndCodePoint

```java
public void setEndCodePoint(String end)
                     throws IllegalArgumentException, IllegalStateException
```

終了位置のコードポイントを設定する。

**パラメータ:**
- `end` - 終了位置(U+n表記)

**例外:**
- `IllegalArgumentException` - コードポイントが範囲外の場合
- `IllegalStateException` - 開始終了位置の大小関係が逆転している場合

---

### toCodePoint

```java
private int toCodePoint(String s)
```

文字列（U+n表記）をコードポイントに変換する。

**パラメータ:**
- `s` - 文字列

**戻り値:**
コードポイント

---

### checkRange

```java
private void checkRange(int codePoint)
                throws IllegalArgumentException
```

コードポイントの範囲をチェックする。

**パラメータ:**
- `codePoint` - チェック対象となるコードポイント

**例外:**
- `IllegalArgumentException` - コードポイントが範囲外の場合

---

### checkRelation

```java
private void checkRelation()
                   throws IllegalStateException
```

開始終了位置の関係をチェックする。

**例外:**
- `IllegalStateException` - 開始終了位置の大小関係が逆転している場合

---

### contains

```java
public boolean contains(int codePoint)
```

{@inheritDoc}

---
