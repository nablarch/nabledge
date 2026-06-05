# class JaxbStateEncoder

**パッケージ:** nablarch.common.web.session.encoder

**実装されたインタフェース:**
- StateEncoder

---

```java
public class JaxbStateEncoder
implements StateEncoder
```

JAXBを使用した{@link StateEncoder}実装クラス。
<p/>
XMLベースのためJVMに依存せずに直列化を行うことができる。<br/>
ただし、パフォーマンス及びデータサイズの面で{@link JavaSerializeStateEncoder}に劣るため、
本クラスを使用する場面は限られる。

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
