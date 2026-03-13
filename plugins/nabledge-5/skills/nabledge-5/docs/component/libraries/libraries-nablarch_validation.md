# Nablarch Validation

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/package-summary.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/convertor/package-summary.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/date/package-summary.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/package-summary.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationManager.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/domain/DomainValidationHelper.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/domain/DomainValidator.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/PropertyName.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/convertor/Digits.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/NumberRange.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationUtil.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidateFor.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationContext.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/DirectCallableValidator.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/SystemChar.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/SystemCharValidator.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationTarget.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/WebUtil.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Validation.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Validator.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Convertor.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/FormCreator.html)

## 機能概要

> **補足**: [validation](libraries-validation.md) で説明したように、[bean_validation](libraries-bean_validation.md) を使用することを推奨する。

- バリデーション、型変換、値の正規化が可能。型変換により、BeanクラスのInteger/Long等の数値型に直接マッピングできる。
- ドメインごとにバリデーションルールを定義できる（ドメインバリデーション）。Beanクラスのsetterにはドメイン名の指定だけでよく、バリデーションルールの変更が容易。
- 標準提供のバリデータ・コンバータ: `validator`, `convertor`, `date`, `validator`

**クラス**: `nablarch.core.validation.ValidationUtil`, `nablarch.core.validation.ValidationContext`
**アノテーション**: `@ValidateFor`, `@Domain`, `@Required`

バリデーション実行手順:
1. バリデーション対象BeanにMapを引数に取るコンストラクタを実装する
2. Beanのstaticメソッドに`@ValidateFor`アノテーションを設定し、バリデーション識別子（任意の文字列）を指定する
3. そのメソッド内で`ValidationUtil.validate()`を呼び出す

```java
public class SampleForm {
  public SampleForm(Map<String, Object> params) {
    userName = (String) params.get("userName");
    birthDay = (String) params.get("birthDay");
    age = (Integer) params.get("age");
  }

  @Domain(SampleDomain.NAME)
  @Required
  public void setUserName(String userName) { this.userName = userName; }

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {
    ValidationUtil.validate(context, new String[] {"userName", "birthday", "age"});
  }
}

// バリデーション実行
ValidationContext<SampleForm> validationContext =
    ValidationUtil.validateAndConvertRequest(SampleForm.class, request, "validate");
validationContext.abortIfInvalid();
SampleForm form = validationContext.createObject();
```

`validateAndConvertRequest`の第3引数でBeanの`@ValidateFor`に指定した識別子を指定し、対応するstaticメソッドでバリデーションが実行される。ウェブアプリケーションの場合は [inject_form_interceptor](../handlers/handlers-InjectForm.md) でより簡易的にバリデーションができる。

### プロジェクト固有のバリデータを追加したい

