# class FixedLengthDataBindConfigBuilder

**パッケージ:** nablarch.common.databind.fixedlength

---

```java
public class FixedLengthDataBindConfigBuilder
```

固定長のフォーマットを現す{@link FixedLengthDataBindConfig}を構築するクラス。

**作成者:** siosio  

---

## フィールドの詳細

### length

```java
private int length
```

レコードの長さ(バイト数)

---

### charset

```java
private Charset charset
```

文字セット

---

### lineSeparator

```java
private String lineSeparator
```

改行を現す文字

---

### fillChar

```java
private char fillChar
```

未定義部の埋め文字

---

## コンストラクタの詳細

### FixedLengthDataBindConfigBuilder

```java
private FixedLengthDataBindConfigBuilder()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### newBuilder

```java
public static FixedLengthDataBindConfigBuilder newBuilder()
```

新しいビルダーを生成する。

**戻り値:**
新しいビルダー

---

### length

```java
public FixedLengthDataBindConfigBuilder length(int length)
```

レコードの長さを設定する。

**パラメータ:**
- `length` - レコードの長さ

**戻り値:**
自身のインスタンス

---

### charset

```java
public FixedLengthDataBindConfigBuilder charset(Charset charset)
```

文字セットを設定する。

**パラメータ:**
- `charset` - 文字セット

**戻り値:**
自身のインスタンス

---

### lineSeparator

```java
public FixedLengthDataBindConfigBuilder lineSeparator(String lineSeparator)
```

改行をあらわす文字を設定する。

**パラメータ:**
- `lineSeparator` - 改行をあらわす文字

**戻り値:**
自身のインスタンス

---

### fillChar

```java
public FixedLengthDataBindConfigBuilder fillChar(char fillChar)
```

未定義部の埋め文字を設定する。

**パラメータ:**
- `fillChar` - 未定義部の埋め文字

**戻り値:**
自身のインスタンス

---

### singleLayout

```java
public SingleLayoutBuilder singleLayout()
```

シングルレイアウト用の{@link FixedLengthDataBindConfig}を構築する。

**戻り値:**
シングルレイアウト用の{@link FixedLengthDataBindConfig}を構築するクラス

---

### multiLayout

```java
public MultiLayoutBuilder multiLayout()
```

マルチレイアウト用の{@link FixedLengthDataBindConfig}を構築する。

**戻り値:**
マルチレイアウト用の{@link FixedLengthDataBindConfig}を構築するクラス

---
