# 再送電文制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessageResendHandler`

応答電文の再送処理制御ハンドラ。:ref:`フレームワーク制御ヘッダ<fw_header>` 上の再送要求フラグで初回電文/再送要求電文を判定する。

**関連ハンドラ**:
- [MessageReplyHandler](handlers-MessageReplyHandler.md) — 本ハンドラが作成した再送電文オブジェクトを送信する
- [TransactionManagementHandler](handlers-TransactionManagementHandler.md) — 送信済み電文は業務トランザクションと同じトランザクションでコミットするため、このハンドラの後続に配置する
- [MessagingAction](handlers-MessagingAction.md) — 業務アクションが応答した電文オブジェクトを応答済み電文テーブルに保存する

**再送制御**: 再送要求電文受信時のシステム状態は4ケースに分類される:
1. **初回電文が未受信**: 再送要求電文を初回電文として処理する。並行実行の場合、先にコミットされたトランザクションのみ正常終了し、他はロールバック。ロールバックされた要求の応答として先に正常終了した電文の応答を再送する。
2. **初回電文を処理中**: ケース1と同じ扱い（先に完了したトランザクションをコミット、他はロールバック）。
3. **業務処理正常終了だが応答電文が未達**: 送信済電文テーブルから該当メッセージIDの電文データを取得し応答電文として送信。業務処理は実行されない。
4. **業務処理異常終了でエラー応答電文が未達**: 再送要求電文を初回電文として処理する。

**主要機能**:
- **再送応答機能**: 送信済電文保存機能が保持する過去の応答電文を再送信する。
- **送信済電文保存機能**: 送信成功メッセージをDBの送信済電文テーブルに保存する。業務トランザクションとともにコミット。業務処理がエラー終了した場合は再送用電文は残らない。

**送信済電文テーブルスキーマ**:
| 論理名 | データ型 |
|---|---|
| メッセージID | VARCHAR PK |
| リクエストID | VARCHAR PK |
| 応答宛先キュー | VARCHAR |
| 処理結果コード | VARCHAR |
| 電文データ部 | BLOB |

```sql
CREATE TABLE SENT_MESSAGE (
  MESSAGE_ID  VARCHAR(64)
, REQUEST_ID  VARCHAR(64)
, REPLY_QUEUE VARCHAR(64)
, STATUS_CODE CHAR(4)
, BODY_DATA   BLOB
, CONSTRAINT pk_SENT_MESSAGE 
    PRIMARY KEY(MESSAGE_ID, REQUEST_ID)
);
```

<details>
<summary>keywords</summary>

MessageResendHandler, nablarch.fw.messaging.handler.MessageResendHandler, MessageReplyHandler, TransactionManagementHandler, MessagingAction, 再送電文制御, 送信済電文テーブル, 再送要求フラグ, 応答電文再送, 送信済電文保存

</details>

## ハンドラ処理フロー

**[往路処理]**
1. フレームワーク制御ヘッダから再送要求フラグ(resendFlag)を取得する。
1a. 再送要求フラグが定義されていない電文の場合、本ハンドラはなにもせず後続ハンドラに委譲してその結果を返す。
2. メッセージIDとリクエストIDをキーに送信済電文テーブルを検索し、合致する送信済電文が存在した場合は `ResponseMessage` を作成して返す（後続ハンドラへの委譲は行わず、業務処理は実行されない）。
2a. 送信済電文が存在しない場合は後続ハンドラに処理を委譲し結果を取得する。

**[復路処理]**
3. 後続ハンドラから返された応答電文を送信済電文テーブルに保存した後、応答電文を返す。

**[例外処理]**
3a. 応答電文保存時に一意制約違反エラーが発生した場合は、並行トランザクションによって既に正常終了しているため、送信済電文テーブルから応答電文を取得して返す。
3c. 一意制約違反にもかかわらず送信済電文テーブルに電文が登録されていない場合は元例外を再送出する（通常は発生しない）。
4. その他の実行時例外・エラーは本ハンドラでは捕捉せず上位ハンドラに再送出する。

<details>
<summary>keywords</summary>

ResponseMessage, 往路処理, 復路処理, 例外処理, 再送要求フラグ取得, 一意制約違反, 送信済電文テーブル検索, resendFlag

</details>

## 設定項目・拡張ポイント

**基本設定（必須）**: フレームワーク制御ヘッダー定義を使用するため必ず設定する。

```xml
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition">
  <property name="formatFileName" value="${headerFileName}" />
</component>

<component class="nablarch.fw.messaging.handler.MessageResendHandler">
  <property name="fwHeaderDefinition" ref="fwHeaderDefinition" />
</component>
```

**テーブル名・カラム名の変更**: デフォルト設定と異なる名前を使用する場合は `sentMessageTableSchema` プロパティに `nablarch.fw.messaging.tableschema.SentMessageTableSchema` を設定する。

| プロパティ名 | 説明 |
|---|---|
| tableName | テーブル名 |
| messageIdColumnName | メッセージIDカラム名 |
| requestIdColumnName | リクエストIDカラム名 |
| replyQueueColumnName | 応答宛先キューカラム名 |
| statusCodeColumnName | 処理結果コードカラム名 |

```xml
<component class="nablarch.fw.messaging.handler.MessageResendHandler">
  <property name="fwHeaderDefinition" ref="fwHeaderDefinition" />
  <property name="sentMessageTableSchema">
    <component class="nablarch.fw.messaging.tableschema.SentMessageTableSchema">
      <property name="tableName"            value="TBL_SENT_MESSAGE" />
      <property name="messageIdColumnName"  value="CLM_MESSAGE_ID" />
      <property name="requestIdColumnName"  value="CLM_REQUEST_ID" />
      <property name="replyQueueColumnName" value="CLM_REPLY_QUEUE" />
      <property name="statusCodeColumnName" value="CLM_STATUS_CODE" />
    </component>
  </property>
</component>
```

**再送要求フラグ定義方法の変更**: デフォルトの再送要求フラグ仕様がプロジェクト要件に合致しない場合は、フレームワーク制御ヘッダー定義を拡張してカスタム実装を設定する。

```xml
<component name="customHeaderDefinition"
           class="example.CustomFwHeaderDefinition">
  <property name="formatFileName" value="${headerFileName}" />
</component>

<component class="nablarch.fw.messaging.handler.MessageResendHandler">
  <property name="fwHeaderDefinition" ref="customHeaderDefinition" />
</component>
```

<details>
<summary>keywords</summary>

StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, SentMessageTableSchema, nablarch.fw.messaging.tableschema.SentMessageTableSchema, fwHeaderDefinition, sentMessageTableSchema, tableName, messageIdColumnName, requestIdColumnName, replyQueueColumnName, statusCodeColumnName, テーブル名変更, カラム名変更, 再送要求フラグ定義変更, フレームワーク制御ヘッダー定義

</details>
