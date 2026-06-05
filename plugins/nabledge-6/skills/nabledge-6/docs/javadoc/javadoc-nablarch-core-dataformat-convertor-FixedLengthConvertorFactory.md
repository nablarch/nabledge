# class FixedLengthConvertorFactory

**パッケージ:** nablarch.core.dataformat.convertor

**継承階層:**
```
java.lang.Object
  └─ ConvertorFactorySupport
      └─ nablarch.core.dataformat.convertor.FixedLengthConvertorFactory
```

---

```java
public class FixedLengthConvertorFactory
extends ConvertorFactorySupport
```

固定長ファイルの読み書きを行う際に使用するコンバータのファクトリクラス。

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

固定長ファイルのデフォルトのコンバータ名とコンバータ実装クラスの対応表を返却する。

**戻り値:**
固定長ファイルのデフォルトのコンバータ名とコンバータ実装クラスの対応表

---
