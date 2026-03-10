# メール送信

## 機能概要

メール送信機能は、ディレードオンライン処理方式を採用している。メール送信を即時に行うのではなく、メール送信要求をDBに格納し、:ref:`常駐バッチ<nablarch_batch-resident_batch>` で非同期にメール送信する。

この方式の理由:
- メール送信をアプリケーションの業務トランザクションに含められる
- メールサーバ・ネットワーク障害時もアプリケーション処理に影響を与えない

提供する2つの機能:
- :ref:`メール送信要求をデータベースに登録する機能<mail-request>`
- :ref:`メール送信要求に基づいてメールを送信するバッチ機能<mail-send>`

メール送信要求1件につきメール1通を送信する。

> **補足**: 即時メール送信APIは提供していない。即時送信が必要な場合は Jakarta Mail を直接使用すること。

## テンプレートを使った定型メール

テンプレートとプレースホルダ変換で件名・本文を作成できる。詳細は :ref:`mail-request` を参照。

> **重要**: Nablarch 5u13からテンプレートエンジンを使用した定型メールがサポートされた。5u12までの `TinyTemplateEngineMailProcessor` は機能が限定的（単純な文字列置換のみ、条件分岐・繰り返し非対応）。以下の高機能テンプレートエンジンの使用を推奨:
> - :ref:`mail_sender_freemarker_adaptor`
> - :ref:`mail_sender_thymeleaf_adaptor`
> - :ref:`mail_sender_velocity_adaptor`

## 大量メール一斉送信非対応

以下のケースには本機能を使用せず、専用プロダクトの使用を推奨:
- キャンペーン通知・メールマガジンなど大量メールの一括送信
- 開封率・クリックカウントの効果測定
- メールアドレスによるクライアント判別と送信メール切り替え

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-mail-sender</artifactId>
</dependency>

<!-- メール送信要求IDの採番に使用する -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-idgenerator</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-idgenerator-jdbc</artifactId>
</dependency>
```

## メール送信を使うための設定

メール送信機能はデータベースでメール送信データを管理する。以下の4テーブルが必要。

**メール送信要求テーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | メール送信要求を一意に識別するID |
| メール送信パターンID（任意） | 文字列型 | 送信方法パターン識別ID（:ref:`mail-mail_send_pattern` 参照） |
| メール送信バッチのプロセスID（任意） | 文字列型 | マルチプロセス実行時の悲観ロック用カラム（:ref:`mail-mail_multi_process` 参照） |
| 件名 | 文字列型 | |
| 送信者メールアドレス | 文字列型 | Fromヘッダのメールアドレス |
| 返信先メールアドレス | 文字列型 | Reply-Toヘッダのメールアドレス |
| 差戻し先メールアドレス | 文字列型 | Return-Pathヘッダのメールアドレス |
| 文字セット | 文字列型 | Content-Typeヘッダの文字セット |
| ステータス | 文字列型 | 送信状態（未送信／送信済／送信失敗）のコード値 |
| 要求日時 | タイムスタンプ型 | |
| 送信日時 | タイムスタンプ型 | |
| 本文 | 文字列型 | |

**メール送信先テーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | |
| 連番 (PK) | 数値型 | 1つのメール送信要求内の連番 |
| 送信先区分 | 文字列型 | 送信先区分（TO／CC／BCC）のコード値 |
| メールアドレス | 文字列型 | |

**メール添付ファイルテーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | |
| 連番 (PK) | 数値型 | 1つのメール送信要求内の連番 |
| 添付ファイル名 | 文字列型 | |
| Content-Type | 文字列型 | |
| 添付ファイル | バイト配列型 | |

**メールテンプレートテーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メールテンプレートID (PK) | 文字列型 | |
| 言語 (PK) | 文字列型 | |
| 件名 | 文字列型 | |
| 本文 | 文字列型 | |
| 文字セット | 文字列型 | メール送信時に指定する文字セット |

## テーブルスキーマ設定

以下のクラスをコンポーネント定義に追加し、initializerの`initializeList`に登録する:
- `MailRequestTable`（メール送信要求テーブル）
- `MailRecipientTable`（メール送信先テーブル）
- `MailAttachedFileTable`（添付ファイルテーブル）
- `MailTemplateTable`（メールテンプレートテーブル）

```xml
<component name="mailRequestTable" class="nablarch.common.mail.MailRequestTable" />
<component name="mailRecipientTable" class="nablarch.common.mail.MailRecipientTable" />
<component name="mailAttachedFileTable" class="nablarch.common.mail.MailAttachedFileTable" />
<component name="mailTemplateTable" class="nablarch.common.mail.MailTemplateTable" />
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

