# class ValidationUtil

**パッケージ:** nablarch.core.validation

---

```java
public final class ValidationUtil
```

バリデーションの実行時に使用するユーティリティクラス。<br/>
全てのメソッドは{@link SystemRepository}から"validationManager"という名前で取得した{@link ValidationManager}に処理を委譲する。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### VALIDATION_MANAGER_NAME

```java
private static final String VALIDATION_MANAGER_NAME
```

{@link SystemRepository}に定義されている{@link ValidationManager}の名称。

---

## コンストラクタの詳細

### ValidationUtil

```java
private ValidationUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getManager

```java
private static ValidationManager getManager()
```

{@link SystemRepository}から{@link ValidationManager}を取得する。

**戻り値:**
{@link SystemRepository}から取得した{@link ValidationManager}

**例外:**
- `IllegalStateException` - {@link ValidationManager}を取得できなかった場合

---

### validate

```java
public static void validate(ValidationContext<T> context, String[] propertyNames)
```

バリデーション対象のプロパティを指定してバリデーションを行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyNames` - バリデーション対象とするプロパティ名の配列

---

### validate

```java
public static void validate(ValidationContext<T> context, String propertyName, Class<? extends Annotation> annotation, Map<String,Object> params)
```

対象のプロパティについて、指定したアノテーションクラスに従ったバリデーションを行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyName` - バリデーション対象とするプロパティ名
- `annotation` - バリデーション用のアノテーションクラス
- `params` - バリデーション用のアノテーションパラメータ

---

### validate

```java
public static void validate(ValidationContext<T> context, String propertyName, Class<? extends Annotation> annotation)
```

対象のプロパティについて、指定したアノテーションクラスに従ったバリデーションを行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyName` - バリデーション対象とするプロパティ名
- `annotation` - バリデーション用のアノテーションクラス

---

### validateWithout

```java
public static void validateWithout(ValidationContext<T> context, String[] propertyNames)
```

バリデーション対象としないプロパティを指定してバリデーションを行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト
- `propertyNames` - バリデーション対象としないプロパティ名の配列

---

### validateAll

```java
public static void validateAll(ValidationContext<T> context)
```

すべてのプロパティについてバリデーションを行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - バリデーションコンテキスト

---

### validateAndConvertRequest

```java
public static ValidationContext<T> validateAndConvertRequest(Class<T> targetClass, Map<String,?> params, String validateFor)
```

リクエストのバリデーションと変換を行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `targetClass` - バリデーション対象のフォームクラス
- `params` - バリデーション対象のデータ
- `validateFor` - targetClassのバリデーション対象メソッドに付与した{@link ValidateFor}の値

**戻り値:**
バリデーション結果の入ったバリデーションコンテキスト

---

### validateAndConvertRequest

```java
public static ValidationContext<T> validateAndConvertRequest(Class<T> targetClass, Validatable<?> request, String validateFor)
```

リクエストのバリデーションと変換を行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `targetClass` - バリデーション対象のフォームクラス
- `request` - リクエスト
- `validateFor` - targetClassのバリデーション対象メソッドに付与した{@link ValidateFor}の値

**戻り値:**
バリデーション結果の入ったバリデーションコンテキスト

---

### validateAndConvertRequest

```java
public static ValidationContext<T> validateAndConvertRequest(String prefix, Class<T> targetClass, Map<String,?> params, String validateFor)
```

リクエストのバリデーションと変換を行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `prefix` - リクエストパラメータ名のプレフィクス
- `targetClass` - バリデーション対象のフォームクラス
- `params` - バリデーション対象のデータ
- `validateFor` - targetClassのバリデーション対象メソッドに付与した{@link ValidateFor}の値

**戻り値:**
バリデーション結果の入ったバリデーションコンテキスト

---

### validateAndConvertRequest

```java
public static ValidationContext<T> validateAndConvertRequest(String prefix, Class<T> targetClass, Validatable<?> request, String validateFor)
```

リクエストのバリデーションと変換を行う。
<p/>
バリデーション結果は{@link ValidationContext}に保持される。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `prefix` - リクエストパラメータ名のプレフィクス
- `targetClass` - バリデーション対象のフォームクラス
- `request` - リクエスト
- `validateFor` - targetClassのバリデーション対象メソッドに付与した{@link ValidateFor}の値

**戻り値:**
バリデーション結果の入ったバリデーションコンテキスト

---

### createMessageForProperty

```java
public static Message createMessageForProperty(String fullPropertyName, String messageId, Object options)
```

特定のプロパティに対するバリデーションエラーメッセージを作成する。

**パラメータ:**
- `fullPropertyName` - プレフィクスを含むプロパティ名
- `messageId` - エラーメッセージのメッセージID
- `options` - メッセージフォーマットのテンプレート文字列に埋め込む値

**戻り値:**
特定のプロパティに対するバリデーションエラーメッセージ

---
