# class VariableLengthConvertorFactory

**パッケージ:** nablarch.core.dataformat.convertor

**継承階層:**
```
java.lang.Object
  └─ ConvertorFactorySupport
      └─ nablarch.core.dataformat.convertor.VariableLengthConvertorFactory
```

---

```java
public class VariableLengthConvertorFactory
extends ConvertorFactorySupport
```

可変長データコンバータのファクトリクラス。

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### DEFAULT_CONVERTOR_TABLE

```java
private static final Map<String,Class<?>> DEFAULT_CONVERTOR_TABLE
```

デフォルトのコンバータ名とコンバータ実装クラスの対応表

---

## メソッドの詳細

### getDefaultConvertorTable

```java
protected Map<String,Class<?>> getDefaultConvertorTable()
```

可変長ファイルのデフォルトのコンバータ名とコンバータ実装クラスの対応表を返却する。

**戻り値:**
固定長ファイルのデフォルトのコンバータ名とコンバータ実装クラスの対応表

---
