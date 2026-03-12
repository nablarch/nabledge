# Nablarch Validation

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/nablarch_validation.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/package-summary.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/convertor/package-summary.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/date/package-summary.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/code/validator/package-summary.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationManager.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/domain/DomainValidationHelper.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/domain/DomainValidator.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/PropertyName.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/convertor/Digits.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/NumberRange.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationUtil.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidateFor.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/DirectCallableValidator.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/SystemChar.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/SystemCharValidator.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationContext.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationTarget.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/WebUtil.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Validation.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Validator.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/Convertor.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/FormCreator.html)

## 機能概要

> **補足**: [validation](libraries-validation.md) の説明通り、[bean_validation](libraries-bean_validation.md) を使用することを推奨する。

Nablarchバリデーション機能の特徴:
- バリデーション、入力値の型変換（IntegerやLongなど数値型への直接マッピング）、正規化（編集解除など）が可能
- ドメインバリデーション: ドメインごとにバリデーションルールを定義でき、Beanクラスのsetterにはドメイン名の指定だけを行えばよく、バリデーションルールの変更が容易になる
- 標準バリデータ・コンバータ提供済み（プロジェクト側での個別実装不要）

提供バリデータ・コンバータ:
- `validator`
- `convertor`
- `date`
- `validator`

バリデーションは `ValidationUtil` のメソッドを呼び出して実行する。

**実装手順**:
1. バリデーション対象BeanにMapを引数に取るコンストラクタを実装する
2. Beanにバリデーション実行用のstaticメソッドを実装し、 `@ValidateFor` アノテーションでバリデーション識別子を指定する
3. メソッド内で `ValidationUtil` を使ってバリデーションを実行する

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

  @Domain(SampleDomain.DATE)
  public void setBirthday(String birthday) { this.birthday = birthday; }

  @Domain(SampleDomain.AGE)
  public void setAge(Integer age) { this.age = age; }

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {
    ValidationUtil.validate(context, new String[] {"userName", "birthday", "age"});
  }
}
```

バリデーション実行:
```java
ValidationContext<SampleForm> validationContext =
        ValidationUtil.validateAndConvertRequest(SampleForm.class, request, "validate");
validationContext.abortIfInvalid();  // バリデーションエラーがある場合は例外を送出
SampleForm form = validationContext.createObject();  // Mapコンストラクタを使ってFormを生成
```

> **補足**: ウェブアプリケーションでは [inject_form_interceptor](../handlers/handlers-InjectForm.md) でより簡易的にバリデーションが行える。

### プロジェクト固有のバリデータを追加したい

バリデータ追加手順:
1. アノテーションの作成
2. バリデータの作成
3. 設定ファイルにバリデータの登録（[nablarch_validation-definition_validator_convertor](#s3) 参照）

アノテーション作成条件:
- `@Validation` を設定すること
- `@Target` に `ElementType.METHOD` を設定すること
- `@Retention` に `RetentionPolicy.RUNTIME` を設定すること

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Sample {
}
```

バリデータは `Validator` インタフェースを実装する:

```java
public class SampleValidator implements Validator {
    public Class<? extends Annotation> getAnnotationClass() {
        return Sample.class;
    }
    public <T> boolean validate(ValidationContext<T> context, ...) { ... }
}
```

### プロジェクト固有のコンバータを追加したい

コンバータ追加手順:
1. コンバータの作成
2. 設定ファイルにコンバータの登録（[nablarch_validation-definition_validator_convertor](#s3) 参照）

コンバータは `Convertor` インタフェースを実装する:

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
        } else {
            convertible = false;
        }
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

### バリデーション対象のBeanオブジェクトの生成方法を変更したい

変更手順:
1. `FormCreator` の実装クラスを作成
2. `ValidationManager.formCreator` に作成したクラスのコンポーネント定義を追加

<details>
<summary>keywords</summary>

