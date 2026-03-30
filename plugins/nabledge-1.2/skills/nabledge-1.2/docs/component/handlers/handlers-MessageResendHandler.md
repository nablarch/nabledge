# 再送電文制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessageResendHandler`

応答電文の再送処理制御を行うハンドラ。初回電文/再送要求電文の判定は :ref:`フレームワーク制御ヘッダ<fw_header>` 上の再送要求フラグの値で行う。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [MessageReplyHandler](handlers-MessageReplyHandler.md) | 本ハンドラが作成した再送電文オブジェクトを送信する |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 送信済み電文は業務トランザクションと同じトランザクションでコミットするため、このハンドラの後続に配置する |
| [MessagingAction](handlers-MessagingAction.md) | 業務アクションが応答した電文オブジェクトを応答済み電文テーブルに保存する |

**再送制御**: 再送要求電文受信時のシステム状態に応じた挙動:

1. **初回電文が未受信**: 再送要求電文を初回電文として処理する。並行して遅延初回電文が処理される可能性があるが、先にコミットされたトランザクションのみ正常終了し、その他はロールバック。また、ロールバックされた要求の応答として、先に正常終了した電文の応答を再送する。
2. **初回電文を処理中**: 再送要求電文も初回電文として処理し、先に完了したトランザクションをコミット、もう一方をロールバック（1と同じ扱い）。
3. **業務処理は正常終了したが応答電文が未達**: 送信済電文テーブルから当該メッセージIDの電文データを取得し応答電文として送信。業務処理は実行されない。
4. **業務処理が正常終了したがエラー応答電文が未達**: 再送要求電文を初回電文として処理する。

**再送応答機能**: 再送要求電文を受信した際に、送信済電文保存機能が保持する過去の応答電文を再送信する。

**送信済電文保存機能**: 送信に成功した（=ローカルキューに対するPUT命令が完了した）メッセージの内容をDBの送信済電文テーブルに保存する。業務トランザクションとともにコミットされる。業務処理がエラー終了した場合には再送用電文は残らない。

再送電文管理テーブルのスキーマ:

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

MessageResendHandler, nablarch.fw.messaging.handler.MessageResendHandler, SentMessageTableSchema, 再送電文制御, 応答電文再送, 再送要求フラグ, 送信済電文テーブル, SENT_MESSAGE, 再送応答機能, 送信済電文保存機能, MessageReplyHandler, TransactionManagementHandler, MessagingAction

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 要求電文のフレームワーク制御ヘッダから再送要求フラグ（resendFlag）を取得する。
2. (1a) フレームワーク制御ヘッダに再送要求フラグが定義されていない場合、後続ハンドラに処理を移譲し結果を返して終了（本ハンドラは何もしない）。
3. (2) メッセージIDとリクエストIDをキーに送信済電文テーブルを検索し、一致する送信済電文が存在する場合は `ResponseMessage` を作成して返す（業務処理は実行されない）。
4. (2a) 送信済電文が存在しない場合は後続ハンドラに処理を委譲し結果を取得する。

**[復路処理]**

5. (3) 後続ハンドラから返された応答電文を送信済電文テーブルに保存後、応答電文を返す。

**[例外処理]**

6. (3a) 応答電文保存時に一意制約違反エラーが発生した場合は、並行するトランザクションが既に正常終了しているため、送信済電文テーブルから応答電文を取得して返す。
7. (3c) 一意制約違反エラーが発生したにも関わらず送信済電文テーブルに電文が未登録の場合は、元例外を再送出する（通常は発生しえない）。
8. (4) 上記以外の実行時例外・エラーは捕捉せず上位ハンドラに再送出する。

<details>
<summary>keywords</summary>

MessageResendHandler, ResponseMessage, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, 再送要求フラグ, 一意制約違反, resendFlag

</details>

## 設定項目・拡張ポイント

**基本設定**: `fwHeaderDefinition` の設定は必須。

```xml
<!-- フレームワーク制御ヘッダー定義 -->
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition">
  <property name="formatFileName" value="${headerFileName}" />
</component>

<!-- 再送制御ハンドラ -->
<component class="nablarch.fw.messaging.handler.MessageResendHandler">
    <property name="fwHeaderDefinition" ref="fwHeaderDefinition" />
</component>
```

**テーブル名・カラム名の変更**: デフォルトとは異なるテーブル名・カラム名を使用する場合は `sentMessageTableSchema` プロパティを設定する。

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

**再送要求フラグ定義の変更**: デフォルトの再送要求フラグ仕様がプロジェクト要件に合致しない場合はフレームワーク制御ヘッダー定義を拡張する。詳細は「フレームワーク制御ヘッダリーダ」の項を参照。

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

MessageResendHandler, SentMessageTableSchema, StandardFwHeaderDefinition, fwHeaderDefinition, sentMessageTableSchema, tableName, messageIdColumnName, requestIdColumnName, replyQueueColumnName, statusCodeColumnName, テーブル名変更, 再送要求フラグカスタム, CustomFwHeaderDefinition

</details>
