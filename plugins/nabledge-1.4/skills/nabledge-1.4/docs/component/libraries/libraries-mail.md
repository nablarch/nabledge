# メール送信

## 概要

メール送信処理は、常駐バッチを経由して業務アプリケーションの処理とは非同期に行う方式を採用している。

**非同期方式を採用する理由：**

- 業務アプリケーションから見て、メール送信処理を業務アプリケーションのDBトランザクションに含めることができる
- メールサーバー障害やネットワーク障害によりメール送信が遅延・失敗しても、業務アプリケーションの処理への影響を与えない

業務アプリケーションはメール送信要求APIを呼び出すだけでよい。**メール送信要求APIを呼び出す毎に一つのメール送信要求が作成され、メール送信要求一つにつきメールが一通送信される。**

逐次メール送信バッチでは、メール送信ライブラリとして **JavaMail API** を使用する。

## テーブルスキーマ定義

以下4クラスにテーブルのスキーマ情報を設定する。これらはInitializableインターフェースの実装クラスのため、初期化設定（`nablarch.core.repository.initialization.BasicApplicationInitializer`のinitializeList）に含める必要がある。

| クラス | スキーマ情報を保持するテーブル |
|---|---|
| `nablarch.common.mail.MailRequestTable` | メール送信要求 |
| `nablarch.common.mail.MailRecipientTable` | メール送信先 |
| `nablarch.common.mail.MailAttachedFileTable` | メール添付ファイル |
| `nablarch.common.mail.MailTemplateTable` | メールテンプレート |

```xml
<component name="mailRequestTable" class="nablarch.common.mail.MailRequestTable">
    <property name="tableName" value="MAIL_REQUEST" />
    <property name="mailRequestIdColumnName" value="MAIL_REQUEST_ID" />
    <property name="subjectColumnName" value="SUBJECT" />
    <property name="fromColumnName" value="MAIL_FROM" />
    <property name="replyToColumnName" value="REPLY_TO" />
    <property name="returnPathColumnName" value="RETURN_PATH" />
    <property name="charsetColumnName" value="CHARSET" />
    <property name="statusColumnName" value="STATUS" />
    <property name="requestDateTimeColumnName" value="REQUEST_DATETIME" />
    <property name="sendDateTimeColumnName" value="SEND_DATETIME" />
    <property name="mailBodyColumnName" value="MAIL_BODY" />
    <property name="mailSendPatternIdColumnName" value="MAIL_SEND_PATTERN_ID" />
</component>

<component name="mailRecipientTable" class="nablarch.common.mail.MailRecipientTable">
    <property name="tableName" value="MAIL_RECIPIENT" />
    <property name="mailRequestIdColumnName" value="MAIL_REQUEST_ID" />
    <property name="serialNumberColumnName" value="SERIAL_NUMBER" />
    <property name="recipientTypeColumnName" value="RECIPIENT_TYPE" />
    <property name="mailAddressColumnName" value="MAIL_ADDRESS" />
</component>

<component name="mailAttachedFileTable" class="nablarch.common.mail.MailAttachedFileTable">
    <property name="tableName" value="MAIL_ATTACHED_FILE" />
    <property name="mailRequestIdColumnName" value="MAIL_REQUEST_ID" />
    <property name="serialNumberColumnName" value="SERIAL_NUMBER" />
    <property name="fileNameColumnName" value="FILE_NAME" />
    <property name="contentTypeColumnName" value="CONTENT_TYPE" />
    <property name="fileColumnName" value="ATTACHED_FILE" />
</component>

<component name="mailTemplateTable" class="nablarch.common.mail.MailTemplateTable">
    <property name="tableName" value="MAIL_TEMPLATE" />
    <property name="mailTemplateIdColumnName" value="MAIL_TEMPLATE_ID" />
    <property name="langColumnName" value="LANG" />
    <property name="subjectColumnName" value="SUBJECT" />
    <property name="charsetColumnName" value="CHARSET" />
    <property name="mailBodyColumnName" value="MAIL_BODY" />
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="mailRequestTable" />
            <component-ref name="mailRecipientTable" />
            <component-ref name="mailAttachedFileTable" />
            <component-ref name="mailTemplateTable" />
        </list>
    </property>
</component>
```

