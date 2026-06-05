# class TrimNormalizer

**パッケージ:** nablarch.fw.web.handler.normalizer

**実装されたインタフェース:**
- Normalizer

---

```java
public class TrimNormalizer
implements Normalizer
```

前後のホワイトスペース({@link Character#isWhitespace(int)})を除去するノーマライザ実装クラス。

ホワイトスペースを除去した結果、空文字列となった場合には{@code null}に置き換える。

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### canNormalize

```java
public boolean canNormalize(String key)
```

全てのパラメータがトリム対象なので、常に{@code true}を返す。

---

### normalize

```java
public String[] normalize(String[] value)
```

前後のホワイトスペースを除去した値を返す。

**戻り値:**
前後のホワイトスペースを除去した値

---

### trimWhiteSpace

```java
private static String trimWhiteSpace(String value)
```

ホワイトスペースをトリムする。

**パラメータ:**
- `value` - トリム対象の値

**戻り値:**
トリム後の値

---
