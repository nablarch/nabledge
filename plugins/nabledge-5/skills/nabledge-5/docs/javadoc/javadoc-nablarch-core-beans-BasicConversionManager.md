# class BasicConversionManager

**パッケージ:** nablarch.core.beans

**実装されたインタフェース:**
- ConversionManager

---

```java
public class BasicConversionManager
implements ConversionManager
```

{@link ConversionManager}の基本実装クラス。
<p/>
フレームワークでデフォルトで用意しているコンバータを生成して提供する。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### converters

```java
private Map<Class<?>,Converter<?>> converters
```

型変換に使用する{@link Converter}を格納したMap

---

### extensionConverters

```java
private final List<ExtensionConverter<?>> extensionConverters
```

拡張型変換のList

---

## コンストラクタの詳細

### BasicConversionManager

```java
public BasicConversionManager()
```

コンストラクタ。

---

## メソッドの詳細

### getConverters

```java
public Map<Class<?>,Converter<?>> getConverters()
```

---

### getExtensionConvertor

```java
public List<ExtensionConverter<?>> getExtensionConvertor()
```

---

### setDatePatterns

```java
public void setDatePatterns(List<String> patterns)
```

日付パターンを設定する。

**パラメータ:**
- `patterns` - 日付パターン

---

### setNumberPatterns

```java
public void setNumberPatterns(List<String> patterns)
```

数値パターンを設定する。

**パラメータ:**
- `patterns` - 数値パターン

---