## コード値とメッセージID

**クラス**: `nablarch.common.mail.MailConfig`

メール送信に使用するコード値、メッセージID、障害コードをMailConfigクラスのプロパティとして設定する。

```xml
<component name="mailConfig" class="nablarch.common.mail.MailConfig">
    <property name="mailRequestSbnId" value="9999" />
    <property name="recipientTypeTO" value="0" />
    <property name="recipientTypeCC" value="1" />
    <property name="recipientTypeBCC" value="2" />
    <property name="statusUnsent" value="0" />
    <property name="statusSent" value="1" />
    <property name="statusFailure" value="2" />
    <property name="mailRequestCountMessageId" value="MREQCOUNT0" />
    <property name="sendSuccessMessageId" value="MSENDOK000" />
    <property name="sendFailureCode" value="MSENDFAIL0" />
    <property name="abnormalEndExitCode" value="199" />
</component>
```

<details>
<summary>keywords</summary>

メール送信概要, 非同期処理方式, JavaMail API, DBトランザクション, メールサーバー障害, 常駐バッチ, メール送信処理方式, MailRequestTable, MailRecipientTable, MailAttachedFileTable, MailTemplateTable, MailConfig, Initializable, BasicApplicationInitializer, テーブルスキーマ定義, コード値設定, メッセージID, 初期化設定, mailRequestSbnId, recipientTypeTO, recipientTypeCC, recipientTypeBCC

</details>

## クラス図

![メール送信クラス図](../../../knowledge/component/libraries/assets/libraries-mail/09_Mail.jpg)

## メール送信要求API

**クラス**: `nablarch.common.mail.MailRequester`

業務アプリケーションは`nablarch.common.mail.MailUtil`クラスの`getMailRequester`メソッドでこのコンポーネントを取得する。以下のコンポーネントをプロパティに設定する:
- MailRequestConfig
- IdGenerator
- MailRequestTable
- MailRecipientTable
- MailAttachedFileTable
- MailTemplateTable

省略可能な項目のデフォルト値と、精査に使用する最大宛先数・添付ファイルサイズ上限値を`nablarch.common.mail.MailRequestConfig`クラスのプロパティとして設定する。

```xml
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
    <property name="mailRequestConfig" ref="mailRequestConfig" />
    <property name="mailRequestIdGenerator" ref="idGenerator" />
    <property name="mailRequestTable" ref="mailRequestTable" />
    <property name="mailRecipientTable" ref="mailRecipientTable" />
    <property name="mailAttachedFileTable" ref="mailAttachedFileTable" />
    <property name="mailTemplateTable" ref="mailTemplateTable" />
</component>

<component name="mailRequestConfig" class="nablarch.common.mail.MailRequestConfig">
    <property name="defaultReplyTo" value="default.reply.to@nablarch.sample" />
    <property name="defaultReturnPath" value="default.return.path@nablarch.sample" />
    <property name="defaultCharset" value="ISO-2022-JP" />
    <property name="maxRecipientCount" value="100" />
    <property name="maxAttachedFileSize" value="2097152" />
</component>
```

## メール送信要求ID採番

メール送信要求IDの採番にはIdGeneratorを使用する（[id-generator-top](libraries-06_IdGenerator.md) 参照）。他の採番用コンポーネントと併用可能。IdGeneratorはMailRequesterのプロパティ（`mailRequestIdGenerator`）として設定する（:ref:`mailApiComponentConfig` 参照）。

<details>
<summary>keywords</summary>

メール送信クラス図, クラス構造, メール送信アーキテクチャ, MailSender, MailRequester, MailRequestConfig, MailUtil, IdGenerator, getMailRequester, mailRequestIdGenerator, defaultReplyTo, defaultReturnPath, defaultCharset, maxRecipientCount, maxAttachedFileSize, メール送信要求API, 採番

</details>

## 各クラスの責務

## メール送信要求API

| クラス名 | 概要 |
|---|---|
| `nablarch.common.mail.MailRequester` | メール送信受付API |
| `nablarch.common.mail.MailUtil` | MailRequesterインスタンス取得用のユーティリティ |

## 逐次メール送信バッチアクションクラス

