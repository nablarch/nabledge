# class BeanValidationStrategy

**パッケージ:** nablarch.common.web.validator

**実装されたインタフェース:**
- ValidationStrategy

---

```java
public class BeanValidationStrategy
implements ValidationStrategy
```

BeanValidationを使用する場合のリクエスト内容のバリデーション、オブジェクト(Bean)生成ロジック.

<p>
本実装ではバリデーションエラーが発生した場合に、
リクエストパラメータから値をコピーしたオブジェクト(Bean)が、
リクエストスコープに格納する機能を持つ。
これは、バリデーションエラーが発生した時でも、JSP等でリクエストパラメータの値を
参照できるようにするためである。
本機能を有効化するには{@link #setCopyBeanToRequestScopeOnError(boolean)}に真を設定すること。
</p>

**作成者:** sumida  

---

## フィールドの詳細

### copyBeanToRequestScopeOnError

```java
private boolean copyBeanToRequestScopeOnError
```

バリデーションエラー時にBeanをリクエストスコープにコピーするかどうか

---

### formFactory

```java
private BeanValidationFormFactory formFactory
```

フォームファクトリ。
（デフォルトでは単純にリフレクションでインスタンスを生成する）

---

## コンストラクタの詳細

### BeanValidationStrategy

```java
public BeanValidationStrategy()
```

{@code BeanValidationStrategy}を生成する。

---

## メソッドの詳細

### createForm

```java
protected Serializable createForm(HttpRequest request, InjectForm annotation)
```

{@link InjectForm}のform属性で指定された型のフォームを生成する。

**パラメータ:**
- `request` - リクエスト
- `annotation` - InjectFormアノテーション

**戻り値:**
リクエストパラメータが登録されたフォーム

---

### validate

```java
public Serializable validate(HttpRequest request, InjectForm annotation, boolean notUse, ServletExecutionContext context)
```

---

### sortMessages

```java
protected List<Message> sortMessages(List<Message> messages, ServletExecutionContext context, InjectForm injectForm)
```

メッセージをソートする。
<p>
ソートされる順序は、{@link ServletRequest#getParameterNames()}の順となる。
{@link ServletRequest#getParameterNames()}に存在しない項目は、メッセージリストの末尾に移動する。

**パラメータ:**
- `messages` - ソート対象のメッセージリスト
- `context` - Servlet実行コンテキスト
- `injectForm` - {@code InjectForm}アノテーション

**戻り値:**
ソートしたメッセージリスト

---

### getParameterIndex

```java
private static int getParameterIndex(List<String> parameterNames, Message message)
```

メッセージが持つプロパティ名がパラメータ名の何番目の要素か返す。

**パラメータ:**
- `parameterNames` - パラメータ名のリスト
- `message` - メッセージ

**戻り値:**
パラメータ名の何番目か(パラメータ名にない場合はプロパティ名を持たない場合は{@link Integer#MAX_VALUE})

---

### getMapWithConvertedKey

```java
private Map<String,String[]> getMapWithConvertedKey(String prefix, Map<String,String[]> reqParamMap)
```

{@link InjectForm}のprefixに指定した文字列を、キーの先頭から削除したMapオブジェクトを返す.<br>

**パラメータ:**
- `prefix` - 項目名から削除するプレフィックス
- `reqParamMap` - リクエストパラメータを格納したMap

**戻り値:**
キーからprefixが削除されたMap

---

### setCopyBeanToRequestScopeOnError

```java
public void setCopyBeanToRequestScopeOnError(boolean copyBeanToRequestScopeOnError)
```

バリデーションエラー時に、Beanをリクエストスコープにコピーするかどうかを
設定する（デフォルトは「コピーしない」）。

**パラメータ:**
- `copyBeanToRequestScopeOnError` - コピーする場合は真を指定

---

### setFormFactory

```java
public void setFormFactory(BeanValidationFormFactory formFactory)
```

---