バリデータを追加する手順:
1. アノテーションの作成
2. バリデータの作成
3. 設定ファイルにバリデータの登録（[nablarch_validation-definition_validator_convertor](#s3) 参照）

**アノテーションの条件**:
- `@Validation` アノテーションを設定すること
- `@Target` アノテーションで `ElementType.METHOD` を設定すること
- `@Retention` アノテーションで `RetentionPolicy.RUNTIME` を設定すること

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Sample {
}
```

**バリデータ**: `Validator` インタフェースを実装する。

```java
public class SampleValidator implements Validator {
  public Class<? extends Annotation> getAnnotationClass() {
      return Sample.class;
  }
  public <T> boolean validate(ValidationContext<T> context, ...) {
      // 省略
  }
}
```

<details>
<summary>keywords</summary>

バリデーション, 型変換, 正規化, ドメインバリデーション, nablarch.core.validation.validator, nablarch.core.validation.convertor, nablarch.common.date, nablarch.common.code.validator, Bean Validation推奨, ValidationUtil, ValidationContext, ValidateFor, @ValidateFor, @Domain, @Required, validateAndConvertRequest, abortIfInvalid, createObject, バリデーション実行, Validator, @Validation, @Target, @Retention, カスタムバリデータ追加, バリデーションアノテーション作成, プロジェクト固有バリデータ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation</artifactId>
</dependency>

<!-- 日付のバリデータ、コンバータを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-date</artifactId>
</dependency>

<!-- コード値のバリデータ、コンバータを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-code</artifactId>
</dependency>
```

**クラス**: `nablarch.core.validation.DirectCallableValidator`
**アノテーション**: `@ValidateFor`

アノテーションを使わず、`ValidationUtil` を直接呼び出してバリデーションを実行する方法。原則は通常のアノテーションベースのバリデーションを使用し、個別にバリデーションを実行する必要がある場合（例：特定の画面だけコードパターンを変えてバリデーション）に限りこの方法を使う。

> **重要**: 明示的なバリデーションを実施する前に、対象項目のバリデーションを実施済みである必要がある。詳細は [nablarch_validation-execute](#s6) を参照。

指定できるアノテーションは`DirectCallableValidator`を実装しているものに限定される（コンバータは指定不可）。

```java
@ValidateFor("validate")
public static void validate(ValidationContext<SampleForm> context) {
  ValidationUtil.validate(context, new String[]{"userName", "prefectureCode"});

  // 個別バリデーション（アノテーションクラスを直接指定）
  ValidationUtil.validate(context, "userName", Required.class);

  // パラメータ付き個別バリデーション
  Map<String, Object> params = new HashMap<String, Object>();
  params.put("codeId", "1052");
  params.put("pattern", "A");
  params.put("messageId", "M4865");
  ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
}
```

### プロジェクト固有のコンバータを追加したい

コンバータを追加する手順:
1. コンバータの作成
2. 設定ファイルにコンバータの登録（[nablarch_validation-definition_validator_convertor](#s3) 参照）

**コンバータ**: `Convertor` インタフェースを実装する。

```java
public class SampleConvertor implements Convertor {
    @Override
    public Class<?> getTargetClass() { return Short.class; }

    @Override
    public <T> boolean isConvertible(ValidationContext<T> context, String propertyName,
            Object propertyDisplayName, Object value, Annotation format) {
        boolean convertible = true;
        if (value instanceof String) {
            try { Short.valueOf((String) value); }
            catch (NumberFormatException e) { convertible = false; }
        } else { convertible = false; }
        if (!convertible) {
            context.addResultMessage(propertyName, "sampleconvertor.message", propertyDisplayName);
        }
        return convertible;
    }

    @Override
    public <T> Object convert(ValidationContext<T> context, String propertyName,
            Object value, Annotation format) {
        return Short.valueOf((String) value);
    }
}
```

<details>
<summary>keywords</summary>

nablarch-core-validation, nablarch-common-date, nablarch-common-code, モジュール依存関係, Maven, DirectCallableValidator, ValidationUtil, @ValidateFor, 明示的バリデーション, 個別バリデーション実行, CodeValue, Required, Convertor, ValidationContext, カスタムコンバータ追加, プロジェクト固有コンバータ

</details>

## 使用するバリデータとコンバータを設定する

> **重要**: バリデータやコンバータの設定がない場合、バリデーション機能は使用できないので必ず設定すること。

- `ValidationManager` を `validationManager` という名前でコンポーネント定義する。
- `convertors` プロパティに使用するコンバータを列挙する。
- `validators` プロパティに使用するバリデータを列挙する。

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
  <property name="convertors">
    <list>
      <!-- ここに使用するコンバータを列挙する -->
    </list>
  </property>
  <property name="validators">
    <list>
      <!-- ここに使用するバリデータを列挙する -->
    </list>
  </property>
</component>
```

**アノテーション**: `@SystemChar` (`nablarch.core.validation.validator.unicode.SystemChar`)
**クラス**: `nablarch.core.validation.validator.unicode.SystemCharValidator`

定義方法は [bean_validation](libraries-bean_validation.md) と同じ（詳細は [bean_validation-system_char_validator](libraries-bean_validation.md) を参照）。

> **重要**: `@SystemChar`の完全修飾名は [bean_validation](libraries-bean_validation.md) のものと異なるので注意（アノテーション名は同一）。

サロゲートペアはデフォルトで許容しない（`LiteralCharsetDef`で明示的に定義していても不可）。サロゲートペアを許容する場合は`SystemCharValidator`の`allowSurrogatePair`プロパティを`true`に設定する。

```xml
<component name="systemCharValidator" class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <property name="allowSurrogatePair" value="true"/>
</component>
```

### バリデーション対象のBeanオブジェクトの生成方法を変更したい

Bean生成方法を変更する手順:
1. `FormCreator` の実装クラスを作成する
2. `ValidationManager.formCreator` に作成したクラスのコンポーネント定義を追加する

<details>
<summary>keywords</summary>

ValidationManager, validationManager, convertors, validators, バリデータ設定, コンバータ設定, nablarch.core.validation.ValidationManager, SystemChar, SystemCharValidator, @SystemChar, nablarch.core.validation.validator.unicode.SystemChar, 文字種バリデーション, サロゲートペア, allowSurrogatePair, LiteralCharsetDef, FormCreator, Bean生成方法変更

</details>

## バリデーションルールを設定する

> **補足**: 個別にアノテーションを設定すると実装ミスが増えメンテナンスコストが大きくなるため、[nablarch_validation-domain_validation](#s4) を使うことを推奨する。

バリデーションルールのアノテーションは、バリデーション対象Beanクラスのプロパティのsetterに設定する。getterには指定不可（指定しても意味がない）。

```java
public class SampleForm {

  @Length(max = 10)
  @SystemChar(charsetDef = "全角文字")
  @Required
  public void setUserName(String userName) {
      this.userName = userName;
  }

  @Length(min = 8, max = 8)
  @SystemChar(charsetDef = "半角数字")
  public void setBirthday(String birthday) {
      this.birthday = birthday;
  }

  @Digits(integer = 3)
  public void setAge(Integer age) {
      this.age = age;
  }
}
```

**クラス**: `nablarch.core.validation.ValidationContext`
**アノテーション**: `@ValidateFor`

相関バリデーションは`@ValidateFor`アノテーションを設定したstaticメソッドで実装する。

実装パターン:
1. `ValidationUtil.validate()`で各項目のバリデーションを実施
2. `context.isValid()`でエラー確認し、エラーがある場合は相関バリデーションをスキップ
3. `context.createObject()`でFormを生成して複数項目を検証
4. 相関バリデーションエラーの場合は`context.addMessage("メッセージID")`でメッセージを追加

```java
@ValidateFor("validate")
public static void validate(ValidationContext<SampleForm> context) {
  ValidationUtil.validate(context, new String[] {"mailAddress", "confirmMailAddress"});
  if (!context.isValid()) {
    return;
  }
  SampleForm form = context.createObject();
  if (!Objects.equals(form.mailAddress, form.confirmMailAddress)) {
    context.addMessage("compareMailAddress");
  }
}
```

<details>
<summary>keywords</summary>

@Length, @SystemChar, @Required, @Digits, setter, バリデーションアノテーション, SampleForm, ドメインバリデーション推奨, ValidationContext, @ValidateFor, 相関バリデーション, addMessage, isValid, createObject, 複数項目バリデーション

</details>

## ドメインバリデーションを使う

ドメインバリデーションを使用するための実装と設定手順。

**1. ドメインEnumの作成**

`DomainDefinition` インタフェースを実装したEnumを作成する。各列挙子がドメイン名となる。`getConvertorAnnotation()` と `getValidatorAnnotations()` の実装内容は以下の例と全く同じにすること。

```java
public enum SampleDomain implements DomainDefinition {

    @Length(max = 10)
    @SystemChar(charsetDef = "全角文字")
    NAME,

    @Length(min = 8, max = 8)
    @SystemChar(charsetDef = "半角数字")
    DATE;

    @Override
    public Annotation getConvertorAnnotation() {
        return DomainValidationHelper.getConvertorAnnotation(this);
    }

    @Override
    public List<Annotation> getValidatorAnnotations() {
        return DomainValidationHelper.getValidatorAnnotations(this);
    }
}
```

**2. ドメインアノテーションの作成**

`value` 属性にドメインEnumを指定できるアノテーションを作成する。

```java
@ConversionFormat
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Domain {
    SampleDomain value();
}
```

**3. BeanのsetterにドメインアノテーションをBeanに設定**

```java
@Domain(SampleDomain.NAME)
public void setUserName(String userName) {
    this.userName = userName;
}
```

この例では、`userName` に対して `SampleDomain.NAME` に設定したバリデーションが実行される。※コンバータが設定されている場合は、コンバータによる値の変換も行われる。

**4. ドメインバリデーション有効化の設定**

`DomainValidationHelper` の設定（`domainAnnotation` プロパティにドメインアノテーションのFQCNを指定）:

```xml
<component name="domainValidationHelper"
    class="nablarch.core.validation.domain.DomainValidationHelper">
  <property name="domainAnnotation" value="sample.Domain" />
</component>
```

`DomainValidator` の設定:

> **重要**: `DomainValidator` 自身を `validators` リストに設定しないこと。設定すると循環参照となり、システムリポジトリ初期化時にエラーとなる。

```xml
<component name="domainValidator"
    class="nablarch.core.validation.domain.DomainValidator">
  <property name="validators">
    <list>
      <component-ref name="requiredValidator" />
    </list>
  </property>
  <property name="domainValidationHelper" ref="domainValidationHelper" />
</component>
```

`ValidationManager` の設定（`DomainValidator` を `validators` リストに含める）:

```xml
<component name="validationManager" class="nablarch.core.validation.ValidationManager">
  <property name="validators">
    <list>
      <component-ref name="domainValidator" />
      <!-- 他のバリデータの記述は省略 -->
    </list>
  </property>
  <property name="domainValidationHelper" ref="domainValidationHelper" />
</component>
```

初期化コンポーネントの設定（`DomainValidator` と `ValidationManager` を初期化対象リストに設定する）:

```xml
<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="validationManager" />
      <component-ref name="domainValidator" />
    </list>
  </property>
</component>
```

**複数バリデーションルール時の挙動**: 1項目に複数エラーが存在する場合、1つ目のエラーで打ち切り（後続のバリデーションは実行しない）。

**アノテーション**: `@ValidationTarget` (`nablarch.core.validation.ValidationTarget`)

同一情報の複数入力（一括登録等）では、バリデーション対象BeanにネストしたBeanを定義して対応する。ネストしたBeanのsetterに`@ValidationTarget`アノテーションを設定してネストBeanのサイズを指定する。

| 属性 | 用途 |
|---|---|
| `size` | 要素数固定（コンパイル時に決定）の場合 |
| `sizeKey` | 要素数可変（実行時に決定）の場合。サイズを保持するプロパティ名を指定 |

```java
public class SampleForm {
  private AddressForm[] addressForms;
  private Integer addressSize;  // hiddenなどから送信

  @ValidationTarget(sizeKey = "addressSize")
  public void setAddressForms(AddressForm[] addressForms) { this.addressForms = addressForms; }

  @Domain(SampleDomain.SIZE)
  @Required
  public void setAddressSize(Integer addressSize) { this.addressSize = addressSize; }

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {
    ValidationUtil.validate(context, new String[] {"addressSize", "addressForms"});
  }
}
```

<details>
<summary>keywords</summary>

DomainDefinition, DomainValidationHelper, DomainValidator, @Domain, ドメインEnum, domainAnnotation, 循環参照, BasicApplicationInitializer, nablarch.core.validation.domain.DomainValidationHelper, nablarch.core.validation.domain.DomainValidator, @ConversionFormat, @Validation, ValidationTarget, @ValidationTarget, sizeKey, size, 一括登録, ネストBean, 配列バリデーション

</details>

## バリデーション対象のBeanを継承する

継承は推奨しない（親クラスの変更による予期せぬバリデーション実行や、複雑なオーバーライドルールの意識が必要となり、間違い（バグ）の原因となるため）。

継承した場合の動作ルール:
- サブクラス側に `@PropertyName` のみをつけた場合、親クラスのバリデータとコンバータが使用される。
- サブクラス側にバリデータ用アノテーションを1つでもつけた場合、親クラスのバリデータアノテーションは無視される（コンバータは親クラスのものを使用）。
- サブクラス側にコンバータ用アノテーションを1つでもつけた場合、親クラスのコンバータアノテーションは無視される（バリデータは親クラスのものを使用）。
- サブクラス側にバリデータもコンバータも設定された場合、全てサブクラス側の設定が使われる。
- 親クラス側のコンバータの設定をサブクラス側で削除できない。

```java
// 親Form
public class ParentForm {
  @Digits(integer=5, fraction=3)
  public void setValue(BigDecimal value) {
      this.value = value;
  }
}

// 子Form
public class ChildForm extends ParentForm {
  @Override
  @NumberRange(min=100.0, max=20000.0)
  public void setValue(BigDecimal value) {
      super.setBdValue(value);
  }
}
```

この場合、`ChildForm.value` に対して `@Digits` と `@NumberRange` の両方のバリデーションが実行される。

**クラス**: `nablarch.common.web.WebUtil`

`WebUtil` を使うことで、ラジオボタンやリストボックスの選択値に応じてバリデーション項目を切り替えられる。

| メソッド | 用途 |
|---|---|
| `containsPropertyKeyValue(context, key, value)` | 送信キーと値の両方をチェック |
| `containsPropertyKey(context, key)` | キーの存在のみチェック（ラジオボタンのチェック有無のみ確認する場合） |

```java
@ValidateFor("validate")
public static void validate(ValidationContext<SampleForm> context) {
  if (WebUtil.containsPropertyKeyValue(context, "form.radio", "ptn1")) {
    ValidationUtil.validate(context, new String[] {"item1"});
  } else {
    ValidationUtil.validate(context, new String[] {"item1", "item2"});
  }
}
```

<details>
<summary>keywords</summary>

Bean継承, @PropertyName, @Digits, @NumberRange, バリデーション継承ルール, nablarch.core.validation.PropertyName, nablarch.core.validation.convertor.Digits, nablarch.core.validation.validator.NumberRange, WebUtil, containsPropertyKeyValue, containsPropertyKey, ラジオボタン, リストボックス, 条件付きバリデーション, nablarch.common.web.WebUtil

</details>

## 特定の項目に紐づくバリデーションエラーのメッセージを作りたい

[Bean Validationの特定の項目に紐づくバリデーションエラーのメッセージを作りたい](libraries-bean_validation.md) を参照。

<details>
<summary>keywords</summary>

バリデーションエラーメッセージ, 項目紐づきメッセージ, bean_validation-create_message_for_property

</details>

## バリデーションエラー時のメッセージに項目名を埋め込みたい

**アノテーション**: `@PropertyName` (`nablarch.core.validation.PropertyName`)

バリデーション対象項目のsetterに`@PropertyName`アノテーションで項目名を設定する。メッセージには項目名を埋め込む箇所に`{0}`を指定する（項目名は必ず先頭に配置されるため`{0}`を使用）。

```properties
required.message = {0}を入力してください。
```

```java
public class SampleForm {
  @Domain(SampleDomain.NAME)
  @Required
  @PropertyName("名前")
  public void setUserName(String userName) { this.userName = userName; }

  @Domain(SampleDomain.DATE)
  @PropertyName("誕生日")
  public void setBirthday(String birthday) { this.birthday = birthday; }
}
```

`userName`プロパティで必須エラーが発生すると、生成されるメッセージは「名前を入力してください。」となる。

<details>
<summary>keywords</summary>

@PropertyName, PropertyName, nablarch.core.validation.PropertyName, メッセージ項目名埋め込み, {0}, required.message

</details>

## 数値型への型変換

**アノテーション**: `@Digits` (`nablarch.core.validation.convertor.Digits`)

バリデーション後にBeanの数値型プロパティに変換する場合、その項目に`@Digits`アノテーションが必須。ドメインバリデーションの場合はドメインEnumに`@Digits`を設定すること（推奨）。数値型変換コンバータが [nablarch_validation-definition_validator_convertor](#s3) の手順で設定済みであることが前提。

```java
@PropertyName("年齢")
@Digits(integer = 3)
public void setAge(Integer age) { this.age = age; }
```

<details>
<summary>keywords</summary>

@Digits, Digits, nablarch.core.validation.convertor.Digits, 数値型変換, integer属性, ドメインバリデーション

</details>

## データベースとの相関バリデーションを行う

データベースとの相関バリデーションは業務アクションで実施する。理由は [bean_validation-database_validation](libraries-bean_validation.md) を参照。

<details>
<summary>keywords</summary>

データベース相関バリデーション, 業務アクション, bean_validation-database_validation

</details>

## ウェブアプリケーションのユーザ入力値のチェックを行う

ウェブアプリケーションのユーザ入力値のチェックは [inject_form_interceptor](../handlers/handlers-InjectForm.md) を使用して行う。詳細は [inject_form_interceptor](../handlers/handlers-InjectForm.md) を参照。

<details>
<summary>keywords</summary>

inject_form_interceptor, ウェブアプリケーション, ユーザ入力値チェック

</details>