**クラス**: `nablarch.common.mail.MailSender`

メール送信要求テーブルから未送信データを抽出してメール送信を行うバッチアクションクラス。

- 未送信データの抽出方法は2種類: テーブル全体から抽出 / メール送信パターンID毎に抽出
- メール送信パターンID毎の場合、パターンID毎に別プロセスを起動し、起動引数 `mailSendPatternId` に処理対象のメール送信パターンIDを指定する
- バッチ起動時に引数 `mailSendPatternId` を指定しない場合はテーブル全体の未送信データが監視対象となる
- 電子署名付きメールや暗号化メールを送信したい場合は、本クラスを継承して実現する

## メール送信要求データオブジェクト

| クラス名 | 概要 |
|---|---|
| `nablarch.common.mail.MailContext` | メール送信要求を表す抽象クラス |
| `nablarch.common.mail.FreeTextMailContext` | 非定型メール送信要求を表すクラス |
| `nablarch.common.mail.TemplateMailContext` | 定型メール送信要求を表すクラス |
| `nablarch.common.mail.AttachedFile` | メール添付ファイルの情報を保持するクラス |

## 設定値を保持するクラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.mail.MailRequestConfig` | メールのデフォルト設定を保持するクラス |
| `nablarch.common.mail.MailConfig` | 出力ライブラリ(メール送信)のコード値を保持するクラス |
| `nablarch.common.mail.MailSessionConfig` | メール送信用設定値を保持するクラス |

## テーブルのスキーマ情報を保持するクラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.mail.MailRecipientTable` | メール送信先管理テーブルのスキーマ情報を保持するクラス |
| `nablarch.common.mail.MailRequestTable` | メール送信要求管理テーブルのスキーマを保持するクラス |
| `nablarch.common.mail.MailAttachedFileTable` | 添付ファイル管理テーブルのスキーマ情報を保持するクラス |
| `nablarch.common.mail.MailTemplateTable` | メールテンプレート管理テーブルのスキーマ情報を保持するクラス |

## 例外クラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.mail.AttachedFileSizeOverException` | 添付ファイルサイズが上限値を超えている場合に発生する例外 |
| `nablarch.common.mail.RecipientCountException` | 宛先数が不正な場合（宛先なし、もしくは上限数超過）に発生する例外 |
| `nablarch.common.mail.InvalidCharacterException` | 不正な文字が含まれていた場合に発生する例外 |

## 処理対象のメール送信パターンID

コマンドライン引数として指定する。
- パラメータ名: `mailSendPatternId`
- パラメータ値: 処理対象のメール送信パターンID

`nablarch.common.mail.MailRequestTable`の`mailSendPatternIdColumnName`を設定した場合は指定が必須となる。

コマンドライン引数の指定方法は :ref:`parsing_commandLine` を参照。

## メールセッション

**クラス**: `nablarch.common.mail.MailSessionConfig`

逐次メール送信バッチが使用するSMTPサーバーへの接続情報を設定する（JavaMail APIのjavax.mail.Sessionオブジェクトに設定するプロパティ）。

```xml
<component name="mailSessionConfig" class="nablarch.common.mail.MailSessionConfig">
    <property name="mailSmtpHost" value="localhost" />
    <property name="mailHost" value="localhost" />
    <property name="mailSmtpPort" value="25" />
    <property name="mailSmtpConnectionTimeout" value="100000" />
    <property name="mailSmtpTimeout" value="100000" />
</component>
```

## メールヘッダインジェクション攻撃への対策

**根本的対策**:
- メールヘッダは固定値を使用する（ユーザ等の外部からの入力値を使用しない）
- JavaMail APIを使用してメール送信を行う

**保険的対策**: 以下の項目に改行コードが含まれている場合はメール送信を実施しない。`InvalidCharacterException`を送出し、ログ出力（ログレベル: FATAL）を行い、該当メールは送信失敗として扱う。
- 件名
- 差し戻し先メールアドレス

> **注意**: 送信者メールアドレス・TO/CC/BCC送信先メールアドレス・文字コード・返信先メールアドレスはJavaMailのチェック機能が存在するため保険的対策の対象外。

<details>
<summary>keywords</summary>

