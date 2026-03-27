# バリデーション機能の基本的な使用方法

## Formの実装

Formは入力値の保持とバリデーションの責務を持つクラス。実装手順:
1. 入力値を受け付けるプロパティを追加
2. `Map<String, Object>` を引数に取るコンストラクタを追加し、Map から各プロパティに値を設定
3. プロパティのセッタに単項目精査アノテーションを設定（[validator_and_convertor](libraries-validation_basic_validators.md) に示すアノテーション、または :ref:`add-validation-method` で追加したアノテーションを使用）
4. `@ValidateFor` アノテーション付き static メソッド（validateFor メソッド）を実装し、`ValidationUtil.validate` で対象プロパティを指定

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`  
**クラス**: `ValidationUtil`, `ValidationContext`

```java
public class User {
    private String id;
    private String name;
    private String remarks;

    public User(Map<String, Object> params) {
        id = (String) params.get("id");
        name = (String) params.get("name");
        remarks = (String) params.get("remarks");
    }

    @PropertyName("ID")
    @Required
    @Length(min=8, max=8)
    public void setId(String id) { this.id = id; }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) { this.name = name; }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) { this.remarks = remarks; }

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("update")
    public static void validateForUpdate(ValidationContext<User> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

**クラス**: `ValidationUtil`, `ValidationContext`
**アノテーション**: `@ValidateFor`, `@PropertyName`, `@Required`, `@Length`

`@ValidateFor` アノテーションを設定したメソッド内で複数プロパティのバリデーションをハードコーディングする。バリデーション対象プロパティを指定して実行する場合は `ValidationUtil.validate(context, propsArray)` を使用する。

通常バリデーション成功後、プロパティ間を比較し、不一致の場合は `context.addResultMessage(propertyName, messageId)` でプロパティに紐付くエラーメッセージを追加する。プロパティに関連付けない場合は `context.addMessage(messageId)` を使用する。

実行方法は [validation-prop](#s4) と同様に `ValidationUtil.validateAndConvertRequest` を呼び出す。

```java
private static final String[] PASSWORD_CHANGE_PROPS
        = new String[] {"id", "prevPassword", "newPassword", "confirmPassword"};

@ValidateFor("changePassword")
public static void validateForChangePassword(ValidationContext<User> context) {
    ValidationUtil.validate(context, PASSWORD_CHANGE_PROPS);
    if (!context.isValid()) return;
    String newPassword = (String) context.getConvertedValue("newPassword");
    String confirmPassword = (String) context.getConvertedValue("confirmPassword");
    if (!newPassword.equals(confirmPassword)) {
        context.addResultMessage("newPassword", "MSG10001");
        // プロパティ非関連エラーの場合: context.addMessage("MSG10001");
    }
}
```

```java
ValidationContext result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "changePassword");
```

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, @PropertyName, @Required, @Length, @ValidateFor, Formの実装, validateFor メソッド, バリデーション, 相関バリデーション, 複数項目バリデーション, パスワード確認, addResultMessage, addMessage, User

</details>

## Actionからのバリデーションメソッドの呼び出し

HTMLフォームの入力項目名は `{プレフィクス}.{プロパティ名}` 形式（例: `user.id`, `user.name`）。この先頭の名称を「プレフィクス」と呼ぶ。

```html
<form method="post">
<input type="hidden" name="user.id" value="00000001"/>
ユーザ名: <input type="text" name="user.name"/> <br/>
備考: <input type="text" name="user.remarks"/> <br/>
<input type="submit" value="更新" />
</form>
```

> **注意**: 通常、Nablarchを使用したWebアプリケーションの開発では、`:ref:`custom_tag`` に記載したカスタムタグを使用する。以下のHTMLフォーム実装例はバリデーションの理解に集中するための例であり、実際のアプリケーション実装にそのまま使用しないこと。

`ValidationUtil.validateAndConvertRequest` の引数:
1. FormのプレフィクスString（例: `"user"`）
2. Formのクラス（例: `User.class`）
3. 入力値を保持した `Validatable` インタフェースを実装したクラス、またはMap
4. バリデーション名（`@ValidateFor` アノテーションの値と一致したメソッドが実行される。例: `"update"`）

```java
// バリデーション実行（validateForUpdateメソッドが自動的に呼び出される）
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "update");

// エラー処理: ApplicationExceptionを送出
result.abortIfInvalid();

// 正常終了: Formオブジェクト生成
User user = result.createObject();
```

- `ValidationContext#abortIfInvalid()`: バリデーション失敗時に `ApplicationException` を送出
- `ValidationContext#isValid()`: 正常/異常終了判定。任意の異常処理を行う場合に使用
- `ValidationContext#createObject()`: 正常終了時にFormオブジェクトを生成

これらの詳細については :ref:`message_management` を参照。

**アノテーション**: `@Digits`, `@NumberRange`

Webアプリケーションの文字列入力をLong・BigDecimalなどの数値型プロパティに自動変換する機能がバリデーション機構に組み込まれている。

- `@Digits(integer=N)`: 整数部の桁数を指定
- `@NumberRange(min=N, max=N)`: 数値の範囲を指定

```java
@Digits(integer=6)
@NumberRange(min=0, max=200000)
public void setAmount(BigDecimal amount) { this.amount = amount; }
```

```java
ValidationContext<Order> result = ValidationUtil.validateAndConvertRequest("form", Order.class, req, "insert");
```

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, validateAndConvertRequest, abortIfInvalid, createObject, isValid, ApplicationException, Validatable, バリデーション実行, 入力値変換, プレフィクス, カスタムタグ, BigDecimal, @Digits, @NumberRange, 型変換, 数値バリデーション, Order

</details>

## バリデーション結果のエラーメッセージ生成

:ref:`message_management` の機能を使用して、メッセージテンプレートとプロパティ表示名称から自動生成。例: 「{0}は必ず入力してください。」+「ユーザ名」→「ユーザ名は必ず入力してください。」

プロパティ表示名称は通常 `@PropertyName` アノテーションでFormに直接指定する。

> **注意**: `@PropertyName` は言語ごとに別々の表示名称を指定できないため、国際化が必要なアプリケーションでは使用不可。国際化が必要な場合は :ref:`property_display_name_internationalization` の方法を使用すること。

バリデーション条件を変えずにプロパティ表示名称だけ変更したい場合は :ref:`validation_form_inheritance_model` の方法を使用できる。

**クラス**: `nablarch.core.validation.convertor.StringConvertor`

数値型（Long、BigDecimal）プロパティへの変換時は空白が許容されず、常にトリムされる。文字列型プロパティへの変換時は `StringConvertor` の `trimPolicy` プロパティで制御する。

| 設定値 | 動作 |
|---|---|
| `trimAll` | 前後の空白をトリム |
| `noTrim` | トリムしない |

詳細は [StringConvertorの設定値](libraries-validation_basic_validators.md) の `trimPolicy` プロパティを参照。

```xml
<component class="nablarch.core.validation.convertor.StringConvertor">
  <property name="conversionFailedMessageId" value="MSG90001" />
  <property name="allowNullValue" value="${validationConvertorAllowNullValue}" />
  <!-- trimAll または noTrim -->
  <property name="trimPolicy" value="trimAll" />
</component>
```

<details>
<summary>keywords</summary>

@PropertyName, エラーメッセージ生成, message_management, property_display_name_internationalization, validation_form_inheritance_model, バリデーション結果, StringConvertor, trimPolicy, 入力値トリム, 文字列トリム, trimAll, noTrim

</details>

## Entity の使用

FormをRDBMSのテーブルと1対1に対応づけたEntity（Formの特殊形態）を使用することで下記メリットが得られる:
1. バリデーションとデータベースへの反映を容易に実装できる
2. RDBMSの定義から実装の大部分が自動生成できる

RDBMSを使用したアプリケーション実装時はできる限りEntityを使用すること。

**テーブル構造とEntityのマッピング例（Oracleデータ型）**:

| カラム名 | データ型 | 説明 |
|----------|----------|------|
| ID | CHAR(8) | ユーザを一意に特定するID（プライマリキー）|
| NAME | NVARCHAR(10) | ユーザの氏名 |
| REMARKS | NVARCHAR(100) | ユーザの補足情報 |

RDBMSのカラム型定義がEntityのバリデーションアノテーションに対応する（例: `CHAR(8)` → `@Length(min=8, max=8)`、`NVARCHAR(10)` → `@Length(max=10)`）。

**アノテーション**: `@PropertyName`, `@Required`, `@Length`, `@ValidateFor`  
**クラス**: `ValidationUtil`, `ValidationContext`

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
    public void setId(String id) { this.id = id; }

    @PropertyName("ユーザ名")
    @Required
    @Length(max=10)
    public void setName(String name) { this.name = name; }

    @PropertyName("備考")
    @Length(max=100)
    public void setRemarks(String remarks) { this.remarks = remarks; }

    private static final String[] UPDATE_PARAMS = new String[] { "id", "name", "remarks" };
    @ValidateFor("insert")
    public static void validateForUpdate(ValidationContext<UserEntity> context) {
        ValidationUtil.validate(context, UPDATE_PARAMS);
    }
}
```

Entityを使用したデータベース登録実装例（[DbAccessSupportクラス](libraries-04_Statement.md) も参照）:

```java
ValidationContext<UserEntity> result = ValidationUtil.validateAndConvertRequest("user", UserEntity.class, req, "insert");
result.abortIfInvalid();
UserEntity user = result.createObject();
ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USER");
statement.executeUpdateByObject(user);
```

バリデーション対象は `Map<String, ?>` 型。キーがString型のMap実装クラスであれば精査・変換処理が可能。NablarchのDB取得結果である `SqlRow`（`Map<String, Object>` 実装）も直接バリデーション可能。

> **注意**: デフォルトコンバータ使用時の変換可能型には制限あり。[validator_and_convertor](libraries-validation_basic_validators.md) を参照。

SqlRow使用時のポイント:
- `validateAndConvertRequest` の第1引数（プレフィックス）に `null` を指定
- DBカラム名は変換先Entity/Formのプロパティ名と一致させること（SqlRowは大文字・小文字・アンダースコアを区別しない）

```java
SqlRow row = search();
ValidationContext<UserEntity> context = ValidationUtil.validateAndConvertRequest(
        null, UserEntity.class, row, "validateUserData");
```

<details>
<summary>keywords</summary>

UserEntity, Entity, ParameterizedSqlPStatement, executeUpdateByObject, @ValidateFor, @PropertyName, @Required, @Length, ValidationUtil, ValidationContext, データベース登録, RDBMSテーブルとForm対応, Entityによるバリデーション, SqlRow, Map精査, データベース精査, validateAndConvertRequest

</details>

## バリデーション対象のプロパティ指定

全プロパティではなく特定プロパティのみをバリデーション対象にしたい場合（例: Insert時にシステム採番のプライマリキーはバリデーション不要）、`@ValidateFor` アノテーション付きのバリデーションメソッドをFormに追加することでバリデーション対象を限定できる。

ユーザ登録画面（システムでIDを採番するためIDフィールドなし）のHTMLフォーム例:

```html
<form method="POST">
ユーザ名: <input type="text" name="user.name"/> <br/>
備考: <input type="text" name="user.remarks"/> <br/>
<input type="submit" value="登録" />
</form>
```

このように `user.id` フィールドが存在しないため、`id` プロパティをバリデーション対象から除外する必要がある。

`ValidationUtil.validateWithout(context, excludedProps)`: 指定したプロパティを除いてバリデーションを実行。

**アノテーション**: `@ValidateFor`  
**クラス**: `ValidationUtil`, `ValidationContext`

```java
/** insert時にバリデーションを省略するプロパティ */
private static final String[] INSERT_SKIP_PROPS = new String[] {"id"};

@ValidateFor("insert")
public static void validateForInsert(ValidationContext<User> context) {
    // idを無視してバリデーションを実行
    ValidationUtil.validateWithout(
        context,
        INSERT_SKIP_PROPS);
}
```

Actionから `validateAndConvertRequest` の最後にバリデーション名（この例では `"insert"`）を指定することで、対応する `@ValidateFor` メソッドが実行される:

```java
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "insert");
```

**クラス**: `ValidationUtil`

Actionの実装内でプロパティに紐付くバリデーションエラーメッセージを設定する場合は `ValidationUtil.createMessageForProperty` を使用する（一般メッセージの `MessageUtil.createMessage` と区別）。:ref:`WebView_ErrorViewErrorTag` で任意の場所に表示可能。

```java
Message message = ValidationUtil.createMessageForProperty("user.loginId", "MSG00091");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ValidationUtil, validateWithout, @ValidateFor, ValidationContext, バリデーション対象プロパティ指定, プロパティ除外バリデーション, 部分バリデーション, INSERT_SKIP_PROPS, validateForInsert, createMessageForProperty, ApplicationException, プロパティメッセージ作成, MessageUtil, Message

</details>
