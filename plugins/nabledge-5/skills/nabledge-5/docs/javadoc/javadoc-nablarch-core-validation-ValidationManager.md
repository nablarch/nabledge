# class ValidationManager

**パッケージ:** nablarch.core.validation

**実装されたインタフェース:**
- Initializable

---

```java
public class ValidationManager
implements Initializable
```

バリデーションとデータの変換を行うクラス。<br/>
実際のバリデーションとデータの変換はバリデータとコンバータに委譲する。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー。

---

### DEFAULT_SIZE_KEY_MAX_LENGTH

```java
private static final int DEFAULT_SIZE_KEY_MAX_LENGTH
```

フォーム配列サイズキー文字列の最大長のデフォルト値(999まで指定可能)

---

### formDefinitionCache

```java
private StaticDataCache<FormValidationDefinition> formDefinitionCache
```

FormValidationDefinitionを保持するStaticDataCache。

---

### formCreator

```java
private FormCreator formCreator
```

フォームの生成クラス。

---

### convertors

```java
private List<Convertor> convertors
```

コンバータのリスト。

---

### validators

```java
private List<Validator> validators
```

バリデータのリスト。

---

### useFormPropertyNameAsMessageId

```java
private boolean useFormPropertyNameAsMessageId
```

フォームのプロパティ名をデフォルトのメッセージIDとして使用するかどうかの設定値。

---

### convertorMap

```java
private Map<Class<?>,Convertor> convertorMap
```

コンバータのマップ。

---

### validatorMap

```java
private Map<Class<? extends Annotation>,Validator> validatorMap
```

バリデータのマップ。

---

### formArraySizeValueMaxLength

```java
private int formArraySizeValueMaxLength
```

フォーム配列サイズ文字列の最大長。

---

### invalidSizeKeyMessageId

```java
private String invalidSizeKeyMessageId
```

ValidationTargetアノテーションのsizeKeyに不正な長さを指定した際のエラーメッセージID。

---

### domainValidationHelper

```java
private DomainValidationHelper domainValidationHelper
```

ドメイン定義によるバリデーションをサポートするヘルパークラス

---

## メソッドの詳細

### setFormDefinitionCache

```java
public void setFormDefinitionCache(StaticDataCache<FormValidationDefinition> formDefinitionCache)
```

FormValidationDefinitionをキャッシュするStaticDataCacheをセットする。

**パラメータ:**
- `formDefinitionCache` - FormValidationDefinitionを保持するStaticDataCache

---

### setFormCreator

```java
public void setFormCreator(FormCreator formCreator)
```

フォームの生成クラスをセットする。<br/>
セットしなかった場合、MapConstructorFormCreatorが使用される。

**パラメータ:**
- `formCreator` - フォームの生成クラス

---

### setMessageResource

```java
public void setMessageResource(StringResourceHolder stringResourceHolder)
```

メッセージリソースをセットする。

**パラメータ:**
- `stringResourceHolder` - メッセージリソース

---

### setConvertors

```java
public void setConvertors(List<Convertor> convertors)
```

コンバータのリストをセットする。

**パラメータ:**
- `convertors` - セットするコンバータのリスト

---

### setValidators

```java
public void setValidators(List<Validator> validators)
```

バリデータのリストをセットする。

**パラメータ:**
- `validators` - バリデータのリスト

---

### setUseFormPropertyNameAsMessageId

```java
public void setUseFormPropertyNameAsMessageId(boolean useFormPropertyNameAsMessageId)
```

フォームのプロパティ名をデフォルトのメッセージIDとして使用するかどうかの設定値を設定する。

**パラメータ:**
- `useFormPropertyNameAsMessageId` - フォームのプロパティ名をデフォルトのメッセージIDとして使用するかどうかの設定値。

---

### setFormArraySizeValueMaxLength

```java
public void setFormArraySizeValueMaxLength(int formArraySizeKeyMaxLength)
```

フォーム配列サイズ文字列の最大長を設定する。

**パラメータ:**
- `formArraySizeKeyMaxLength` - フォーム配列サイズ文字列の最大長

---

### setInvalidSizeKeyMessageId

```java
public void setInvalidSizeKeyMessageId(String invalidSizeKeyLengthMessageId)
```

ValidationTargetアノテーションのsizeKeyに不正な長さを指定した際のエラーメッセージIDを設定する。

**パラメータ:**
- `invalidSizeKeyLengthMessageId` - ValidationTargetアノテーションのsizeKeyに不正な長さを指定した際のエラーメッセージID

