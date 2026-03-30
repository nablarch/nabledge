# バリデーション機能の基本的な使用方法

## Formの実装

## Formの実装手順

1. 入力値を受け付けるプロパティを追加
2. `Map<String, Object>` を引数に取るコンストラクタを追加し、Mapから各プロパティに値を設定
3. プロパティのセッタに、プロパティに対する**単項目精査**の条件を表すアノテーションを設定（使用可能なアノテーション: [validator_and_convertor](libraries-validation_basic_validators.md)、カスタム追加: :ref:`add-validation-method`）
4. `@ValidateFor` アノテーションを付けたバリデーション `static` メソッド（validateForメソッド）を実装し、`ValidationUtil.validate` でバリデーション対象プロパティを指定

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

複数のプロパティを比較するバリデーション（例: パスワードと確認パスワードの一致チェック）は、`@ValidateFor` アノテーションを設定したメソッド内でハードコーディングして実現する。

`ValidationUtil.validate(context, String[])` で特定プロパティのみを対象にバリデーションを実行できる。

バリデーション後のエラーメッセージ追加:
- プロパティに紐付ける場合: `context.addResultMessage("propertyName", "msgId")`
- プロパティに紐付けない場合: `context.addMessage("msgId")`

```java
private static final String[] PASSWORD_CHANGE_PROPS
        = new String[] {"id", "prevPassword", "newPassword", "confirmPassword"};

@ValidateFor("changePassword")
public static void validateForChangePassword(ValidationContext<User> context) {
    ValidationUtil.validate(context, PASSWORD_CHANGE_PROPS);
    if (!context.isValid()) {
        return;
    }
    String newPassword = (String) context.getConvertedValue("newPassword");
    String confirmPassword = (String) context.getConvertedValue("confirmPassword");
    if (!newPassword.equals(confirmPassword)) {
        context.addResultMessage("newPassword", "MSG10001");
    }
}
```

