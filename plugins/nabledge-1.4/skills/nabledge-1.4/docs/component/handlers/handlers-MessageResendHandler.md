## 再送電文制御ハンドラ

**クラス名:** `nablarch.fw.messaging.handler.MessageResendHandler`

### 概要

応答電文の再送処理制御を行うハンドラ。

一般に、外部システムに対する要求電文がタイムアウトした場合、
再送要求電文や、取消電文といった補償電文を送信することがある。

本ハンドラではこのうち、再送要求に対する制御をフレームワークレベルで実装しており、
同一メッセージIDの電文を複数回受信した際に、再送制御を実施するものである。

具体的には、 [フレームワーク制御ヘッダ](../../component/libraries/libraries-enterprise-messaging-mom.md#データモデル) 上の **再送要求フラグ** を用いて再送処理対象かどうかの判定を行ったうえで、
応答済み電文テーブルの登録内容を用いて初回電文/再送要求電文の判定を行い、それぞれの判定結果に応じた処理を実行する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| 電文応答制御ハンドラ | nablarch.fw.messaging.handler.MessageReplyHandler | Object | ResponseMessage | - | 後続ハンドラから返される応答電文オブジェクトの内容をもとに電文を作成して送信する。 | エラーオブジェクトの内容をもとに電文を作成して送信する。 | - |
| データリードハンドラ(FW制御ヘッダリーダ/メッセージリーダ利用) | nablarch.fw.handler.DataReadHandler_messaging | Object | Result | 要求電文を受信しFW制御ヘッダ部を解析して要求電文オブジェクト(RequestMessage)を作成し後続のハンドラに渡す。また、FW制御ヘッダのrequestId/userIdの値をメッセージコンテキストに設定する。 | - | - | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| 再送電文制御ハンドラ | nablarch.fw.messaging.handler.MessageResendHandler | RequestMessage | ResponseMessage | 再送要求に対し、以前応答した電文が保存されていれば、その内容をリターンする。(後続ハンドラは実行しない) | 業務トランザクションが正常終了(コミット)された場合のみ電文を保存する | - | - |
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md) | 本ハンドラの作成した再送電文オブジェクトは、 [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md) によって送信される。 |
| [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) | 送信済み電文は、業務トランザクションと同じトランザクションでコミットするので、 [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) の後続にこのハンドラを配置する。 |
| [同期応答電文送信処理用業務アクションハンドラのテンプレートクラス](../../component/handlers/handlers-MessagingAction.md) | 本ハンドラでは、業務アクションが応答した電文オブジェクトを応答済み電文テーブルに 保存する。 |

-----

**再送制御**

本システムに対する処理要求メッセージ(初回電文)が、転送経路上のネットワークエラーや
遅延により外部システム側でタイムアウトし、その補償電文として再送要求電文が送信されたとする。
この際、再送要求電文を受信した時点でのシステムの状態は、以下の4つに分類できる。

1. ネットワークエラーもしくは遅延により、初回電文が未受信。
2. 初回電文を処理中。
3. 初回電文に対する業務処理は正常終了(トランザクションをコミット)したが、
  ネットワークエラーもしくは遅延により応答電文が未達。
4. 初回電文に対する業務処理が異常終了(トランザクションをロールバック)し、
  ネットワークエラーもしくは遅延によりエラー応答電文が未達。

それぞれのケースについて、本システムの挙動は以下のようになる。

1. 初回電文が未受信
  再送要求電文を初回電文として処理する。
  この場合、再送要求電文を処理中に、遅延していた初回電文を並行実行する可能性があるが
  先にコミットされたトランザクションのみ正常終了し、それ以外はロールバックする。
  また、ロールバックされた要求の応答として、先に正常終了した電文の応答を再送する。
2. 本システムで初回電文を処理中
  再送要求電文も初回電文として処理し、先に完了したトランザクションをコミットし、
  もう一方をロールバックする。
  (1.と同じ扱い。)
3. 業務処理は正常終了したが応答電文が未達
  再送用電文テーブルから当該メッセージIDの電文データを取得し、応答電文として送信する。
  業務処理は実行されない。
4. 業務処理が正常終了したがエラー応答電文が未達
  再送要求電文を初回電文として処理する。

本機能は大きく以下の2つの機能によって構成されている。

**1. 再送応答機能**

接続先システムから再送要求電文が送信された場合に、
後述の送信済電文保存機能が保持する過去の応答電文の内容を再送信する機能。

**2. 送信済電文保存機能**

送信に成功した(=ローカルキューに対するPUT命令が完了した)メッセージの内容をデータベース上の
送信済電文テーブルに保存する機能。
送信済電文の内容は業務トランザクションとともにコミットされる。
従って、業務処理がエラー終了した場合には再送用電文は残らない。

