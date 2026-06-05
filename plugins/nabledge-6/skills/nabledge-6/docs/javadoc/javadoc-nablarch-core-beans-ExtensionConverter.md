# interface ExtensionConverter

**パッケージ:** nablarch.core.beans

---

```java
public interface ExtensionConverter
```

拡張の型変換インタフェース。
<p>
本インタフェースは、ロジックにより変換可能かを判断し型変換を行う場合に使用する。

**param:** 型変換後に返す型  
**作成者:** siosio  

---

## メソッドの詳細

### convert

```java
T convert(Class<? extends T> type, Object src)
```

型変換を行う。

**パラメータ:**
- `type` - 変換対象の型
- `src` - 変換元オブジェクト

**戻り値:**
型変換を行った結果のオブジェクト

---

### isConvertible

```java
boolean isConvertible(Class<?> type)
```

このコンバータで値変換できるか否か。

**パラメータ:**
- `type` - 変換対象の型

**戻り値:**
値変換出来る場合は{@code true}

---
