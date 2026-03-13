# メール送信

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/mail.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequestTable.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRecipientTable.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailAttachedFileTable.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailTemplateTable.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailConfig.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequester.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailRequestConfig.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailSessionConfig.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/TinyTemplateEngineMailProcessor.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailUtil.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/FreeTextMailContext.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/TemplateMailContext.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/AttachedFile.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/MailSender.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/mail/InvalidCharacterException.html)

## 機能概要

メール送信はディレードオンライン処理を採用。即時送信ではなく、メール送信要求をDBに格納し、[常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) で非同期送信する。

採用理由:
- メール送信をアプリケーションの業務トランザクションに含められる
- メールサーバ/ネットワーク障害時もアプリケーション処理に影響しない

提供する機能:
- :ref:`メール送信要求をDBに登録する機能<mail-request>`
- :ref:`メール送信要求に基づいてメールを送信するバッチ機能<mail-send>`

アプリケーションがメール送信要求を出す毎に1つのメール送信要求を作成し、メール送信要求1つにつきメールを1通送信する。

> **補足**: 即時メール送信APIは提供していない。即時送信が必要な場合はJavaMailを直接使用すること。

## テンプレートを使った定型メール

同じ文言で一部のみ異なるメール送信向けに、テンプレートのプレースホルダを変換して件名・本文を生成する機能を提供。詳細は:ref:`mail-request`を参照。

> **重要**: Nablarch 5u13からテンプレートエンジンを使用した定型メールがサポートされた。5u12以前の`TinyTemplateEngineMailProcessor`は以下の制限がある:
> - プレースホルダに設定できるのは単純な文字列のみ（構造化オブジェクト不可）
> - 条件分岐・繰り返し等の制御構文が非対応
>
> 既存の定型メール機能の代わりに、以下のテンプレートエンジンを使用することを推奨:
> - [mail_sender_freemarker_adaptor](../adapters/adapters-mail_sender_freemarker_adaptor.md)
> - [mail_sender_thymeleaf_adaptor](../adapters/adapters-mail_sender_thymeleaf_adaptor.md)
> - [mail_sender_velocity_adaptor](../adapters/adapters-mail_sender_velocity_adaptor.md)

## キャンペーンメール等の大量一斉送信非対応

本機能はキャンペーン通知等の一斉送信には対応していない。以下に該当する場合は専用プロダクトの使用を推奨:
- キャンペーン通知やメールマガジンなど大量メールの一括送信
- 配信メールの開封率・クリックカウント計測
- メールアドレスからクライアント種別（フィーチャーフォン等）を判別した送信切り替え

## テーブルレイアウト

**メール送信要求テーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | 一意識別ID |
| メール送信パターンID (任意) | 文字列型 | 未送信データ抽出パターン識別ID（:ref:`mail-mail_send_pattern` 参照） |
| メール送信バッチのプロセスID (任意) | 文字列型 | マルチプロセス実行時の悲観ロック用カラム（:ref:`mail-mail_multi_process` 参照） |
| 件名 | 文字列型 | |
| 送信者メールアドレス | 文字列型 | Fromヘッダ |
| 返信先メールアドレス | 文字列型 | Reply-Toヘッダ |
| 差戻し先メールアドレス | 文字列型 | Return-Pathヘッダ |
| 文字セット | 文字列型 | Content-Typeヘッダ |
| ステータス | 文字列型 | 未送信/送信済/送信失敗のコード値 |
| 要求日時 | タイムスタンプ型 | |
| 送信日時 | タイムスタンプ型 | |
| 本文 | 文字列型 | |

**メール送信先テーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | |
| 連番 (PK) | 数値型 | 1つの送信要求内の連番 |
| 送信先区分 | 文字列型 | TO/CC/BCCのコード値 |
| メールアドレス | 文字列型 | |

**メール添付ファイルテーブル**

| カラム | 型 | 説明 |
|---|---|---|
| メール送信要求ID (PK) | 文字列型 | |
| 連番 (PK) | 数値型 | 1つの送信要求内の連番 |
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
| 文字セット | 文字列型 | 送信時の文字セット |

## テーブルスキーマ設定

**クラス**: `nablarch.common.mail.MailRequestTable`, `nablarch.common.mail.MailRecipientTable`, `nablarch.common.mail.MailAttachedFileTable`, `nablarch.common.mail.MailTemplateTable`

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

> **補足**: `MailRequestTable`の`mailSendPatternIdColumnName`プロパティ（:ref:`mail-mail_send_pattern` 参照）と`sendProcessIdColumnName`プロパティ（:ref:`mail-mail_multi_process` 参照）は任意項目。機能を使用する場合のみ設定する。

## コード値とメッセージ設定

**クラス**: `nablarch.common.mail.MailConfig`

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

## メール送信要求コンポーネント設定

