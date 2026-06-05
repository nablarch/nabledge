# interface ObjectMapper

**パッケージ:** nablarch.common.databind

**継承階層:**
```
java.lang.Object
  └─ Closeable
      └─ nablarch.common.databind.ObjectMapper
```

---

```java
public interface ObjectMapper
extends Closeable
```

Javaオブジェクトと任意のフォーマットをバインディングするインタフェース。

**param:** バインディング対象のJavaオブジェクトの型  
**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### write

```java
void write(T object)
```

オブジェクトの情報をアウトプットする。

**パラメータ:**
- `object` - オブジェクト

---

### read

```java
T read()
```

オブジェクトにマッピングする。

**戻り値:**
オブジェクト

---

### close

```java
void close()
```

リソースを開放する。

---
