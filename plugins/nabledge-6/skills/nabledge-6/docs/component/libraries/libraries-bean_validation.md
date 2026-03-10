# Bean Validation

## 機能概要

> **重要**: この機能はJakarta Bean Validationのエンジンを実装しているわけではない。Jakarta EE環境(WebLogicやWildFlyなど)ではサーバ内バンドルのJakarta Bean Validation実装が使用される。Jakarta EE環境外では別途Jakarta Bean Validationの実装ライブラリを追加する必要がある（[Hibernate Validator(外部サイト、英語)](https://hibernate.org/validator/)を推奨）。

**ドメインバリデーション**: ドメインごとにバリデーションルールを定義できる。Beanのプロパティにはドメイン名の指定だけを行えばよく、バリデーションルールの変更が容易。

**提供バリデータ**: Nablarchが提供するバリデータのアノテーションは以下のパッケージを参照：
- `nablarch.core.validation.ee`
- `nablarch.common.code.validator.ee`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>

<!-- メッセージ管理を使用する場合（デフォルトで使用される） -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-message</artifactId>
</dependency>

<!-- コード値のバリデータを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-code</artifactId>
</dependency>

<!-- ウェブアプリケーションで使用する場合 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## Bean Validationを使うための設定

**MessageInterpolatorの設定**

バリデーションエラー発生時のメッセージを構築するクラス（`MessageInterpolator` の実装クラス）を設定する。

- デフォルト: `NablarchMessageInterpolator`（`message` 機能を使用）

> **重要**: コンポーネント名は必ず **messageInterpolator** とすること。

Hibernate ValidatorのResourceBundleMessageInterpolatorを使用する場合の設定例：

```xml
<component name="messageInterpolator"
    class="org.hibernate.validator.messageinterpolation.ResourceBundleMessageInterpolator"/>
```

## バリデーションエラー時のエラーメッセージを定義する

デフォルトの `NablarchMessageInterpolator` を使用した場合のメッセージ定義ルール：

- アノテーションの `message` 属性に指定された値が `{`、`}` で囲まれていた場合のみ `message` 機能を使用してメッセージを構築する
- プレースホルダはアノテーションの属性名を `{`、`}` で囲んで定義する
- EL式などの動的な式は使用できない

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

```properties
nablarch.core.validation.ee.Length.min.message={min}文字以上で入力してください。
nablarch.core.validation.ee.Length.max.message={max}文字以内で入力してください。
nablarch.core.validation.ee.Length.min.max.message={min}文字以上{max}文字以内で入力してください。
nablarch.core.validation.ee.SystemChar.message={charsetDef}を入力してください。
```

> **補足**: デフォルト動作を変更した場合は、`MessageInterpolator` の実装に従いメッセージを定義すること。

## バリデーションルールの設定方法

バリデーションルールはアノテーションをFieldかProperty(getter)に設定する。setterにはアノテーションを指定できない（指定しても無視される）。

> **補足**: BeanクラスのプロパティはすべてStringとして定義すること。Bean Validationでは入力値をBeanに変換した後にバリデーションが実施されるため、String以外のプロパティに不正な値が送信された場合、Beanへの変換処理が失敗し予期せぬ例外が発生する。外部からの値をString以外の型に変換したい場合は、バリデーション実施後に変換すること。クライアントサイドでJavaScriptバリデーションを行っている場合でも、サーバサイドのプロパティは必ずStringとすること（JavaScriptの無効化やブラウザ開発者ツールによる改竄が可能なため、クライアントサイドバリデーションをすり抜けた不正値がサーバサイドに送られる可能性がある）。

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

> **補足**: 個別にアノテーションを設定した場合、実装ミスやメンテナンスコスト増加のリスクがあるため、ドメインバリデーションを使うことを推奨する。

## ドメインバリデーションを使う

**ドメインBeanの作成**

ドメインごとのバリデーションルールを持つBean（ドメインBean）を作成する。フィールド名がドメイン名となる。

> **補足**: `@Required` アノテーションはドメインBeanに設定するのではなく個別Bean側に設定すること（必須かどうかは機能の設計によるため）。

```java
public class SampleDomainBean {
    @Length(max = 10)
    @SystemChar(charsetDef = "全角文字")
    String name;

    @Length(min = 8, max = 8)
    @SystemChar(charsetDef = "半角数字")
    String date;
}
```

**DomainManagerの実装と有効化**

`DomainManager` 実装クラスを作成し、`getDomainBean` でドメインBeanのクラスオブジェクトを返す。コンポーネント名は `domainManager` で設定する。

```java
public class SampleDomainManager implements DomainManager<SampleDomainBean> {
  @Override
  public Class<SampleDomainBean> getDomainBean() {
      return SampleDomainBean.class;
  }
}
```

```xml
<component name="domainManager" class="sample.SampleDomainManager"/>
```

**各Beanでのドメインバリデーション使用**

バリデーション対象プロパティに `@Domain` アノテーションを設定する。

```java
public class SampleForm {
  @Domain("name")
  @Required
  private String userName;

  @Domain("date")
  private String birthday;
}
```

## 文字種バリデーションを行う

文字種ごとに許容する文字のセットをコンポーネント定義に登録し、`@SystemChar` アノテーションの `charsetDef` 属性にコンポーネント名（文字種名）を指定する。

**許容文字セットのクラス**

| クラス | 用途 |
|---|---|
| `RangedCharsetDef` | 範囲で許容文字セットを登録 |
| `LiteralCharsetDef` | リテラルで許容文字を全て登録 |
| `CompositeCharsetDef` | 複数のRangedCharsetDef/LiteralCharsetDefを組み合わせ |

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

<!-- 英数字 -->
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

```java
public class SampleForm {
    @SystemChar(charsetDef = "半角数字")
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
}
```

> **補足**: 許容文字セットの文字数が大きい場合、前方から順に検索するため後方の文字チェックに時間を要する。文字種バリデーションがボトルネックとなる場合に `CachingCharsetDef` によるキャッシュ機能の使用を検討すること（原則はキャッシュなしで開発を進めること）。

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

**サロゲートペアの許容**

デフォルトではサロゲートペアを許容しない（`LiteralCharsetDef` で明示的に定義していても同様）。許容する場合は `SystemCharConfig` をコンポーネント名 `ee.SystemCharConfig` で設定し、`allowSurrogatePair` プロパティを `true` にする。

```xml
<component name="ee.SystemCharConfig" class="nablarch.core.validation.ee.SystemCharConfig">
  <property name="allowSurrogatePair" value="true"/>
</component>
```

## 相関バリデーションを行う

フィールド間の相関バリデーションは `@AssertTrue` アノテーションを使用したメソッドで実装する。

> **重要**: Jakarta Bean Validationはバリデーションの実行順序を保証しない。そのため、相関バリデーションはフィールド単体のバリデーションより先に呼び出される場合があり、フィールドがnull/空の状態でも呼び出される可能性がある。予期せぬ例外をスローしないよう、対象フィールドがnull/空の場合はtrueを返して処理をスキップすること。

**メールアドレス一致確認の例**:

```java
@AssertTrue(message = "{compareMailAddress}")
public boolean isEqualsMailAddress() {
    if (StringUtil.isNullOrEmpty(mailAddress) || StringUtil.isNullOrEmpty(confirmMailAddress)) {
        // フィールドがnull/空の場合はtrueを返してスキップ（単体バリデーションに任せる）
        return true;
    }
    return Objects.equals(mailAddress, confirmMailAddress);
}
```

## データベースとの相関バリデーションを行う

> **重要（セキュリティ）**: データベースとの相関バリデーションは、Bean Validationでは行わずビジネスアクション側で実施すること。

Bean Validationでデータベースアクセスを行うと、まだバリデーションされていない不正な値をDB問い合わせに使用するため、SQLインジェクションの脆弱性につながる可能性がある。

データベースとの相関チェック（例：メールアドレスの重複チェック）は、Bean Validationを通過した後のビジネスアクション内で実施すること。

## 特定の項目に紐づくバリデーションエラーのメッセージを作りたい

特定のプロパティに紐づいたバリデーションエラーメッセージを生成するには、`ValidationUtil#createMessageForProperty` を使用してメッセージを構築し、`ApplicationException` をスローする。

```java
throw new ApplicationException(
    ValidationUtil.createMessageForProperty("form.mailAddress", "duplicate.mailAddress"));
```

- 第1引数: エラーを紐づけるプロパティ名
- 第2引数: メッセージID

アクションハンドラで行うバリデーション（:ref:`bean_validation-database_validation` 等）でエラーが発生した場合に、画面上で対象項目をエラーハイライト表示したい場合は、`ValidationUtil#createMessageForProperty` でエラーメッセージを構築し、`ApplicationException` を送出する。

```java
throw new ApplicationException(
        ValidationUtil.createMessageForProperty("form.mailAddress", "duplicate.mailAddress"));
```

## 一括登録のようなBeanを複数入力する機能でバリデーションを行う

一括登録など複数のBeanを入力する機能では、親フォームクラスのListフィールドに `@Valid` アノテーションを付与することで、リスト内の各Beanに対してバリデーションが実行される。

```java
public class SampleBulkForm {
    @Valid
    private List<SampleForm> sampleForm;

    public SampleBulkForm() {
        sampleForm = new ArrayList<>();
    }
}
```

## ネストしたBeanをバリデーションする際の注意点

ネストしたBeanをバリデーションする際の注意点：

**1. ネストしたBeanがnullになる問題**

HTMLの改ざんやJSON/XMLの不正送信でネストしたBeanの情報が送られない場合、ネストしたBeanはnullとなりバリデーションが実行されない。コンストラクタでネストしたBeanを初期化すること。

```java
public class SampleBulkForm {
    @Valid
    private List<SampleForm> sampleForm;

    public SampleBulkForm() {
        // コンストラクタで初期化することでnullを防ぐ
        sampleForm = new ArrayList<>();
    }
}
```

**2. リストの件数制約**

リストの件数に制約を設ける場合は `@Size` アノテーションを使用する。

```java
@Valid
@Size(min = 1, max = 5)
private List<SampleForm> sampleForm;
```

**3. 1対1のネストしたBean**

1対1でネストしたBeanを使用する場合は、フォームをフラット化するか、コンストラクタでネストしたBeanを初期化すること。

## ウェブアプリケーションのユーザ入力値のチェックを行う

ウェブアプリケーションでBean Validationを使用するには、`BeanValidationStrategy` をコンポーネント名 `validationStrategy` で登録する。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy" />
```

> **補足**: バリデーションエラー時のメッセージのソート順は、`getParameterNames` の実装に依存するため、使用するサーバによって順序が異なる場合がある。ソート順を変更したい場合は `BeanValidationStrategy` を継承して実装を変更すること。

## RESTfulウェブサービスのユーザ入力値のチェックを行う

RESTfulウェブサービスでBean Validationを使用するには、リソースクラスのメソッドに `@Valid` アノテーションを設定する。

```java
@Path("/sample")
public class SampleResource {
    @POST
    public void register(@Valid SampleForm form) {
        // ...
    }
}
```

## バリデーションエラー時にもリクエストパラメータをリクエストスコープから取得したい

バリデーションエラー時にもBeanをリクエストスコープに保持するには、`BeanValidationStrategy` の `copyBeanToRequestScopeOnError` プロパティを `true` に設定する。

この設定により、バリデーションエラー発生時にも `@InjectForm` で指定した名前をキーとしてBeanがリクエストスコープに格納される。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy">
  <property name="copyBeanToRequestScopeOnError" value="true"/>
</component>
```

## バリデーションエラー時のメッセージに項目名を含めたい

バリデーションエラーメッセージに項目名を含めるには、`ItemNamedConstraintViolationConverterFactory` をコンポーネント名 `constraintViolationConverterFactory` で登録する。

```xml
<component name="constraintViolationConverterFactory"
    class="nablarch.core.validation.ee.ItemNamedConstraintViolationConverterFactory" />
```

項目名のメッセージIDは `完全修飾クラス名.プロパティ名` の形式で定義する。このメッセージがエラーメッセージのプレフィックスとして付与される。

Jakarta Bean Validationの仕様ではメッセージに項目名を含められないが、Nablarchでは `ItemNamedConstraintViolationConverterFactory` を使用してエラーメッセージの先頭に `[項目名]` を付加できる。

**コンポーネント設定**: コンポーネント名 `constraintViolationConverterFactory` で定義する。

```xml
<component name="constraintViolationConverterFactory"
    class="nablarch.core.validation.ee.ItemNamedConstraintViolationConverterFactory" />
```

**項目名の定義**: 項目名のメッセージIDは `{完全修飾クラス名}.{プロパティ名}` とする。定義がない場合は項目名は付加されない。

```properties
sample.User.name = ユーザ名
sample.User.address = 住所
```

**生成されるメッセージ**: エラーメッセージの先頭に `[項目名]` が付加される（例: `[ユーザ名]入力してください。`）。

> **補足**: メッセージへの項目名追加方法を変更したい場合は、`ItemNamedConstraintViolationConverterFactory` を参考にプロジェクト側で実装すること。

## バリデーションの明示的な実行

バリデーションを明示的に実行するには `ValidatorUtil#validate` を使用する。バリデーションエラーが発生した場合は `ApplicationException` がスローされる。

```java
ValidatorUtil.validate(form); // エラー時はApplicationExceptionをスロー
```

> **重要**: `HttpRequest#getParamMap` はアーキテクト向けAPIであり、Actionクラスでの使用は禁止されている。Actionクラスで明示的なバリデーションが必要な場合は、`BeanUtil.createAndCopy` と `ValidatorUtil.validate` をラップしたユーティリティクラスを作成して使用すること。

## バリデーションエラー時に任意の処理を行いたい

バリデーションエラー発生時に任意の処理を行うには、`ValidatorUtil.validate` が投げる `ApplicationException` をcatchして処理を行い、再スローする。

```java
try {
    form = ProjectValidatorUtil.validate(ProjectForm.class, request);
} catch (ApplicationException e) {
    // バリデーションエラー時のカスタム処理
    // （ログ出力や追加情報の設定など）
    throw e;
}
```

## Bean Validationのグループ機能を使用したい

グループを指定してバリデーションを実行するには `ValidatorUtil#validateWithGroup` を使用する。

```java
ValidatorUtil.validateWithGroup(form, SampleForm.Test1.class);
```

> **重要**: Nablarchでは、グループ機能を使って1つのFormクラスを複数の画面やAPIで共有することは推奨しない。HTMLフォームごと、またはAPIごとにFormクラスを作成すること。

## 相関バリデーションを行う

複数項目を使った相関バリデーションには `@AssertTrue` アノテーションを使用する。`message` プロパティでエラーメッセージを指定する。

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

> **重要**: Jakarta Bean Validationではバリデーション実行順序が保証されないため、項目単体のバリデーションよりも前に相関バリデーションが呼び出される場合がある。相関バリデーションのロジックは、項目単体のバリデーションが未実行の場合でも予期せぬ例外が発生しないよう実装すること。

任意項目の場合、未入力時はバリデーションをスキップして `true` を返す必要がある:

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

## データベースとの相関バリデーションを行う

データベースとの相関バリデーションは業務アクション側で実装すること。Bean Validationでデータベースアクセスを行うと、バリデーション前の安全でない値でDBアクセスすることになり、SQLインジェクション等の脆弱性の原因となる。業務アクションでバリデーション済みの値を使ってDBアクセスすること。

## 一括登録のようなBeanを複数入力する機能でバリデーションを行う

一括登録等、同一情報を複数入力するケースでは、バリデーション対象のBeanにネストしたBeanを定義し、`@Valid` アノテーションを付加することでバリデーションを実行する（Jakarta Bean Validationの仕様）。

```java
// 一括入力された全情報を保持するForm
public class SampleBulkForm {
  @Valid
  private List<SampleForm> sampleForm;

  public SampleBulkForm() {
    sampleForm = new ArrayList<>();
  }
}

// 1入力分の情報を保持するForm
public class SampleForm {
  @Domain("name")
  private String name;
}
```

## ネストしたBeanをバリデーションする際の注意点

ブラウザのHTML改竄や不正なJSON/XMLを受信した場合、ネストしたBeanの情報が送信されずnull（未初期化）となり、バリデーション対象外になる問題がある。確実にネストしたBeanがバリデーションされるよう実装すること。

**親BeanとネストしたBeanが1対Nの場合**: `@Valid` と `@Size` アノテーションを設定し、コンストラクタでフィールドを初期化する。

```java
// min=1でネストしたBeanが必ず1つは選択されていることをバリデーション
@Valid
@Size(min = 1, max = 5)
private List<SampleNestForm> sampleNestForms;

public SampleForm() {
  sampleNestForms = new ArrayList<>();
}
```

**親BeanとネストしたBeanが1対1の場合**: フラットなBeanにできないか検討すること。対応できない場合はコンストラクタでネストしたBeanを初期化する。

```java
@Valid
private SampleNestForm sampleNestForm;

public SampleForm() {
  sampleNestForm = new SampleNestForm();
}
```

## ウェブアプリケーションのユーザ入力値のチェックを行う

ウェブアプリケーションのユーザ入力値チェックには :ref:`inject_form_interceptor` を使用する。Bean Validationを使用するにはコンポーネント設定ファイルに `BeanValidationStrategy` を `validationStrategy` という名前で定義すること。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy" />
```

> **補足**: BeanValidationStrategyはバリデーションエラーのメッセージを `jakarta.servlet.ServletRequest#getParameterNames` が返す項目名順でソートする。`getParameterNames` の返す順序は実装依存（アプリケーションサーバにより異なる可能性あり）。ソート順を変更したい場合はBeanValidationStrategyを継承して対応すること。

## RESTfulウェブサービスのユーザ入力値のチェックを行う

RESTfulウェブサービスのユーザ入力値チェックは、入力値を受け取るリソースクラスのメソッドに `@Valid` アノテーションを設定することで行う。詳細は :ref:`jaxrs_bean_validation_handler_perform_validation` を参照。

## バリデーションエラー時にもリクエストパラメータをリクエストスコープから取得したい

:ref:`inject_form_interceptor` を使用した場合、バリデーション成功時のみリクエストスコープにバリデーション済みフォームが格納される。JSTLタグ（EL式）を使用する場合、Nablarchカスタムタグとは異なりリクエストパラメータを暗黙的に参照できないため、バリデーションエラー時にリクエストパラメータにアクセスするには次のいずれかの処理を追加する必要がある。

- Nablarchタグ `<n:set>` を使用してリクエストパラメータの値を変数に格納する
- 暗黙オブジェクト `param` を使用してリクエストパラメータにアクセスする

**`<n:set>` を使用する例**:

```jsp
<%-- リクエストパラメータの値をJSTL(EL式)でも参照できるよう変数に代入する --%>
<n:set var="quantity" name="form.quantity" />
<c:if test="${quantity >= 100}">
  <%-- 数量が100以上の場合... --%>
```

このような場合、`BeanValidationStrategy` の `copyBeanToRequestScopeOnError` プロパティを `true` に設定することで、バリデーションエラー時にもリクエストパラメータをコピーしたBeanをリクエストスコープに格納できる。リクエストスコープには `@InjectForm` の `name` で指定されたキー名でBeanが格納される。

```xml
<component name="validationStrategy" class="nablarch.common.web.validator.BeanValidationStrategy">
  <property name="copyBeanToRequestScopeOnError" value="true"/>
</component>
```

この設定により、エラー時もリクエストスコープ経由でパラメータにアクセスできる:

```jsp
<%-- リクエストスコープ経由でリクエストパラメータの値をJSTL(EL式)でも参照できる --%>
<c:if test="${form.quantity >= 100}">
  <%-- 数量が100以上の場合... --%>
```

## バリデーションの明示的な実行

通常の方法（:ref:`bean_validation-web_application`、:ref:`bean_validation-restful_web_service`）が使用できない場合、`ValidatorUtil#validate` で明示的にバリデーションを実行できる。バリデーションエラー時は `ApplicationException` が送出される。

```java
ValidatorUtil.validate(form);
```

> **重要（Webアプリケーション）**: `HttpRequest#getParamMap` はアーキテクト向けの公開APIであり、Actionクラスでの使用は禁止。バリデーション前の入力値をアプリケーションプログラマが自由に扱えてしまうと、バリデーションされないまま業務ロジックが実行され障害につながる危険がある。

Webアプリケーションで明示的バリデーションが必要な場合は、以下のようなユーティリティクラスの作成を推奨する:

```java
public final class ProjectValidatorUtil {
    public static <T> T validate(Class<T> beanClass, HttpRequest request) {
        T bean = BeanUtil.createAndCopy(beanClass, request.getParamMap());
        ValidatorUtil.validate(bean);
        return bean;
    }
}
```

## バリデーションエラー時に任意の処理を行いたい

バリデーションエラー時に任意の処理を行うには、:ref:`bean_validation-execute_explicitly` で紹介したユーティリティクラスを使用して明示的にバリデーションを実行し、発生する `ApplicationException` をcatch処理する。

```java
@OnError(type = ApplicationException.class, path = "/WEB-INF/view/project/create.jsp")
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    ProjectForm form;
    try {
        form = ProjectValidatorUtil.validate(ProjectForm.class, request);
    } catch (ApplicationException e) {
        // バリデーションエラー時の任意処理
        throw e;
    }
    // 以下省略
}
```

## Bean Validationのグループ機能を使用したい

Jakarta Bean Validationの仕様では、バリデーション実行時にグループを指定すると、使用するルールを特定グループに制限できる。

- グループを指定しない場合は `Default` グループに所属するルールでバリデーションされる
- グループを指定する場合は指定グループに所属するルールでバリデーションされる

**バリデーション対象のForm例**:

```java
public class SampleForm {

    @SystemChar(charsetDef = "数字", groups = {Default.class, Test1.class})
    String id;

    @SystemChar.List({
            @SystemChar(charsetDef = "全角文字") // グループを指定しない場合は、Defaultグループに所属していると見なされる
            @SystemChar(charsetDef = "半角英数", groups = Test1.class),
    })
    String name;

    public interface Test1 {}
}
```

**バリデーション実行例**:

```java
// グループを指定しない場合はDefaultグループのルールでバリデーション
ValidatorUtil.validate(form);

// グループを指定する場合は指定グループのルールでバリデーション
ValidatorUtil.validateWithGroup(form, SampleForm.Test1.class);
```

APIの詳細は `ValidatorUtil#validateWithGroup` および `ValidatorUtil#validateProperty` を参照。

> **補足**: グループ機能を使ってフォームクラスを複数画面・APIで共通化できるが、Nablarchではそのような使用方法を推奨していない（:ref:`フォームクラスは、htmlのform単位に作成する <application_design-form_html>` および :ref:`フォームクラスはAPI単位に作成する <rest-application_design-form_html>` 参照）。フォームクラスを共通化する目的でグループ機能を使用する場合は、プロジェクト側で十分検討の上で使用すること。

## 拡張例

### プロジェクト固有のアノテーションとバリデーションロジックを追加したい

:ref:`bean_validation-validator` に記載のバリデータで要件を満たせない場合は、プロジェクト側でアノテーションおよびバリデーションロジックを追加すること。

参考:
- [Hibernate Validator(外部サイト、英語)](https://hibernate.org/validator/)
- [Jakarta Bean Validation(外部サイト、英語)](https://jakarta.ee/specifications/bean-validation/)
