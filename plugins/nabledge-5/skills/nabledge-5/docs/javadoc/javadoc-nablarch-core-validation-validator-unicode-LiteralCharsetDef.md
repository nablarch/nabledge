# class LiteralCharsetDef

**パッケージ:** nablarch.core.validation.validator.unicode

**継承階層:**
```
java.lang.Object
  └─ CharsetDefSupport
      └─ nablarch.core.validation.validator.unicode.LiteralCharsetDef
```

---

```java
public class LiteralCharsetDef
extends CharsetDefSupport
```

リテラル文字列による許容文字集合定義クラス。<br/>
定義したい文字集合の要素が、Unicodeコードポイント上に散在する場合、
範囲指定による集合定義は煩雑になるおそれがある。
そのような場合には、本クラスを利用することで簡便に文字集合を定義できる。
<pre>
{@code
// 1と3を許可
LiteralCharsetDef oneAndThree = new LiteralCharsetDef();
oneAndThree.setAllowedCharacters("13");
}
</pre>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### bitSet

```java
private BitSet bitSet
```

許容可否

---

## メソッドの詳細

### contains

```java
public boolean contains(int codePoint)
```

{@inheritDoc}

---

### setAllowedCharacters

```java
public LiteralCharsetDef setAllowedCharacters(String allowedCharacters)
```

許容文字を設定する。
許容文字がBMPの範囲外にあり表示や入力に難がある場合は、U+n表記を使用するとよい。
例えば、ホッケ(U+29E3D)の場合は&#x005C;uD867&#x005C;uDE3Dのように入力する。

**パラメータ:**
- `allowedCharacters` - 許容文字

**戻り値:**
本インスタンス自身

---

### addAllowedCharacters

```java
private void addAllowedCharacters(String allowedCharacters)
```

許容文字を追加する。

**パラメータ:**
- `allowedCharacters` - 許容文字

---
