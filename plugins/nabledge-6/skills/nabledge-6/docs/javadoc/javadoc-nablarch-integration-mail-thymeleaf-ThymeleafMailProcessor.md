# class ThymeleafMailProcessor

**パッケージ:** nablarch.integration.mail.thymeleaf

**実装されたインタフェース:**
- TemplateEngineMailProcessor

---

```java
public class ThymeleafMailProcessor
implements TemplateEngineMailProcessor
```

Thymeleafを使用する{@link TemplateEngineMailProcessor}の実装クラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### templateEngine

```java
private ITemplateEngine templateEngine
```

Thymeleafのテンプレートエンジン

---

### delimiter

```java
private String delimiter
```

件名と本文を分けるデリミタ

---

## メソッドの詳細

### process

```java
public TemplateEngineProcessedResult process(String templateId, String lang, Map<String,Object> variables)
```

テンプレートIDから取得されたテンプレートと変数をマージして、その結果を返す。

<p>
テンプレートの検索、テンプレートと変数のマージは{@link ITemplateEngine#process(String, IContext)}が使われる。
</p>

<p>
※この実装ではテンプレートの検索が多言語対応していないため、第二引数の言語は使用されない。
</p>

---

### createContext

```java
protected IContext createContext(Map<String,Object> variables)
```

{@link IContext}を作成する。

**パラメータ:**
- `variables` - {@link #process(String, String, Map)}に渡された変数

**戻り値:**
{@link IContext}のインスタンス

---

### setTemplateEngine

```java
public void setTemplateEngine(ITemplateEngine templateEngine)
```

Thymeleafのエントリーポイントとなる{@link ITemplateEngine}を設定する。

**パラメータ:**
- `templateEngine` - Thymeleafのテンプレートエンジン

---

### setDelimiter

```java
public void setDelimiter(String delimiter)
```

件名と本文を分けるデリミタを設定する。

<p>
なにも設定されていなければ{@link TemplateEngineProcessedResult#DEFAULT_DELIMITER デフォルトのデリミタ}が使用される。
</p>

**パラメータ:**
- `delimiter` - 件名と本文を分けるデリミタ

---
