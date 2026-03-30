# その他実装例集

## 本ページの構成

このドキュメントで説明する実装例の一覧。

- ログの出力方法 (:ref:`other_example_log_write`)
- 設定値の取得方法 (:ref:`other_example_repository_get_settings`)
- メッセージの取得方法 (:ref:`other_example_message_get`)
- エラーメッセージの通知方法 (:ref:`other_example_message_notify`)
- データベースアクセスを伴う精査を行う方法 (:ref:`other_database_access_error`)
- エラーメッセージを任意の個所に表示する方法 (:ref:`other_error_message_for_property`)
- コード値の取得方法 (:ref:`other_example_code_get`)
- コード値を使ったバリデーション (:ref:`other_example_code_validate`)
- 警告メッセージの表示方法 (:ref:`other_example_warn_message`)

**クラス**: `CodeUtil`

コード管理機能でコード名称・コード値を取得する。全メソッドはThreadContextの言語設定に応じた値を返す。

### コード名称の取得

`CodeUtil.getName(codeId, value)` — コード名称テーブルのNAMEカラムの値を取得。

```java
String name = CodeUtil.getName("0001", "1");
// en -> "Male", ja -> "男性"
```

### コード略称の取得

`CodeUtil.getShortName(codeId, value)` — コード名称テーブルのSHORT_NAMEカラムの値を取得。

```java
String name = CodeUtil.getShortName("0001", "1");
// en -> "男", ja -> "M"
```

### オプション名称の取得

`CodeUtil.getOptionalName(codeId, value, columnName)` — コード名称テーブルの任意カラム（NAME_WITH_VALUE等）の値を取得。カラム名を第3引数に指定する。

```java
String name = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");
// en -> "1:Male", ja -> "1:男性"
```

### コード値の取得

`CodeUtil.getValues(codeId)` — コード値リストをSORT_ORDERカラムの昇順で返す。

```java
List<String> values = CodeUtil.getValues("0001");
// en -> {"2", "1", "9"}, ja -> {"1", "2", "9"}
```

### パターンごとのコード値の取得

`CodeUtil.getValues(codeId, patternColumn)` — コードパターンテーブルのパターンカラムを指定してコード値リストを取得。パターンカラムに"1"が設定された行のみ対象。値はSORT_ORDERカラムの昇順で返す。

```java
List<String> values = CodeUtil.getValues("0001", "PATTERN1");
// en -> {"2", "1"}, ja -> {"1", "2"}
```

<details>
<summary>keywords</summary>

ログ出力, 設定値取得, メッセージ取得, エラーメッセージ通知, DBアクセス精査, コード値取得, コード値バリデーション, 警告メッセージ, 実装例集, CodeUtil, getName, getShortName, getOptionalName, getValues, コード名称取得, コード略称取得, オプション名称取得, ThreadContext言語, パターンカラム指定

</details>

## ログの出力方法

**クラス**: `Logger`, `LoggerManager`

ロガーはクラス変数に設定し、`LoggerManager.get(ClassName.class)` で取得する。

```java
private static final Logger LOGGER = LoggerManager.get(CM311AC1Component.class);
```

デバッグログ出力前に `isDebugEnabled()` で出力有無を確認し、不要なメッセージ組み立て処理による性能劣化を防ぐ。

```java
if (LOGGER.isDebugEnabled()) {
    String message = String.format("user was not found. userId = [%s], name = [%s]",
                                   user.getUserId(), user.getName());
    LOGGER.logDebug(message);
}
```

ログ出力設定については :ref:`Web_Log` を参照。

**アノテーション**: `@CodeValue`

コード値のバリデーションには`@CodeValue`バリデータを使用する。

```java
@PropertyName("性別")
@CodeValue(codeId="0001", pattern="PATTERN1")
public String setGender(String gender) {
    this.gender = gender;
}
```

- `codeId`: 対象のコードID
- `pattern`: パターンのカラム名。指定したパターンに含まれる値（パターンカラムが"1"の行）のみ有効とする。パターンに含まれない値はバリデーションエラーとなる。

<details>
<summary>keywords</summary>

Logger, LoggerManager, logDebug, isDebugEnabled, ログ出力, デバッグログ, @CodeValue, CodeValue, @PropertyName, PropertyName, codeId, pattern, コード値バリデーション, バリデーションアノテーション

</details>

## 設定値の取得方法

**クラス**: `SystemRepository`

| 型 | メソッド |
|---|---|
| 文字列 | `SystemRepository.getString("key")` |
| 真偽値 | `SystemRepository.getBoolean("key")` |
| その他 | `getString()` で取得後に変換 |

```java
String messageId = SystemRepository.getString("notPermissionMessage");
boolean registerFlg = SystemRepository.getBoolean("registerUserPermission");
int effectiveDateTo = Integer.parseInt(SystemRepository.getString("userEffectiveDateTo"));
```

