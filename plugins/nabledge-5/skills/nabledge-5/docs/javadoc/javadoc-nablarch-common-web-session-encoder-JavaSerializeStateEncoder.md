# class JavaSerializeStateEncoder

**パッケージ:** nablarch.common.web.session.encoder

**実装されたインタフェース:**
- StateEncoder

---

```java
public class JavaSerializeStateEncoder
implements StateEncoder
```

Java標準のSerialize機構を使用した{@link StateEncoder}実装クラス。

**作成者:** kawasima  
**作成者:** tajima  

---

## メソッドの詳細

### encode

```java
public byte[] encode(T obj)
```

---

### decode

```java
public T decode(byte[] dmp, Class<T> type)
```

---
