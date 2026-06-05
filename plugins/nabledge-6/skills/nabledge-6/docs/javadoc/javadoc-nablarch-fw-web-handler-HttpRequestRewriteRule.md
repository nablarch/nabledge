# class HttpRequestRewriteRule

**パッケージ:** nablarch.fw.web.handler

**継承階層:**
```
java.lang.Object
  └─ RewriteRule<HttpRequest,HttpRequestRewriteRule>
      └─ nablarch.fw.web.handler.HttpRequestRewriteRule
```

---

```java
public class HttpRequestRewriteRule
extends RewriteRule<HttpRequest,HttpRequestRewriteRule>
```

{@link HttpRequest} 中のリクエストパスの書き換え処理を行うクラス。

**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### getPathToRewrite

```java
public String getPathToRewrite(HttpRequest request)
```

---

### applyRewrittenPath

```java
public void applyRewrittenPath(String rewrittenPath, HttpRequest request)
```

---

### getParam

```java
protected Object getParam(String type, String name, HttpRequest request, ExecutionContext context)
```

---

### getProperty

```java
private String getProperty(String name, HttpRequest request)
```

HTTPリクエストオブジェクト自体に付随するプロパティを返す。

**パラメータ:**
- `name` - プロパティ名
- `request` - HTTPリクエストオブジェクト

**戻り値:**
プロパティの値

---

### exportParam

```java
protected void exportParam(String scope, String name, String value, HttpRequest req, ExecutionContext context)
```

---