コンポーネント設定ファイルに `config-file` タグで環境設定ファイルを読み込む:

```xml
<config-file file="application/system.config" />
```

> **警告**: キー値にユーザ入力値やデータベースから取得した値を使用しないこと。キー値が可変の場合、障害発生時の解析が困難になる。キー値は常に固定値を使用すること。

悪い例:
```java
// Entityから取得した値をキー値に使用（不可）
String message = SystemRepository.getString("user" + userEntity.getUserId() + ".message");
// DBから取得した値をキー値に使用（不可）
String message = SystemRepository.getString("user" + row.getString("userId") + ".message");
```

**クラス**: `WebUtil`, `MessageUtil`

正常な画面遷移でメッセージを表示する場合、ActionでWebUtilの`notifyMessages`メソッドを使用してメッセージを設定し、JSPで`<n:errors />`タグで出力する。精査エラーではなく業務仕様上のチェック結果として警告メッセージを次画面に表示する場合に使用する。

```java
Message message = MessageUtil.createMessage(MessageLevel.WARN, "MSG00022");
WebUtil.notifyMessages(ctx, message);
return new HttpResponse("/ss11AC/W11AC0302.jsp");
```

```jsp
<n:errors />
```

`n:errors`タグはMessageLevelに応じたCSSクラス名を出力する：

| MessageLevel | CSSクラス名 |
|---|---|
| INFO | `nablarch_info` |
| WARN | `nablarch_warn` |
| ERROR | `nablarch_error` |

<details>
<summary>keywords</summary>

SystemRepository, getString, getBoolean, 設定値取得, 環境設定ファイル, config-file, WebUtil, MessageUtil, notifyMessages, createMessage, n:errors, MessageLevel, 警告メッセージ表示, 正常画面遷移メッセージ, nablarch_warn, nablarch_info, nablarch_error

</details>

## メッセージの取得方法

**クラス**: `MessageUtil`, `Message`, `StringResource`

メッセージはThreadContextに保持した言語に対応した文言が返る。

```java
// 基本的なメッセージ取得
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
String messageStr = message.formatMessage();
```

プレースホルダ（`{0}` など）付きメッセージをフォーマットする場合、国際化するときは `StringResource` または `Message` を引数に渡す。国際化を行わない場合はオプション引数に直接文字列を指定してもよい:

```java
StringResource nameResource = MessageUtil.getStringResource("PRP0002");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0002", nameResource);
String messageStr = message.formatMessage();
```

<details>
<summary>keywords</summary>

MessageUtil, Message, StringResource, createMessage, formatMessage, getStringResource, MessageLevel, メッセージ取得, 国際化

</details>

## エラーメッセージの通知方法

**クラス**: `ApplicationException`

業務エラーは `ApplicationException`（またはそのサブクラス）をスローすることで、フレームワークの例外処理機構を通じてエラー内容をユーザに通知する。

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ApplicationException, MessageLevel, エラーメッセージ通知, 業務エラー, 例外処理

</details>

## データベースアクセスを伴う精査を行う方法

**クラス**: `ApplicationException`, `SqlPStatement`, `MessageUtil`

DBアクセスを伴う精査（単体項目・複合項目を問わず）は Entity ではなく Action に実装する。精査エラーは `ApplicationException` でユーザに通知する（:ref:`other_example_message_notify` 参照）。

ログインIDの重複チェックの実装例:

```java
W11AC02Form form = context.createObject();
SystemAccountEntity systemAccount = form.getSystemAccount();
String loginId = systemAccount.getLoginId();

SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
statement.setString(1, loginId);
if (!statement.retrieve().isEmpty()) {
    throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
}
```

<details>
<summary>keywords</summary>

ApplicationException, SqlPStatement, retrieve, MessageLevel, DBアクセス精査, 重複チェック, Action

</details>

## エラーメッセージを任意の個所に表示する方法

**クラス**: `ValidationUtil`, `ApplicationException`

Action内の精査でも通常のバリデーション結果と同様に入力値の近くにエラーを表示したい場合は、`MessageUtil.createMessage` の代わりに `ValidationUtil.createMessageForProperty` を使用する。

```java
// 第1引数: n:error タグの name 属性で指定した名称
throw new ApplicationException(ValidationUtil.createMessageForProperty(
        "W11AC02.systemAccount.loginId", "MSG00001"));
```

JSPのエラー表示は通常のバリデーション結果と同様に `<n:error>` タグを使用する:

```jsp
<n:text name="W11AC02.systemAccount.loginId" size="50" maxlength="20"/>
<n:error name="W11AC02.systemAccount.loginId"/>
```

<details>
<summary>keywords</summary>

ValidationUtil, createMessageForProperty, n:error, エラーメッセージ表示位置, プロパティ別エラー

</details>
