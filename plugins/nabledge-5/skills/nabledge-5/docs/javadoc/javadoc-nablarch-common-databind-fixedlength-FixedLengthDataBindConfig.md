# class FixedLengthDataBindConfig

**パッケージ:** nablarch.common.databind.fixedlength

**実装されたインタフェース:**
- DataBindConfig

---

```java
public class FixedLengthDataBindConfig
implements DataBindConfig
```

固定長のフォーマットをあらわすクラス。

**作成者:** siosio  

---

## フィールドの詳細

### length

```java
private final int length
```

レコードの長さ(バイト数)

---

### charset

```java
private final Charset charset
```

固定長データの文字セット

---

### lineSeparator

```java
private final String lineSeparator
```

改行をあらす文字

---

### fillChar

```java
private final char fillChar
```

未定義部の埋め文字

---

### recordConfigs

```java
private final Map<String,RecordConfig> recordConfigs
```

レコードの定義

---

### multiLayoutConfig

```java
private MultiLayoutConfig multiLayoutConfig
```

マルチレイアウトの定義

---

## コンストラクタの詳細

### FixedLengthDataBindConfig

```java
public FixedLengthDataBindConfig(int length, Charset charset, String lineSeparator, char fillChar, Map<String,RecordConfig> recordConfigs, MultiLayoutConfig multiLayoutConfig)
```

固定長のフォーマットを構築する。

**パラメータ:**
- `length` - レコードの長さ(バイト数)
- `charset` - 文字セット
- `lineSeparator` - 改行をあらす文字
- `fillChar` - 未定義部の埋め文字
- `recordConfigs` - レコードの定義
- `multiLayoutConfig` - マルチレイアウトの定義

---

### FixedLengthDataBindConfig

```java
public FixedLengthDataBindConfig(int length, Charset charset, String lineSeparator, char fillChar, Map<String,RecordConfig> recordConfigs)
```

固定長のフォーマットを構築する。

**パラメータ:**
- `length` - レコードの長さ(バイト数)
- `charset` - 文字セット
- `lineSeparator` - 改行をあらす文字
- `fillChar` - 未定義部の埋め文字
- `recordConfigs` - レコードの定義

---

## メソッドの詳細

### getLength

```java
public int getLength()
```

レコードの長さ(バイト数)を返す。

**戻り値:**
レコードの長さ(バイト数)

---

### getCharset

```java
public Charset getCharset()
```

文字セットを返す。

**戻り値:**
文字セット

---

### getLineSeparator

```java
public String getLineSeparator()
```

改行をあらわす文字を返す。

**戻り値:**
改行をあらわす文字

---

### getFillChar

```java
public char getFillChar()
```

未定義部の埋め文字を返す。

**戻り値:**
未定義部の埋め文字

---

### getRecordConfig

```java
public RecordConfig getRecordConfig(String recordName)
```

レコードの定義を返す。

**パラメータ:**
- `recordName` - レコード名

**戻り値:**
レコードの定義

---

### isMultiLayout

```java
public boolean isMultiLayout()
```

マルチレイアウトか否かを返す。

**戻り値:**
マルチレイアウトであれば {@code true}

---

### getMultiLayoutConfig

```java
public MultiLayoutConfig getMultiLayoutConfig()
```

マルチレイアウトの定義を返す。

**戻り値:**
マルチレイアウトの定義

---
