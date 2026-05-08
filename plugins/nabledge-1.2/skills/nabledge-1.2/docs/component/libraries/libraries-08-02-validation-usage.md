# バリデーション機能の基本的な使用方法

## バリデーションの実行と入力値の変換

本機能は、 Form にアノテーションを設定するだけの簡易な実装で使用できる。

本機能を使用して入力値のバリデーションと Form の生成に必要な実装は下記の2つである。

1. Form の実装
2. Action からのバリデーションメソッドの呼び出し。

以下に最もシンプルな「単項目のバリデーション」のみを行う例で、それぞれについて説明する。

### Formの実装

Form は、外部からの入力値の保持とバリデーションの責務を持つクラスである。
この目的を果たすためには、 Form に下記手順の実装が必要となる。

1. 入力値を受け付けるプロパティを追加する。
2. Form に Map<String, Object> を引数に取るコンストラクタを追加する。
  コンストラクタ内では、単に引数の Map から各プロパティに値を設定する実装を行う。
3. プロパティのセッタに、プロパティに対する単項目精査の条件を表すアノテーションを設定する。
  ここで使用できるアノテーションの種類は、フレームワークで [基本バリデータ・コンバータ](../../component/libraries/libraries-validation-basic-validators.md#基本バリデータコンバータ)
  に示すアノテーションが Nablarch で提供されているほか、 [バリデータの追加・変更](../../component/libraries/libraries-08-05-custom-validator.md#バリデータの追加変更) に示す方法で任意に追加可能である。
4. Form にバリデーション処理の内容を表す static メソッド(以降 validateFor メソッドと呼ぶ)を実装する。
  validateFor メソッドには、基本的に ValidationUtil.validate メソッドを呼び出し、
  「どの項目に対してバリデーションを行うか」を指定する。

上記の1～4を行った Form の一例を以下に示す。
この例は、入力値として id、 name、 remarks を取ることを前提としている。

```java
public class User {

    // 手順1に対応するプロパティ
    // (プロパティの getter はここでの説明は不要であると考え、省略している。)
    private String id;

    private String name;

    private String remarks;

    // 手順2に対応するコンストラクタ。
    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    // 手順3に対応するアノテーションの設定
    // この例では、 IDに、「必須」「文字列長8固定」のバリデーション条件を指定。
    @PropertyName("ID")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    // getterは省略

    // 手順4に対応するvalidateFor メソッドの実装
    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("update")
    public static void validateForUpdate(ValidationContext<User> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

### Action からのバリデーションメソッドの呼び出し

上記の Form に対して Action からバリデーションと Form の生成を行うには、下記の実装が必要となる。

1. ValidationUtil.validateAndConvertRequest メソッドを呼び出し、バリデーションを実行する。
2. バリデーション結果がエラーの場合、エラー処理を行う。
3. バリデーション結果が正常終了の場合、Formの生成を行う。

まず、HTML フォームから上記 Form の項目を入力として、更新を行う場合、HTMLのフォームは下記のようになる。

```html
<form method="post" >
<input type="hidden" name="user.id" value="00000001"/>
ユーザ名: <input type="text" name="user.name"/> <br/>
備考: <input type="text" name="user.remarks"/> <br/>
<input type="submit" value="更新" />
</form>
```

> **Note:**
> 通常、Nablarchを使用したWebアプリケーションの開発では、 [JSPカスタムタグライブラリの使用方法](../../component/libraries/libraries-07-CustomTag.md#jspカスタムタグライブラリの使用方法) に記載したカスタムタグを使用する。

> 上記実装はあくまでバリデーションの理解に集中するための実装例とし、実際のアプリケーション実装を
> そのまま行わないよう注意すること。

このように、HTMLフォームの入力項目名には、 "user.id"、 "user.name"、 "user.remarks" のように
Form のプロパティの前に "." (ピリオド) で区切って同じ名称を設定する。
この名称を "プレフィクス" と呼ぶ。

HTMLフォームから送信されたリクエストから Form を生成する Action 内の処理は、下記のように実装する。

```java
// 手順1 バリデーションの実行。
// 入力値のMapであるparamsに対してバリデーションと Form のプロパティの型に合わせた変換を実行
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "update");

// 手順2 バリデーション結果のエラー処理を行う。
// バリデーション結果が異常終了であった場合、バリデーション例外を投げる。
if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

// 手順3 Form (ここではUserクラス)の生成を行う。
User user = result.createObject();
```

上記の実装で使用している ValidationUtil.validateAndConvertRequest メソッドを呼び出すことで、
Form に追加した validateFor メソッド(この例では User#validateForUpdate メソッド)が呼び出され、
精査処理が本機能により自動的に行われる。

ValidationUtil.validateAndConvertRequest メソッドの引数を以下に示す。

1. 入力値の Form に対応するプレフィクス(上記例では"user")
2. Form のクラス (上記例では User)
3. 入力値を保持した Validatable インタフェースを実装したクラス、または Map 。
4. validateFor メソッドの指定。
  @ValidateFor アノテーションが指定された validateFor のうち、ここで指定した文字列と
  @ValidateFor アノテーションの値(上記例では "update")が一致したメソッドがバリデーション時に実行される。

ValidationUtil.validateAndConvertRequest メソッドは、バリデーション実行結果を持つ
ValidationContext クラスを戻り値に返す。
ValidationContext クラスは、精査結果がエラーであった場合にはエラーメッセージ、正常終了であった場合は Form
の生成に必要なパラメータを内部に持つ。

正常終了であった場合は、ValidationContext#createObject メソッドで Form のオブジェクトが生成できる。

反対に異常終了であった場合は、 ValidationContext#getMessages メソッドでエラー内容を表すメッセージが取得できる。
このメッセージは処理結果のメッセージの通知に使用する ApplicationException クラスのコンストラクタに直接渡すことができる。
これらの詳細については、 [メッセージ管理](../../component/libraries/libraries-07-Message.md#メッセージ管理) を参照のこと。

### バリデーション結果のエラーメッセージ生成

上記実装例の手順2では、エラーメッセージを ApplicationException に詰めて送出している。
ここで生成しているアノテーションで指定した精査に対するエラーメッセージは、 [メッセージ管理](../../component/libraries/libraries-07-Message.md#メッセージ管理) に記載した機能を使用して、
本機能の内部でメッセージのテンプレートと、プロパティの表示名称から自動的に作成する。

例えば、必須入力のエラーメッセージは、「{0}は必ず入力してください。」というメッセージと、「ユーザ名」という表示名称から「ユーザ名は必ず入力してください。」というエラーメッセージを作成する。
プロパティの表示名称は、通常 @PropertyName アノテーションで Form に直接指定する。

> **Note:**
> @PropertyName でプロパティの表示名称を指定する方法は最も簡単なプロパティ名の指定方法である。

> ただしこの方法は、言語ごとに別々の表示名称を指定できないため、国際化が必要なアプリケーションでは使用できない。
> 国際化が必要な場合は、 [国際化したプロパティの表示名称の取得方法](../../component/libraries/libraries-08-04-validation-form-inheritance.md#国際化したプロパティの表示名称の取得方法) に記述する方法を使用すること。

> また、プロパティの表示名称を画面に合わせて変更したい場合は、 [Form の継承とバリデーション条件の継承](../../component/libraries/libraries-08-04-validation-form-inheritance.md#form-の継承とバリデーション条件の継承) に記述した方法でバリデーション条件を変えずにプロパティの表示名称を変更できる

## Entity の使用

[概要](../../component/libraries/libraries-08-Validation.md#概要) で述べたとおり、 Form をRDBMS上のテーブルと1対1に対応づけることにより、
下記2つのメリットが得られる。

1. バリデーションとデータベースへの反映を容易に実装できる。
2. RDBMS の定義から、実装の大部分が自動生成できる。

以下の説明のため、ここでこの Entity を使用した際に得られる上記メリットのうち、1について詳細に説明する。
なお、上記メリット2については自明であるため、ここでは説明を割愛する。

### テーブル構造とEntity

ここでは下記カラムを持つ USER テーブルを例に説明する。

> **Note:**
> ここではテーブルを Oracle のデータ型で説明する。

| カラム名 | データ型 | 説明 |
|---|---|---|
| ID | CHAR(8) | ユーザを一意に特定するID プライマリキー |
| NAME | NVARCHAR(10) | ユーザの氏名 |
| REMARKS | NVARCHAR(100) | ユーザの補足情報 |

上記テーブルに対応する Entity は以下のように実装する。

```java
public class UserEntity {

    private String id;

    private String name;

    private String remarks;

    public UserEntity(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    @PropertyName("ID")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    // getterは省略

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("insert")
    public static void validateForUpdate(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }

}
```

上記のように Entity を実装しておくことで、データベースに Entity を登録する処理を下記のように非常に単純に記述できる。

```java
// USER テーブルにデータを登録する実装例。
ValidationContext<UserEntity> result = ValidationUtil.validateAndConvertRequest("user", UserEntity.class, req, "insert");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

UserEntity user = result.createObject();

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USER");
statement.executeUpdateByObject(user);
```

> **Note:**
> 上記例のデータベースアクセス実装部分の詳細は、 [DbAccessSupportクラス](../../component/libraries/libraries-04-Statement.md#nablarchcoredbstatementパッケージ) を参照のこと。

このような利点があるため、RDBMSを使用したアプリケーションの実装時はできる限り
Form の特殊形態である Entity を使用して実装するよう考慮すべきである。

## バリデーション対象のプロパティ指定

上記までの説明では、全てデータ更新を行う画面を例にしていたため、バリデーションは生成対象の Form の全プロパティに対して実行していた。
しかし、データベースへデータを Insert する画面では、プライマリキーとなるプロパティは自動採番であることが多い。
この場合、プライマリキーとなるプロパティは画面入力されないため、バリデーションの対象外となる。

このように、データの更新以外の目的でバリデーションを行う場合、実際のアプリケーションでは多くの場合 Form の全プロパティに対して
バリデーションを行なわない。

このような場合、 @ValidateFor アノテーションを使用した任意のバリデーションメソッドを Form に用意することで、
バリデーション対象のプロパティを限定できる。

下記のように、ユーザ登録画面(一般的に、登録画面ではシステムで採番するIDは指定しない)の場合を例に取って使用方法を説明する。

```html
<form method="POST">
ユーザ名: <input type="text" name="user.name"/> <br/>
備考: <input type="text" name="user.remarks"/> <br/>
<input type="submit" value="登録" />
</form>
```

このような画面のバリデーションを行う場合、バリデーションを行うメソッドを Form に作成する。
バリデーションを行うメソッドには、@ValidateForアノテーションを設定する。
@ValidateFor アノテーションの値には、バリデーションのパターンを表す名称を設定する。
この名称をバリデーション名と呼ぶ。

@ValidateFor アノテーションを設定したメソッドは、バリデーション結果を保持する ValidationContext を引数に持つ必要がある。
メソッド内では、引数の ValidationContext に対してバリデーション結果を追加する。
また、このメソッド内で ValidationUtil クラスの validateWithout メソッドを使用することで特定のプロパティを除いてバリデーションを行なえる。

以下に上記の画面に対応するバリデーション処理を追加した User Form の例を示す。
この例では、 ValidationUtil クラスの validateWithout メソッドの引数に "id" を指定することで、 id プロパティを除いたバリデーションが行なわれる。

```java
public class User {
    private String id;
    private String name;
    private String remarks;

    @PropertyName("ID")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    /* getter,コンストラクタは省略 */

    /** insert時にバリデーションを省略するプロパティ */
    private static final String[] INSERT_SKIP_PROPS = new String[] {"id"};

    @ValidateFor("insert")
    public static void validateForInsert(ValidationContext<User> context) {
        // idを無視してバリデーションを実行
        ValidationUtil.validateWithout(
            context,
            INSERT_SKIP_PROPS);
    }
}
```

上記のように Form を作成した上で、下記のように ValidationUtil クラスの validateAndConvertRequest メソッドの最後に
バリデーション名(この例の場合、 "insert" )を指定することで、 User  にある @ValidateFor で付けられた
validateForInsertメソッドが実行され、 id を除いたプロパティのみを対象としてバリデーションが
実行される。

```java
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "insert");
```

## 1つのForm内の複数項目にまたがる入力チェック

ユーザのパスワードとパスワードの確認入力のように、複数のプロパティを比較したバリデーションが必要な場合などには、
Form に関連する任意のバリデーション処理が必要となる。
このようなバリデーションは [バリデーション対象のプロパティ指定](../../component/libraries/libraries-08-02-validation-usage.md#バリデーション対象のプロパティ指定) と同様に @ValidateFor アノテーションを設定したメソッド内で
バリデーションの処理をハードコーディングすることで実現できる。

下記に示すユーザのパスワード変更のHTMLフォームを例に取って使用方法を説明する。

```html
<form method="POST">
<input type="hidden" name="user.id" value="00000001"/>
旧パスワード: <input type="password" name="user.prevPassword"/> <br/>
新パスワード: <input type="password" name="user.newPassword"/> <br/>
新パスワード(確認): <input type="password" name="user.confirmPassword"/> <br/>
<input type="submit" value="変更" />
</form>
```

ユーザのパスワードと新パスワード(確認)のバリデーションを行う Form は下記のようになる。
この例でも、 User に対するバリデーションを [バリデーション対象のプロパティ指定](../../component/libraries/libraries-08-02-validation-usage.md#バリデーション対象のプロパティ指定) と同様に行なっている。
(ただし、 [バリデーション対象のプロパティ指定](../../component/libraries/libraries-08-02-validation-usage.md#バリデーション対象のプロパティ指定) の例と異なり、ここではバリデーション対象とするプロパティを
指定する ValidationUtil クラスの validate メソッドを使用している。)

通常のバリデーションの実行後、新パスワードと確認パスワードが異なった場合には ValidationContext クラスの addResultMessage メソッドで
ValidationContextにエラーメッセージを追加する。

```java
public class User {
    private String id;
    private String name;
    private String remarks;
    private String prevPassword;
    private String newPassword;
    private String confirmPassword;

    @PropertyName("ID")
    @Required
    @Length(min=6, max=10)
    public void setId(String id) {
        this.id = id;
    }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) {
        this.name = name;
    }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    @PropertyName("旧パスワード")
    @Required
    @Length(min=8, max=16)
    public void setPrevPassword(String prevPassword) {
        this.prevPassword = prevPassword;
    }

    @PropertyName("新パスワード")
    @Required
    @Length(min=8, max=16)
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    @PropertyName("新パスワード(確認)")
    @Required
    @Length(min=8, max=16)
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    // getter、コンストラクタは省略

    /** password更新時にバリデーションするプロパティ */
    private static final String[] PASSWORD_CHANGE_PROPS
            = new String[] {"id", "prevPassword", "newPassword", "confirmPassword"};

    @ValidateFor("changePassword")
    public static void validateForChangePassword(ValidationContext<User> context) {
        // idを無視してバリデーションを実行
        ValidationUtil.validate(
            context,
            PASSWORD_CHANGE_PROPS);

        if (!context.isValid()) {
            return;
        }

        String newPassword = (String) context.getConvertedValue("newPassword");
        String confirmPassword = (String) context.getConvertedValue("confirmPassword");
        if (!newPassword.equals(confirmPassword)) {
            // 新パスワードと確認パスワードが異なるエラーメッセージを追加
            context.addResultMessage("newPassword", "MSG10001");
        }
    }

    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
        prevPassword = (String) params.get("prevPassword");
        newPassword = (String) params.get("newPassword");
        confirmPassword = (String) params.get("confirmPassword");
    }

}
```

> **Note:**
> 上記の実装例は、エラーメッセージを newPassword と関連付けたい場合の実装例である。

> どのプロパティにも関連付けられないエラーメッセージを追加する場合、下記実装例のように
> addMessage メソッドでエラーメッセージの追加を行う。

> ```java
> if (!newPassword.equals(confirmPassword)) {
>     // 新パスワードと確認パスワードが異なるエラーメッセージを追加
>     context.addMessage("MSG10001");
> }
> ```

validateForChangePassword メソッドに記述されたバリデーション処理は、下記のように
ValidationUtil.validateAndConvertRequest を呼び出すことで実行される。
この呼び出し方法は、 [バリデーション対象のプロパティ指定](../../component/libraries/libraries-08-02-validation-usage.md#バリデーション対象のプロパティ指定) と同様である。

```java
ValidationContext result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "changePassword");
```

## 値の変換

Form のプロパティには、 Long や BigDecimal といった、ビジネスロジックで頻繁に登場するデータ型を持つことができる。
しかしWebアプリケーションでは、システム外部からの入力は基本的に文字列のみからなる。
このため、 Form のプロパティに値を設定するためには、文字列から Form のプロパティの型に
データ型を変換する必要がある。

このようなデータ型の変換は、バリデーションの機構の中で自動的に実行される。
例えば、注文データをデータベースに格納する場合、下記のようにBigDecimal型のプロパティを持つ
Form を作成する。

```java
    public class Order {

        private String id;

        private BigDecimal amount;

        public Order(Map<String, Object> params) {
            id = (String) params.get("id");
            amount = (BigDecimal) params.get("amount");
        }

        @PropertyName("ID")
        @Required
        @Length(min=8,max=8)
        public void setId(String id) {
            this.id = id;
        }

        @PropertyName("合計金額")
        // 数値型のプロパティ
        @Required
        // 整数部の桁数6桁
        @Digits(integer=6)
        // 0以上200000以下の指定
        @NumberRange(min=0, max=200000)
        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        /** password更新時にバリデーションするプロパティ */
        private static final String[] INSERT_PROPS
                = new String[] {"id", "amount"};

        @ValidateFor("insert")
        public static void validateForInsert(ValidationContext<Order> context) {
            ValidationUtil.validate(context, INSERT_PROPS);
        }

    // getterは省略
}
```

上記例のように、 BigDecimal 型のプロパティのセッタには、プロパティのフォーマットを表す @Digits アノテーションを
設定する。この例では、 @Digits アノテーションで整数部の桁数をデータベースに合わせて6桁であることを設定している。
また、データの桁数以外の条件を設定する必要がある場合、 @NumberRange アノテーションを使用して数値の範囲を指定できる。

このようにアノテーションを設定することで、数値をプロパティに持つ Form も文字列のプロパティのみを持つ Form と
同様に、下記のようにバリデーションを実行できる。

```java
ValidationContext<Order> result = ValidationUtil.validateAndConvertRequest("form", Order.class, req, "insert");
```

## 入力値のトリム

Web アプリケーションなどでは、入力値となる文字列の前後に空白が含まれる可能性がある。
そのような入力値をForm のプロパティに変換する前にトリムを行なう機能を提供する。

Formのプロパティの型によって、以下のとおりトリムの動作が異なる。

* 入力値をLong や BigDecimal といった数値型のForm のプロパティに変換する場合は、空白が許容されないので、必ず入力値に対してトリムが行われる。
* 入力値を文字列型のForm のプロパティに変換する場合は、設定によりトリムの要否を選択できる。

文字列型のForm のプロパティに変換する際に、入力値のトリムを行う場合の設定例を以下に示す。設定の詳細については [StringConvertorの設定値](../../component/libraries/libraries-validation-basic-validators.md#nablarchcorevalidationconvertorstringconvertor) の trimPolicy プロパティの説明を参照すること。

```xml
<component class="nablarch.core.validation.convertor.StringConvertor">
  <property name="conversionFailedMessageId" value="MSG90001" />
  <property name="allowNullValue" value="${validationConvertorAllowNullValue}" />
  <!-- トリムのポリシーを設定する。 設定可能な値は "trimAll" "noTrim" のいずれか -->
  <property name="trimPolicy" value="trimAll" />
  <property name="extendedStringConvertors">
    <list>
        <component class="nablarch.common.date.YYYYMMDDConvertor">
            <property name="parseFailedMessageId" value="MSG90003" />
        </component>
    </list>
  </property>