- **クラス**: `nablarch.common.mail.MailRequester`, `nablarch.common.mail.MailRequestConfig`
- コンポーネント名は必ず `mailRequester` と指定する（名前でルックアップされるため）
- [採番](libraries-generator.md) の設定も別途必要

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

> **補足**: `TinyTemplateEngineMailProcessor` は機能が限定的なため、FreeMarkerなどのテンプレートエンジンの使用を推奨する（:ref:`mail-template` 参照）。

## メール送信バッチ設定（SMTPサーバ接続情報）

**クラス**: `nablarch.common.mail.MailSessionConfig`

```xml
<component name="mailSessionConfig" class="nablarch.common.mail.MailSessionConfig">
  <property name="mailSmtpHost" value="localhost" />
  <property name="mailHost" value="localhost" />
  <property name="mailSmtpPort" value="25" />
  <property name="mailSmtpConnectionTimeout" value="100000" />
  <property name="mailSmtpTimeout" value="100000" />
</component>
```

**クラス**: `nablarch.common.mail.MailSender`

`MailSender` は [常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) として動作するバッチアクション。

メール送信処理は、障害発生時に同一のメールが複数送信されないよう二重送信防止の仕組みを備えている。メール送信成功時にはステータスが確実に送信済みとなっているため、二重送信を防止できる。処理の詳細な流れは公式ドキュメントのフロー図を参照。

> **重要**: メール送信失敗時のステータス更新（送信失敗への変更）で例外（例: データベース・ネットワーク障害）が発生した場合、ステータスが送信済みのままとなる。この場合、該当データにパッチを適用（ステータスを送信失敗へ変更）する必要がある。例外にはパッチ適用を促すメッセージが付加されている。

> **補足**: ステータスの更新処理は別トランザクションで実行される。使用するトランザクションのコンポーネント名は `statusUpdateTransaction` としてコンポーネント設定ファイルに登録する必要がある。詳細は [database-new_transaction](libraries-database.md) を参照。

`requestPath` に `MailSender` を指定して起動する:
```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./mail-batch-config.xml \
  -requestPath nablarch.common.mail.MailSender/SENDMAIL00 \
  -userId mailBatchUser
```

未送信データの抽出条件は以下の2つから選択可能:
- テーブル全体から未送信のデータを抽出する
- メール送信パターンID毎に未送信のデータを抽出する（優先度別の送信制御など）

メール送信パターンID毎に抽出する場合、パターンID毎にバッチプロセスを起動し、`-mailSendPatternId` オプションで処理対象のパターンIDを指定する:
```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./mail-batch-config.xml \
  -requestPath nablarch.common.mail.MailSender/SENDMAIL00 \
  -userId mailBatchUser
  -mailSendPatternId 02
```

<details>
<summary>keywords</summary>

メール送信, ディレードオンライン処理, 非同期メール送信, テンプレートエンジン, 定型メール, TinyTemplateEngineMailProcessor, キャンペーンメール, 一斉送信非対応, メール送信要求, 1対1, 1通, MailRequestTable, MailRecipientTable, MailAttachedFileTable, MailTemplateTable, MailConfig, MailRequester, MailRequestConfig, MailSessionConfig, BasicApplicationInitializer, mailSendPatternIdColumnName, sendProcessIdColumnName, mailRequestSbnId, recipientTypeTO, recipientTypeCC, recipientTypeBCC, statusUnsent, statusSent, statusFailure, mailRequestCountMessageId, sendSuccessMessageId, sendFailureCode, abnormalEndExitCode, defaultReplyTo, defaultReturnPath, defaultCharset, maxRecipientCount, maxAttachedFileSize, mailSmtpHost, mailHost, mailSmtpPort, mailSmtpConnectionTimeout, mailSmtpTimeout, メール送信設定, テーブルスキーマ, コード値設定, SMTPサーバ設定, メール送信バッチ設定, MailSender, 常駐バッチ, メール送信バッチ, statusUpdateTransaction, mailSendPatternId, 二重送信防止, メール送信パターンID

</details>

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

## 使用クラス

- `MailRequester`: メール送信要求をDBに登録
- `MailUtil`: `MailRequester` を取得
- `FreeTextMailContext`: 非定型メールの送信要求
- `TemplateMailContext`: 定型メールの送信要求
- `AttachedFile`: 添付ファイル

## 定型メール実装例

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

> **重要**: 定型メールのプレースホルダ値設定時の注意:
> - キーに `null` を指定した場合は例外を送出する
> - 値に `null` を指定した場合は空文字列で置き換える
> - テンプレートのプレースホルダとキー/値の整合性はチェックしない。プレースホルダに値が未設定の場合、プレースホルダが変換されずにメールが送信される。対応するプレースホルダがない値は無視される。

**クラス**: `nablarch.common.mail.MailSender`

例外の種類とエラー処理:

