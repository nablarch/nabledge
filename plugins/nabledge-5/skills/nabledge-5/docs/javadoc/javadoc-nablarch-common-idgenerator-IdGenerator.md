# interface IdGenerator

**パッケージ:** nablarch.common.idgenerator

---

```java
public interface IdGenerator
```

IDを採番するインタフェース。

**作成者:** Hisaaki Sioiri  

---

## メソッドの詳細

### generateId

```java
String generateId(String id)
```

引数で指定された採番対象ID内でユニークなIDを採番する。

**パラメータ:**
- `id` - 採番対象を識別するID

**戻り値:**
採番対象ID内でユニークな採番結果のID

---

### generateId

```java
String generateId(String id, IdFormatter formatter)
```

引数で指定された採番対象ID内でユニークなIDを採番し、指定された{@link nablarch.common.idgenerator.IdFormatter}でフォーマットし返却する。

**パラメータ:**
- `id` - 採番対象を識別するID
- `formatter` - 採番したIDをフォーマットするIdFormatter

**戻り値:**
採番対象ID内でユニークな採番結果のID

---
