# class ValidatorUtil

**パッケージ:** nablarch.core.validation.ee

---

```java
public final class ValidatorUtil
```

{@link Validator}に関するユーティリティクラス。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### VALIDATOR_FACTORY_BUILDER

```java
private static final String VALIDATOR_FACTORY_BUILDER
```

{@link SystemRepository}から取得する際のキー

---

## コンストラクタの詳細

### ValidatorUtil

```java
private ValidatorUtil()
```

コンストラクタ

---

## メソッドの詳細

### getValidator

```java
public static Validator getValidator()
```

{@link Validator}インスタンスを取得する。
<p/>
{@link Validator}インスタンスは以下の手順で取得される。<br/>
<ol>
    <li>
        {@link SystemRepository}から"validatorFactoryBuilder"という名前で
        {@link ValidatorFactoryBuilder}を取得する。
        {@link SystemRepository}から{@link ValidatorFactoryBuilder}が取得できなかった場合は、
        このクラスの内部クラスとして用意されている{@link ValidatorFactoryBuilder}のデフォルトの実装が使用される。
    </li>
    <li>
        {@link ValidatorFactoryBuilder}を使用して、{@link ValidatorFactory}を生成する。
    </li>
    <li>
        {@link ValidatorFactory}から{@link Validator}インスタンスを生成して返却する。
    </li>
</ol>

**戻り値:**
{@link Validator}インスタンス

---

### clearCachedValidatorFactory

```java
public static void clearCachedValidatorFactory()
```

キャッシュをクリアする。
テスト用。通常は使用しない。

---

### getValidatorFactory

```java
public static ValidatorFactory getValidatorFactory()
```

{@link ValidatorFactory}インスタンスを取得する。

**戻り値:**
{@link ValidatorFactory}

---

### getValidatorFactoryBuilder

```java
private static ValidatorFactoryBuilder getValidatorFactoryBuilder()
```

{@link ValidatorFactoryBuilder}インスタンスを取得する。

**戻り値:**
{@link ValidatorFactoryBuilder}

---

### validate

```java
public static void validate(Object bean)
```

指定されたBeanオブジェクトに対してBean Validationを行う。
<p/>
バリデーションエラーが発生した場合には、発生した全てのメッセージを持つ{@link ApplicationException}を送出する。

**パラメータ:**
- `bean` - Bean Validation対象のオブジェクト

**例外:**
- `ApplicationException` - バリデーションエラーが発生した場合

---

### validate

```java
public static void validate(Object bean, String propertyNames)
```

指定されたBeanオブジェクトのプロパティに対してBean Validationを行う。
<p/>
{@code propertyNames}が{@code null}または空の場合は何もしない。
プロパティ名が重複している場合でも、バリデーションエラーの際に生成されるエラーメッセージは一つになる。
バリデーションエラーが発生した場合は、発生した全てのメッセージを持つ{@link ApplicationException}を送出する。

**パラメータ:**
- `bean` - Bean Validation対象のオブジェクト
- `propertyNames` - Bean Validation対象のプロパティ名

**例外:**
- `ApplicationException` - バリデーションエラーが発生した場合

---

### validateWithGroup

```java
public static void validateWithGroup(Object bean, Class<?> groups)
```

指定されたBeanオブジェクトに対して、指定したグループを使用してBean Validationを行う。
<p/>
バリデーションエラーが発生した場合には、発生した全てのメッセージを持つ{@link ApplicationException}を送出する。

**パラメータ:**
- `bean` - Bean Validation対象のオブジェクト
- `groups` - Bean Validationのグループ

**例外:**
- `ApplicationException` - バリデーションエラーが発生した場合

---

### validateProperty

```java
public static void validateProperty(Object bean, String propertyName, Class<?> groups)
```

指定されたBeanオブジェクトのプロパティに対してBean Validationを行う。
<p/>
バリデーションエラーが発生した場合には、発生した全てのメッセージを持つ{@link ApplicationException}を送出する。

**パラメータ:**
- `bean` - Bean Validation対象のオブジェクト
- `propertyName` - Bean Validation対象のプロパティ名
- `groups` - Bean Validationのグループ

**例外:**
- `ApplicationException` - バリデーションエラーが発生した場合

---