Nablarchバリデーション, バリデーション, 型変換, 正規化, ドメインバリデーション, バリデータ, コンバータ, ValidationUtil, ValidationContext, @ValidateFor, validateAndConvertRequest, abortIfInvalid, createObject, バリデーション実行, フォームバリデーション, Mapコンストラクタ, Validator, Convertor, FormCreator, ValidationManager, NumberFormatException, @Validation, @Target, @Retention, SampleValidator, SampleConvertor, ElementType, RetentionPolicy, nablarch.core.validation.Validator, nablarch.core.validation.Convertor, nablarch.core.validation.FormCreator, nablarch.core.validation.ValidationManager, nablarch.core.validation.ValidationContext, カスタムバリデータ追加, カスタムコンバータ追加, Bean生成方法変更, プロジェクト固有バリデーション拡張

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

アノテーションベースではなく直接バリデーションを実行する方法。原則は通常のアノテーションベースのバリデーションを使用し、個別にバリデーションを実行する必要がある場合（例: [コード管理のパターン](libraries-code.md) を使って特定の画面だけパターンを変えてバリデーションしたい場合）にのみ使用する。

> **重要**: 明示的バリデーションで指定できるアノテーションは `DirectCallableValidator` を実装しているものに限定される（コンバータは指定不可）。