> **補足**: `MailRequestTable`の`mailSendPatternIdColumnName`（:ref:`mail-mail_send_pattern` 参照）と`sendProcessIdColumnName`（:ref:`mail-mail_multi_process` 参照）は任意項目。使用する場合のみ設定する。

## コード値とメッセージ設定（MailConfig）

`MailConfig` をコンポーネント定義に追加する。

```xml
<component name="mailConfig" class="nablarch.common.mail.MailConfig">
  <property name="mailRequestSbnId" value="MAIL_REQUEST_ID" />
  <property name="recipientTypeTO" value="0" />
  <property name="recipientTypeCC" value="1" />
  <property name="recipientTypeBCC" value="2" />
  <property name="statusUnsent" value="0" />
  <property name="statusSent" value="1" />
  <property name="statusFailure" value="2" />
  <property name="mailRequestCountMessageId" value="mail.request.count" />
  <property name="sendSuccessMessageId" value="mail.send.success" />
  <property name="sendFailureCode" value="mail.send.failure" />
  <property name="abnormalEndExitCode" value="199" />
</component>
```

## メール送信要求設定（MailRequester・MailRequestConfig）

`MailRequester` と `MailRequestConfig` をコンポーネント定義に追加する。

- `MailRequester`は名前でルックアップされるため、コンポーネント名を`mailRequester`とすること。
- `MailRequester`はメール送信要求IDの生成に :ref:`採番<generator>` を使用するため、:ref:`採番<generator>` の設定も別途必要。

```xml
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="mailRequestConfig" ref="mailRequestConfig" />
  <property name="mailRequestIdGenerator" ref="idGenerator" />
  <property name="mailRequestTable" ref="mailRequestTable" />
  <property name="mailRecipientTable" ref="mailRecipientTable" />
  <property name="mailAttachedFileTable" ref="mailAttachedFileTable" />
  <property name="templateEngineMailProcessor">
    <component class="nablarch.common.mail.TinyTemplateEngineMailProcessor">
      <property name="mailTemplateTable" ref="mailTemplateTable" />
    </component>
  </property>
</component>
<component name="mailRequestConfig" class="nablarch.common.mail.MailRequestConfig">
  <property name="defaultReplyTo" value="default.reply.to@nablarch.sample" />
  <property name="defaultReturnPath" value="default.return.path@nablarch.sample" />
  <property name="defaultCharset" value="ISO-2022-JP" />
  <property name="maxRecipientCount" value="100" />
  <property name="maxAttachedFileSize" value="2097152" />
</component>
```

> **補足**: `TinyTemplateEngineMailProcessor`は機能が限定的なため、FreeMarkerなどのテンプレートエンジンの使用を推奨する（:ref:`mail-template` 参照）。

## メール送信バッチ設定（MailSessionConfig）

`MailSessionConfig` でSMTPサーバへの接続情報を設定する。

```xml
<component name="mailSessionConfig" class="nablarch.common.mail.MailSessionConfig">
  <property name="mailSmtpHost" value="localhost" />
  <property name="mailHost" value="localhost" />
  <property name="mailSmtpPort" value="25" />
  <property name="mailSmtpConnectionTimeout" value="100000" />
  <property name="mailSmtpTimeout" value="100000" />
</component>
```

## メール送信要求を登録する

**クラス**: `MailRequester`, `MailUtil`, `FreeTextMailContext`, `TemplateMailContext`, `AttachedFile`

非定型メール（`FreeTextMailContext`）と定型メール（`TemplateMailContext`）の2種類に対応。

定型メールの実装例:

```java
TemplateMailContext mailRequest = new TemplateMailContext();
mailRequest.setFrom("from@tis.co.jp");
mailRequest.addTo("to@tis.co.jp");
mailRequest.addCc("cc@tis.co.jp");
mailRequest.addBcc("bcc@tis.co.jp");
mailRequest.setSubject("件名");
mailRequest.setTemplateId("テンプレートID");
mailRequest.setLang("ja");

mailRequest.setVariable("name", "名前");
mailRequest.setVariable("address", "住所");
mailRequest.setVariable("tel", "電話番号");
// 値にnullを設定した場合、空文字列で置き換えが行われる
mailRequest.setVariable("opeion", null);

AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
mailRequest.addAttachedFile(attachedFile);

MailRequester requester = MailUtil.getMailRequester();
String mailRequestId = requester.requestToSend(mailRequest);
```

> **重要**: テンプレートのプレースホルダ変数設定時の注意:
> - キーに`null`を指定した場合は例外を送出する
> - 値に`null`を指定した場合、空文字列で置き換える
> - テンプレートのプレースホルダとキー/値の整合性チェックは行わない。プレースホルダに対応する値が未設定の場合、プレースホルダが変換されずにメールが送信される。対応するプレースホルダがない値は無視されてメールが送信される。

## メールを送信する(メール送信バッチを実行する)

**クラス**: `nablarch.common.mail.MailSender`

`MailSender` は :ref:`常駐バッチ<nablarch_batch-resident_batch>` として動作するバッチアクション。障害発生時に同一メールが複数送信されないよう、メール送信成功時にステータスが確実に送信済みとなる処理フローにより二重送信を防止する。

![メール送信バッチの処理フロー](../../knowledge/component/libraries/assets/libraries-mail/mail_sender_flow.png)

> **重要**: 送信失敗時のステータス更新（送信失敗への変更）で例外（例: DB/ネットワーク障害時）が発生した場合、ステータスが送信済みのままになる。この場合は該当データにパッチを適用（ステータスを送信失敗へ変更）する必要がある。なお、例外にはパッチ適用を促すメッセージが付加されている。

> **補足**: ステータス更新処理は別トランザクションで実行される。このトランザクションのコンポーネント名は `statusUpdateTransaction` としてコンポーネント設定ファイルに登録する必要がある。詳細は :ref:`database-new_transaction` を参照。

実行例（`requestPath` オプションに `MailSender` を指定）。詳細は :ref:`main-run_application` を参照。

```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./mail-batch-config.xml \
  -requestPath nablarch.common.mail.MailSender/SENDMAIL00 \
  -userId mailBatchUser
```

未送信データ抽出条件は以下の2つから選択可能:
- テーブル全体から未送信データを抽出する
- メール送信パターンID毎に未送信データを抽出する

メール送信パターンIDを使うケースとしては、例えば、送信までの時間をできるだけ短くしたい優先度が高いメールと、1時間に1回程度の間隔で送信すればよい優先度の低いメールを扱うようなシステムが考えられる。

メール送信パターンID毎に抽出する場合は、対象パターンID毎にバッチプロセスを起動し、`mailSendPatternId` オプションで対象パターンIDを指定する。

```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./mail-batch-config.xml \
  -requestPath nablarch.common.mail.MailSender/SENDMAIL00 \
  -userId mailBatchUser
  -mailSendPatternId 02
```

## メール送信時のエラー処理

`MailSender` は例外の種類に応じて以下の処理を行う。外部入力データ（アドレスやヘッダ）に起因する例外やメール送信失敗例外が発生した場合は、対象のメール送信要求のステータスを送信失敗にして次のメール送信処理を行う。上記以外の例外が発生した場合は、メール送信要求のステータスを送信失敗にしてリトライする。

| 例外 | 処理 |
|---|---|
| `AddressException` (送信要求のアドレス変換時) | 変換失敗アドレスをログ出力(ERROR)し、次のメール送信処理に進む |
| `InvalidCharacterException` (:ref:`mail-mail_header_injection`) | ヘッダ文字列をログ出力(ERROR)し、次のメール送信処理に進む |
| `SendFailedException` (メール送信失敗時) | 送信済み/未送信/不正アドレスをログ出力(ERROR)し、次のメール送信処理に進む |
| 上記以外の `Exception` | メール送信要求のステータスを送信失敗にしてリトライ例外を送出 |