再送電文管理テーブルのスキーマ構造として、以下のようなテーブル構造を想定している。

| 論理名 | データ型 |
|---|---|
| メッセージID | VARCHAR PK |
| リクエストID | VARCHAR PK |
| 応答宛先キュー | VARCHAR |
| 処理結果コード | VARCHAR |
| 電文データ部 | BLOB |

下にデフォルト設定でのテーブル名、カラム名に沿ったテーブルスキーマのサンプルを示す。

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

### ハンドラ処理フロー

**[往路処理]**

**1. (再送要求フラグの取得)**

要求電文のフレームワーク制御ヘッダ中の再送要求フラグ(resendFlag)を取得する。

**1a. (再送要求フラグを使用しない電文のスキップ)**

要求電文のフレームワーク制御ヘッダに再送要求フラグが未設定の場合、
本ハンドラではなにもせず、後続のハンドラに処理を移譲し、その結果を返して終了する。

※再送要求フラグが未設定の場合とは、電文内に項目が存在しない場合、
または、存在しても空文字（トリムされて空文字になる場合も含む）の場合を示す。

**2. (再送応答)**

要求電文中のメッセージIDとリクエストIDをキーとして送信済電文テーブルを検索し、
条件に合致する送信済電文が存在した場合は、その内容に沿って [ResponseMessage](../../javadoc/nablarch/fw/messaging/ResponseMessage.html) を作成し、
それを返して終了する。この場合、後続ハンドラへの処理移譲は行なわずに折り返すため
業務処理は実行されない。

※キーとして利用するメッセージIDには、要求電文内に関連メッセージIDが設定されている場合は関連メッセージIDを利用し、
未設定の場合は、要求電文内のメッセージIDを利用する。

**2a. (初回電文の処理が未完→再送要求を初回電文として実行)**

条件に合致する送信済電文が存在しない場合は、後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**3. (正常終了)**

後続のハンドラから返された応答電文を送信済電文テーブルに保存した後、応答電文を返す。

**[例外処理]**

**3a. (並行に処理された電文の応答を再送)**

応答電文を保存した際に、一意制約違反エラーが発生した場合は、並行するトランザクションによって
既に正常終了しているため、送信済電文テーブルから応答電文を取得して返す。

**3c. (エラー応答1)**

一意制約違反エラーが発生したにも関わらず、送信済み電文テーブルに送信電文が登録されていない場合は、
元例外を再送出する。(通常は発生しえない。)

**4. (エラー応答2)**

上記以外のケースで発生した実行時例外・エラーについては、このハンドラでは捕捉せず、
上位のハンドラに再送出される。

### 設定項目・拡張ポイント

* **基本設定**

  要求電文から再送要求フラグを取得する際にフレームワーク制御ヘッダー定義を使用するため、
  必ず設定する必要がある。
  下記の例では、フレームワーク標準のヘッダー定義を使用している。

  ```xml
  <!-- フレームワーク制御ヘッダー定義 -->
  <component name = "fwHeaderDefinition"
             class = "nablarch.fw.messaging.StandardFwHeaderDefinition">
    <property name  = "formatFileName"
              value = "${headerFileName}" />
  </component>
  
  <!-- 再送制御ハンドラ -->
  <component class="nablarch.fw.messaging.handler.MessageResendHandler">
      <property name="fwHeaderDefinition" ref="fwHeaderDefinition" />
  </component>
  ```
* **テーブル名、カラム名の変更**

  命名規約や既存システムとの整合性の確保などの理由により、、
  デフォルト設定とは異なるテーブル名、カラム名を利用する必要がある場合は以下のように設定する。

  ```xml
  <!-- 再送制御ハンドラ -->
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
* **再送要求フラグ定義方法の変更**

  デフォルトの設定での再送要求フラグの仕様が、プロジェクトの要件に合致しない場合は、
  フレームワーク制御ヘッダー定義を拡張する必要がある。

  フレームワーク制御ヘッダー定義の拡張については、「フレームワーク制御ヘッダリーダ」の項を参照すること。

  ```xml
  <!-- フレームワーク制御ヘッダー定義(カスタム定義) -->
  <component name = "customHeaderDefinition"
             class = "example.CustomFwHeaderDefinition">
    <property name  = "formatFileName"
              value = "${headerFileName}" />
  </component>
  
  <!-- 再送制御ハンドラ -->
  <component class="nablarch.fw.messaging.handler.MessageResendHandler">
      <property name="fwHeaderDefinition" ref="customHeaderDefinition" />
  </component>
  ```
