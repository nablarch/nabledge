# class FixedLengthConvertorSetting

**パッケージ:** nablarch.core.dataformat.convertor

**実装されたインタフェース:**
- ConvertorSetting

---

```java
public class FixedLengthConvertorSetting
implements ConvertorSetting
```

固定長ファイルの読み書きを行う際に使用するコンバータの設定情報を保持するクラス。
データタイプのグローバル設定や、システム共通で使用するゾーン数値の符号ビットなどを、DIコンテナから設定できる。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### factory

```java
private FixedLengthConvertorFactory factory
```

コンバータのファクトリクラス

---

### defaultPositiveZoneSignNibble

```java
private Byte defaultPositiveZoneSignNibble
```

ゾーン数値の符号ビット（正）のデフォルト設定

---

### defaultNegativeZoneSignNibble

```java
private Byte defaultNegativeZoneSignNibble
```

ゾーン数値の符号ビット（負）のデフォルト設定

---

### defaultPositivePackSignNibble

```java
private Byte defaultPositivePackSignNibble
```

パック数値の符号ビット（正）のデフォルト設定

---

### defaultNegativePackSignNibble

```java
private Byte defaultNegativePackSignNibble
```

パック数値の符号ビット（負）のデフォルト設定

---

### convertEmptyToNull

```java
private boolean convertEmptyToNull
```

空文字列を{@code null}に変換するフラグ。
<p/>
デフォルトでは{@code null}に変換する({@code true})。

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

システムリポジトリ上の登録名

---

### SIGN_BIT_FORMAT

```java
private static final String SIGN_BIT_FORMAT
```

符号ビットのパターン

---

### SIGN_BIT_FORMAT_PATTERN

```java
private static final Pattern SIGN_BIT_FORMAT_PATTERN
```

符号ビットのパターン

---

### DEFAULT_SETTING

```java
private static final FixedLengthConvertorSetting DEFAULT_SETTING
```

デフォルトのコンバータ設定情報保持クラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

## メソッドの詳細

### getInstance

```java
public static FixedLengthConvertorSetting getInstance()
```

このクラスのインスタンスをリポジトリから取得し、返却する。

**戻り値:**
このクラスのインスタンス

---

### getConvertorFactory

```java
public ConvertorFactorySupport getConvertorFactory()
```

コンバータのファクトリクラスを返却する。

**戻り値:**
コンバータのファクトリクラス

---

### getDefaultPositiveZoneSignNibble

```java
public Byte getDefaultPositiveZoneSignNibble()
```

ゾーン数値の符号ビット（正） を返却する。

**戻り値:**
ゾーン数値の符号ビット（正）

---

### setDefaultPositiveZoneSignNibble

```java
public FixedLengthConvertorSetting setDefaultPositiveZoneSignNibble(String nibble)
```

ゾーン数値の符号ビット（正） を設定する。

**パラメータ:**
- `nibble` - 符号ビット（4bit）を表す文字列（[0-9a-zA-Z]）

**戻り値:**
このオブジェクト自体

---

### getDefaultNegativeZoneSignNibble

```java
public Byte getDefaultNegativeZoneSignNibble()
```

ゾーン数値の符号ビット（負） を返却する。

**戻り値:**
ゾーン数値の符号ビット（負）

---

### setDefaultNegativeZoneSignNibble

```java
public FixedLengthConvertorSetting setDefaultNegativeZoneSignNibble(String nibble)
```

ゾーン数値の符号ビット（負） を設定する。

**パラメータ:**
- `nibble` - 符号ビット（4bit）を表す文字列（[0-9a-zA-Z]）

**戻り値:**
このオブジェクト自体

---

### getDefaultPositivePackSignNibble

```java
public Byte getDefaultPositivePackSignNibble()
```

パック数値の符号ビット（正） を返却する。

**戻り値:**
パック数値の符号ビット（正）

---

### setDefaultPositivePackSignNibble

```java
public FixedLengthConvertorSetting setDefaultPositivePackSignNibble(String nibble)
```

パック数値の符号ビット（正） を設定する。

**パラメータ:**
- `nibble` - 符号ビット（4bit）を表す文字列（[0-9a-zA-Z]）

**戻り値:**
このオブジェクト自体

---

### getDefaultNegativePackSignNibble

```java
public Byte getDefaultNegativePackSignNibble()
```

パック数値の符号ビット（負） を返却する。

**戻り値:**
パック数値の符号ビット（負）

---

### setDefaultNegativePackSignNibble

```java
public FixedLengthConvertorSetting setDefaultNegativePackSignNibble(String nibble)
```

パック数値の符号ビット（負） を設定する。

**パラメータ:**
- `nibble` - 符号ビット（4bit）を表す文字列（[0-9a-zA-Z]）

**戻り値:**
このオブジェクト自体

---

### setConvertorTable

```java
public ConvertorSetting setConvertorTable(Map<String,String> table)
                                   throws ClassNotFoundException
```

コンバータ名と、コンバータの実装クラスを保持するテーブルを設定する。

**パラメータ:**
- `table` - コンバータ名と、コンバータの実装クラスを保持するテーブル

**戻り値:**
このオブジェクト自体

**例外:**
- `ClassNotFoundException` - 指定されたクラスが存在しなかった場合、
もしくは、指定されたクラスが ValueConvertorを実装していなかった場合に、スローされる例外

---

### setFixedLengthConvertorFactory

```java
public void setFixedLengthConvertorFactory(FixedLengthConvertorFactory factory)
```

{@link FixedLengthConvertorFactory}を設定する。

**パラメータ:**
- `factory` - {@link FixedLengthConvertorFactory}

---

### setConvertEmptyToNull

```java
public void setConvertEmptyToNull(boolean convertEmptyToNull)
```

空文字列を{@code null}に変換するかを設定する。
<p/>
デフォルトは{@code null}に変換する({@code true})。

**パラメータ:**
- `convertEmptyToNull` - 空文字列を{@code null}に変換するならtrue

---

### isConvertEmptyToNull

```java
public boolean isConvertEmptyToNull()
```

空文字列を{@code null}に変換するかを取得する。

**戻り値:**
空文字列を{@code null}に変換するならtrue

---
