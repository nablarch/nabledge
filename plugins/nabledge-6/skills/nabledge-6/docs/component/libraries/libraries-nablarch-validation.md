# Nablarch Validation

**目次**

* 機能概要

  * バリデーションと型変換及び値の正規化ができる
  * ドメインバリデーションができる
  * よく使われるバリデータ及びコンバータが提供されている
* モジュール一覧
* 使用方法

  * 使用するバリデータとコンバータを設定する
  * バリデーションルールを設定する
  * ドメインバリデーションを使う
  * バリデーション対象のBeanを継承する
  * バリデーションを実行する
  * バリデーションの明示的な実行
  * 文字種バリデーションを行う
  * 相関バリデーションを行う
  * 一括登録のようなBeanの配列を入力とする機能でバリデーションを行う
  * ラジオボタンやリストボックスの選択値に応じてバリデーション項目を変更する
  * 特定の項目に紐づくバリデーションエラーのメッセージを作りたい
  * バリデーションエラー時のメッセージに項目名を埋め込みたい
  * 数値型への型変換
  * データベースとの相関バリデーションを行う
  * ウェブアプリケーションのユーザ入力値のチェックを行う
* 拡張例

  * プロジェクト固有のバリデータを追加したい
  * プロジェクト固有のコンバータを追加したい
  * バリデーション対象のBeanオブジェクトの生成方法を変更したい

この章では、Nablarchで独自に実装したバリデーション機能を解説する。

