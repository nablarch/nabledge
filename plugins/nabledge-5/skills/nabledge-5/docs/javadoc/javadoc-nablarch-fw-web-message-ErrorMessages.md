# class ErrorMessages

**パッケージ:** nablarch.fw.web.message

---

```java
public class ErrorMessages
```

エラーメッセージを保持するクラス。

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### EMPTY_INSTANCE

```java
private static final ErrorMessages EMPTY_INSTANCE
```

空のインスタンス

---

### allMessages

```java
private final List<String> allMessages
```

全てのメッセージのリスト

---

### globalMessages

```java
private final List<String> globalMessages
```

グローバルなメッセージのリスト

---

### propertyMessages

```java
private final PropertyMessages propertyMessages
```

プロパティ名に紐づくメッセージを保持するオブジェクト *

---

## コンストラクタの詳細

### ErrorMessages

```java
public ErrorMessages(ApplicationException applicationException)
```

{@link ApplicationException}からオブジェクトを構築する。

**パラメータ:**
- `applicationException` - エラーメッセージを持つアプリケーション例外

---

### ErrorMessages

```java
private ErrorMessages()
```

空の{@link ErrorMessages}を構築するコンストラクタ。

---

## メソッドの詳細

### empty

```java
public static ErrorMessages empty()
```

空の{@link ErrorMessages}インスタンスを返す。
{@link nablarch.fw.web.handler.HttpErrorHandler HttpErrorHandler}から使用されることを想定。

**戻り値:**
空のインスタンス

---

### getMessage

```java
public String getMessage(String propertyName)
```

プロパティ名に対応したメッセージを返す。
<p>
プロパティ名に対応したメッセージが複数存在した場合には、最後に追加されたものを返す。
プロパティ名に対応したメッセージが存在しない場合は、{@code null}を返す。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
プロパティ名に対応したメッセージ(存在しない場合は{@code null})

---

### hasError

```java
public boolean hasError(String propertyName)
```

指定されたプロパティ名に対応したエラーがあるかを返す。

**パラメータ:**
- `propertyName` - プロパティ名

**戻り値:**
プロパティ名に対応したエラーがある場合は{@code true}

---

### verifyPropertyName

```java
private void verifyPropertyName(String propertyName)
```

プロパティ名の検証を行う。
<p>
プロパティ名が{@code null}の場合は、{@link IllegalArgumentException}を送出する。

**パラメータ:**
- `propertyName` - プロパティ名

---

### getPropertyMessages

```java
public List<String> getPropertyMessages()
```

プロパティに対応したメッセージをすべて返す。

**戻り値:**
プロパティ対応したメッセージのリスト

---

### getGlobalMessages

```java
public List<String> getGlobalMessages()
```

グローバルなメッセージ(プロパティに紐付かないメッセージ)をすべて返す。

**戻り値:**
グローバルなメッセージのリスト

---

### getAllMessages

```java
public List<String> getAllMessages()
```

全てのメッセージを返す。

**戻り値:**
全てのメッセージのリスト

---