ステータスの送信失敗への更新に失敗した場合、またはリトライ上限に達した場合、メール送信バッチは異常終了する。

> **重要**: 送信失敗の検知は、別プロセスでログファイルをチェックするなどして対応する必要がある。

ログ出力処理やリトライ処理を変更したい場合は :ref:`mail-mail_extension_sample` を参照。

## メール送信をマルチプロセス化する

メール送信要求テーブルのプロセスIDカラムを使用した悲観ロックにより、複数プロセスが同一送信要求を処理しないようにする。

以下の設定が必要:
1. メール送信要求テーブルにメール送信バッチのプロセスIDのカラムを定義する
2. `MailRequestTable` の `sendProcessIdColumnName` プロパティにプロセスIDのカラム名を設定し、コンポーネント定義に追加する
3. プロセスID更新用のトランザクションを `mailMultiProcessTransaction` の名前でコンポーネント定義に追加する（:ref:`database-new_transaction` 参照）

> **重要**: 2. の設定がされていない場合、排他制御がされないため1件のメール送信要求を複数プロセスが処理する可能性がある。見かけ上メール送信バッチが動作するため設定漏れを検知しづらい。メール送信をマルチプロセス化する場合は上記の設定を漏れなく行うこと。

> **重要**: マルチプロセス化の目的は大量メールの分散送信ではなく（:ref:`do-not-use-for-campaign-mail` 参照）、冗長構成のサーバで一部に障害が発生してもメール送信を継続できることである。各プロセスが送信対象とするメールはプロセス起動時点での未送信メール全てであり（メール送信パターンIDを指定している場合は該当パターンIDのうち未送信メール全て）、プロセス間での均等分散は行わない。

## メールヘッダインジェクション攻撃への対策

メールヘッダインジェクション攻撃への根本的対策として以下を実施する:
- メールヘッダは固定値を使用する。外部からの入力値は使用しない。
- プログラミング言語の標準API（JavaではJavaMail）を使用してメールを送信する。

固定値にできない場合は、プロジェクトで改行コードを変換または除去する対応を行う。

ただし、JavaMailを使用しても、一部のメールヘッダの項目に改行コードが含まれていてもメール送信可能な項目がある。そのため、保険的対策として、これらの項目に対して改行コードが含まれている場合はメール送信を実施しないチェック機能を設けている。改行コードが含まれていた場合は `InvalidCharacterException` を送出してログ出力(ERROR)し、該当メールは送信失敗として扱う。

対象項目:
- 件名
- 差し戻し先メールアドレス

## 拡張例

**電子署名付加・メール本文暗号化などの送信処理変更**

`MailSender` を継承したクラスをプロジェクトで作成する。詳細は `MailSenderのJavadoc` を参照。

**メール送信失敗時の処理変更**（ログレベル変更・リトライ対象の例外変更など。詳細は :ref:`mail-mail_error_process` 参照）

`MailSender` を継承したクラスを作成して対応する。

**メール送信要求時のトランザクション指定**

`MailRequester` の `mailTransactionManager` プロパティにトランザクションマネージャを設定する。トランザクションマネージャと :ref:`採番<generator>` で指定するトランザクション名を同じにする。

```xml
<!-- メール送信要求コンポーネント -->
<component name="mailRequester" class="nablarch.common.mail.MailRequester">
  <property name="mailTransactionManager" ref="txManager" />
</component>

<!-- トランザクションマネージャ -->
<component name="txManager" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="dbTransactionName" value="mail-transaction" />
</component>

<!-- メール送信要求IDジェネレータ -->
<component name="mailRequestIdGenerator"
    class="nablarch.common.idgenerator.TableIdGenerator">
  <property name="dbTransactionName" value="mail-transaction" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <!-- TableIdGeneratorは初期化が必要 -->
      <component-ref name="mailRequestIdGenerator" />
    </list>
  </property>
</component>
```
