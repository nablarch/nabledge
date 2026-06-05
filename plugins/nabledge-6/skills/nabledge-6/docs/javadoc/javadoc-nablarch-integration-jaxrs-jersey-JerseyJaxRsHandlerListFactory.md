# class JerseyJaxRsHandlerListFactory

**パッケージ:** nablarch.integration.jaxrs.jersey

**実装されたインタフェース:**
- JaxRsHandlerListFactory

---

```java
public class JerseyJaxRsHandlerListFactory
implements JaxRsHandlerListFactory
```

Jerseyを使用する{@link JaxRsHandlerListFactory}の実装クラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### handlerList

```java
private final List<Handler<HttpRequest,?>> handlerList
```

{@link Handler}のリスト

---

## コンストラクタの詳細

### JerseyJaxRsHandlerListFactory

```java
public JerseyJaxRsHandlerListFactory()
```

コンストラクタ。

---

## メソッドの詳細

### createObject

```java
public List<Handler<HttpRequest,?>> createObject()
```

---
