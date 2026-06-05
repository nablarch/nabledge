# class Base64Util

**パッケージ:** nablarch.core.util

---

```java
public final class Base64Util
```

Base64エンコーディングを行うユーティリティクラス。
<p>
本クラスは、<a href="https://www.ietf.org/rfc/rfc4648.txt">RFC4648</a>の「4. Base 64 Encoding」に準拠したBase64エンコーディングを行う。
<p>
Java8以降は、標準APIの{@link java.util.Base64#getEncoder()}及び{@link java.util.Base64#getDecoder()}で取得するエンコーダ・デコーダが本クラスと同等のBase64エンコーディング機能を提供しており、本クラスは後方互換のために存在している。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### ENCODING

```java
private static final char[] ENCODING
```

エンコードの変換表

---

### DECODING

```java
private static final byte[] DECODING
```

デコードの変換表

---

## コンストラクタの詳細

### Base64Util

```java
private Base64Util()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### encode

```java
public static String encode(byte[] b)
```

バイト配列をBase64でエンコードする。
<p/>
引数にnullが渡された場合、nullを返す。<br/>
引数の長さが0の場合、空文字を返す。 <br/>
本メソッドは、エンコード結果に改行文字を追加しない。

**パラメータ:**
- `b` - バイト配列

**戻り値:**
エンコード結果の文字列

---

### getByte

```java
private static byte getByte(byte[] b, int pos)
```

文字列をバイトに変換する。

**パラメータ:**
- `b` - バイトに変換したい文字列
- `pos` - インデックス

**戻り値:**
バイト

---

### decode

```java
public static byte[] decode(String base64)
              throws IllegalArgumentException
```

Base64でエンコードした文字列をデコードする。
<p/>
引数にnullが渡された場合、nullを返す。<br/>
引数の長さが0の場合、空のバイト配列を返す。

**パラメータ:**
- `base64` - Base64でエンコードした文字列

**戻り値:**
デコード結果のバイト配列

**例外:**
- `IllegalArgumentException` - デコードできなかった場合

---

### containsInvalidCharacter

```java
private static boolean containsInvalidCharacter(String base64)
```

文字列にBase64エンコードに使用しない不正な文字が含まれているかを判定する。

**パラメータ:**
- `base64` - 文字列

**戻り値:**
不正な文字が含まれている場合はtrue

---