| 例外 | 処理 |
|---|---|
| JavaMailの[AddressException](https://javaee.github.io/javamail/docs/api/javax/mail/internet/AddressException.html)（送信要求のメールアドレス変換時） | 変換失敗アドレスをログ出力（ERROR）し、次のメール送信処理へ |
| `InvalidCharacterException`（:ref:`mail-mail_header_injection` での検出） | ヘッダ文字列をログ出力（ERROR）し、次のメール送信処理へ |
| JavaMailの[SendFailedException](https://javaee.github.io/javamail/docs/api/javax/mail/SendFailedException.html)（メール送信失敗時） | 送信済み・未送信・不正アドレスをログ出力（ERROR）し、次のメール送信処理へ |
| 上記以外の`Exception` | リトライ例外を送出 |

ステータスの送信失敗への更新失敗時、またはリトライ上限到達時は、メール送信バッチが異常終了する。

> **重要**: 送信失敗の検知は、別プロセスでログファイルをチェックするなどして対応する必要がある。

<details>
<summary>keywords</summary>

nablarch-mail-sender, nablarch-common-idgenerator, nablarch-common-idgenerator-jdbc, モジュール依存関係, メール送信モジュール, MailRequester, MailUtil, FreeTextMailContext, TemplateMailContext, AttachedFile, requestToSend, setVariable, メール送信要求登録, 定型メール, 非定型メール, テンプレートメール, プレースホルダ, MailSender, InvalidCharacterException, AddressException, SendFailureException, メール送信エラー処理, リトライ, 送信失敗

</details>

## メール送信をマルチプロセス化する

マルチプロセス化（冗長構成サーバ等）では、メール送信要求テーブルのプロセスIDカラムによる悲観ロックで同一送信要求の重複処理を防ぐ。

設定手順:
1. メール送信要求テーブルにプロセスIDカラムを定義する
2. `MailRequestTable` の `sendProcessIdColumnName` プロパティにプロセスIDカラム名を設定し、コンポーネント定義に追加する
3. プロセスID更新用トランザクションを `mailMultiProcessTransaction` の名前でコンポーネント定義に追加する（設定方法は [database-new_transaction](libraries-database.md) を参照）

> **重要**: 手順2の設定がされていない場合、排他制御がされないため1件のメール送信要求を複数プロセスが処理する可能性がある。見かけ上バッチが動作するため設定漏れを検知しづらい。マルチプロセス化する場合は上記の設定を漏れなく行うこと。

> **重要**: マルチプロセス化の目的は大量メールの分散送信ではなく、冗長構成サーバでの継続稼働。各プロセスが対象とするメールはプロセス起動時点で未送信のメール全て（メール送信パターンIDを指定している場合は該当パターンの未送信メール全て）となり、プロセス間での均等分散は行わない。

<details>
<summary>keywords</summary>

MailRequestTable, sendProcessIdColumnName, mailMultiProcessTransaction, マルチプロセス, 悲観ロック, 排他制御, 冗長構成

</details>

## メールヘッダインジェクション攻撃への対策

メールヘッダインジェクション攻撃への根本的対策:
- メールヘッダは固定値を使用する（外部入力値を使用しない）
- JavaMailを使用する

固定値にできない場合は、プロジェクトで改行コードを変換または除去する対応を行う。

ただし、JavaMailを使用しても、一部のメールヘッダの項目は改行コードが含まれていてもメール送信可能な項目がある。そのため、保険的対策として、これらの項目に改行コードが含まれている場合はメール送信を実施しないチェック機能を設けている。

保険的対策の対象項目（改行コードが含まれている場合はメール送信を実施しない）:
- 件名
- 差し戻し先メールアドレス

改行コードが含まれていた場合は `InvalidCharacterException` を送出し、ログ出力（ERROR）して当該メールを送信失敗として扱う。

<details>
<summary>keywords</summary>

InvalidCharacterException, メールヘッダインジェクション, 改行コード, セキュリティ対策, JavaMail

</details>

## 拡張例

**クラス**: `nablarch.common.mail.MailSender`, `nablarch.common.mail.MailRequester`

**電子署名・暗号化などのカスタマイズ**: `MailSender` を継承したクラスをプロジェクトで作成する。

**送信失敗時のエラー処理変更**（ログレベル変更、リトライ対象例外変更など）: 同様に `MailSender` を継承したクラスを作成する。

**メール送信要求のトランザクションを業務アプリケーションのトランザクションとは独立して指定する場合**（`MailRequester` とメール送信要求IDの [採番](libraries-generator.md) で使用）:

> **補足**: トランザクションマネージャとメール送信要求IDの採番で指定するトランザクション名を同じにする。

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
```

<details>
<summary>keywords</summary>

MailSender, MailRequester, SimpleDbTransactionManager, TableIdGenerator, mailTransactionManager, 電子署名, 暗号化, MailSender継承

</details>