MailRequester, MailUtil, MailSender, MailContext, FreeTextMailContext, TemplateMailContext, AttachedFile, MailRequestConfig, MailConfig, MailSessionConfig, MailRecipientTable, MailRequestTable, MailAttachedFileTable, MailTemplateTable, AttachedFileSizeOverException, RecipientCountException, InvalidCharacterException, メール送信クラス責務, 逐次メール送信バッチ, メール送信パターンID, mailSendPatternId, mailSmtpHost, mailHost, mailSmtpPort, mailSmtpConnectionTimeout, mailSmtpTimeout, メールヘッダインジェクション, SMTPサーバー接続設定, メールセッション

</details>

## テーブル定義

テーブル名・カラム名は任意に指定できる。データベースの型はJavaの型に変換可能な型を選択する。

## メール送信要求テーブル

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK。メール送信要求を一意に識別するID |
| メール送信パターンID | java.lang.String | メールの送信方法のパターンを識別するID。**任意項目のため、定義しなくてもメール送信機能は動作する。** |
| 件名 | java.lang.String | |
| 送信者メールアドレス | java.lang.String | メールのFromヘッダに指定するメールアドレス |
| 返信先メールアドレス | java.lang.String | メールのReply-Toヘッダに指定するメールアドレス |
| 差戻し先メールアドレス | java.lang.String | メールのReturn-Pathヘッダに指定するメールアドレス |
| 文字セット | java.lang.String | メールのContent-Typeヘッダに指定する文字セット |
| ステータス | java.lang.String | メールの送信状態（未送信／送信済／送信失敗）を表すコード値 |
| 要求日時 | java.sql.Timestamp | |
| 送信日時 | java.sql.Timestamp | |
| 本文 | java.lang.String | |

## メール送信先テーブル

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK。一つのメール送信要求内の連番 |
| 送信先区分 | java.lang.String | メールの送信先区分（TO／CC／BCC）を表すコード値 |
| メールアドレス | java.lang.String | |

## メール添付ファイルテーブル

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 添付ファイル名 | java.lang.String | |
| 添付ファイルContent-Type | java.lang.String | |
| 添付ファイル | byte[] | |

## メールテンプレートテーブル

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メールテンプレートID | java.lang.String | PK |
| 言語 | java.lang.String | PK |
| 件名 | java.lang.String | |
| 本文 | java.lang.String | |
| 文字セット | java.lang.String | メール送信時に指定する文字セット |

**クラス**: `nablarch.common.mail.MailRequestTable`

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メール送信要求管理テーブルの名前 |
| 2 | mailRequestIdColumnName | 要求IDカラムの名前 |
| 3 | subjectColumnName | 件名カラムの名前 |
| 4 | fromColumnName | 送信者メールアドレスカラムの名前 |
| 5 | replyToColumnName | 返信先メールアドレスカラムの名前 |
| 6 | returnPathColumnName | 差し戻し先メールアドレスカラムの名前 |
| 7 | charsetColumnName | 文字セットカラムの名前 |
| 8 | statusColumnName | ステータスカラムの名前 |
| 9 | requestDateTimeColumnName | 要求日時カラムの名前 |
| 10 | sendDateTimeColumnName | メール送信日時カラムの名前 |
| 11 | mailBodyColumnName | 本文カラムの名前 |
| 12 | mailSendPatternIdColumnName | メール送信パターンIDのカラム名（任意）。省略した場合はメール送信パターンIDを使用しない。 |

<details>
<summary>keywords</summary>

メール送信要求テーブル, メール送信先テーブル, メール添付ファイルテーブル, メールテンプレートテーブル, テーブルスキーマ, メール送信パターンID, 送信先区分, メールテンプレートID, MailRequestTable, tableName, mailRequestIdColumnName, subjectColumnName, fromColumnName, replyToColumnName, returnPathColumnName, charsetColumnName, statusColumnName, requestDateTimeColumnName, sendDateTimeColumnName, mailBodyColumnName, mailSendPatternIdColumnName, メール送信要求管理テーブル

</details>

## メール送信要求

メール送信要求APIを呼び出す毎に一つのメール送信要求が作成され、**メール送信要求一つにつきメールが一通送信される**。

