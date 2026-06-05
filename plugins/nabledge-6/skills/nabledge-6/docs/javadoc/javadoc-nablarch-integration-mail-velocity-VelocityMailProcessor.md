# class VelocityMailProcessor

**パッケージ:** nablarch.integration.mail.velocity

**実装されたインタフェース:**
- TemplateEngineMailProcessor

---

```java
public class VelocityMailProcessor
implements TemplateEngineMailProcessor
```

Velocityを使用する{@link TemplateEngineMailProcessor}の実装クラス。

**作成者:** Taichi Uragami  

---

## フィールドの詳細

### velocityEngine

```java
private VelocityEngine velocityEngine
```

Velocityのエンジン

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
テンプレートの検索は{@link VelocityEngine#getTemplate(String)}が使われる。
テンプレートと変数のマージは{@link Template#merge(Context, Writer)}が使われる。
</p>

<p>
※この実装ではテンプレートの検索が多言語対応していないため、第二引数の言語は使用されない。
</p>

---

### createContext

```java
protected Context createContext(Map<String,Object> variables)
```

{@link Context}を作成する。

**パラメータ:**
- `variables` - {@link #process(String, String, Map)}に渡された変数

**戻り値:**
{@link Context}のインスタンス

---

### setVelocityEngine

```java
public void setVelocityEngine(VelocityEngine velocityEngine)
```

Velocityのエントリーポイントとなる{@link VelocityEngine}を設定する。

**パラメータ:**
- `velocityEngine` - Velocityのエンジン

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
