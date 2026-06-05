# interface Normalizer

**パッケージ:** nablarch.fw.web.handler.normalizer

---

```java
public interface Normalizer
```

ノーマライズを行うインタフェース。

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### canNormalize

```java
boolean canNormalize(String key)
```

このパラメータをノーマライズするか否か。

**パラメータ:**
- `key` - パラメータのキー

**戻り値:**
ノーマライズ対象の場合は {@code true}

---

### normalize

```java
String[] normalize(String[] value)
```

ノーマライズを行う。

**パラメータ:**
- `value` - ノーマライズ対象の値

**戻り値:**
ノーマライズ後の値

---
