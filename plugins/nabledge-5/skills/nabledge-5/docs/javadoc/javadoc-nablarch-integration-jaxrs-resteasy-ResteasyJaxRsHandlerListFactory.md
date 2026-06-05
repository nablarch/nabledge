# class ResteasyJaxRsHandlerListFactory

**パッケージ:** nablarch.integration.jaxrs.resteasy

**実装されたインタフェース:**
- JaxRsHandlerListFactory

---

```java
public class ResteasyJaxRsHandlerListFactory
implements JaxRsHandlerListFactory
```

Resteasyを使用する{@link JaxRsHandlerListFactory}の実装クラス。

**作成者:** Naoki Yamamoto  

---

## フィールドの詳細

### handlerList

```java
private final List<Handler<HttpRequest,?>> handlerList
```

{@link Handler}のリスト

---

## コンストラクタの詳細

### ResteasyJaxRsHandlerListFactory

```java
public ResteasyJaxRsHandlerListFactory()
```

コンストラクタ。

---

## メソッドの詳細

### createObject

```java
public List<Handler<HttpRequest,?>> createObject()
```

---
