# class XmlDataConvertorFactory

**パッケージ:** nablarch.core.dataformat.convertor

**継承階層:**
```
java.lang.Object
  └─ ConvertorFactorySupport
      └─ nablarch.core.dataformat.convertor.XmlDataConvertorFactory
```

---

```java
public class XmlDataConvertorFactory
extends ConvertorFactorySupport
```

XMLデータコンバータのファクトリクラス。

**作成者:** TIS  

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

XMLデータのデフォルトのコンバータ名とコンバータ実装クラスの対応表を返却する。

**戻り値:**
XMLデータのデフォルトのコンバータ名とコンバータ実装クラスの対応表

---
