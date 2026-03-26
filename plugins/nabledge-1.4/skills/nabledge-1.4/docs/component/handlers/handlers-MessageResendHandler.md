# 再送電文制御ハンドラ

## 概要

**クラス**: `nablarch.fw.messaging.handler.MessageResendHandler`

応答電文の再送処理制御を行うハンドラ。:ref:`フレームワーク制御ヘッダ<fw_header>` 上の **再送要求フラグ** を用いて再送処理対象かどうかを判定し、応答済み電文テーブルの登録内容で初回電文/再送要求電文を判定して処理を実行する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [MessageReplyHandler](handlers-MessageReplyHandler.md) | 本ハンドラの作成した再送電文オブジェクトを送信する |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 送信済み電文は業務トランザクションと同じトランザクションでコミットするため、このハンドラの後続に配置する |
| [MessagingAction](handlers-MessagingAction.md) | 業務アクションが応答した電文オブジェクトを応答済み電文テーブルに保存する |

**再送制御の4ケース**

再送要求電文受信時のシステム状態と挙動:

1. **初回電文が未受信**: 再送要求電文を初回電文として処理する。並行して遅延初回電文を受信した場合、先にコミットされたトランザクションのみ正常終了し、他はロールバック。ロールバックされた要求への応答として、先に正常終了した電文の応答を再送する。
2. **初回電文処理中**: 再送要求電文も初回電文として処理し、先に完了したトランザクションをコミット、もう一方をロールバック（1と同じ扱い）。
3. **業務処理は正常終了したが応答電文が未達**: 再送用電文テーブルから当該メッセージIDの電文データを取得し応答電文として送信。業務処理は実行しない。
4. **業務処理が異常終了しエラー応答電文が未達**: 再送要求電文を初回電文として処理する。

**機能構成**

- **再送応答機能**: 再送要求電文受信時に、送信済電文保存機能が保持する過去の応答電文の内容を再送信する。
- **送信済電文保存機能**: 送信に成功したメッセージの内容をデータベース上の送信済電文テーブルに保存する。業務トランザクションと共にコミットされるため、業務処理がエラー終了した場合には再送用電文は残らない。

**再送電文管理テーブルスキーマ**

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

MessageResendHandler, nablarch.fw.messaging.handler.MessageResendHandler, StandardFwHeaderDefinition, 再送電文制御, 再送要求フラグ, 送信済電文テーブル, 応答電文再送, 再送応答機能, 送信済電文保存機能, MessageReplyHandler, TransactionManagementHandler, MessagingAction

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 再送要求フラグ取得: 要求電文のフレームワーク制御ヘッダ中の `resendFlag` を取得する。
2. 再送要求フラグ未設定の場合: 本ハンドラは何もせず後続ハンドラに移譲してその結果を返す（フラグが未設定 = 項目が存在しない、または空文字の場合）。
3. 再送応答: メッセージIDとリクエストIDをキーとして送信済電文テーブルを検索し、合致する送信済電文が存在した場合はその内容で `ResponseMessage` を作成して返す（後続ハンドラへの処理移譲は行わず業務処理は実行されない）。キーのメッセージIDは、関連メッセージIDが設定されている場合はそちらを優先する。
4. 送信済電文が存在しない場合: 後続ハンドラに処理を委譲し結果を取得する。

**[復路処理]**

3. 正常終了: 後続ハンドラから返された応答電文を送信済電文テーブルに保存した後、応答電文を返す。

**[例外処理]**

3a. 一意制約違反: 応答電文保存時に一意制約違反エラーが発生した場合、並行トランザクションによって既に正常終了しているため、送信済電文テーブルから応答電文を取得して返す。
3c. 一意制約違反かつ送信済電文未登録: 送信済電文テーブルに送信電文が登録されていない場合は元例外を再送出する（通常は発生しえない）。
4. その他の実行時例外: 本ハンドラでは捕捉せず上位ハンドラに再送出する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 再送応答, 一意制約違反, 往路処理, 復路処理, resendFlag, ResponseMessage

</details>

## 設定項目・拡張ポイント

**基本設定**

`fwHeaderDefinition` プロパティは必須。

```xml
<!-- フレームワーク制御ヘッダー定義 -->
<component name="fwHeaderDefinition"
           class="nablarch.fw.messaging.StandardFwHeaderDefinition">
  <property name="formatFileName"
            value="${headerFileName}" />
</component>

<!-- 再送制御ハンドラ -->
<component class="nablarch.fw.messaging.handler.MessageResendHandler">
    <property name="fwHeaderDefinition" ref="fwHeaderDefinition" />
</component>
```

**テーブル名・カラム名の変更**

デフォルト設定と異なるテーブル名・カラム名を利用する場合は `sentMessageTableSchema` プロパティを設定する:

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

**再送要求フラグ定義方法の変更**

デフォルトの再送要求フラグ仕様がプロジェクト要件に合致しない場合は、フレームワーク制御ヘッダー定義を拡張する（詳細は「フレームワーク制御ヘッダリーダ」参照）:

```xml
<component name="customHeaderDefinition"
           class="example.CustomFwHeaderDefinition">
  <property name="formatFileName"
            value="${headerFileName}" />
</component>

<component class="nablarch.fw.messaging.handler.MessageResendHandler">
    <property name="fwHeaderDefinition" ref="customHeaderDefinition" />
</component>
```

<details>
<summary>keywords</summary>

StandardFwHeaderDefinition, nablarch.fw.messaging.StandardFwHeaderDefinition, SentMessageTableSchema, nablarch.fw.messaging.tableschema.SentMessageTableSchema, fwHeaderDefinition, sentMessageTableSchema, テーブル名変更, カラム名変更, 再送要求フラグカスタマイズ, messageIdColumnName, requestIdColumnName, tableName, replyQueueColumnName, statusCodeColumnName

</details>
