# class TemplateMailContext

**パッケージ:** nablarch.common.mail

**継承階層:**
```
java.lang.Object
  └─ MailContext
      └─ nablarch.common.mail.TemplateMailContext
```

---

```java
public class TemplateMailContext
extends MailContext
```

定型メール送信要求を表すクラス。

**作成者:** Shinsuke Yoshio  

---

## フィールドの詳細

### templateId

```java
private String templateId
```

テンプレートID

---

### lang

```java
private String lang
```

言語

---

### variables

```java
private final Map<String,Object> variables
```

テンプレートとマージする変数

---

## コンストラクタの詳細

### TemplateMailContext

```java
public TemplateMailContext()
```

{@link TemplateMailContext}のインスタンスを生成する。

---

## メソッドの詳細

### getTemplateId

```java
public String getTemplateId()
```

テンプレートIDを取得する。

**戻り値:**
テンプレートID

---

### setTemplateId

```java
public void setTemplateId(String templateId)
```

テンプレートIDを設定する。

**パラメータ:**
- `templateId` - テンプレートID

---

### getLang

```java
public String getLang()
```

言語を取得する。

**戻り値:**
言語

---

### setLang

```java
public void setLang(String lang)
```

言語を設定する。

**パラメータ:**
- `lang` - 言語

---

### getReplaceKeyValue

```java
public Map<String,String> getReplaceKeyValue()
```

プレースホルダのキーと置換文字列のマップを取得する。

**戻り値:**
プレースホルダと置換文字列のマップ

---

### getVariables

```java
public Map<String,Object> getVariables()
```

テンプレートとマージする変数を取得する。

**戻り値:**
テンプレートとマージする変数

---

### setReplaceKeyValue

```java
public void setReplaceKeyValue(String key, String value)
```

メールテンプレート中のプレースホルダのキーと置換文字列を追加する。
<p/>
プレースホルダは、指定した{@code key}をもとに{@code value}で置換される。<br/>
<b>プレースホルダの記述形式は、{キー名} と記載する。</b><br/>
プレースホルダがあるにも関わらず置換文字列が渡されない場合は、変換されずメールが送信される。<br/>
ただし、テンプレートエンジンを使用したメール送信処理ではプレースホルダがあるにも関わらず
置換文字列が渡されない場合の動作はテンプレートエンジンの仕様に準ずる。

**パラメータ:**
- `key` - プレースホルダのキー
- `value` - 置換文字列(null不可)

---

### setVariable

```java
public void setVariable(String name, Object value)
```

テンプレートとマージする変数を追加する。

**パラメータ:**
- `name` - 変数名
- `value` - 値

---
