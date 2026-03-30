# その他実装例集

## 本ページの構成

このページで説明する実装例:

- :ref:`other_example_log_write`
- :ref:`other_example_repository_get_settings`
- :ref:`other_example_message_get`
- :ref:`other_example_message_notify`
- :ref:`other_database_access_error`
- :ref:`other_error_message_for_property`
- :ref:`other_example_code_get`
- :ref:`other_example_code_validate`
- :ref:`other_example_warn_message`

コード管理機能でコード名称・値を取得するには`CodeUtil`クラスを使用する。取得結果はThreadContextに保持した言語に依存する。

| メソッド | 説明 |
|---|---|
| `CodeUtil.getName(codeId, value)` | ThreadContextの言語に応じたコード名称を返す |
| `CodeUtil.getShortName(codeId, value)` | ThreadContextの言語に応じたコード略称を返す |
| `CodeUtil.getOptionalName(codeId, value, columnName)` | コード名称テーブルの任意カラム（オプション名称用）の値を取得 |
| `CodeUtil.getValues(codeId)` | コードパターンテーブルのSORT_ORDER昇順でコード値リストを返す |
| `CodeUtil.getValues(codeId, patternColumn)` | パターン用カラム（PATTERN1等）に"1"が設定された行のコード値を返す |

```java
// コード名称取得 (ja: "男性", en: "Male")
String name = CodeUtil.getName("0001", "1");

// コード略称取得 (en -> "男", ja -> "M")
String name = CodeUtil.getShortName("0001", "1");

// オプション名称取得 (NAME_WITH_VALUEカラム指定時: ja -> "1:男性", en -> "1:Male")
String name = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");

// コード値一覧取得 (ja: {"1","2","9"}, en: {"2","1","9"})
List<String> values = CodeUtil.getValues("0001");

// パターンでフィルタしたコード値取得 (ja: {"1","2"}, en: {"2","1"})
List<String> values = CodeUtil.getValues("0001", "PATTERN1");
```

(:ref:`記載しているサンプルプログラムソースコードの注意事項 <sourceCode>` 参照)

<details>
<summary>keywords</summary>

ログ出力, 設定値取得, メッセージ取得, エラーメッセージ通知, データベース精査, エラー表示位置, コード値取得, コード値バリデーション, 警告メッセージ表示, CodeUtil, getName, getShortName, getOptionalName, getValues, コード名称取得, コード略称取得, オプション名称取得, ThreadContext言語依存, ThreadContext, PATTERN1, NAME_WITH_VALUE

</details>

## ログの出力方法

**クラス**: `LoggerManager`, `Logger`

`LoggerManager.get(ClassName.class)` でLoggerを取得し、クラス変数に保持する。

```java
private static final Logger LOGGER = LoggerManager.get(CM311AC1Component.class);
```

メッセージ組み立て処理が必要な場合は、事前に `isDebugEnabled()` で出力有無をチェックすること。不要な文字列組み立てによる性能劣化を防ぐためである。

```java
if (LOGGER.isDebugEnabled()) {
    String message = String.format("user was not found. userId = [%s], name = [%s]",
                                   user.getUserId(), user.getName());
    LOGGER.logDebug(message);
}
```

ログ出力の設定方法については、:ref:`Web_Log` を参照。

`@CodeValue`アノテーションを使用してコード値のバリデーションを行う。`pattern`属性にパターン用カラム名を指定する。指定パターンに含まれない値はバリデーションエラーとなる。

```java
@PropertyName("性別")
@CodeValue(codeId="0001", pattern="PATTERN1")
public String setGender(String gender) {
    this.gender = gender;
}
```

上記例ではPATTERN1カラムが"1"の値（"1","2"）以外はバリデーションエラー。

(:ref:`記載しているサンプルプログラムソースコードの注意事項 <sourceCode>` 参照)

<details>
<summary>keywords</summary>

LoggerManager, Logger, isDebugEnabled, logDebug, ログ出力, デバッグログ, @CodeValue, CodeValue, codeId, pattern, @PropertyName, コード値バリデーション, パターンバリデーション

</details>

## 設定値の取得方法

リポジトリ機能を使用した設定値の取得方法。環境設定ファイルをコンポーネント設定ファイルに `config-file` タグで登録し、`SystemRepository` で値を取得する。

コンポーネント設定ファイルへの登録:

```xml
<config-file file="application/system.config" />
```

**クラス**: `SystemRepository`

| メソッド | 型 | 用途 |
|---|---|---|
| `getString(key)` | String | 文字列値の取得 |
| `getBoolean(key)` | boolean | 真偽値の取得 |

文字列・真偽値以外の型は `getString` で取得後に変換する:

```java
String messageId = SystemRepository.getString("notPermissionMessage");
boolean registerFlg = SystemRepository.getBoolean("registerUserPermission");
int effectiveDateTo = Integer.parseInt(SystemRepository.getString("userEffectiveDateTo"));
```

> **警告**: 環境設定値取得のキー値にユーザ入力値やDB取得値を使用しないこと。キー値が可変になると、設定値が取得できなかった場合の障害解析が非常に困難となる。キー値は常に固定値とすること。

精査エラーとは異なり、業務チェックによる警告メッセージを次画面に表示するには、ActionでWebUtil.notifyMessages()でメッセージを設定し、JSPでn:errorsタグを使用する。

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
| `INFO` | `nablarch_info` |
| `WARN` | `nablarch_warn` |
| `ERROR` | `nablarch_error` |

(:ref:`記載しているサンプルプログラムソースコードの注意事項 <sourceCode>` 参照)

<details>
<summary>keywords</summary>

