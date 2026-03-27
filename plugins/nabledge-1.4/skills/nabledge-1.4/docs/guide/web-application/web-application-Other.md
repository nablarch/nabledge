# その他実装例集

## 本ページの構成

本ページで説明する実装例の一覧:

- :ref:`other_example_log_write`
- :ref:`other_example_repository_get_settings`
- :ref:`other_example_message_get`
- :ref:`other_example_message_notify`
- :ref:`other_error_message_for_property`
- :ref:`other_example_code_get`
- :ref:`other_example_warn_message`

**クラス**: `CodeUtil`

**コードパターンテーブル例**

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 1 | 1 | 0 | 0 |
| 0001 | 2 | 1 | 0 | 0 |
| 0001 | 9 | 0 | 0 | 0 |

**コード名称テーブル例**

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | NAME_WITH_VALUE |
|---|---|---|---|---|---|---|
| 0001 | 1 | 1 | ja | 男性 | 男 | 1:男性 |
| 0001 | 2 | 2 | ja | 女性 | 女 | 2:女性 |
| 0001 | 9 | 3 | ja | 不明 | 不 | 9:不明 |
| 0001 | 1 | 2 | en | Male | M | 1:Male |
| 0001 | 2 | 1 | en | Female | F | 2:Female |
| 0001 | 9 | 3 | en | Unknown | U | 9:Unknown |

コード名称取得: `CodeUtil.getName(codeId, value)` — ThreadContextの言語に合わせた名称を返す。

```java
String name = CodeUtil.getName("0001", "1");
// en -> "Male", ja -> "男性"
```

コード略称取得: `CodeUtil.getShortName(codeId, value)` — ThreadContextの言語に合わせた略称を返す。

```java
String name = CodeUtil.getShortName("0001", "1");
// en -> "男", ja -> "M"
```

オプション名称取得: `CodeUtil.getOptionalName(codeId, value, columnName)` — コード名称テーブルの任意カラム（NAME_WITH_VALUE等）からオプション名称を取得する。

```java
String name = CodeUtil.getOptionalName("0001", "1", "NAME_WITH_VALUE");
// en -> "1:Male", ja -> "1:男性"
```

コード値一覧取得: `CodeUtil.getValues(codeId)` — SORT_ORDER昇順でコード値のリストを返す。

```java
List<String> values = CodeUtil.getValues("0001");
// en -> {"2", "1", "9"}, ja -> {"1", "2", "9"}
```

パターン別コード値取得: `CodeUtil.getValues(codeId, patternColumn)` — パターン用カラム（PATTERN1等）に"1"が設定された行のコード値をSORT_ORDER昇順で返す。

```java
List<String> values = CodeUtil.getValues("0001", "PATTERN1");
// en -> {"2", "1"}, ja -> {"1", "2"}
```

<details>
<summary>keywords</summary>

ログ出力, 設定値取得, メッセージ取得, エラーメッセージ通知, コード値取得, 警告メッセージ, その他実装例一覧, CodeUtil, getName, getShortName, getOptionalName, getValues, コード名称取得, コード略称取得, オプション名称取得, コード値一覧取得, パターン別コード値取得

</details>

## ログの出力方法

**クラス**: `Logger`, `LoggerManager`

クラス変数にロガーを設定し、`LoggerManager.get(ClassName.class)` で取得する:

```java
private static final Logger LOGGER = LoggerManager.get(CM311AC1Component.class);
```

ログ出力前に `isDebugEnabled()` で出力有無をチェックし、不要なメッセージ生成処理（文字列組み立てなど）による性能劣化を避ける:

```java
if (LOGGER.isDebugEnabled()) {
    String message = String.format("user was not found. userId = [%s], name = [%s]",
                                   user.getUserId(), user.getName());
    LOGGER.logDebug(message);
}
```

ログ出力設定方法については :ref:`Web_Log` を参照。

精査エラーではなく業務仕様上のチェック結果として警告メッセージを次画面に表示する場合、ActionでWebUtilのnotifyMessagesメソッドを使用してメッセージを設定し、`n:errors`タグで画面表示する。

**クラス**: `WebUtil`, `MessageUtil`

**Actionでのメッセージ設定**:

```java
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    Message message = MessageUtil.createMessage(MessageLevel.WARN, "MSG00022");
    WebUtil.notifyMessages(ctx, message);
    return new HttpResponse("/ss11AC/W11AC0302.jsp");
}
```

**JSPでのメッセージ出力**:

```jsp
<n:errors />
```

`n:errors`タグはMessageLevelに応じたCSSクラス名を出力する。デフォルトでは下記の対応でクラス名が出力される。

| MessageLevel | CSSクラス名（デフォルト） |
|---|---|
| INFO | nablarch_info |
| WARN | nablarch_warn |
| ERROR | nablarch_error |

```css
li.nablarch_warn {
    color: #0000FF;
}
```

<details>
<summary>keywords</summary>

Logger, LoggerManager, logDebug, isDebugEnabled, ログ出力, デバッグログ, WebUtil.notifyMessages, MessageUtil.createMessage, n:errors, 警告メッセージ表示, 正常画面遷移でのメッセージ, MessageLevel, nablarch_warn, nablarch_info, nablarch_error

</details>

## 設定値の取得方法

**クラス**: `SystemRepository`

コンポーネント設定ファイルに `<config-file>` タグで環境設定ファイルを読み込ませる:

```xml
<config-file file="application/system.config" />
```

取得方法:

```java
// 文字列
String messageId = SystemRepository.getString("notPermissionMessage");

// 真偽値
boolean registerFlg = SystemRepository.getBoolean("registerUserPermission");

// その他の型（文字列取得後に変換）
int effectiveDateTo = Integer.parseInt(SystemRepository.getString("userEffectiveDateTo"));
```

> **警告**: キー値にユーザ入力値やDBから取得した値を使用しないこと。キー値が可変になると、設定値が取得できず障害が発生した場合の解析が非常に困難になる。キー値は常に固定値を使用すること。

<details>
<summary>keywords</summary>

SystemRepository, getString, getBoolean, 環境設定ファイル, 設定値取得, system.config

</details>

## メッセージの取得方法

**クラス**: `MessageUtil`, `MessageLevel`, `StringResource`

`MessageUtil.createMessage(MessageLevel, messageId)` で `Message` を取得し、`formatMessage()` で ThreadContext の言語に合わせた文字列を取得する:

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
String messageStr = message.formatMessage();
```

フォーマット引数付きメッセージ: 国際化が必要な場合はオプション引数に `StringResource` または `Message` を指定する。国際化を行わない場合はオプション引数に直接文字列を指定してもよい:

```java
StringResource nameResource = MessageUtil.getStringResource("PRP0002");
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0002", nameResource);
String messageStr = message.formatMessage();
```

<details>
<summary>keywords</summary>

MessageUtil, createMessage, formatMessage, MessageLevel, StringResource, getStringResource, メッセージ取得, 国際化

</details>

## エラーメッセージの通知方法

**クラス**: `ApplicationException`

業務エラー発生時は `ApplicationException`（またはサブクラス）にメッセージを指定してスローすることで、フレームワークの例外処理機構を使用してエラー内容を使用者に伝えられる:

```java
Message message = MessageUtil.createMessage(MessageLevel.ERROR, "MSG0001");
throw new ApplicationException(message);
```

<details>
<summary>keywords</summary>

ApplicationException, MessageUtil, MessageLevel, エラーメッセージ通知, 業務エラー

</details>

## エラーメッセージを任意の個所に表示する方法

Action内で実装した精査（DBアクセスを伴う精査など）でも、通常のバリデーション結果と同様に特定フィールド近くにエラーを表示したい場合は、`MessageUtil.createMessage` の代わりに `ValidationUtil.createMessageForProperty` を使用する。

**クラス**: `ValidationUtil`

```java
// 第1引数: JSP の <n:error> タグの name 属性で指定した名称
// 第2引数: メッセージID
throw new ApplicationException(ValidationUtil.createMessageForProperty(
        "W11AC02.systemAccount.loginId", "MSG00001"));
```

JSP側では通常のバリデーション結果のエラー表示と同様に `<n:error>` タグを使用する:

```jsp
<n:error name="W11AC02.systemAccount.loginId"/>
```

<details>
<summary>keywords</summary>

ValidationUtil, createMessageForProperty, ApplicationException, n:error, エラーメッセージ表示位置, フィールドエラー

</details>