</component>
```

### 様々なMapオブジェクトの精査と変換

本機能で精査、変換可能なオブジェクトは、Map<String, ?>となっている。
このため、キー値がStringであるMap実装クラスであれば、精査と変換処理を行うことが可能である。

例えば、Nablarchデータベースアクセス機能を使用してデータベースからデータを取得した際に返却されるオブジェクトは、
Mapの実装クラスのSqlRow(総称型は<String, Object>)となっている。
このため、データベースから取得したレコードを精査する必要（要件）が出てきた場合であっても、
本機能を使用することにより精査処理を実現することが可能となっている。
（SqlRowの詳細は、 [データベースアクセス機能](../../component/libraries/libraries-04-DbAccessSpec.md#概要) を参照）

※デフォルトで提供されるコンバータを使用した場合、変換可能なオブジェクト型には制限があるため、
変換可能なオブジェクト型は [基本バリデータ・コンバータ](../../component/libraries/libraries-validation-basic-validators.md#基本バリデータコンバータ) を参照すること。

#### SqlRowをインプットとして精査を行う例

以下にSqlRowをインプットとして精査を行う例を示す。
なお、EntityやForm等の実装例は、本章以前に解説を行っているため省略する。

```java
// ************************************************************************
// データベースからデータを取得する。
// SqlRowは、Map(総称型は<String, Object>)のため、特に変換を行わずに精査を行うことが出来る。
// データベースから取得時のカラム名は変換先オブジェクト(EntityやForm)のプロパティ名と一致させること。
// (SqlRowは大文字、小文字、アンダースコアの区別は行わないため、データベース取得時のカラム名に
//  アンダースコアを含めることは問題ない。)
// ************************************************************************
SqlRow row = search();

// ************************************************************************
// SqlRowをインプットとツシテ精査を実行する。
// プレフィックス(第一引数)は、nullを指定する。
// ************************************************************************
ValidationContext<UserEntity> context = ValidationUtil.validateAndConvertRequest(
        null, UserEntity.class, row, "validateUserData");

// 以降の実装は、画面オンライン処理と同じため省略する。
```

## プロパティに紐付くメッセージの作成

アプリケーションでは、バリデーションの実行時にチェックできないエラーが存在する。

これらエラーに対するエラーメッセージは、 [errorタグ](../../component/libraries/libraries-07-DisplayTag.md#errorタグ)
を使用して任意の場所に表示したいケースがある。

このようなケースでは、 Action の実装内から直接バリデーション結果の
エラーメッセージを設定する機能を使用する。
この機能を使用する際は、通常 MessageUtil.createMessage メソッドを使用するが、
プロパティに紐付くメッセージを作成する場合は ValidationUtil.createMessageForProperty メソッドを使用する。

以下に Action の実装例を示す。

```java
// user.loginId プロパティのエラーメッセージを設定する。
Message message = ValidationUtil.createMessageForProperty("user.loginId", "MSG00091");

throw new ApplicationException(message);
```
