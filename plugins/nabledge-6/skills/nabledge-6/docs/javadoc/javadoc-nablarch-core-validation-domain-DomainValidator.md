# class DomainValidator

**パッケージ:** nablarch.core.validation.domain

**実装されたインタフェース:**
- Validator
- Initializable

---

```java
public class DomainValidator
implements Validator, Initializable
```

ドメイン定義にしたがってバリデーションを行うバリデータ。

**作成者:** kawasima  
**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### domainValidationHelper

```java
private DomainValidationHelper domainValidationHelper
```

ドメイン定義によるバリデーションをサポートするヘルパークラス

---

### validators

```java
private List<Validator> validators
```

バリデータのリスト。

---

### validatorMap

```java
private Map<Class<? extends Annotation>,Validator> validatorMap
```

バリデータのマップ。

---

## メソッドの詳細

### initialize

```java
public void initialize()
```

---

### getAnnotationClass

```java
public Class<? extends Annotation> getAnnotationClass()
```

---

### validate

```java
public boolean validate(ValidationContext<T> context, String propertyName, Object propertyDisplayName, Annotation annotation, Object value)
```

---

### getDomainValidationHelper

```java
protected DomainValidationHelper getDomainValidationHelper()
```

ドメインを表すアノテーションのクラスを取得する。
<p/>
ドメインを表すアノテーションのクラスが設定されていない場合は、{@link IllegalStateException}を送出する。

**戻り値:**
ドメインを表すアノテーションのクラス

---

### setDomainValidationHelper

```java
public void setDomainValidationHelper(DomainValidationHelper domainValidationHelper)
```

ドメイン定義によるバリデーションをサポートするヘルパークラスを設定する。

**パラメータ:**
- `domainValidationHelper` - ドメイン定義によるバリデーションをサポートするヘルパークラス

---

### setValidators

```java
public void setValidators(List<Validator> validators)
```

バリデータのリストを設定する。

**パラメータ:**
- `validators` - バリデータのリスト

---
