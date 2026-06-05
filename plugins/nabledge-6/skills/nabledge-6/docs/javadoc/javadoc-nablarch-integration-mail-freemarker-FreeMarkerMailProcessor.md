# class FreeMarkerMailProcessor

**パッケージ:** nablarch.integration.mail.freemarker

**実装されたインタフェース:**
- TemplateEngineMailProcessor

---

```java
public class FreeMarkerMailProcessor
implements TemplateEngineMailProcessor
```

FreeMarkerを使用する{@link TemplateEngineMailProcessor}の実装クラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### configuration

```java
private Configuration configuration
```

FreeMarkerの設定

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

テンプレートIDと言語から取得されたテンプレートと変数をマージして、その結果を返す。

<p>
テンプレートの検索は{@link Configuration#getTemplate(String, Locale)}が使われる。
テンプレートと変数のマージは{@link Template#process(Object, java.io.Writer)}が使われる。
</p>

---

### setConfiguration

```java
public void setConfiguration(Configuration configuration)
```

FreeMarkerのエントリーポイントとなる{@link Configuration}を設定する。

**パラメータ:**
- `configuration` - FreeMarkerの設定

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
