# メール送信

## 概要

メールを送信する機能を提供する。

本フレームワークのメール送信処理は、 [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) を経由し、
業務アプリケーションの処理とは非同期に行う方式を採用している。
その理由は以下の通り。

* 業務アプリケーションから見て、メール送信処理を業務アプリケーションのDBトランザクションに含めることができる。
* メールサーバー障害やネットワーク障害によりメール送信が遅延もしくは失敗しても、業務アプリケーションの処理への影響を与えないようにすることができる。

上記方式を実現するため、本フレームワークは、業務アプリケーションからメール送信の要求データ(以下、メール送信要求)を
受け付けデータベースに格納するAPI(以下、メール送信要求API)と、
メール送信要求に基づいてメールを送信する常駐バッチ(以下、逐次メール送信バッチ)を提供する。

アプリケーションプログラマは、本フレームワークが提供するメール送信要求APIを呼び出すだけでよい。
メール送信要求は、業務アプリケーションがメール送信要求APIを呼び出す毎に一つ作成され、メール送信要求一つにつきメールが一通送信される。

なお、逐次メール送信バッチでは、メール送信ライブラリとして、 [JavaMail API](http://www.oracle.com/technetwork/java/javamail/index.html) を使用する。

本フレームワークのメール送信処理方式の概要を下図に示す。

![mail_overview.jpg](../../../knowledge/assets/libraries-mail/mail_overview.jpg)

## 構造

### クラス図

![09_Mail.jpg](../../../knowledge/assets/libraries-mail/09_Mail.jpg)

### 各クラスの責務

#### メール送信要求API

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.MailRequester | メール送信受付API |
| nablarch.common.mail.MailUtil | MailRequesterインスタンス取得用のユーティリティ |

#### 逐次メール送信バッチアクションクラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.MailSender | 逐次メール送信バッチのアクションクラス  本バッチは、 メール送信要求テーブル から未送信のデータを抽出し、メール送信を行う。 未送信のデータを抽出する際の条件は、テーブル全体から未送信のデータを抽出するか、 メール送信パターンID毎に未送信のデータを抽出するかを選択可能となっている。  メール送信パターンID毎に未送信のデータを抽出する場合には、監視対象のメール送信パターンID毎に 逐次メール送信バッチのプロセスを起動する必要がある。 プロセス起動時には、処理対象のメール送信パターンIDを起動引数に指定する。 詳細は、 処理対象のメール送信パターンID を参照。  また、電子署名を付加したりメール本文を暗号化したメールを送信したい場合には、 本クラスを継承しすることにより実現可能となっている。（詳細は、本クラスのJavaDocコメントを参照）  例えば、以下表のように電子署名を付加したメールと、電子署名なしのメールを扱うようなシステムの場合には、 本クラスでは電子署名なしのメールを送信し、拡張したクラスで電子署名付きのメールを送信すれば良い。  \| メール送信パターンID \| 送信内容 \| 使用するバッチアクション \| \|---\|---\|---\| \| 01 \| 電子署名なし \| 本クラス(MailSender)を使用する。 \| \| 02 \| 電子署名あり \| 本クラスを拡張したバッチアクションを使用する。 \| |

#### メール送信要求データオブジェクト

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.MailContext | メール送信要求を表す抽象クラス |
| nablarch.common.mail.FreeTextMailContext | 非定形メール送信要求を表すクラス |
| nablarch.common.mail.TemplateMailContext | 定型メール送信要求を表すクラス |
| nablarch.common.mail.AttachedFile | メール添付ファイルの情報を保持するクラス |

#### 設定値を保持するクラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.MailRequestConfig | メールのデフォルト設定を保持するクラス |
| nablarch.common.mail.MailConfig | 出力ライブラリ(メール送信)のコード値を保持するクラス |
| nablarch.common.mail.MailSessionConfig | メール送信用設定値を保持するクラス |

#### テーブルのスキーマ情報を保持するクラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.MailRecipientTable | メール送信先管理テーブルのスキーマ情報を保持するクラス |
| nablarch.common.mail.MailRequestTable | メール送信要求管理テーブルのスキーマを保持するクラス |
| nablarch.common.mail.MailAttachedFileTable | 添付ファイル管理テーブルのスキーマ情報を保持するクラス |
| nablarch.common.mail.MailTemplateTable | メールテンプレート管理テーブルのスキーマ情報を保持するクラス |

#### 例外クラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.mail.AttachedFileSizeOverException | 添付ファイルサイズが上限値を超えている場合に発生する例外 |
| nablarch.common.mail.RecipientCountException | 宛先数が不正な場合(宛先なし、もしくは上限数を超えている)に発生する例外 |

### テーブル定義

メール送信機能で使用するテーブル定義を下記に示す。

* テーブル名・カラム名は任意に指定できる。
* データベースの型は、Javaの型に変換可能な型を選択する。

#### メール送信要求テーブル

メール送信要求を管理するテーブル。

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK メール送信要求を一意に識別するID |
| メール送信パターンID | java.lang.String | メールの送信方法のパターンを識別するためのID  本IDの用途などの詳細は、 逐次メール送信バッチアクションクラス を参照。  **本項目は任意項目なので、定義しなくてもメール送信機能は動作する。** |
| 件名 | java.lang.String |  |
| 送信者メールアドレス | java.lang.String | メールのFromヘッダに指定するメールアドレス |
| 返信先メールアドレス | java.lang.String | メールのReply-Toヘッダに指定するメールアドレス |
| 差戻し先メールアドレス | java.lang.String | メールのReturn-Pathヘッダに指定するメールアドレス |
| 文字セット | java.lang.String | メールのContent-Typeヘッダに指定する文字セット |
| ステータス | java.lang.String | メールの送信状態(未送信／送信済／送信失敗)を表すコード値 |
| 要求日時 | java.sql.Timestamp |  |
| 送信日時 | java.sql.Timestamp |  |
| 本文 | java.lang.String |  |

#### メール送信先テーブル

メール送信要求毎の送信先を管理するテーブル。

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK 一つのメール送信要求内の連番 |
| 送信先区分 | java.lang.String | メールの送信先区分(TO／CC／BCC)を表すコード値 |
| メールアドレス | java.lang.String |  |

#### メール添付ファイルテーブル

メール送信要求毎の添付ファイルを管理するテーブル。

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 添付ファイル名 | java.lang.String |  |
| 添付ファイルContent-Type | java.lang.String |  |
| 添付ファイル | byte[] |  |

#### メールテンプレートテーブル

定型メールのメールテンプレートを管理するテーブル。

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メールテンプレートID | java.lang.String | PK |
| 言語 | java.lang.String | PK |
| 件名 | java.lang.String |  |
| 本文 | java.lang.String |  |
| 文字セット | java.lang.String | メール送信時に指定する文字セット |

## メール送信要求API

### メール送信要求

業務アプリケーションがメール送信要求APIを呼び出すと、本フレームワークは、業務アプリケーションから引き渡された内容を、
メール送信要求としてメール送信要求テーブルとその関連テーブル(後述、 [テーブル定義](../../component/libraries/libraries-mail.md#mailtables) 参照)に格納する。
その際、最大宛先数と添付ファイルサイズの精査を行う。

本フレームワークのメール送信要求APIは、下記2パターンのメール送信をサポートしている。

| No | パターン | 説明 |
|---|---|---|
| 1 | 定型メール送信 | 予めデータベースに登録されたテンプレートを元にメールを作成・送信する。 テンプレートの可変部分にはプレースホルダを用意しておくと、 本フレームワークがメール送信要求をテーブルに格納する際に、 各プレースホルダを業務アプリケーションから指定された文字列に 置き換える。 |
| 2 | 非定型メール送信 | 任意の件名・本文でメールを作成・送信する。 |

### メール送信要求実装例

以下に、業務アプリケーションからメール送信要求APIを呼び出す実装例(定型メール送信の場合)を示す。

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

// メール送信パターンIDを設定する。
// 【説明】
// メール送信要求テーブルにメール送信パターンIDを定義している場合は、
// メール送信パターンIDを設定する。
ctx.setMailSendPatternId("00001");

/*
 * 添付ファイルを設定する。
 *
 * 【説明】
 * ファイルを添付する場合は、
 * 添付ファイルのオブジェクトを作成し、設定する。
 * 添付ファイルは、添付ファイルを表すデータオブジェクト
 * nablarch.common.mail.AttachedFileにContent-Typeの指定とともに設定する。
 */
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);

// メール送信APIのインスタンスを取得する。
MailRequester requester = MailUtil.getMailRequester();
// メール送信要求を行う。
String requestId = requester.requestToSend(ctx);
```

## 逐次メール送信バッチ

本フレームワークは [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) に準拠した逐次メール送信バッチ（バッチアクションクラス:nablarch.common.mail.MailSender）を提供し、
アーキテクトによる設定(後述、 [逐次メール送信バッチ用設定項目](../../component/libraries/libraries-mail.md#mailbatchconfig) 参照)のみで使用できる。
このバッチは、メール送信要求テーブルを監視し、メール送信要求があれば逐次メールを送信する。

なお、バッチ起動時の引数として「mailSendPatternId」を指定した場合には、指定されたメール送信パターンIDと一致する送信要求データが監視対象となる。

## 設定の記述

メール送信処理の設定は、リポジトリ機能を使用する。
以下に、メール送信処理の設定方法を記述する。

### 共通設定項目

#### テーブルスキーマ定義

下記4クラスに、上述のテーブルのスキーマ情報を設定する。
また、これら4クラスは初期化処理が必要なInitializableインターフェース実装クラスである。初期化処理が行われるよう設定する。

| クラス | スキーマ情報を保持するテーブル |
|---|---|
| nablarch.common.mail.MailRequestTable | メール送信要求 |
| nablarch.common.mail.MailRecipientTable | メール送信先 |
| nablarch.common.mail.MailAttachedFileTable | メール添付ファイル |
| nablarch.common.mail.MailTemplateTable | メールテンプレート |

設定例は以下の通り。

```xml
<!-- メール送信要求管理テーブルのスキーマ情報 -->
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

<!-- メール送信先管理テーブルのスキーマ情報 -->
<component name="mailRecipientTable" class="nablarch.common.mail.MailRecipientTable">
    <property name="tableName" value="MAIL_RECIPIENT" />
    <property name="mailRequestIdColumnName" value="MAIL_REQUEST_ID" />
    <property name="serialNumberColumnName" value="SERIAL_NUMBER" />
    <property name="recipientTypeColumnName" value="RECIPIENT_TYPE" />
    <property name="mailAddressColumnName" value="MAIL_ADDRESS" />
</component>

<!-- 添付ファイル管理テーブルのスキーマ情報 -->
<component name="mailAttachedFileTable"
    class="nablarch.common.mail.MailAttachedFileTable">
    <property name="tableName" value="MAIL_ATTACHED_FILE" />
    <property name="mailRequestIdColumnName" value="MAIL_REQUEST_ID" />
    <property name="serialNumberColumnName" value="SERIAL_NUMBER" />
    <property name="fileNameColumnName" value="FILE_NAME" />
    <property name="contentTypeColumnName" value="CONTENT_TYPE" />
    <property name="fileColumnName" value="ATTACHED_FILE" />
</component>

<!-- メールテンプレート管理テーブルのスキーマ情報 -->
<component name="mailTemplateTable" class="nablarch.common.mail.MailTemplateTable">
    <property name="tableName" value="MAIL_TEMPLATE" />
    <property name="mailTemplateIdColumnName" value="MAIL_TEMPLATE_ID" />
    <property name="langColumnName" value="LANG" />
    <property name="subjectColumnName" value="SUBJECT" />
    <property name="charsetColumnName" value="CHARSET" />
    <property name="mailBodyColumnName" value="MAIL_BODY" />
</component>

<!-- 初期化設定 -->
<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <!-- 他のコンポーネントは省略 -->
            <component-ref name="mailRequestTable" />
            <component-ref name="mailRecipientTable" />
            <component-ref name="mailAttachedFileTable" />
            <component-ref name="mailTemplateTable" />
        </list>
    </property>
</component>
```

#### コード値とメッセージID

メール送信に使用するコード値、メッセージID、障害コードを、
nablarch.common.mail.MailConfigクラスのプロパティとして設定する。

設定例は以下の通り。

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

### メール送信要求API用設定項目

#### メール送信要求API

業務アプリケーションから呼び出す、メール送信要求APIのコンポーネント(nablarch.common.mail.MailRequester)を設定する。
（業務アプリケーションは、nablarch.common.mail.MailUtilクラスのgetMailRequesterメソッドを使用し、このコンポーネントを取得する。）
プロパティには、以下のコンポーネントを設定する。

* MailRequestConfig
* IdGenerator
* MailRequestTable
* MailRecipientTable
* MailAttachedFileTable
* MailTemplateTable

また、メール送信要求時の設定項目のうち省略可能な項目のデフォルト値と、
メール送信要求受付時の精査に使用するメール1通あたりの最大宛先数と添付ファイルサイズ上限値を、
nablarch.common.mail.MailRequestConfigクラスのプロパティとして設定する。

設定例は以下の通り。

```xml
<!-- メール送信要求コンポーネント -->
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
    <property name="mailRequestConfig" ref="mailRequestConfig" />
    <property name="mailRequestIdGenerator" ref="idGenerator" />
    <property name="mailRequestTable" ref="mailRequestTable" />
    <property name="mailRecipientTable" ref="mailRecipientTable" />
    <property name="mailAttachedFileTable" ref="mailAttachedFileTable" />
    <property name="mailTemplateTable" ref="mailTemplateTable" />
</component>

<!-- メール送信要求時のデフォルト値と精査に使用する値 -->
<component name="mailRequestConfig" class="nablarch.common.mail.MailRequestConfig">
    <!-- デフォルトの返信先メールアドレス -->
    <property name="defaultReplyTo" value="default.reply.to@nablarch.sample" />
    <!-- デフォルトの差戻し先メールアドレス -->
    <property name="defaultReturnPath" value="default.return.path@nablarch.sample" />
    <!-- デフォルトの文字セット -->
    <property name="defaultCharset" value="ISO-2022-JP" />
    <!-- 最大宛先数 -->
    <property name="maxRecipientCount" value="100" />
    <!-- 最大添付ファイルサイズ(byte数で記述) -->
    <property name="maxAttachedFileSize" value="2097152" />
</component>
```

#### メール送信要求ID採番

メール送信要求IDを採番するためのコンポーネントを設定する。

メール送信要求IDの採番には、IdGeneratorを使用する( [採番機能](../../component/libraries/libraries-06-IdGenerator.md#id-generator-top) 参照)。
使用するIdGeneratorコンポーネントは、他の採番用のものと併用してもよい。
IdGeneratorは、メール送信APIのプロパティとして設定する（後述、 [メール送信要求APIのコンポーネント定義](../../component/libraries/libraries-mail.md#mailapicomponentconfig) 参照 ）。

### 逐次メール送信バッチ用設定項目

#### 処理対象のメール送信パターンID

処理対象のメール送信パターンIDは、コマンドライン引数として指定する。

メール送信パターンIDは、 nablarch.common.mail.MailRequestTableの設定 にメール送信パターンIDのカラム名を設定した場合は、設定が必須となる。

コマンドライン引数には、以下の情報を設定すること。

```
パラメータ名 -> mailSendPatternId
パラメータ値 -> 処理対象のメール送信パターンID
```

コマンドライン引数の指定方法は、 [コマンドライン起動引数の扱い](../../component/handlers/handlers-Main.md#parsing-commandline) を参照

#### メールセッション

逐次メール送信バッチが使用する、メール送信時のSMTPサーバーへの接続情報を設定する。

メール・セッションのプロパティ（JavaMail APIのjavax.mail.Sessionオブジェクトに設定するプロパティ）を
nablarch.common.mail.MailSessionConfigクラスのプロパティとして設定する。

設定例は以下の通り。

```xml
<!-- セッション情報 -->
<component name="mailSessionConfig" class="nablarch.common.mail.MailSessionConfig">
    <property name="mailSmtpHost" value="localhost" />
    <property name="mailHost" value="localhost" />
    <property name="mailSmtpPort" value="25" />
    <property name="mailSmtpConnectionTimeout" value="100000" />
    <property name="mailSmtpTimeout" value="100000" />
</component>
```

その他の設定項目については、 [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) の
各ハンドラの設定項目を参照すること。

## 設定項目詳細

### nablarch.common.mail.MailRequestTableの設定

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
| 12 | mailSendPatternIdColumnName | メール送信パターンIDのカラム名(任意)  設定を省略した場合は、メール送信パターンIDは使用しない。 |

### nablarch.common.mail.MailRecipientTableの設定(全て必須)

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メール送信先テーブルの名前 |
| 2 | mailRequestIdColumnName | 要求IDカラムの名前 |
| 3 | serialNumberColumnName | 連番カラムの名前 |
| 4 | recipientTypeColumnName | メール送信区分カラムの名前 |
| 5 | mailAddressColumnName | メールアドレスカラムの名前 |

### nablarch.common.mail.MailAttachedFileTableの設定(すべて必須)

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メール添付ファイルテーブルの名前 |
| 2 | mailRequestIdColumnName | 要求IDカラムの名前 |
| 3 | serialNumberColumnName | 連番カラムの名前 |
| 4 | fileNameColumnName | ファイル名カラムの名前 |
| 5 | contentTypeColumnName | Content-Typeカラムの名前 |
| 6 | fileColumnName | 添付ファイルカラムの名前 |

### nablarch.common.mail.MailTemplateTableの設定(すべて必須)

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | tableName | メールテンプレート管理テーブルの名前 |
| 2 | mailTemplateIdColumnName | テンプレートIDカラムの名前 |
| 3 | langColumnName | 言語カラムの名前 |
| 4 | subjectColumnName | 件名カラムの名前 |
| 5 | charsetColumnName | 文字セットカラムの名前 |
| 6 | mailBodyColumnName | 本文カラムの名前 |

### nablarch.common.mail.MailConfigの設定

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | mailRequestSbnId (必須) | メール送信要求IDの採番対象識別ID。 |
| 2 | recipientTypeTO | メール送信先区分(TO) 。 指定しない場合は"1"。 |
| 3 | recipientTypeCC | メール送信先区分(CC)。 指定しない場合は"2"。 |
| 4 | recipientTypeBCC | メール送信先区分(BCC)。 指定しない場合は"3"。 |
| 5 | statusUnsent | メール送信ステータス(未送信)。 指定しない場合は"0"。 |
| 6 | statusSent | メール送信ステータス(送信済)。 指定しない場合は"1"。 |
| 7 | statusFailure | メール送信ステータス(送信失敗)。 指定しない場合は"9"。 |
| 8 | mailRequestCountMessageId (必須) | メール送信要求件数出力時のメッセージID。 メッセージテーブルにこのIDに対応するメッセージが必要。 |
| 9 | sendSuccessMessageId (必須) | メール送信成功時のメッセージID。 メッセージテーブルにこのIDに対応するメッセージが必要。 |
| 10 | sendFailureCode (必須) | メール送信失敗時の障害コード。 メッセージテーブルにこのIDに対応するメッセージが必要。 |
| 11 | abnormalEndExitCode (必須) | メール送信失敗時の終了コード。 |

### nablarch.common.mail.MailRequestConfigの設定(すべて必須)

| No | プロパティ名 | 説明 |
|---|---|---|
| 1 | defaultReplyTo | デフォルトの返信先メールアドレス(Reply-To)。 メール送信要求時に指定を省略した場合に適用される。 |
| 2 | defaultReturnPath | デフォルトの戻し先メールアドレス(Return-Path)。 メール送信要求時に指定を省略した場合に適用される。 |
| 3 | defaultCharset | デフォルトの文字セット(Charset)。 メール送信要求時に指定を省略した場合に適用される。 |
| 4 | maxRecipientCount | 最大宛先数。 メール送信要求受付時にこの値に基づいた精査が行われる。 |
| 5 | maxAttachedFileSize | 添付ファイルサイズ上限値。 メール送信要求受付時にこの値に基づいた精査が行われる。 |

### nablarch.common.mail.MailSessionConfigの設定

| No | プロパティ名 | 設定内容 |
|---|---|---|
| 1 | mailSmtpHost (必須) | SMTPサーバー名 |
| 2 | mailHost (必須) | 接続ホスト名 |
| 3 | mailSmtpPort (必須) | SMTPポート |
| 4 | mailSmtpConnectionTimeout (必須) | 接続タイムアウト値 |
| 5 | mailSmtpTimeout (必須) | 送信タイムアウト値 |
| 6 | option | 上記以外のjavax.mail.Sessionのプロパティ。 プロパティ名と値のマップ形式で設定する。 |

> **Note:**
> Message-Idヘッダは、JavaMail APIにて生成する。
> JavaMail APIは、Message-IDヘッダ生成時にメール・セッションのmail.hostプロパティをドメイン名として使用する。
> mail.hostプロパティの設定を省略した場合、メール送信自体は可能であるが、RFCに則った正しいMessage-Idヘッダを生成できない。
> そのため、メール・セッションにこのプロパティを明示的に設定する必要がある。