> **重要**: 明示的なバリデーションを行うには、対象の項目に対し予めバリデーションを実施しておく必要がある。詳細は [nablarch_validation-execute](#s6) を参照。

```java
@ValidateFor("validate")
public static void validate(ValidationContext<SampleForm> context) {
    ValidationUtil.validate(context, new String[]{"userName", "prefectureCode"});

    // userNameに対して必須チェックを明示的に実施
    ValidationUtil.validate(context, "userName", Required.class);

    // アノテーションのパラメータはMapで指定する
    Map<String, Object> params = new HashMap<String, Object>();
    params.put("codeId", "1052");     // コードID
    params.put("pattern", "A");       // 使用するコードパターン名
    params.put("messageId", "M4865"); // エラーメッセージのID
    ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
}
```

<details>
<summary>keywords</summary>

nablarch-core-validation, nablarch-common-date, nablarch-common-code, Maven依存関係, モジュール, DirectCallableValidator, ValidationUtil.validate, @ValidateFor, 明示的バリデーション, 個別バリデーション実行, CodeValue

</details>

## 使用するバリデータとコンバータを設定する

> **重要**: バリデータやコンバータの設定がない場合、バリデーション機能は使用できないため必ず設定すること。

**クラス**: `nablarch.core.validation.ValidationManager`

設定要件:
- `ValidationManager` を **validationManager** という名前でコンポーネント定義する
- `ValidationManager#convertors` に使用するコンバータを列挙する
- `ValidationManager#validators` に使用するバリデータを列挙する

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

文字種バリデーションの定義方法は [bean_validation](libraries-bean_validation.md) と同じ。ただし、使用するアノテーションは `@SystemChar` であり、[bean_validation](libraries-bean_validation.md) とは**完全修飾名が異なる**（アノテーション名は同一）ので注意。

詳細な設定方法は [Bean Validationの文字種バリデーションを行う](libraries-bean_validation.md) を参照。

**サロゲートペアの扱い**: デフォルトではサロゲートペアを許容しない（`LiteralCharsetDef` で明示的にサロゲートペアの文字を定義していても許容しない）。サロゲートペアを許容するには、コンポーネント設定ファイルで `SystemCharValidator#allowSurrogatePair` を設定する:

```xml
<component name="systemCharValidator" class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <!-- サロゲートペアを許容する -->
  <property name="allowSurrogatePair" value="true"/>
  <!-- その他のプロパティは省略 -->
</component>
```

<details>
<summary>keywords</summary>

ValidationManager, convertors, validators, validationManager, バリデータ設定, コンバータ設定, コンポーネント設定, @SystemChar, SystemCharValidator, allowSurrogatePair, 文字種バリデーション, サロゲートペア, LiteralCharsetDef

</details>

## バリデーションルールを設定する

バリデーションルールのアノテーションは、バリデーション対象Beanクラスのプロパティ(setter)に設定する。getterには指定不可（指定しても無効）。

> **補足**: 個別アノテーション設定はメンテナンスコストが増えるため、[nablarch_validation-domain_validation](#s4) を推奨する。

実装例（`userName`: 必須・全角最大10文字、`birthday`: 半角数字8桁、`age`: 整数3桁まで）:
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

複数項目を使用した相関バリデーションは `@ValidateFor` アノテーションを設定したstaticメソッドで実装する。まず項目ごとのバリデーションを実施し、エラーがなかった場合にのみ相関バリデーションを実行する。

相関バリデーションでエラーとなった場合は、ユーザに通知すべきメッセージIDを `ValidationContext` に明示的に追加する。

```java
@ValidateFor("validate")
public static void validate(ValidationContext<SampleForm> context) {
    ValidationUtil.validate(context, new String[] {"mailAddress", "confirmMailAddress"});

    if (!context.isValid()) {
        return;  // エラーがある場合は相関バリデーションを実施しない
    }

    SampleForm form = context.createObject();
    if (!Objects.equals(form.mailAddress, form.confirmMailAddress)) {
        context.addMessage("compareMailAddress");  // エラーメッセージIDを追加
    }
}
```

<details>
<summary>keywords</summary>

@Length, @SystemChar, @Required, @Digits, バリデーションルール, アノテーション, setter, ValidationContext, addMessage, isValid, 相関バリデーション, 複数項目バリデーション, @ValidateFor

</details>

## ドメインバリデーションを使う

ドメインバリデーション使用手順:

**1. ドメインEnumの作成**

`DomainDefinition`インタフェースを実装したEnumを作成する。各列挙子がドメイン名となる。`getConvertorAnnotation()`と`getValidatorAnnotations()`の実装内容は以下の例と全く同じとすること。

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

`value`属性に上記で作成したドメインEnumを指定できるようにする。

```java
@ConversionFormat
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Domain {
    SampleDomain value();
}
```

**3. BeanにドメインアノテーションをSet**

```java
@Domain(SampleDomain.NAME)
public void setUserName(String userName) {
    this.userName = userName;
}
```

この例では、`userName` に対して `SampleDomain.NAME` に設定したバリデーションが実行される。
※コンバータが設定されている場合は、コンバータによる値の変換も行われる。

**4. 有効化設定**

以下4つのコンポーネント設定が必要:

`DomainValidationHelper` 設定（`domainAnnotation`プロパティにドメインアノテーションFQCNを設定）:

```xml
<component name="domainValidationHelper"
    class="nablarch.core.validation.domain.DomainValidationHelper">
  <property name="domainAnnotation" value="sample.Domain" />
</component>
```

`DomainValidator` 設定:

> **重要**: `DomainValidator`自身は`validators`リストに含めないこと。含めると循環参照となりシステムリポジトリ初期化時にエラーになる。

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

`ValidationManager` 設定（`domainValidator`をvalidatorsに追加し、`domainValidationHelper`も設定する）:

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

初期化コンポーネント設定（`DomainValidator`と`ValidationManager`を初期化対象リストに追加）:

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

**複数バリデーションルール時の挙動**: 1つの入力項目に複数エラーが存在する場合、1つ目のエラーで精査を打ち切る（例: `Length`エラーの場合`SystemChar`バリデーションは実行されない）。

一括登録のように同一情報を複数入力するケースは、バリデーション対象BeanにネストしたBeanを定義して対応する。

ネストしたBeanのsetterには `@ValidationTarget` アノテーションを設定し、ネストしたBeanのサイズを指定する:
- 要素数が固定（コンパイル時に決定）: `size` 属性に指定
- 要素数が可変: `sizeKey` 属性にサイズを持つプロパティ名を設定

```java
public class SampleForm {
    private AddressForm[] addressForms;
    private Integer addressSize;  // 画面のhiddenなどから送信する

    @ValidationTarget(sizeKey = "addressSize")
    public void setAddressForms(AddressForm[] addressForms) {
        this.addressForms = addressForms;
    }

    @Domain(SampleDomain.SIZE)
    @Required
    public void setAddressSize(Integer addressSize) {
        this.addressSize = addressSize;
    }

    @ValidateFor("validate")
    public static void validate(ValidationContext<SampleForm> context) {
        ValidationUtil.validate(context, new String[] {"addressSize", "addressForms"});
    }
}
```

<details>
<summary>keywords</summary>

DomainDefinition, DomainValidationHelper, DomainValidator, ValidationManager, @Domain, @ConversionFormat, @Validation, BasicApplicationInitializer, domainAnnotation, domainValidationHelper, ドメインバリデーション, ドメインEnum, バリデーション有効化, @ValidationTarget, ValidationTarget, size, sizeKey, ネストBean, 一括登録バリデーション, 配列入力バリデーション

</details>

## バリデーション対象のBeanを継承する

**Beanの継承は推奨しない。** 理由: 親クラスの変更により予期せぬバリデーションが実行されたり、複雑な上書きルールを意識したアノテーション設定が必要になり、バグの原因となる。

継承時の挙動ルール:
- サブクラスに `@PropertyName` のみを付けた場合: 親クラスのバリデータとコンバータが使用される
- サブクラスにバリデータアノテーションを1つでも付けた場合: 親クラスのバリデータアノテーションは無視され、サブクラスのバリデータが使用される（コンバータは親クラスのものを使用）
- サブクラスにコンバータアノテーションを1つでも付けた場合: 親クラスのコンバータは無視され、サブクラスのコンバータが使用される（バリデータは親クラスのものを使用）
- サブクラスにバリデータもコンバータも設定されている場合: 全てサブクラスの設定が使われる
- 親クラスのコンバータ設定をサブクラスで削除することはできない

例（`ChildForm`の`value`プロパティには `@Digits` と `@NumberRange` 両方のバリデーションが実行される）:

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

`WebUtil` を使うことで、ラジオボタンやリストボックスの選択値に応じてバリデーション項目を切り替えられる。

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

> **補足**: 送信された値まで確認する場合は `WebUtil.containsPropertyKeyValue` を使用。単純にラジオボタンのチェック有無だけを調べる場合は `WebUtil.containsPropertyKey` を使う。

<details>
<summary>keywords</summary>

@PropertyName, @Digits, @NumberRange, Bean継承, バリデーション継承, コンバータ継承, WebUtil, containsPropertyKeyValue, containsPropertyKey, 条件付きバリデーション, ラジオボタン, リストボックス

</details>

## 特定の項目に紐づくバリデーションエラーのメッセージを作りたい

[Bean Validationの特定の項目に紐づくバリデーションエラーのメッセージを作りたい](libraries-bean_validation.md) を参照。

<details>
<summary>keywords</summary>

bean_validation-create_message_for_property, 項目エラーメッセージ, バリデーションエラーメッセージ, Bean Validation

</details>

## バリデーションエラー時のメッセージに項目名を埋め込みたい

メッセージに項目名を埋め込むには `@PropertyName` アノテーションを使用して、バリデーション対象項目の項目名を指定する。

項目名はメッセージの先頭に配置されるため、埋め込み箇所には `{0}` を指定する:

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

`username` プロパティで必須エラーが発生した場合、生成されるメッセージは「名前を入力してください。」となる。

<details>
<summary>keywords</summary>

@PropertyName, PropertyName, {0}, 項目名埋め込み, バリデーションエラーメッセージ項目名

</details>

## 数値型への型変換

バリデーション後にBeanクラスの数値型に入力値を変換するには、その項目に `@Digits` アノテーションが必須。ドメインバリデーション使用時はドメインEnumへの設定が必要となる。

数値型変換のコンバータが [nablarch_validation-definition_validator_convertor](#s3) の手順に従い設定されていることが前提。

> **推奨**: 下記の例ではsetterに `@Digits` を指定しているが、ドメインバリデーションを使用する場合はドメインEnumへの指定を推奨する。

```java
public class SampleForm {
    @PropertyName("年齢")
    @Digits(integer = 3)
    public void setAge(Integer age) { this.age = age; }
}
```

<details>
<summary>keywords</summary>

@Digits, Digits, 数値型変換, Integer変換, ドメインバリデーション数値型

</details>

## データベースとの相関バリデーションを行う

データベースとの相関バリデーションは業務アクションで行う。業務アクションで行う理由は [Bean Validationのデータベースとの相関バリデーション](libraries-bean_validation.md) を参照。

<details>
<summary>keywords</summary>

業務アクション, データベース相関バリデーション, bean_validation-database_validation

</details>

## ウェブアプリケーションのユーザ入力値のチェックを行う

ウェブアプリケーションのユーザ入力値チェックは [inject_form_interceptor](../handlers/handlers-InjectForm.md) を使用して行う。詳細は [inject_form_interceptor](../handlers/handlers-InjectForm.md) を参照。

<details>
<summary>keywords</summary>

inject_form_interceptor, ウェブバリデーション, ユーザ入力値チェック, InjectForm

</details>