---

### initialize

```java
public void initialize()
```

{@inheritDoc}

---

### validateAndConvert

```java
public ValidationContext<T> validateAndConvert(String prefix, Class<T> targetClass, Map<String,?> params, String validateFor)
```

バリデーションと値の変換を行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `prefix` - Mapに入ったキーのプレフィクス
- `targetClass` - バリデーション対象のフォームのクラス
- `params` - バリデーション対象のデータ
- `validateFor` - バリデーション対象メソッド

**戻り値:**
バリデーション結果の入ったValidationContext

---

### createValidationContext

```java
public ValidationContext<T> createValidationContext(Class<T> targetClass, Map<String,?> params, String innerPrefix, String validateFor)
```

{@link ValidationContext}を生成する。

**パラメータ:**
- `targetClass` - バリデーション対象のフォームのクラス
- `params` - バリデーション対象のデータ
- `innerPrefix` - Mapに入ったキーのプレフィクス
- `<T>` - バリデーション結果で取得できる型
- `validateFor` - バリデーション対象メソッド

**戻り値:**
{@link ValidationContext}

---

### validateAndConvertAllProperty

```java
protected void validateAndConvertAllProperty(ValidationContext<T> context, FormValidationDefinition formValidationDefinition)
```

フォームのバリデーションと変換を行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `formValidationDefinition` - FormValidationDefinition

---

### validateAndConvertProperty

```java
protected void validateAndConvertProperty(ValidationContext<T> context, FormValidationDefinition formDef, PropertyValidationDefinition propertyDef)
```

プロパティに対するバリデーションと変換を行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `formDef` - FormValidationDefinition
- `propertyDef` - PropertyValidationDefinition

---

### setDomainValidationHelper

```java
public void setDomainValidationHelper(DomainValidationHelper domainValidationHelper)
```

ドメイン定義によるバリデーションをサポートするヘルパークラスを設定する。

**パラメータ:**
- `domainValidationHelper` - ドメイン定義によるバリデーションをサポートするヘルパークラス

---

### getFormatAnnotation

```java
protected Annotation getFormatAnnotation(Annotation convertorFormatAnnotation)
```

{@link Convertor}に渡すフォーマットを指定するアノテーションを取得する。
<p/>
指定されたコンバータのアノテーションがドメイン定義の場合は、ドメイン定義に指定されたコンバータアノテーションを返す。
それ以外の場合は、指定されたコンバータのアノテーションをそのまま返す。

**パラメータ:**
- `convertorFormatAnnotation` - コンバータのアノテーション

**戻り値:**
{@link Convertor}に渡すフォーマットを指定するアノテーション

---

### validate

```java
public void validate(ValidationContext<T> context, String propertyName, Class<? extends Annotation> annotation, Map<String,Object> params)
```

指定されたバリデーションアノテーションに沿ったバリデーション処理を行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyName` - バリデーション対象のプロパティ名
- `annotation` - バリデーションアノテーションクラス
- `params` - バリデーションアノテーションのパラメータ

---

### validateSizeValue

```java
private int validateSizeValue(ValidationContext<T> context, String propertyName, String lenStr)
```

サイズキー文字列をバリデーションし、値を取得する。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyName` - サイズキーのプロパティ名
- `lenStr` - サイズ文字列

**戻り値:**
サイズキー文字列のパース結果。

---

### addInvalidSizeKeyMessage

```java
private void addInvalidSizeKeyMessage(ValidationContext<T> context, String propertyName)
```

サイズキーが不正であるエラーメッセージを設定。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyName` - サイズキーのプロパティ名

---

### createPropertyDisplayNameObject

```java
protected Object createPropertyDisplayNameObject(ValidationContext<T> context, PropertyValidationDefinition propertyDef)
```

プロパティの表示名を表すオブジェクトを作成する。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyDef` - PropertyValidationDefinition

**戻り値:**
プロパティの表示名を表すオブジェクト

---

### validate

```java
public void validate(ValidationContext<T> context, String[] propertyNames)
```

バリデーション対象のプロパティを指定してバリデーションを行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyNames` - バリデーション対象とするプロパティ名の配列

---

### validateWithout

```java
public void validateWithout(ValidationContext<T> context, String[] propertyNames)
```

バリデーション対象外のプロパティを指定してバリデーションを行う。

**パラメータ:**
- `<T>` - バリデーション結果で取得できる型
- `context` - ValidationContext
- `propertyNames` - バリデーション対象としないプロパティ名の配列

---
