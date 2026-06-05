# class EntityResponse

**パッケージ:** nablarch.fw.jaxrs

**継承階層:**
```
java.lang.Object
  └─ HttpResponse
      └─ nablarch.fw.jaxrs.EntityResponse
```

---

```java
public class EntityResponse
extends HttpResponse
```

Entityを持つレスポンス。

{@link javax.ws.rs.Produces}を使用した場合に
レスポンスヘッダとステータスコードを指定したい場合に使用する。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### entity

```java
private Object entity
```

エンティティ

---

### statusCodeSet

```java
private boolean statusCodeSet
```

ステータスコードが設定されたか否か

---

## メソッドの詳細

### getEntity

```java
public Object getEntity()
```

エンティティを取得する。

**戻り値:**
エンティティ

---

### setEntity

```java
public EntityResponse setEntity(Object entity)
```

エンティティを設定する。

**パラメータ:**
- `entity` - エンティティ

---

### setStatusCode

```java
public HttpResponse setStatusCode(int code)
```

---

### isStatusCodeSet

```java
public boolean isStatusCodeSet()
```

ステータスコードが設定されたかを判定する。

**戻り値:**
ステータスコードが設定された場合はtrue

---