メール送信要求APIを呼び出すと、メール送信要求テーブルとその関連テーブルに格納する。格納時に最大宛先数と添付ファイルサイズの精査を行う。

メール送信要求APIは以下2パターンをサポートする。

| No | パターン | 説明 |
|---|---|---|
| 1 | 定型メール送信 | DBに登録済みテンプレートを使用してメール作成・送信。テンプレートのプレースホルダ部分は、格納時に業務アプリケーションから指定された文字列に置き換えられる。 |
| 2 | 非定型メール送信 | 任意の件名・本文でメールを作成・送信する。 |

**クラス**: `nablarch.common.mail.MailRecipientTable`

全プロパティ必須。

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メール送信先テーブルの名前 |
| 2 | mailRequestIdColumnName | 要求IDカラムの名前 |
| 3 | serialNumberColumnName | 連番カラムの名前 |
| 4 | recipientTypeColumnName | メール送信区分カラムの名前 |
| 5 | mailAddressColumnName | メールアドレスカラムの名前 |

<details>
<summary>keywords</summary>

定型メール送信, 非定型メール送信, メール送信要求API, TemplateMailContext, FreeTextMailContext, プレースホルダ置換, 最大宛先数, 添付ファイルサイズ精査, 1呼び出し1通, MailRecipientTable, tableName, mailRequestIdColumnName, serialNumberColumnName, recipientTypeColumnName, mailAddressColumnName, メール送信先テーブル

</details>

## メール送信要求実装例

定型メール送信の実装例：

```java
// 定型メール送信要求データオブジェクトを作成する。
TemplateMailContext ctx = new TemplateMailContext();
ctx.setFrom("from@tis.co.jp");
ctx.addTo("to@tis.co.jp");
ctx.addCc("cc@tis.co.jp");
ctx.addBcc("bcc@tis.co.jp");
ctx.setSubject("件名");
ctx.setTemplateId("テンプレートID");
ctx.setLang("ja");

// テンプレートのプレースホルダに対する値を設定する。
ctx.setReplaceKeyValue("name", "名前");
ctx.setReplaceKeyValue("address", "住所");
ctx.setReplaceKeyValue("tel", "電話番号");
// 以下のように値にnullを設定した場合、空文字列で置き換えが行われる。
ctc.setReplaceKeyValue("opeion", null);

// メール送信パターンIDを設定する（テーブルに定義している場合）。
ctx.setMailSendPatternId("00001");

// 添付ファイルを設定する。
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);

// メール送信APIのインスタンスを取得し、メール送信要求を行う。
MailRequester requester = MailUtil.getMailRequester();
String requestId = requester.requestToSend(ctx);
```

**クラス**: `nablarch.common.mail.MailAttachedFileTable`

全プロパティ必須。

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メール添付ファイルテーブルの名前 |
| 2 | mailRequestIdColumnName | 要求IDカラムの名前 |
| 3 | serialNumberColumnName | 連番カラムの名前 |
| 4 | fileNameColumnName | ファイル名カラムの名前 |
| 5 | contentTypeColumnName | Content-Typeカラムの名前 |
| 6 | fileColumnName | 添付ファイルカラムの名前 |

<details>
<summary>keywords</summary>

TemplateMailContext, MailRequester, MailUtil, requestToSend, setReplaceKeyValue, AttachedFile, setMailSendPatternId, addTo, addCc, addBcc, setFrom, setSubject, setTemplateId, setLang, メール送信実装例, MailAttachedFileTable, tableName, mailRequestIdColumnName, serialNumberColumnName, fileNameColumnName, contentTypeColumnName, fileColumnName, メール添付ファイルテーブル

</details>

## nablarch.common.mail.MailTemplateTableの設定(すべて必須)

**クラス**: `nablarch.common.mail.MailTemplateTable`

全プロパティ必須。

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メールテンプレート管理テーブルの名前 |
| 2 | mailTemplateIdColumnName | テンプレートIDカラムの名前 |
| 3 | langColumnName | 言語カラムの名前 |
| 4 | subjectColumnName | 件名カラムの名前 |
| 5 | charsetColumnName | 文字セットカラムの名前 |
| 6 | mailBodyColumnName | 本文カラムの名前 |

<details>
<summary>keywords</summary>

