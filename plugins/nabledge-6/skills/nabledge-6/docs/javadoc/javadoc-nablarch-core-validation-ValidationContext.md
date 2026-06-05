# class ValidationContext

**パッケージ:** nablarch.core.validation

---

```java
public class ValidationContext
```

バリデーション実行中の情報を保持するクラス。

**param:** バリデーション結果で取得できる型  
**関連項目:** Message  
**作成者:** Koichi Asano  

---

## フィールドの詳細

### prefix

```java
private String prefix
```

バリデーション対象のプレフィクス。<br/>
このプレフィクスにマッチする入力値のみバリデーションの対象とする。

---

### messages

```java
private List<Message> messages
```

バリデーション結果メッセージのリスト。

---

### params

```java
private Map<String,?> params
```

変換前文字列のMap。

---

### convertedValues

```java
private Map<String,Object> convertedValues
```

変換後オブジェクトのマップ。

---

### targetClass

```java
private Class<T> targetClass
```

バリデーションの対象クラス。

---

### validateFor

```java
private String validateFor
```

バリデーション対象メソッド。

---

### formCreator

```java
private FormCreator formCreator
```

EntityCreator。

---

### invalidPropertyNames

```java
private Set<String> invalidPropertyNames
```

バリデーション結果がvalidでないプロパティの名前

---

### processedProperties

```java
private Set<String> processedProperties
```

バリデーション実行済みのプロパティ名のセット。

---

## コンストラクタの詳細

### ValidationContext

```java
public ValidationContext(String prefix, Class<T> targetClass, FormCreator formCreator, Map<String,?> params, String validateFor)
```

{@code ValidationContext}オブジェクトを生成する。

**パラメータ:**
- `prefix` - バリデーション対象のプレフィクス
- `targetClass` - バリデーション対象のクラス
- `formCreator` - FormCreator
- `params` - パラメータのMap
- `validateFor` - バリデーション対象メソッド

---

## メソッドの詳細

### addMessage

```java
public void addMessage(String messageId, Object params)
```

メッセージを追加する。

**パラメータ:**
- `messageId` - メッセージID
- `params` - メッセージに埋め込む値

---

### addMessages

```java
public void addMessages(List<Message> messages)
```

メッセージを追加する。

**パラメータ:**
- `messages` - メッセージのリスト

---

### addResultMessage

```java
public void addResultMessage(String propertyName, String messageId, Object params)
```

バリデーション結果を追加する。

**パラメータ:**
- `propertyName` - プロパティ名
- `messageId` - バリデーション結果メッセージのメッセージID
- `params` - メッセージのオプションパラメータ

**例外:**
- `IllegalArgumentException` - プロパティ名が{@code null}または空文字だった場合

---

### getMessage

```java
public StringResource getMessage(String messageId)
```

メッセージIDに対応するメッセージを取得する。

**パラメータ:**
- `messageId` - メッセージID

**戻り値:**
メッセージIDに対応するメッセージ

---

### createObject

```java
public T createObject()
```

フォームオブジェクトを生成する。

**戻り値:**
フォームオブジェクト

**例外:**
- `IllegalStateException` - フォームオブジェクトにバリデーションエラーのプロパティがある場合

---

### createDirtyObject

```java
public T createDirtyObject()
```

フォームオブジェクトを生成する。
<p/>
{@link #createObject()}と異なり、生成前にフォームオブジェクトにバリデーションエラーがあるかチェックしない。<br/>
そのため、バリデーションエラーがあるプロパティもフォームオブジェクトに設定される。<br/>
ただし、プロパティをフォームオブジェクトのプロパティの型に変換できない場合は設定されない。

**戻り値:**
フォームオブジェクト

---

### getParameters

```java
public Object getParameters(String propertyName)
```

プロパティ名に対応するプレフィクス付き文字列の配列を取得する。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
プロパティ名に対応するプレフィクス付き文字列の配列

---

### putConvertedValue

```java
public void putConvertedValue(String propertyName, Object value)
```

フォームオブジェクトのプロパティの型に変換したプロパティを追加する。

**パラメータ:**
- `propertyName` - 追加するプロパティ名
- `value` - 変換したプロパティの値

---

### getConvertedValue

```java
public Object getConvertedValue(String propertyName)
```

フォームオブジェクトのプロパティの型に変換したプロパティを取得する。
<p/>
プロパティにバリデーションエラーがある場合も変換した値を返す。
変換できない場合、プロパティが見つからない場合は{@code null}を返す。

**パラメータ:**
- `propertyName` - 取得するプロパティ名

**戻り値:**
変換したプロパティの値

---

### getTargetClass

```java
public Class<T> getTargetClass()
```

変換対象のフォームクラスを取得する。

**戻り値:**
変換対象のフォームクラス

---

### getMessages

```java
public List<Message> getMessages()
```

バリデーション結果メッセージのリストを取得する。

**戻り値:**
バリデーション結果メッセージのリスト

---

### isValid

```java
public boolean isValid()
```

バリデーションエラーがないかどうかを取得する。

**戻り値:**
バリデーションエラーがない場合は{@code true}

---

### abortIfInvalid

```java
public void abortIfInvalid()
                    throws ApplicationException
```

バリデーションエラーがある場合に、
バリデーション結果メッセージを保持した{@link ApplicationException}を送出する。
<p/>
バリデーションエラーのプロパティがない場合、本メソッドは何もしない。

**例外:**
- `ApplicationException` - バリデーションエラーのプロパティがある場合

---

### isInvalid

```java
public boolean isInvalid(String propertyName)
```

指定されたプロパティにバリデーションエラーがあるかどうか判定する。
<p/>
バリデーション対象でないプロパティ名が指定された場合は{@code false}を返す。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
指定されたプロパティにバリデーションエラーがある場合は{@code true}

---

### setPropertyProcessed

```java
public void setPropertyProcessed(String propertyName)
```

バリデーション済みプロパティのセットにプロパティを追加する。

**パラメータ:**
- `propertyName` - 追加するプロパティ名

---

### isProcessed

```java
public boolean isProcessed(String propertyName)
```

バリデーション済みプロパティか否か判定する。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
指定したプロパティがバリデーション済みである場合{@code true}

---

### getPrefix

```java
public String getPrefix()
```

バリデーション対象のプレフィクスを取得する。

**戻り値:**
バリデーション対象のプレフィクス

---

### getParams

```java
public Map<String,?> getParams()
```

プロパティの値が文字列のMapを取得する。

**戻り値:**
プロパティの値が文字列のMap

---

### getValidateFor

```java
public String getValidateFor()
```

バリデーション対象メソッドを取得する。

**戻り値:**
バリデーション対象メソッド

---
