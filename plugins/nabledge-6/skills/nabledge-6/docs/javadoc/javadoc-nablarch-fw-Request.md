# interface Request

**パッケージ:** nablarch.fw

---

```java
public interface Request
```

リクエストを表すインタフェース。

**param:** リクエストパラメータの型  
**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## メソッドの詳細

### getRequestPath

```java
String getRequestPath()
```

リクエストパスを取得する。

**戻り値:**
リクエストパス

---

### setRequestPath

```java
Request<TParam> setRequestPath(String requestPath)
```

リクエストパスを設定する。

**パラメータ:**
- `requestPath` - リクエストパス

**戻り値:**
オブジェクト自体

---

### getParam

```java
TParam getParam(String name)
```

リクエストパラメータを取得する。

**パラメータ:**
- `name` - パラメータ名

**戻り値:**
パラメータの値

---

### getParamMap

```java
Map<String,TParam> getParamMap()
```

リクエストパラメータのMapを取得する。

**戻り値:**
リクエストパラメータのMap

---
