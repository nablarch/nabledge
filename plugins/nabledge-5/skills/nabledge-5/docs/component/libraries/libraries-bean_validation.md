# Bean Validation

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/validation/bean_validation.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/MessageInterpolator.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/NablarchMessageInterpolator.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/DomainManager.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Domain.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/RangedCharsetDef.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/LiteralCharsetDef.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/CompositeCharsetDef.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/SystemChar.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/validator/unicode/CachingCharsetDef.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/SystemCharConfig.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/constraints/AssertTrue.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ValidationUtil.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/message/ApplicationException.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/javax/validation/Valid.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Size.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/validator/BeanValidationStrategy.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ItemNamedConstraintViolationConverterFactory.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/ValidatorUtil.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpRequest.html)

## 機能概要

Java EE7のBean Validation（JSR349）に準拠したバリデーション機能を提供する。

> **重要**: この機能はBean Validationのエンジンを実装しているわけではない。Java EE環境（WebLogicやWildFlyなど）ではサーババンドルのBean Validation実装が使用される。Java EE環境外では別途Bean Validation実装の追加が必要（[Hibernate Validator](https://hibernate.org/validator/)を推奨）。

**ドメインバリデーション**: ドメインごとにバリデーションルールを定義できる。Beanのプロパティにはドメイン名の指定だけを行えばよく、バリデーションルールの変更が容易になる。詳細は [bean_validation-domain_validation](#s5) を参照。

**Nablarch提供バリデータ**: 以下のパッケージのアノテーションを参照
- `nablarch.core.validation.ee`
- `nablarch.common.code.validator.ee`

複数項目を使った相関バリデーションには `@AssertTrue` アノテーションを使用する。`message` プロパティに指定したメッセージがエラーメッセージになる。

```java
public class SampleForm {
  private String mailAddress;
  private String confirmMailAddress;

  @AssertTrue(message = "{compareMailAddress}")
  public boolean isEqualsMailAddress() {
    return Objects.equals(mailAddress, confirmMailAddress);
  }
}
```

> **重要**: Bean Validationではバリデーションの実行順序が保証されないため、項目単体のバリデーションよりも前に相関バリデーションが呼び出される場合がある。相関バリデーションでは項目単体のバリデーションが実行されていない状態でも予期せぬ例外が発生しないよう実装すること。任意項目の場合、未入力時はバリデーションを実行せずtrueを返すこと。

```java
@AssertTrue(message = "{compareMailAddress}")
public boolean isEqualsMailAddress() {
  if (StringUtil.isNullOrEmpty(mailAddress) || StringUtil.isNullOrEmpty(confirmMailAddress)) {
    // どちらかが未入力の場合は相関バリデーションを実施しない
    return true;
  }
  return Objects.equals(mailAddress, confirmMailAddress);
}
```

Bean Validation(JSR349)のグループ機能を使用すると、バリデーション実行時に使用するルールを特定グループに制限できる。NablarchはBean Validationでグループ指定可能なAPIを提供している。

グループを指定しないアノテーションは `Default` グループに所属すると見なされる。

**バリデーション対象のForm:**
```java
public class SampleForm {

    @SystemChar(charsetDef = "数字", groups = {Default.class, Test1.class})
    String id;

    @SystemChar.List({
            @SystemChar(charsetDef = "全角文字") // グループを指定しない場合は、Defaultグループに所属
            @SystemChar(charsetDef = "半角英数", groups = Test1.class),
    })
    String name;

    public interface Test1 {}
}
```

**バリデーション実行:**
```java
// グループを指定しない場合は、Defaultグループのルールでバリデーション
ValidatorUtil.validate(form);

// グループを指定する場合は、指定グループのルールでバリデーション
ValidatorUtil.validateWithGroup(form, SampleForm.Test1.class);
```

**クラス**: `ValidatorUtil#validateWithGroup`, `ValidatorUtil#validateProperty`

> **補足**: グループ機能を使用してバリデーションのルールを切り替えることで一つのフォームクラスを複数の画面やAPIで共通化できるが、Nablarchではそのような使用方法を推奨していない（:ref:`フォームクラスは、htmlのform単位に作成する <application_design-form_html>` および :ref:`フォームクラスはAPI単位に作成する <rest-application_design-form_html>` を参照）。フォームクラスを共通化する目的でグループ機能を使用する場合は、プロジェクト側で十分検討の上で使用すること。

<details>
<summary>keywords</summary>

Bean Validation, ドメインバリデーション, Hibernate Validator, nablarch.core.validation.ee, nablarch.common.code.validator.ee, バリデータ一覧, JSR349, Java EE7, @AssertTrue, 相関バリデーション, javax.validation.constraints.AssertTrue, バリデーション実行順序, Objects.equals, 複数項目バリデーション, StringUtil, StringUtil.isNullOrEmpty, ValidatorUtil, @SystemChar, Bean Validationグループ機能, バリデーショングループ指定, validateWithGroup, validateProperty, Defaultグループ, グループ切り替え, Default

</details>

## モジュール一覧

**モジュール**:
```xml
<!-- 必須 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>

<!-- メッセージ管理使用時のみ（デフォルトで使用） -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-message</artifactId>
</dependency>

<!-- コード値バリデータ使用時のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-code</artifactId>
</dependency>

<!-- ウェブアプリケーション使用時 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

データベースとの相関バリデーションは業務アクション側で実装すること。

Bean Validationを使ってデータベースに対する相関バリデーションを実施した場合、バリデーション実行中のオブジェクトの値（安全であることが保証されない）を使ってDBアクセスすることになり、SQLインジェクション等の脆弱性の原因となる。バリデーション後にアクションでバリデーションを行うことで、バリデーション済みの安全な値を使ってDBアクセスできる。

[bean_validation-validator](#s1) に記載のバリデータで要件を満たせない場合は、プロジェクト側でアノテーションおよびバリデーションのロジックを追加すること。

実装の参考:
- [Hibernate Validator(外部サイト、英語)](https://hibernate.org/validator/)
- [JSR349(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=349)

<details>
<summary>keywords</summary>

nablarch-core-validation-ee, nablarch-core-message, nablarch-common-code, nablarch-fw-web, Maven依存関係, モジュール, データベース相関バリデーション, SQLインジェクション, 業務アクション実装, 安全でない値, カスタムバリデーション, プロジェクト固有アノテーション, バリデーション拡張, Hibernate Validator, JSR349

</details>

## Bean Validationを使うための設定

**MessageInterpolatorの設定**

> **重要**: コンポーネント名は必ず **messageInterpolator** とすること。

デフォルト（省略時）は `NablarchMessageInterpolator` が使用され、[message](libraries-message.md) でメッセージを構築する。

Hibernate Validatorのプロパティファイルからメッセージを構築する実装例:
```xml
<component name="messageInterpolator"
    class="org.hibernate.validator.messageinterpolation.ResourceBundleMessageInterpolator"/>
```

- ドメインバリデーション設定: [bean_validation-domain_validation](#s5) を参照
- ウェブアプリケーション設定: [bean_validation-web_application](#) を参照
- RESTfulウェブサービス設定: [bean_validation-restful_web_service](#) を参照

アクションハンドラでのバリデーションエラー時に特定項目をエラーとしてハイライト表示したい場合、`ValidationUtil#createMessageForProperty` でエラーメッセージを構築し、`ApplicationException` を送出する。

```java
throw new ApplicationException(
    ValidationUtil.createMessageForProperty("form.mailAddress", "duplicate.mailAddress"));
```

<details>
<summary>keywords</summary>

MessageInterpolator, NablarchMessageInterpolator, messageInterpolator, Bean Validation設定, javax.validation.MessageInterpolator, nablarch.core.validation.ee.NablarchMessageInterpolator, コンポーネント設定, ValidationUtil, createMessageForProperty, ApplicationException, nablarch.core.validation.ValidationUtil, nablarch.core.message.ApplicationException, 項目エラーハイライト

</details>

## バリデーションエラー時のエラーメッセージを定義する

デフォルトでは `NablarchMessageInterpolator` を使用し、[message](libraries-message.md) でメッセージを構築する。

**メッセージ定義ルール**（NablarchMessageInterpolatorを使用した場合）:
- アノテーションの `message` 属性が `{` `}` で囲まれている場合のみ [message](libraries-message.md) を使用してメッセージを構築する
- メッセージテキスト内にアノテーション属性名を `{属性名}` 形式でプレースホルダとして使用できる
- EL式などの動的式は使用不可

Java実装例:
```java
public class SampleForm {
  @Length(max = 10)
  @SystemChar(charsetDef = "全角文字")
  @Required
  private String userName;

  @Length(min = 8, max = 8)
  @SystemChar(charsetDef = "半角数字")
  private String birthday;
}
```

メッセージ定義例（アノテーションで指定されているメッセージIDをキーにメッセージを定義する。アノテーションの `message` 属性を指定していない場合は、デフォルト値がメッセージIDとなる）:
```properties
nablarch.core.validation.ee.Length.min.message={min}文字以上で入力してください。
nablarch.core.validation.ee.Length.max.message={max}文字以内で入力してください。
nablarch.core.validation.ee.Length.min.max.message={min}文字以上{max}文字以内で入力してください。
nablarch.core.validation.ee.SystemChar.message={charsetDef}を入力してください。
```

> **補足**: デフォルト動作を変更している場合は、`MessageInterpolator` の実装に従いメッセージを定義すること。

一括登録のように同一情報を複数入力する場合は、バリデーション対象Beanにネストしたリスト型Beanを定義し、`@Valid` アノテーションを設定する。

> **補足**: これはBean Validationの仕様。詳細はBean Validation仕様を参照すること。

```java
// 一括入力された全ての情報を保持するForm
public class SampleBulkForm {
  @Valid  // ネストしたBeanに対してもバリデーションを実行
  private List<SampleForm> sampleForm;

  public SampleBulkForm() {
    sampleForm = new ArrayList<>();
  }
}

// 一括入力された情報の1入力分の情報を保持するForm
public class SampleForm {
  @Domain("name")
  private String name;
}
```

<details>
<summary>keywords</summary>

バリデーションエラーメッセージ, NablarchMessageInterpolator, プレースホルダ, メッセージ定義, nablarch.core.validation.ee.Length, nablarch.core.validation.ee.SystemChar, message属性, @Valid, 一括登録, ネストしたBean, javax.validation.Valid, List型バリデーション, @Domain

</details>

## バリデーションルールの設定方法

アノテーションをFieldかProperty(getter)に設定する。setterにはアノテーションを設定できない（指定しても無視される）。

> **補足**: Beanクラスのプロパティの型は全て `String` として定義すること。Bean Validationでは入力値をBeanに変換した後でバリデーションが実施されるため、`String` 以外の型が存在すると不正な値の入力時にBeanへの変換処理が失敗し予期せぬ例外が発生する。クライアントサイドJavaScriptバリデーションを使用している場合でも、JavaScriptの無効化やブラウザ開発者ツールで改竄が可能なため、サーバサイドではプロパティを必ず `String` とすること。外部からの値をString以外の型に変換したい場合は、バリデーション実施後に変換すること。

```java
public class SampleForm {
  @Length(max = 10)
  @SystemChar(charsetDef = "全角文字")
  @Required
  private String userName;

  @Length(min = 8, max = 8)
  @SystemChar(charsetDef = "半角数字")
  private String birthday;
}
```

> **補足**: 個別にアノテーションを設定するより [bean_validation-domain_validation](#s5) を使うことを推奨する。

ブラウザのHTML改竄やWebサービスでの不正なJSON/XML受信時にネストしたBeanが送信されない場合、ネストしたBeanがnull（未初期化状態）となりバリデーション対象にならない問題がある。確実にネストしたBeanがバリデーションされるよう実装すること。

**親BeanとネストしたBeanが1対Nの場合**: `@Valid` を設定し、ネストしたBeanの情報が必須（最低1つは入力）の場合は `@Size` アノテーションも設定する。コンストラクタでフィールドを初期化する。

```java
@Valid
@Size(min = 1, max = 5)
private List<SampleNestForm> sampleNestForms;

public SampleForm() {
  sampleNestForms = new ArrayList<>();  // インスタンス作成時に初期化
}
```

**親BeanとネストしたBeanが1対1の場合**: フラットなBeanにできないか検討すること。対応できない場合は、コンストラクタでネストしたBeanを初期化し `@Valid` を設定する。

```java
@Valid
private SampleNestForm sampleNestForm;

public SampleForm() {
  sampleNestForm = new SampleNestForm();  // インスタンス作成時に初期化
}
```

<details>
<summary>keywords</summary>

バリデーションルール, Stringプロパティ, @Required, @Length, @SystemChar, setter, アノテーション設定, プロパティ型, ネストしたBean, HTML改竄, null初期化, @Size, nablarch.core.validation.ee.Size, 1対N, 1対1, コンストラクタ初期化

</details>

## ドメインバリデーションを使う

**1. ドメインBeanの作成**

ドメインごとのバリデーションルールを持つBean（ドメインBean）を作成する。フィールド名がドメイン名となる。

> **補足**: `@Required` アノテーションはドメインBeanに設定せず、個別のBean側に設定すること。必須かどうかはドメイン側で強制できるものではなく、機能の設計によるため。

```java
package sample;

import nablarch.core.validation.ee.Length;
import nablarch.core.validation.ee.SystemChar;

public class SampleDomainBean {
    @Length(max = 10)
    @SystemChar(charsetDef = "全角文字")
    String name;

    @Length(min = 8, max = 8)
    @SystemChar(charsetDef = "半角数字")
    String date;
}
```

**2. DomainManagerの実装と設定**

`DomainManager` 実装クラスを作成し、`getDomainBean` でドメインBeanのクラスオブジェクトを返す。コンポーネント名 `domainManager` で設定する。

```java
public class SampleDomainManager implements DomainManager<SampleDomainBean> {
  @Override
  public Class<SampleDomainBean> getDomainBean() {
      return SampleDomainBean.class;
  }
}
```

```xml
<!-- DomainManager実装クラスは、domainManagerという名前で設定すること -->
<component name="domainManager" class="sample.SampleDomainManager"/>
```

**3. @Domainアノテーションで使用**

`@Domain` アノテーションをBeanのバリデーション対象プロパティに設定する。

```java
public class SampleForm {
  @Domain("name")
  @Required
  private String userName;

  @Domain("date")
  private String birthday;
}
```

ウェブアプリケーションのユーザ入力値チェックは [inject_form_interceptor](../handlers/handlers-InjectForm.md) を使用する。詳細は [inject_form_interceptor](../handlers/handlers-InjectForm.md) を参照。

Bean Validationを使用するには、`BeanValidationStrategy` を `validationStrategy` という名前でコンポーネント定義すること。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy" />
```

> **補足**: BeanValidationStrategyはバリデーションエラーのメッセージを `javax.servlet.ServletRequest#getParameterNames` が返す項目名順にソートする（エラーが発生した項目がリクエストパラメータに存在しない場合は末尾）。`getParameterNames` の返す値は実装依存であり、使用するアプリケーションサーバによっては並び順が変わる可能性がある。ソート順を変更したい場合は BeanValidationStrategy を継承して対応すること。

<details>
<summary>keywords</summary>

ドメインバリデーション, DomainManager, DomainBean, @Domain, @Required, nablarch.core.validation.ee.DomainManager, nablarch.core.validation.ee.Domain, domainManager, getDomainBean, BeanValidationStrategy, inject_form_interceptor, validationStrategy, nablarch.common.web.validator.BeanValidationStrategy, ウェブアプリケーションバリデーション, getParameterNames

</details>

## 文字種バリデーションを行う

**許容文字セットの定義クラス**（コンポーネント名には文字種を表す任意の名前を設定すること）:
- `RangedCharsetDef`: 範囲で許容文字セットを登録
- `LiteralCharsetDef`: リテラルで許容文字を全て登録
- `CompositeCharsetDef`: 複数のRangedCharsetDef/LiteralCharsetDefから構成

設定例:
```xml
<!-- 半角数字 -->
<component name="半角数字" class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
  <property name="allowedCharacters" value="01234567890" />
  <property name="messageId" value="numberString.message" />
</component>

<!-- ASCII(制御コードを除く) -->
<component name="ascii" class="nablarch.core.validation.validator.unicode.RangedCharsetDef">
  <property name="startCodePoint" value="U+0020" />
  <property name="endCodePoint" value="U+007F" />
  <property name="messageId" value="ascii.message" />
</component>

<!-- 英数字（複合） -->
<component name="英数字" class="nablarch.core.validation.validator.unicode.CompositeCharsetDef">
  <property name="charsetDefList">
    <list>
      <component-ref name="半角数字" />
      <component class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
        <property name="allowedCharacters"
            value="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" />
      </component>
    </list>
  </property>
  <property name="messageId" value="asciiAndNumberString.message" />
</component>
```

**アノテーション指定**: `@SystemChar` の `charsetDef` 属性にコンポーネント名（文字種名）を設定する。

```java
public class SampleForm {
    @SystemChar(charsetDef = "半角数字")
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
}
```

> **補足**: 許容文字セットが大きい場合、前方から順にチェックするため後方の文字チェックに時間を要する。`CachingCharsetDef` でキャッシュ可能だが、文字種バリデーションがボトルネックとなる場合のみ使用を検討すること。

```xml
<component name="半角数字" class="nablarch.core.validation.validator.unicode.CachingCharsetDef">
  <property name="charsetDef">
    <component class="nablarch.core.validation.validator.unicode.LiteralCharsetDef">
      <property name="allowedCharacters" value="01234567890" />
    </component>
  </property>
  <property name="messageId" value="numberString.message" />
</component>
```

**サロゲートペア**: デフォルトでは許容しない（LiteralCharsetDefで明示的に定義していても不可）。許容する場合は `SystemCharConfig` をコンポーネント名 `ee.SystemCharConfig` で設定する。

```xml
<component name="ee.SystemCharConfig" class="nablarch.core.validation.ee.SystemCharConfig">
  <property name="allowSurrogatePair" value="true"/>
</component>
```

RESTfulウェブサービスのユーザ入力値チェックは、入力値を受け取るリソースクラスのメソッドに `@Valid` アノテーションを設定する。詳細は [jaxrs_bean_validation_handler_perform_validation](../handlers/handlers-jaxrs_bean_validation_handler.md) を参照。

<details>
<summary>keywords</summary>

文字種バリデーション, RangedCharsetDef, LiteralCharsetDef, CompositeCharsetDef, @SystemChar, CachingCharsetDef, SystemCharConfig, サロゲートペア, nablarch.core.validation.validator.unicode.RangedCharsetDef, nablarch.core.validation.validator.unicode.LiteralCharsetDef, nablarch.core.validation.validator.unicode.CompositeCharsetDef, nablarch.core.validation.ee.SystemCharConfig, charsetDef, ee.SystemCharConfig, @Valid, RESTfulウェブサービス, javax.validation.Valid, jaxrs_bean_validation_handler_perform_validation, リソースクラス

</details>

## バリデーションエラー時にもリクエストパラメータをリクエストスコープから取得したい

[inject_form_interceptor](../handlers/handlers-InjectForm.md) 使用時、バリデーション成功後はリクエストスコープにバリデーション済みフォームが格納されパラメータを参照できるが、バリデーションエラー時にも同様にリクエストスコープからパラメータを取得したい場合がある。

JSTLタグ（EL式）を使用する場合、Nablarchカスタムタグとは異なりリクエストパラメータを暗黙的に参照できないため、バリデーションエラー時は次のようなワークアラウンドが必要になる。

* Nablarchタグ `<n:set>` を使用してリクエストパラメータの値を変数に格納する
* 暗黙オブジェクト `param` を使用してリクエストパラメータにアクセスする

`<n:set>` を使用する例:

```jsp
<%-- リクエストパラメータの値をJSTL(EL式)でも参照できるよう変数に代入する --%>
<n:set var="quantity" name="form.quantity" />
<c:if test="${quantity >= 100}">
  <%-- 数量が100以上の場合... --%>
```

このような場合、`BeanValidationStrategy` の `copyBeanToRequestScopeOnError` プロパティを `true` に設定することで、バリデーションエラー時にもリクエストパラメータをコピーしたBeanをリクエストスコープに格納できる。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy">
  <!-- バリデーションエラー時にリクエストスコープに値をコピーする -->
  <property name="copyBeanToRequestScopeOnError" value="true"/>
</component>
```

リクエストスコープには `@InjectForm` の `name` で指定されたキー名でBeanが格納される（[inject_form_interceptor](../handlers/handlers-InjectForm.md) の通常動作と同じ）。この機能を有効にすることで、前述のJSPは以下のように簡略化できる。

```jsp
<%-- リクエストスコープ経由でリクエストパラメータの値をJSTL(EL式)でも参照できる --%>
<c:if test="${form.quantity >= 100}">
  <%-- 数量が100以上の場合... --%>
```

<details>
<summary>keywords</summary>

copyBeanToRequestScopeOnError, BeanValidationStrategy, バリデーションエラー時リクエストスコープ, リクエストパラメータ取得, nablarch.common.web.validator.BeanValidationStrategy, JSTL, EL式, n:set, 暗黙オブジェクトparam

</details>

## バリデーションエラー時のメッセージに項目名を含めたい

Bean Validation(JSR349)の仕様ではメッセージに項目名を含めることができないが、Nablarchではこの機能を提供している。

コンポーネント設定ファイルで `constraintViolationConverterFactory` という名前で `ItemNamedConstraintViolationConverterFactory` を定義する。

```xml
<component name="constraintViolationConverterFactory"
    class="nablarch.core.validation.ee.ItemNamedConstraintViolationConverterFactory" />
```

項目名はメッセージとして定義する。メッセージIDは「バリデーション対象クラスの完全修飾名 + "." + プロパティ名」とする（例: `sample.User.name`、`sample.User.address`）。項目名が未定義の場合、メッセージに項目名は付加されない。

```properties
# Requiredのメッセージ
nablarch.core.validation.ee.Required.message=入力してください。

# 項目名の定義
sample.User.name = ユーザ名
sample.User.address = 住所
```

生成されるメッセージはエラーメッセージの先頭に `[項目名]` が付加される。

```
[ユーザ名]入力してください。
[住所]入力してください。
```

> **補足**: メッセージへの項目名の追加方法を変更したい場合は、`ItemNamedConstraintViolationConverterFactory` を参考にしてプロジェクト側で実装すること。

<details>
<summary>keywords</summary>

ItemNamedConstraintViolationConverterFactory, constraintViolationConverterFactory, 項目名付きエラーメッセージ, nablarch.core.validation.ee.ItemNamedConstraintViolationConverterFactory, JSR349, メッセージID

</details>

## バリデーションの明示的な実行

通常はウェブアプリケーションまたはRESTfulウェブサービスの方法でバリデーションを行うが、バリデーションエラーをハンドリングしたい場合など使用できない場合は、`ValidatorUtil#validate` で明示的にバリデーションを実行できる。

```java
ValidatorUtil.validate(form);
```

バリデーションエラー時は `ApplicationException` が送出される。

**Webアプリケーションの場合**: 明示的なバリデーションでは、バリデーション前のリクエストパラメータを `HttpRequest#getParamMap` から取得してBeanに変換する必要がある。しかし、バリデーション前の入力値をアプリケーションプログラマが自由に扱えてしまうと、バリデーションされないまま業務ロジックを実行し、場合によっては障害につながる危険がある。そのため、`HttpRequest#getParamMap` はアーキテクト向け公開APIとし、Actionクラスでの使用は禁止している。明示的にバリデーションを実行する必要がある場合は、共通基盤部品として以下のようなユーティリティクラスの作成を推奨する。

```java
public final class ProjectValidatorUtil {
    public static <T> T validate(Class<T> beanClass, HttpRequest request) {
        T bean = BeanUtil.createAndCopy(beanClass, request.getParamMap());
        ValidatorUtil.validate(bean);
        return bean;
    }
}
```

<details>
<summary>keywords</summary>

ValidatorUtil, validate, nablarch.core.validation.ee.ValidatorUtil, 明示的バリデーション実行, HttpRequest, getParamMap, nablarch.fw.web.HttpRequest, ApplicationException, ProjectValidatorUtil, BeanUtil, BeanUtil.createAndCopy

</details>

## バリデーションエラー時に任意の処理を行いたい

バリデーションエラー時に任意の処理を行いたい場合は、明示的にバリデーションを実行して `ApplicationException` をキャッチすることで任意の処理を行える。

```java
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/create.jsp")
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    ProjectForm form;
    try {
        // バリデーションを明示的に実行し、バリデーション済みのフォームを取得する
        form = ProjectValidatorUtil.validate(ProjectForm.class, request);
    } catch (ApplicationException e) {
        // バリデーションエラー時に任意の処理を行う
        // ...
        // ApplicationExceptionを送出し、@OnErrorアノテーションで指定された遷移先に遷移する
        throw e;
    }
    // 以下省略
}
```

<details>
<summary>keywords</summary>

ApplicationException, バリデーションエラー任意処理, @OnError, 明示的バリデーション, 例外ハンドリング

</details>
