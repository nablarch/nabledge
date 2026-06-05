# class JaxRsMethodBinderFactory

**パッケージ:** nablarch.fw.jaxrs

**実装されたインタフェース:**
- MethodBinderFactory<Object>

---

```java
public class JaxRsMethodBinderFactory
implements MethodBinderFactory<Object>
```

JAX-RS用の{@link MethodBinder}を生成する。

**作成者:** Hisaaki Shioiri  

---

## フィールドの詳細

### handlerList

```java
private List<Handler<HttpRequest,?>> handlerList
```

ハンドラリスト

---

## メソッドの詳細

### create

```java
public MethodBinder<HttpRequest,Object> create(String methodName)
```

---

### setHandlerList

```java
public void setHandlerList(List<Handler<HttpRequest,?>> handlerList)
```

ハンドラリストを設定する。

**パラメータ:**
- `handlerList` - ハンドラリスト

---