SystemRepository, getString, getBoolean, config-file, 環境設定ファイル, 設定値取得, WebUtil, notifyMessages, n:errors, MessageUtil, MessageLevel, nablarch_warn, nablarch_info, nablarch_error, 警告メッセージ表示, 正常画面遷移メッセージ, Message, HttpResponse

</details>

## メッセージの取得方法

**クラス**: `MessageUtil`, `Message`, `StringResource`

`MessageUtil.createMessage(MessageLevel, messageId)` でメッセージを取得し、`message.formatMessage()` で文字列化する。メッセージはThreadContextに保持した言語に合わせて返される。

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
String messageStr = message.formatMessage();
```

メッセージにプレースホルダがある場合、国際化対応では `getStringResource` で取得した `StringResource` をオプション引数に渡す:

```java
StringResource nameResource = MessageUtil.getStringResource("PRP0002");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0002", nameResource);
String messageStr = message.formatMessage();
```

<details>
<summary>keywords</summary>

MessageUtil, Message, createMessage, MessageLevel, StringResource, getStringResource, メッセージ取得, 国際化

</details>

## エラーメッセージの通知方法

業務的エラーが発生した際は、`ApplicationException`（またはサブクラス）にメッセージを設定してスローする。フレームワークの例外処理機構によりエラー内容がユーザに通知される。

**クラス**: `ApplicationException`

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ApplicationException, MessageUtil, MessageLevel, エラーメッセージ通知, 例外処理

</details>

## データベースアクセスを伴う精査を行う方法

データベースアクセスを伴う精査は、単体項目・複合項目を問わず `Entity` ではなく `Action`（業務共通コンポーネントを含む）に実装すること。精査エラーは `ApplicationException` を使用してメッセージを通知する（:ref:`other_example_message_notify` 参照）。

**クラス**: `SqlPStatement`, `ApplicationException`, `MessageUtil`, `MessageLevel`

ログインIDの重複チェックの実装例:

```java
SqlPStatement statement = getSqlPStatement("SELECT_SYSTEM_ACCOUNT");
statement.setString(1, loginId);
if (!statement.retrieve().isEmpty()) {
    throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
}
```

<details>
<summary>keywords</summary>

SqlPStatement, ApplicationException, MessageUtil, MessageLevel, データベース精査, 重複チェック, Action実装

</details>

## エラーメッセージを任意の個所に表示する方法

Action内の精査で特定の入力項目の近くにエラーメッセージを表示するには、`MessageUtil.createMessage` ではなく `ValidationUtil.createMessageForProperty` を使用する。第1引数には `n:error` タグの `name` 属性で指定した名称を渡す。

**クラス**: `ValidationUtil`

```java
throw new ApplicationException(ValidationUtil.createMessageForProperty(
        "W11AC02.systemAccount.loginId", "MSG00001"));
```

JSP側は通常のバリデーション結果のエラー表示と同様に `n:error` タグを使用する:

```jsp
<n:text name="W11AC02.systemAccount.loginId" size="50" maxlength="20"/>
<n:error name="W11AC02.systemAccount.loginId"/>
```

<details>
<summary>keywords</summary>

ValidationUtil, createMessageForProperty, n:error, プロパティ紐付け, エラー表示位置, JSP

</details>

## コード値の取得方法

コード機能を使用してコード値の一覧を取得する方法。`CodeUtil.getValues(codeId)` でコードIDに対応するコード値リストを取得する。

**クラス**: `CodeUtil`

```java
// コードIDに対応するコード値一覧を取得する
List<CodeItem> codeItems = CodeUtil.getValues("codeId");
```

JSPでプルダウンを表示する場合は `n:codeSelect` タグまたは `n:select` タグの `listId` 属性を使用する:

```jsp
<%-- n:codeSelect タグを使用したプルダウン表示 --%>
<n:codeSelect name="form.codeValue" codeId="codeId" />
```

<details>
<summary>keywords</summary>

CodeUtil, getValues, codeId, n:codeSelect, n:select, コード値取得, コードリスト

</details>

## コード値のバリデーション方法

入力値がコードテーブルに定義されているかを検証する方法。`CodeUtil.contains(codeId, value)` を使用して手動で検証するか、フォームクラスのプロパティに `@CodeValue` アノテーションを指定することで自動的にバリデーションが行われる。

**クラス**: `CodeUtil`

アノテーションによるバリデーション（推奨）:

```java
// フォームクラスのプロパティに @CodeValue を指定する
@CodeValue(codeId = "codeId")
private String codeValue;
```

`CodeUtil.contains` による手動検証:

```java
// 入力値がコードテーブルに存在するかを検証する
if (!CodeUtil.contains("codeId", inputValue)) {
    throw new ApplicationException(
        MessageUtil.createMessage(MessageLevel.ERROR, "MSG00001"));
}
```

<details>
<summary>keywords</summary>

CodeUtil, contains, @CodeValue, codeId, コード値バリデーション, コードテーブル

</details>

## 警告メッセージの表示方法

警告メッセージを使用者に表示する方法。エラーと異なり警告は処理を中断せずにメッセージを通知する場合に使用する。`MessageUtil.createMessage` に `MessageLevel.WARN` を指定してメッセージを作成する。

**クラス**: `MessageUtil`, `MessageLevel`

```java
// 警告メッセージの作成
Message warnMessage = MessageUtil.createMessage(MessageLevel.WARN, "MSG0001");
```

JSPで警告メッセージを表示するには `n:message` タグを使用する:

```jsp
<%-- 警告メッセージの表示 --%>
<n:message />
```

<details>
<summary>keywords</summary>

MessageUtil, MessageLevel, WARN, n:message, 警告メッセージ, 警告表示

</details>
