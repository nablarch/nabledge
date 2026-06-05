# interface SecureResponseHeader

**パッケージ:** nablarch.fw.web.handler.secure

---

```java
public interface SecureResponseHeader
```

セキュリティに関連したレスポンスヘッダを返すインタフェース

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### getName

```java
String getName()
```

レスポンスヘッダの名前を返す。

**戻り値:**
レスポンスヘッダの名前

---

### getValue

```java
String getValue()
```

レスポンスヘッダの値を返す。

**戻り値:**
レスポンスヘッダの値

---

### isOutput

```java
boolean isOutput(HttpResponse response, ServletExecutionContext context)
```

このヘッダを出力するか否かを返す。

**パラメータ:**
- `response` - レスポンスオブジェクト
- `context` - Servlet APIの情報を持つコンテキスト

**戻り値:**
出力する場合は{@code true}

---