[validation-prop](#s4) と同様に `ValidationUtil.validateAndConvertRequest` で実行する。

```java
ValidationContext result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "changePassword");
```

<details>
<summary>keywords</summary>

@Required, @Length, @PropertyName, @ValidateFor, ValidationUtil, ValidationContext, validate, バリデーション実装, Formクラス, 単項目精査, 入力値変換, Map, コンストラクタ, addResultMessage, addMessage, 相関バリデーション, 複数項目バリデーション, getConvertedValue

</details>

## ActionからのバリデーションメソッドのAction呼び出し

HTMLフォームの入力項目名には `"user.id"` のようにFormのプロパティ名に `"."` (ピリオド) で区切ったプレフィクスを付ける。

> **注意**: 実際のNablarchウェブアプリケーション開発では :ref:`custom_tag` のカスタムタグを使用すること。HTMLフォームの直接実装はバリデーション理解のための参考例であり、実際のアプリケーション実装としては使用しないこと。

`ValidationUtil.validateAndConvertRequest` を呼び出すと、Formの `@ValidateFor` 付きメソッドが自動的に実行される。

引数：
1. プレフィクス（例: `"user"`）
2. FormのClass（例: `User.class`）
3. `Validatable` 実装クラスまたはMap
4. バリデーション名（`@ValidateFor` の値と一致するメソッドが実行される。例: `"update"`）

戻り値 `ValidationContext`：
- 正常終了：`createObject()` でFormオブジェクト生成
- 異常終了：`abortIfInvalid()` で `ApplicationException` 送出
- 異常終了判定：`isValid()` で判定し任意処理を実装可能

詳細: :ref:`message_management`

```java
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "update");
result.abortIfInvalid();
User user = result.createObject();
```

FormのプロパティはLong、BigDecimalなどの数値型を持てる。文字列からFormプロパティ型への変換はバリデーション機構で自動的に実行される。

数値型プロパティのセッタに設定するアノテーション:
- `@Digits(integer=桁数)`: 整数部の桁数を指定
- `@NumberRange(min=値, max=値)`: 数値の範囲を指定

```java
@PropertyName("合計金額")
@Required
@Digits(integer=6)
@NumberRange(min=0, max=200000)
public void setAmount(BigDecimal amount) {
    this.amount = amount;
}
```

バリデーション実行は文字列型プロパティのFormと同様:

```java
ValidationContext<Order> result = ValidationUtil.validateAndConvertRequest("form", Order.class, req, "insert");
```

<details>
<summary>keywords</summary>

ValidationUtil, validateAndConvertRequest, ValidationContext, @ValidateFor, ApplicationException, abortIfInvalid, isValid, createObject, Validatable, プレフィクス, バリデーション名, @Digits, @NumberRange, BigDecimal, Long, 値の変換, 型変換, 数値型プロパティ, convert_property

</details>

## バリデーション結果のエラーメッセージ生成

:ref:`message_management` の機能を使用し、メッセージテンプレートとプロパティ表示名称から自動生成。

例：テンプレート `「{0}は必ず入力してください。」` ＋ `@PropertyName("ユーザ名")` → `「ユーザ名は必ず入力してください。」`

> **注意**: `@PropertyName` は言語ごとに別々の表示名称を指定できないため、国際化が必要なアプリケーションでは使用不可。国際化が必要な場合は :ref:`property_display_name_internationalization` を使用すること。表示名称を画面に合わせて変更したい場合は :ref:`validation_form_inheritance_model` を使用すること（バリデーション条件を変えずに変更可能）。

Formのプロパティ型によってトリムの動作が異なる:
- 数値型（Long、BigDecimal等）: 空白が許容されないため必ずトリムが行われる
- 文字列型: `trimPolicy` の設定によりトリムの要否を選択できる（`"trimAll"` または `"noTrim"`）

詳細は [StringConvertorの設定値](libraries-validation_basic_validators.md) の `trimPolicy` プロパティを参照。

```xml
<component class="nablarch.core.validation.convertor.StringConvertor">
  <property name="conversionFailedMessageId" value="MSG90001" />
  <property name="allowNullValue" value="${validationConvertorAllowNullValue}" />
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

## 様々なMapオブジェクトの精査と変換

精査・変換可能なオブジェクトは `Map<String, ?>` 。キー値がStringであるMap実装クラスであれば精査と変換処理が可能。

NablarchのデータベースアクセスのSqlRow（`Map<String, Object>` の実装）も精査可能。デフォルトコンバータ使用時は変換可能なオブジェクト型に制限がある（[validator_and_convertor](libraries-validation_basic_validators.md) 参照）。

<details>
<summary>keywords</summary>

@PropertyName, エラーメッセージ生成, message_management, property_display_name_internationalization, validation_form_inheritance_model, abortIfInvalid, ApplicationException, StringConvertor, trimPolicy, 入力値トリム, 入力値のトリム, Map, SqlRow, 様々なMapオブジェクトの精査と変換, YYYYMMDDConvertor, バリデーション

</details>

## Entity の使用

FormをRDBMSのテーブルと1対1対応させた特殊形態を「Entity」と呼ぶ。Entityを使用することで以下の2つのメリットが得られる：

1. バリデーションとデータベースへの反映を容易に実装できる
2. RDBMSの定義から、実装の大部分が自動生成できる

RDBMSを使用する場合、できる限りEntityを使用して実装すること。

## テーブル構造とEntityの実装例

USERテーブル（Oracle型）：

| カラム名 | データ型 | 説明 |
|---|---|---|
| ID | CHAR(8) | ユーザを一意に特定するID（プライマリキー） |
| NAME | NVARCHAR(10) | ユーザの氏名 |
| REMARKS | NVARCHAR(100) | ユーザの補足情報 |

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

Entityを使用することでDBへの登録処理を単純に記述できる：

```java
ValidationContext<UserEntity> result = ValidationUtil.validateAndConvertRequest("user", UserEntity.class, req, "insert");
result.abortIfInvalid();
UserEntity user = result.createObject();

ParameterizedSqlPStatement statement = getParameterizedSqlStatement("INSERT_USER");
statement.executeUpdateByObject(user);
```

SqlRow（`Map<String, Object>`）をインプットとして精査を実行できる。プレフィックス（第一引数）に `null` を指定する。カラム名は変換先オブジェクトのプロパティ名と一致させること（大文字・小文字・アンダースコアの区別なし）。

```java
SqlRow row = search();
ValidationContext<UserEntity> context = ValidationUtil.validateAndConvertRequest(
        null, UserEntity.class, row, "validateUserData");
```

<details>
<summary>keywords</summary>

UserEntity, ParameterizedSqlPStatement, executeUpdateByObject, @ValidateFor, @Required, @Length, @PropertyName, ValidationUtil, ValidationContext, Entity, DBテーブル対応, データベース登録, RDBMS, SqlRow, validateAndConvertRequest, データベースレコード精査, nullプレフィックス

</details>

## バリデーション対象のプロパティ指定

画面ごとにバリデーション対象プロパティを限定するには、`@ValidateFor` アノテーションで複数のバリデーションメソッドをFormに定義する。

- `@ValidateFor` の値には「バリデーション名」を設定する（例: `"insert"`、`"update"`）
- `ValidationUtil.validateAndConvertRequest` の第4引数に指定したバリデーション名と一致するメソッドが実行される
- 特定プロパティを除外してバリデーションする場合は `ValidationUtil.validateWithout` を使用する

例：登録画面でIDを自動採番する場合、idプロパティを除外してバリデーション：

```java
public class User {
    // ...

    private static final String[] INSERT_SKIP_PROPS = new String[] {"id"};

    @ValidateFor("insert")
    public static void validateForInsert(ValidationContext<User> context) {
        ValidationUtil.validateWithout(context, INSERT_SKIP_PROPS);
    }
}
```

```java
// "insert"を指定するとvalidateForInsertが実行され、idを除いたバリデーションが行われる
ValidationContext<User> result = ValidationUtil.validateAndConvertRequest("user", User.class, req, "insert");
```

バリデーションで検出できないエラーのメッセージをActionの実装内から直接設定する場合、メッセージの種類によって使用するメソッドが異なる:
- 通常（プロパティに紐付けない場合）: `MessageUtil.createMessage` メソッドを使用する
- プロパティに紐付くメッセージを作成する場合: `ValidationUtil.createMessageForProperty` メソッドを使用する

```java
// user.loginId プロパティのエラーメッセージを設定する。
Message message = ValidationUtil.createMessageForProperty("user.loginId", "MSG00091");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

@ValidateFor, validateWithout, validateAndConvertRequest, ValidationUtil, ValidationContext, バリデーション対象限定, プロパティ除外, バリデーション名, INSERT_SKIP_PROPS, createMessageForProperty, ApplicationException, プロパティ紐付きメッセージ, プロパティに紐付くメッセージの作成, Message, MessageUtil, validation-message-creation

</details>