> **Tip:**
> [入力値のチェック](../../component/libraries/libraries-validation.md#validation) で説明したように、 [Bean Validation](../../component/libraries/libraries-bean-validation.md) を使用することを推奨する。

## 機能概要

### バリデーションと型変換及び値の正規化ができる

Nablarchのバリデーションでは、バリデーションと入力値の型変換、正規化を行うことが出来る。

型変換が行えるため、入力値をBeanクラスの数値型(IntegerやLong)などに直接マッピングすることが出来る。
また、編集された値の編集解除(正規化)なども型変換時に行うことが出来る。

詳細は、 [使用するバリデータとコンバータを設定する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) を参照。

### ドメインバリデーションができる

ドメインごとにバリデーションルールを定義できる。

ドメインバリデーションを使うと、Beanクラスのsetterにはドメイン名の指定だけを行えばよく、バリデーションルールの変更が容易になる。

詳細は、 ドメインバリデーションを使う を参照。

### よく使われるバリデータ及びコンバータが提供されている

Nablarchでは、よく使われるバリデータやコンバータを標準で提供している。
このため、プロジェクト側では [使用するバリデータとコンバータを設定する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) だけで、バリデーションが実行できる。

Nablarchで提供しているバリデータ及びコンバータについては以下のリンク先を参照。

* nablarch.core.validation.validator
* nablarch.core.validation.convertor
* nablarch.common.date
* nablarch.common.code.validator

## モジュール一覧

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

## 使用方法

### 使用するバリデータとコンバータを設定する

バリデーションを有効にするには、コンポーネント設定ファイルに使用するバリデータとコンバータの登録が必要となる。

Nablarchが提供しているバリデータ及びコンバータについては、 [よく使われるバリデータ及びコンバータが提供されている](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-validator-convertor) を参照。

> **Important:**
> バリデータやコンバータの設定がない場合、バリデーション機能は使用できないので必ず設定すること。

設定例
* ValidationManager を **validationManager** という名前でコンポーネント定義する。
* ValidationManager#convertors に使用するコンバータを列挙する。
* ValidationManager#validators に使用するバリデータを列挙する。

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

  <!--
  他の属性は省略
  詳細は、ValidationManagerのJavadocを参照
   -->
</component>
```

### バリデーションルールを設定する

バリデーションルールのアノテーションは、バリデーション対象のBeanクラスのプロパティ(setter)に設定する。
なお、getterにはアノテーションを指定できないので注意すること。(指定しても意味が無い)

> **Tip:**
> 個別にアノテーションを設定した場合、実装時のミスが増えたりメンテナンスコストが大きくなるため、
> 後述する [ドメインバリデーション](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-domain-validation) を使うことを推奨する。

実装例
[Nablarchで提供しているバリデータとコンバータ](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-validator-convertor) を参照しアノテーションを設定する。

この例では、 userName は入力が必須で、全角文字の最大10文字が許容される。
birthday は、半角数字の8桁が許容される。
age は、整数で3桁まで許容される。

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

### ドメインバリデーションを使う

ドメインバリデーションを使うための設定や実装例を示す。

ドメインごとのバリデーションルールを定義したEnumの作成
ドメインバリデーションを使用するには、まずドメインごとのバリデーションルールを持つEnum(ドメインEnum)を作成する。
このEnumは、必ず DomainDefinition インタフェースを実装すること。

Enumの各列挙子がドメイン名となる。以下の例では `NAME` と `DATE` の２つのドメインが定義されている。

```java
public enum SampleDomain implements DomainDefinition {

    @Length(max = 10)
    @SystemChar(charsetDef = "全角文字")
    NAME,

    @Length(min = 8, max = 8)
    @SystemChar(charsetDef = "半角数字")
    DATE;

    // インタフェースで定義されているメソッドの実装
    // 実装する内容は、この例と全く同じとすること
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
ドメインを表すアノテーションの作成
ドメインを表すアノテーションを作成する。
value 属性には、上記で作成したドメインEnumを指定できるようにする。

```java
@ConversionFormat
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Domain {
    SampleDomain value();
}
```
バリデーション対象のBeanにドメインを設定
上記で作成したドメインを表すアノテーションを設定することで、ドメインバリデーションが行われる。

この例では、 userName に対して SampleDomain.NAME に設定したバリデーションが実行される。
※コンバータが設定されている場合は、コンバータによる値の変換も行われる。

```java
@Domain(SampleDomain.NAME)
public void setUserName(String userName) {
    this.userName = userName;
}
```
ドメインバリデーションを有効にするための設定
ドメインバリデーションを有効にするためには、以下の設定が必要となる。

* DomainValidationHelper の設定
* DomainValidator の設定
* ValidationManager の設定
* 初期化コンポーネントの設定

以下に例を示す。

DomainValidationHelper の設定
* domainAnnotationプロパティ
  にドメインを表すアノテーションの完全修飾名(FQCN)を設定する。

```xml
<component name="domainValidationHelper"
    class="nablarch.core.validation.domain.DomainValidationHelper">

  <property name="domainAnnotation" value="sample.Domain" />

</component>
```
DomainValidator の設定
* domainValidationHelperプロパティ
  に、上記で設定した DomainValidationHelper を設定する。
* validatorsプロパティ
  にバリデータのリストを設定する。

```xml
<component name="domainValidator"
    class="nablarch.core.validation.domain.DomainValidator">

  <!--
    DomainValidatorはここには設定しないこと。設定すると循環参照となり、
    システムリポジトリ初期化時にエラーとなる。
  -->
  <property name="validators">
    <list>
      <component-ref name="requiredValidator" />
    </list>
  </property>
  <property name="domainValidationHelper" ref="domainValidationHelper" />
</component>
```
ValidationManager の設定
* domainValidationHelperプロパティ
  に、上記で設定した DomainValidationHelper を設定する。
* validatorsプロパティ
  にバリデータのリスト(上記で設定した DomainValidator を忘れずに) を設定する。

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
初期化コンポーネントの設定
上記で設定した、 DomainValidator と
ValidationManager を初期化対象のリストに設定する。

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
ドメインバリデーションに複数のバリデーションルールを設定した場合の挙動
ドメインバリデーションにて１つの入力項目に複数のエラーが存在する場合、精査を１つ目のエラーで打ち切る。

```java
 public enum SampleDomain implements DomainDefinition {
   @Length(max = 10)
   @SystemChar(charsetDef = "全角文字")
   NAME;
}
```

上記 NAME は Length バリデーションエラーになった場合、 SystemChar バリデーションは行わない。

### バリデーション対象のBeanを継承する

バリデーション対象のBeanは継承できるが、以下の理由により継承は推奨しない。

安易に継承した場合、親クラスの変更により予期せぬバリデーションが実行されたり、
複雑なバリデーションの上書きルールを意識したアノテーションを設定しなければならず、間違い(バグ)の原因となる。

なお、Beanを継承した場合は以下の動作となる。

* サブクラス側に @PropertyName のみをつけた場合、親クラス側のバリデータとコンバータが使用される。
* サブクラス側にバリデータ用のアノテーションを1つでもつけた場合、親クラス側のバリデータアノテーションは無視され
  サブクラス側のバリデータが使用される。コンバータは親クラスのものが使用される。
* サブクラス側にコンバータ用のアノテーションを1つでもつけた場合は、親クラスのコンバータのアノテーションは無視され
  サブクラス側のコンバータが使用される。バリデータは親クラスのものが使用される。
* サブクラス側にバリデータもコンバータも設定されている場合は、全てサブクラス側の設定が使われる。
* 親クラス側のコンバータの設定をサブクラス側で削除できない。

以下の親子関係のBeanの場合、 ChildForm の value プロパティに対しては、
@Digits と @NumberRange のバリデーションが実行される。

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

### バリデーションを実行する

バリデーションは、 ValidationUtil で提供されるメソッドを呼び出すことで実行できる。

実装例
まず、入力値からBeanオブジェクトを生成するため、バリデーション対象のBeanにMapを引数に取るコンストラクタを実装する。

次にバリデーション対象のBeanにバリデーションを行うためのstaticメソッドを実装する。
このメソッドには、 @ValidateFor アノテーションを設定し、バリデーションを識別するための任意の値を引数で指定する。

このメソッドに必要となる処理は、  ValidationUtil を使用してバリデーションを実行すること。

```java
public class SampleForm {

  public SampleForm(Map<String, Object> params) {
      userName = (String) params.get("userName");
      birthDay = (String) params.get("birthDay");
      age = (Integer) params.get("age");
  }

  @Domain(SampleDomain.NAME)
  @Required
  public void setUserName(String userName) {
      this.userName = userName;
  }

  @Domain(SampleDomain.DATE)
  public void setBirthday(String birthday) {
      this.birthday = birthday;
  }

  @Domain(SampleDomain.AGE)
  public void setAge(Integer age) {
      this.age = age;
  }

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {
    // userNameとbirthdayとageに対してバリデーションを実行
    ValidationUtil.validate(context, new String[] {"userName", "birthday", "age"});
  }
}
```

上記のBeanを使って入力値の request をバリデーションするには、以下のように  ValidationUtil を使用する。
なお、ウェブアプリケーションの場合には ウェブアプリケーションのユーザ入力値のチェックを行う でより簡易的にバリデーションが行える。

```java
// バリデーションの実行
// SampleFormを使って入力パラメータのrequestをチェックする。
//
// 最後の引数にはSampleFormのどのバリデーションメソッドを使用してバリデーションを行うのかを指定する。
// この例では、validateを指しているので、SampleFormの@ValidateForアノテーションに
// validateと指定されているメソッドを使ってバリデーションが実行される。
ValidationContext<SampleForm> validationContext =
        ValidationUtil.validateAndConvertRequest(SampleForm.class, request, "validate");

// バリデーションエラーが発生している場合、abortIfInvalidで例外が送出される
validationContext.abortIfInvalid();

// Mapを引数に取るコンストラクタを使用してFormを生成する。
// (入力値のrequestが変換されたFormが取得できる)
SampleForm form = validationContext.createObject();
```

### バリデーションの明示的な実行

バリデーションを実行する では、Beanのプロパティ(setter)に設定したアノテーションベースでバリデーションが実行されたが、
ここではアノテーションを設定するのではなく直接バリデーションを実行する方法を説明する。

原則、 バリデーションを実行する の方法でバリデーションを行うが、個別にバリデーションを実行する必要がある場合には、
この方法でバリデーションを行うこと。
例えば、 [コード管理のパターン](../../component/libraries/libraries-code.md#code-use-pattern) を使っていて、
特定の画面だけパターンを変えてバリデーションしたい場合に、個別にバリデーションを実行する。

実装例
明示的なバリデーションの実行は、Beanクラスの  @ValidateFor アノテーションが設定されたメソッドから行う。
なお、明示的バリデーションの実行時に指定できるアノテーションは、 DirectCallableValidator を実装しているものに限定される。
(コンバータは指定できない。)

```java
public class SampleForm {
  // 属性は省略

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {

      ValidationUtil.validate(context, new String[]{"userName", "prefectureCode"});

      // userNameに対して必須チェックを実施
      ValidationUtil.validate(context, "userName", Required.class);

      // アノテーションのパラメータはMapで指定する
      Map<String, Object> params = new HashMap<String, Object>();
      params.put("codeId", "1052");     // コードID
      params.put("pattern", "A");       // 使用するコードパターン名
      params.put("messageId", "M4865"); // エラーメッセージのID
      ValidationUtil.validate(context, "prefectureCode", CodeValue.class, params);
  }
}
```

> **Important:**
> 明示的なバリデーションを行うには、対象の項目に対し予めバリデーションを実施しておく必要がある。
> 詳細は [バリデーションを実行する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-execute) を参照

### 文字種バリデーションを行う

文字種バリデーションの定義方法は、 [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) と同じである。
詳細な設定方法は、 [Bean Validationの文字種バリデーションを行う](../../component/libraries/libraries-bean-validation.md#bean-validation-system-char-validator) を参照。
ただし、サロゲートペアを許容する設定は [Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) と異なるので下記を参照すること。

なお、使用するアノテーションは、 @SystemChar で、
[Bean Validation](../../component/libraries/libraries-bean-validation.md#bean-validation) とは完全修飾名が異なる(アノテーション名は同一)ので注意すること。

サロゲートペアを許容する
このバリデーションでは、デフォルトではサロゲートペアを許容しない。
（例え LiteralCharsetDef で明示的にサロゲートペアの文字を定義していても許容しない）

サロゲートペアを許容する場合は次のようにコンポーネント設定ファイルに SystemCharValidator#allowSurrogatePair を設定する必要がある。

```xml
<component name="systemCharValidator" class="nablarch.core.validation.validator.unicode.SystemCharValidator">
  <!-- サロゲートペアを許容する -->
  <property name="allowSurrogatePair" value="true"/>

  <!-- その他のプロパティは省略 -->
</component>
```

### 相関バリデーションを行う

複数の項目を使用した相関バリデーションは、Beanクラスの @ValidateFor アノテーションを設定したメソッドで実装する。
このメソッドでまずは項目ごとのバリデーションを実施し、エラーが発生しなかった場合に複数項目を使用したバリデーションを実行する。

実装例
この例では、mailAddressとconfirmMailAddressを使用した相関バリデーションを行っている。

相関バリデーションでエラーとなった場合は、ユーザに通知すべきメッセージを示すメッセージIDを明示的に ValidationContext に追加する。

```java
public class SampleForm {

  @Domain(SampleDomain.MAIL)
  @Required
  public void setMailAddress(String mailAddress) {
      this.mailAddress = mailAddress;
  }

  @Domain(SampleDomain.MAIL)
  @Required
  public void setConfirmMailAddress(String confirmMailAddress) {
      this.confirmMailAddress = confirmMailAddress;
  }

  @ValidateFor("validate")
  public static void validate(ValidationContext<SampleForm> context) {
      // mailAddressとconfirmMailAddressのバリデーションを実施
      ValidationUtil.validate(context, new String[] {"mailAddress", "confirmMailAddress"});

      // エラーが発生した場合は、相関バリデーションを実施しない
      if (!context.isValid()) {
          return;
      }

      // formオブジェクトを生成し、相関バリデーションを実施
      SampleForm form = context.createObject();
      if (!Objects.equals(form.mailAddress, form.confirmMailAddress)) {
          // mailAddressとconfirmMailAddressが一致していない場合エラー
          context.addMessage("compareMailAddress");
      }
  }
}
```

### 一括登録のようなBeanの配列を入力とする機能でバリデーションを行う

一括登録のように同一の情報を複数入力するケースがある。
このような場合には、バリデーション対象のBeanに対してネストしたBeanを定義することで対応する。

ネストしたBeanのsetterには  @ValidationTarget アノテーションを設定し、ネストしたBeanのサイズを指定する。
要素数が固定(コンパイル時に決まっている)の場合には size 属性に指定する。可変の場合には、
sizeKey 属性にサイズを持つプロパティの名前を設定する。

この例では AddressForm の情報を一括で入力できるため、 SampleForm は AddressForm を配列として保持している。
また、サイズはコンパイル時には決まっていないため、 sizeKey を使用している。

```java
public class SampleForm {
    private AddressForm[] addressForms;
    // addressFormsのサイズ
    // 画面のhiddenなどから送信すること
    private Integer addressSize;

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

public class AddressForm {
    // 省略
}
```

### ラジオボタンやリストボックスの選択値に応じてバリデーション項目を変更する

WebUtil クラスを使うことで、ラジオボタンやリストボックスなどの選択値に応じてバリデーション項目を切り替えることが出来る。

この例では、画面から送信された **form.radio** の値が **ptn1** の場合に、 item1 のみバリデーションを行う。
**ptn1** 以外の場合には、 item1 と item2 のバリデーションを行う。

```java
public class SampleForm {

    // プロパティは省略

    @ValidateFor("validate")
    public static void validate(ValidationContext<SampleForm> context) {
        if (WebUtil.containsPropertyKeyValue(context, "form.radio", "ptn1")) {
            ValidationUtil.validate(context, new String[] {"item1"});
        } else {
            ValidationUtil.validate(context, new String[] {"item1", "item2"});
        }
    }
}
```

> **Tip:**
> この例では、 WebUtil.containsPropertyKeyValue を使って、送信された値までチェックを行っているが、
> 単純にラジオボタンのチェック有無だけを調べたいのであれば WebUtil.containsPropertyKey を使う。

### 特定の項目に紐づくバリデーションエラーのメッセージを作りたい

[Bean Validationの特定の項目に紐づくバリデーションエラーのメッセージを作りたい](../../component/libraries/libraries-bean-validation.md#bean-validation-create-message-for-property) を参照。

### バリデーションエラー時のメッセージに項目名を埋め込みたい

メッセージに項目名を埋め込むには、 @PropertyName アノテーションを使用して、バリデーション対象の項目の項目名を指定する。

実装例
メッセージには、項目名を埋め込むためのパターン文字を使用する。
項目名は、必ず先頭に指定されるので項目名を埋め込む箇所には、 **{0}** と指定する。

```properties
required.message = {0}を入力してください。
```

バリデーション対象の項目に、バリデーション用のアノテーションとともに項目名を設定する @PropertyName アノテーションを設定する。

```java
public class SampleForm {

    @Domain(SampleDomain.NAME)
    @Required
    @PropertyName("名前")
    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Domain(SampleDomain.DATE)
    @PropertyName("誕生日")
    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }
}
```
生成されるメッセージ
上記実装で、 username プロパティで必須エラーが発生すると、生成されるメッセージは **「名前を入力してください。」** となる。

### 数値型への型変換

バリデーション後にBeanクラスの数値型に入力値を変換したい場合、その項目には必ず @Digits アノテーションが必要となる。
※ドメインバリデーションの場合、ドメインEnumに対して設定が必要となる。

なお、数値型へ変換するためのコンバータが [使用するバリデータとコンバータを設定する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) の手順に従い設定されていることが前提となる。

実装例
この例では、setterに指定しているが、ドメインバリデーションを使用したドメインEnumへの指定を推奨する。

```java
public class SampleForm {

    @PropertyName("年齢")
    @Digits(integer = 3)
    public void setAge(Integer age) {
        this.age = age;
    }
}
```

### データベースとの相関バリデーションを行う

データベースとの相関バリデーションは、業務アクションで行う。

業務アクションで行う理由は、[Bean Validationのデータベースとの相関バリデーション](../../component/libraries/libraries-bean-validation.md#bean-validation-database-validation) を参照。

### ウェブアプリケーションのユーザ入力値のチェックを行う

ウェブアプリケーションのユーザ入力値のチェックは [InjectForm インターセプタ](../../component/handlers/handlers-InjectForm.md#inject-form-interceptor) を使用して行う。
詳細は、 [InjectForm インターセプタ](../../component/handlers/handlers-InjectForm.md#inject-form-interceptor) を参照

## 拡張例

### プロジェクト固有のバリデータを追加したい

バリデータを追加するには、以下の手順が必要となる。

1. アノテーションの作成
2. バリデータの作成
3. 設定ファイルにバリデータの登録

以下に手順を示す。

アノテーションの作成
アノテーションは以下の条件を満たすこと。

* @Validation アノテーションを設定すること。
* @Target アノテーションで ElementType.METHOD を設定すること。
* @Retention アノテーションで RetentionPolicy.RUNTIME を設定すること。

```java
@Validation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Sample {
}
```
バリデータの作成
バリデータは、 Validator インタフェースを実装し、バリデーションロジックを実装する。

```java
public class SampleValidator implements Validator {

  public Class<? extends Annotation> getAnnotationClass() {
      return Sample.class;
  }

  public <T> boolean validate(ValidationContext<T> context,
      // 省略
  }
}
```
設定ファイルにバリデータの登録
[使用するバリデータとコンバータを設定する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) を参照。

### プロジェクト固有のコンバータを追加したい

コンバータを追加するには、以下の手順が必要となる。

1. コンバータの作成
2. 設定ファイルにコンバータの登録

以下に手順を示す。

コンバータの作成
コンバータは、 Convertor インタフェースを実装し、型変換ロジックなどを実装する。

```java
public class SampleConvertor implements Convertor {

    @Override
    public Class<?> getTargetClass() {
        return Short.class;
    }

    @Override
    public <T> boolean isConvertible(ValidationContext<T> context, String propertyName, Object propertyDisplayName,
            Object value, Annotation format) {

        boolean convertible = true;

        if (value instanceof String) {
            try {
                Short.valueOf((String) value);
            } catch (NumberFormatException e) {
                convertible = false;
            }
        } else {
            convertible = false;
        }

        if (!convertible) {
            context.addResultMessage(propertyName, "sampleconvertor.message", propertyDisplayName);
        }
        return convertible;
    }

    @Override
    public <T> Object convert(ValidationContext<T> context, String propertyName, Object value, Annotation format) {
        return Short.valueOf((String) value);
    }
}
```
設定ファイルにコンバータの登録
[使用するバリデータとコンバータを設定する](../../component/libraries/libraries-nablarch-validation.md#nablarch-validation-definition-validator-convertor) を参照。

### バリデーション対象のBeanオブジェクトの生成方法を変更したい

バリデーション対象のBeanオブジェクトの生成方法を変更するには、以下の手順が必要となる。

1. FormCreator の実装クラスの作成
2. ValidationManager.formCreator に、作成したクラスのコンポーネント定義を追加
