# class ContentPathRewriteRule

**パッケージ:** nablarch.fw.web.handler

**継承階層:**
```
java.lang.Object
  └─ RewriteRule<HttpResponse,ContentPathRewriteRule>
      └─ nablarch.fw.web.handler.ContentPathRewriteRule
```

---

```java
public class ContentPathRewriteRule
extends RewriteRule<HttpResponse,ContentPathRewriteRule>
```

HTTPレスポンスオブジェクト中のコンテンツパス文字列の置換ルール。

**関連項目:** HttpRewriteHandler  
**作成者:** Iwauo Tajima  

---

## メソッドの詳細

### getPathToRewrite

```java
public String getPathToRewrite(HttpResponse response)
```

---

### applyRewrittenPath

```java
public void applyRewrittenPath(String rewrittenPath, HttpResponse response)
```

---

### getParam

```java
protected Object getParam(String type, String name, HttpResponse response, ExecutionContext context)
```

---