MailTemplateTable, tableName, mailTemplateIdColumnName, langColumnName, subjectColumnName, charsetColumnName, mailBodyColumnName, メールテンプレートテーブル

</details>

## nablarch.common.mail.MailConfigの設定

**クラス**: `nablarch.common.mail.MailConfig`

| No | プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| 1 | mailRequestSbnId | ○ | | メール送信要求IDの採番対象識別ID |
| 2 | recipientTypeTO | | 1 | メール送信先区分(TO) |
| 3 | recipientTypeCC | | 2 | メール送信先区分(CC) |
| 4 | recipientTypeBCC | | 3 | メール送信先区分(BCC) |
| 5 | statusUnsent | | 0 | メール送信ステータス(未送信) |
| 6 | statusSent | | 1 | メール送信ステータス(送信済) |
| 7 | statusFailure | | 9 | メール送信ステータス(送信失敗) |
| 8 | mailRequestCountMessageId | ○ | | メール送信要求件数出力時のメッセージID（メッセージテーブルに対応メッセージが必要）|
| 9 | sendSuccessMessageId | ○ | | メール送信成功時のメッセージID（メッセージテーブルに対応メッセージが必要）|
| 10 | sendFailureCode | ○ | | メール送信失敗時の障害コード（メッセージテーブルに対応メッセージが必要）|
| 11 | abnormalEndExitCode | ○ | | メール送信失敗時の終了コード |

<details>
<summary>keywords</summary>

MailConfig, mailRequestSbnId, recipientTypeTO, recipientTypeCC, recipientTypeBCC, statusUnsent, statusSent, statusFailure, mailRequestCountMessageId, sendSuccessMessageId, sendFailureCode, abnormalEndExitCode, コード値, ステータス定義

</details>

## nablarch.common.mail.MailRequestConfigの設定(すべて必須)

**クラス**: `nablarch.common.mail.MailRequestConfig`

全プロパティ必須。

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | defaultReplyTo | デフォルトの返信先メールアドレス(Reply-To)。メール送信要求時に指定を省略した場合に適用される。|
| 2 | defaultReturnPath | デフォルトの戻し先メールアドレス(Return-Path)。メール送信要求時に指定を省略した場合に適用される。|
| 3 | defaultCharset | デフォルトの文字セット(Charset)。メール送信要求時に指定を省略した場合に適用される。|
| 4 | maxRecipientCount | 最大宛先数。メール送信要求受付時にこの値に基づいた精査が行われる。|
| 5 | maxAttachedFileSize | 添付ファイルサイズ上限値（byte数）。メール送信要求受付時にこの値に基づいた精査が行われる。|

<details>
<summary>keywords</summary>

MailRequestConfig, defaultReplyTo, defaultReturnPath, defaultCharset, maxRecipientCount, maxAttachedFileSize, デフォルト設定, 精査設定, 最大宛先数, 添付ファイルサイズ上限

</details>

## nablarch.common.mail.MailSessionConfigの設定

**クラス**: `nablarch.common.mail.MailSessionConfig`

| No | プロパティ名 | 必須 | 説明 |
|---|---|---|---|
| 1 | mailSmtpHost | ○ | SMTPサーバー名 |
| 2 | mailHost | ○ | 接続ホスト名 |
| 3 | mailSmtpPort | ○ | SMTPポート |
| 4 | mailSmtpConnectionTimeout | ○ | 接続タイムアウト値 |
| 5 | mailSmtpTimeout | ○ | 送信タイムアウト値 |
| 6 | option | | 上記以外のjavax.mail.Sessionのプロパティ。プロパティ名と値のマップ形式で設定する。|

> **注意**: Message-IdヘッダはJavaMailが生成する際にメールセッションの`mail.host`プロパティをドメイン名として使用する。`mailHost`（`mail.host`）の設定を省略した場合、メール送信自体は可能だがRFCに則った正しいMessage-Idヘッダを生成できないため、明示的に設定すること。

<details>
<summary>keywords</summary>

MailSessionConfig, mailSmtpHost, mailHost, mailSmtpPort, mailSmtpConnectionTimeout, mailSmtpTimeout, option, Message-Id, SMTPサーバー, JavaMail Session, mail.host

</details>
