# バリデーション機能の基本的な使用方法

## Formの実装

Formクラスの実装手順:
1. 入力値を受け付けるプロパティを追加
2. `Map<String, Object>` を引数に取るコンストラクタを追加し、各プロパティに値を設定
3. プロパティのセッタに単項目精査アノテーションを設定（使用可能なアノテーション: [validator_and_convertor](libraries-validation_basic_validators.md) 参照、独自追加: :ref:`add-validation-method` 参照）
4. `@ValidateFor` アノテーション付きのstaticな `validateFor` メソッドを実装し、`ValidationUtil.validate` で対象プロパティを指定

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

複数プロパティの相関バリデーションは、[validation-prop](#s4) と同様に `@ValidateFor` アノテーションを設定したメソッド内でバリデーション処理をハードコーディングすることで実現する。

`ValidationUtil.validate(context, String[])` でバリデーション対象プロパティを指定して実行できる。

通常バリデーション後の追加エラーは以下のメソッドで設定する:
- `context.addResultMessage(String propertyName, String messageId)` — 特定プロパティに紐付けてエラーメッセージを追加
- `context.addMessage(String messageId)` — プロパティに紐付けないエラーメッセージを追加

**クラス**: `ValidationContext`, `ValidationUtil`  
**アノテーション**: `@ValidateFor`

```java
private static final String[] PASSWORD_CHANGE_PROPS
        = new String[] {"id", "prevPassword", "newPassword", "confirmPassword"};

@ValidateFor("changePassword")
public static void validateForChangePassword(ValidationContext<User> context) {
    ValidationUtil.validate(context, PASSWORD_CHANGE_PROPS);
    if (!context.isValid()) { return; }
    String newPassword = (String) context.getConvertedValue("newPassword");
    String confirmPassword = (String) context.getConvertedValue("confirmPassword");
    if (!newPassword.equals(confirmPassword)) {
        context.addResultMessage("newPassword", "MSG10001");
    }
}
```

バリデーション実行:
```java
ValidationContext result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "changePassword");
```

> **注意**: プロパティに紐付けないエラーメッセージを追加する場合は `context.addResultMessage` の代わりに `context.addMessage("MSG10001")` を使用する。

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, @ValidateFor, @PropertyName, @Required, @Length, validate, validateForUpdate, Formの実装, 入力値変換, User, 相関バリデーション, 複数項目バリデーション, addResultMessage, addMessage

</details>

## Actionからのバリデーションメソッドの呼び出し

HTMLフォームの入力項目名はプレフィクス + `.`（ピリオド）+ プロパティ名で設定（例: `user.id`、`user.name`）。このプレフィクスを `validateAndConvertRequest` の第1引数に指定する。

> **注意**: 通常のWebアプリケーション開発では :ref:`custom_tag` のカスタムタグを使用する。

`ValidationUtil.validateAndConvertRequest` を呼び出すと、Form に追加した `validateFor` メソッドのうち `@ValidateFor` アノテーションの値が第4引数（バリデーション名）と一致するメソッドが自動的に呼び出され、バリデーション処理が実行される（例: `@ValidateFor("update")` が付いた `validateForUpdate` メソッド）。

**`ValidationUtil.validateAndConvertRequest` の引数**:
1. 入力値のFormに対応するプレフィクス（例: `"user"`）
2. Form クラス（例: `User.class`）
3. 入力値を保持した `Validatable` インタフェース実装クラスまたは `Map`
4. バリデーション名（`@ValidateFor` アノテーションの値と一致する文字列）—この値と一致する `@ValidateFor` が付いた `validateFor` メソッドがバリデーション時に自動実行される

戻り値 `ValidationContext`:
- 正常終了: `ValidationContext#createObject()` で Form オブジェクトを生成
- 異常終了: `ValidationContext#getMessages()` でエラーメッセージ取得。`ApplicationException` のコンストラクタに直接渡せる。詳細は :ref:`message_management` 参照。

```java
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "update");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

User user = result.createObject();
```

なし

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, ApplicationException, validateAndConvertRequest, createObject, getMessages, isValid, Validatable, バリデーション実行, プレフィクス, 値変換, convert_property

</details>

## バリデーション結果のエラーメッセージ生成

エラーメッセージは :ref:`message_management` の機能を使い、メッセージテンプレートとプロパティ表示名称から自動生成される。例: 「{0}は必ず入力してください。」+「ユーザ名」→「ユーザ名は必ず入力してください。」

プロパティ表示名称の指定方法:
- `@PropertyName` アノテーション: 最も簡単だが国際化不可。国際化が必要な場合は :ref:`property_display_name_internationalization` を使用
- 画面に合わせて表示名称のみ変更する場合は :ref:`validation_form_inheritance_model` を使用

FormプロパティにLong、BigDecimalなどの数値型を持てる。文字列→数値型への変換はバリデーション機構が自動実行する。

数値型プロパティのセッタには `@Digits` でフォーマット（整数部桁数など）を設定し、桁数以外の範囲条件は `@NumberRange` で設定する。

**クラス**: `Order`  
**アノテーション**: `@Digits`, `@NumberRange`, `@PropertyName`, `@Required`

```java
@PropertyName("合計金額")
@Required
@Digits(integer=6)            // 整数部6桁
@NumberRange(min=0, max=200000)
public void setAmount(BigDecimal amount) {
    this.amount = amount;
}
```

バリデーション実行（文字列→BigDecimalへの型変換も同時に実行される）:
```java
ValidationContext<Order> result = ValidationUtil.validateAndConvertRequest("form", Order.class, req, "insert");
```

<details>
<summary>keywords</summary>

@PropertyName, エラーメッセージ生成, message_management, property_display_name_internationalization, validation_form_inheritance_model, ValidationUtil, @Digits, @NumberRange, BigDecimal, 数値型変換, 型変換, Order, @Required

</details>

## Entity の使用

RDBMSのテーブルと1対1に対応するFormをEntityと呼ぶ。使用メリット:
1. バリデーションとデータベースへの反映を容易に実装できる
2. RDBMSの定義から実装の大部分が自動生成できる

RDBMSを使用するアプリケーションではできる限りEntityを使用して実装すること。

Formプロパティの型によりトリム動作が異なる:
- **数値型**（Long、BigDecimalなど）: 空白が許容されないため入力値を必ずトリム
- **文字列型**: `trimPolicy` 設定によりトリムの要否を選択可能。設定値は `"trimAll"` または `"noTrim"`

**クラス**: `nablarch.core.validation.convertor.StringConvertor`

`trimPolicy` の詳細は [StringConvertorの設定値](libraries-validation_basic_validators.md) を参照。

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

Entity使用, テーブル対応Form, データベース登録メリット, RDBMS, StringConvertor, trimPolicy, 入力値トリム, trimAll, noTrim, nablarch.core.validation.convertor.StringConvertor, conversionFailedMessageId, allowNullValue

</details>

## テーブル構造とEntity

USERテーブル例（Oracleデータ型）:

| カラム名 | データ型 | 説明 |
|---|---|---|
| ID | CHAR(8) | ユーザを一意に特定するID（プライマリキー） |
| NAME | NVARCHAR(10) | ユーザの氏名 |
| REMARKS | NVARCHAR(100) | ユーザの補足情報 |

Entityの実装例:

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

Entityを使ったDB登録処理:

```java
ValidationContext<UserEntity> result = ValidationUtil.validateAndConvertRequest("user", UserEntity.class, req, "insert");

if (!result.isValid()) {
    throw new ApplicationException(result.getMessages());
}

UserEntity user = result.createObject();

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USER");
statement.executeUpdateByObject(user);
```

> **注意**: データベースアクセス実装の詳細は [DbAccessSupportクラス](libraries-04_Statement.md) 参照。

精査・変換可能なオブジェクトは `Map<String, ?>` （キーがStringのMap実装クラス全般）である。

NablarchのDBアクセス機能が返す `SqlRow` は `Map<String, Object>` の実装クラスであるため、特別な変換なしにバリデーション入力として使用できる（SqlRowの詳細は [データベースアクセス機能](libraries-04_DbAccessSpec.md) を参照）。

> **注意**: デフォルトのコンバータを使用した場合、変換可能な型には制限がある。変換可能な型は [validator_and_convertor](libraries-validation_basic_validators.md) を参照すること。

<details>
<summary>keywords</summary>

UserEntity, ParameterizedSqlPStatement, @ValidateFor, @PropertyName, @Required, @Length, executeUpdateByObject, ValidationUtil, ValidationContext, isValid, データベース登録, validateAndConvertRequest, テーブル構造, SqlRow, Mapバリデーション, Map<String, ?>, 精査, バリデーション入力型

</details>

## バリデーション対象のプロパティ指定

データ更新以外の目的（例: 登録画面でプライマリキーが自動採番のためバリデーション不要）では、Form の全プロパティにバリデーションしないケースが多い。`@ValidateFor` アノテーション付きのバリデーションメソッドを複数用意することでバリデーション対象プロパティを限定できる。

- `ValidationUtil.validateWithout(context, skipProps)`: 引数 `skipProps` に指定したプロパティを除外してバリデーションを実行
- `@ValidateFor` アノテーションの値がバリデーション名。`validateAndConvertRequest` の最後の引数と一致したメソッドが実行される

例: 登録画面（ID自動採番）でidを除外:

```java
public class User {
    private String id;
    private String name;
    private String remarks;

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

    /* getter、コンストラクタは省略 */

    private static final String[] INSERT_SKIP_PROPS = new String[] {"id"};

    @ValidateFor("insert")
    public static void validateForInsert(ValidationContext<User> context) {
        ValidationUtil.validateWithout(context, INSERT_SKIP_PROPS);
    }
}
```

バリデーション名 `"insert"` を指定して呼び出すことで `validateForInsert` が実行され、`id` を除いたプロパティのみバリデーションされる:

```java
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "insert");
```

`SqlRow` をバリデーション入力とする場合、`ValidationUtil.validateAndConvertRequest` の第一引数（プレフィックス）は `null` を指定する。DBカラム名は変換先オブジェクトのプロパティ名と一致させること（SqlRowは大文字・小文字・アンダースコアを区別しない）。

**クラス**: `UserEntity`

```java
SqlRow row = search();
ValidationContext<UserEntity> context = ValidationUtil.validateAndConvertRequest(
        null, UserEntity.class, row, "validateUserData");
```

<details>
<summary>keywords</summary>

ValidationUtil, ValidationContext, @ValidateFor, validateWithout, validateAndConvertRequest, validateForInsert, バリデーション対象プロパティ, プロパティ除外, バリデーション名, INSERT_SKIP_PROPS, SqlRow, DBデータバリデーション, SqlRowバリデーション, UserEntity

</details>

## 

なし

<details>
<summary>keywords</summary>

バリデーションメッセージ, validation-message-creation

</details>

## プロパティに紐付くメッセージの作成

バリデーション時に検出できないエラーに対するエラーメッセージをActionから直接設定できる。一般的なメッセージには `MessageUtil.createMessage` を使用するが、:ref:`WebView_ErrorViewErrorTag` でプロパティに紐付けて表示する場合は `ValidationUtil.createMessageForProperty` を使用する。

**クラス**: `ValidationUtil`, `MessageUtil`, `Message`, `ApplicationException`

```java
Message message = ValidationUtil.createMessageForProperty("user.loginId", "MSG00091");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ValidationUtil, createMessageForProperty, MessageUtil, ApplicationException, プロパティエラーメッセージ, Message

</details>
