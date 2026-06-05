# class ThymeleafResponseWriter

**パッケージ:** nablarch.fw.web.handler.responsewriter.thymeleaf

**実装されたインタフェース:**
- CustomResponseWriter

---

```java
public class ThymeleafResponseWriter
implements CustomResponseWriter
```

Thymeleafを使用する{@link CustomResponseWriter}実装クラス。
<p>
本実装では、引数で与えられたパスが、処理対象パス判定用の正規表現にマッチした場合、
処理対象と判定する。
例えば、{@link #setPathPattern(String)}に"{@literal /template/.*\.html}"を設定した場合、
パスが"/template/foo/bar.html"の時、処理対象と判定される。
pathPatternプロパティにはデフォルト値として"{@literal .*\.html}"が設定されている。
</p>
<p>
Thymeleafでは、テンプレートのパスを解決する際、サフィックスを省略できるが、
本クラスを使用する場合はサフィックスの省略は行わないこと。
<ul>
    <li>OK: {@code return new HttpResponse("/path/to/template.html");}</li>
    <li>NG: {@code return new HttpResponse("/path/to/template");}</li>
</ul>
サフィックスを省略した場合、セッションストアからリクエストスコープへの移送が行われなくなる。
</p>

**作成者:** Tsuyoshi Kawasaki  
**関連項目:** org.thymeleaf.templateresolver.AbstractConfigurableTemplateResolver#setSuffix(java.lang.String)  

---

## フィールドの詳細

### templateEngine

```java
private TemplateEngine templateEngine
```

テンプレートエンジン

---

### pathPattern

```java
private Pattern pathPattern
```

処理対象パス判定に使用する正規表現

---

## メソッドの詳細

### isResponsibleTo

```java
public boolean isResponsibleTo(String pathToTemplate, ServletExecutionContext context)
```

---

### writeResponse

```java
public void writeResponse(String pathToTemplate, ServletExecutionContext context)
                   throws IOException
```

---

### setTemplateEngine

```java
public void setTemplateEngine(TemplateEngine templateEngine)
```

{@link TemplateEngine}を設定する。

**パラメータ:**
- `templateEngine` - {@link TemplateEngine}

---

### setPathPattern

```java
public void setPathPattern(String pathPattern)
```

処理対象パス判定に使用する正規表現を設定する。

**パラメータ:**
- `pathPattern` - 処理対象パス判定用の正規表現

---
