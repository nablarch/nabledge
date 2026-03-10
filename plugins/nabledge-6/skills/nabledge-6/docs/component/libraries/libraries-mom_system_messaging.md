# MOMメッセージング

## 機能概要

MOMを使ったメッセージの送受信を行う機能を提供する。なお、ここでは、MOMメッセージングに使うメッセージキューのことをMQと称す。

MOMメッセージングでは、:ref:`mom_system_messaging-data_model` に示したデータモデルを前提としている。また、メッセージのフォーマットには、:ref:`data_format` を使用する。

> **重要**: :ref:`フレームワーク制御ヘッダ<mom_system_messaging-fw_header>` はNablarch独自の項目で、:ref:`メッセージボディ<mom_system_messaging-message_body>` に含めることを想定している。外部システムで電文フォーマットが既に規定されている場合はこの想定が適合しないことがある。その場合は :ref:`mom_system_messaging-change_fw_header` を参照してプロジェクトで実装を追加する。

MOMメッセージングは送受信の種類により実行制御基盤が異なる:

| 送受信の種類 | 実行制御基盤 |
|---|---|
| :ref:`応答不要メッセージ送信<mom_system_messaging-async_message_send>` | :ref:`nablarch_batch` |
| :ref:`同期応答メッセージ送信<mom_system_messaging-sync_message_send>` | 実行制御基盤に依存しない |
| :ref:`応答不要メッセージ受信<mom_system_messaging-async_message_receive>` | :ref:`mom_messaging` |
| :ref:`同期応答メッセージ受信<mom_system_messaging-sync_message_receive>` | :ref:`mom_messaging` |

### 多様なMOMに対応できる

多様なMOMに対応するため `MessagingProvider` インタフェースを設けている。MQ接続やメッセージ送受信はこのインタフェースを実装したクラスが行うため、実装クラスを作成することで様々なMOMで使用できる。

Jakarta Messagingに対応しており、`JmsMessagingProvider` を提供している。

IBM MQにも対応している。詳細は :ref:`webspheremq_adaptor` を参照。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-mom</artifactId>
</dependency>
```

## MOMメッセージングを使うための設定

以下のクラスをコンポーネント定義に追加する:

- `MessagingProvider` の実装クラス（MQ接続・MQに対する送受信）
- :ref:`messaging_context_handler`（MQ接続の管理）

```xml
<!-- MessagingProviderの実装クラス -->
<component name="messagingProvider"
           class="nablarch.fw.messaging.provider.JmsMessagingProvider">
  <!-- 設定項目はJavadocを参照 -->
</component>

<!-- メッセージングコンテキスト管理ハンドラ -->
<component name="messagingContextHandler"
           class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>
```

メッセージ受信の場合は追加でデータリーダの設定が必要:

- `MessageReader`（MQから電文の読み込み）
- `FwHeaderReader`（電文からフレームワーク制御ヘッダの読み込み）

ポイント:
- データリーダのコンポーネント名には `dataReader` を指定する
- `MessageReader` は `FwHeaderReader` の `messageReader` プロパティに指定する

```xml
<component name="dataReader"
           class="nablarch.fw.messaging.reader.FwHeaderReader">
  <property name="messageReader">
    <component class="nablarch.fw.messaging.reader.MessageReader">
      <!-- 設定項目はJavadocを参照 -->
    </component>
  </property>
</component>
```

## 応答不要でメッセージを送信する(応答不要メッセージ送信)

![応答不要メッセージ送信のフロー](../../knowledge/component/libraries/assets/libraries-mom_system_messaging/mom_system_messaging-async_message_send.png)

送信電文に設定する :ref:`共通プロトコルヘッダ<mom_system_messaging-common_protocol_header>` の内容:
- **メッセージID**: 設定不要（送信後に採番される）
- **関連メッセージID**: 設定不要
- **送信宛先**: 送信宛先の論理名
- **応答宛先**: 設定不要
- **有効期間**: 任意

`AsyncMessageSendAction` は、送信電文データを保持する一時テーブルからデータを取得し電文の作成・送信を行う共通アクションクラス。:ref:`nablarch_batch` で動作する。

> **補足**: 一時テーブルへの送信電文の登録は、:ref:`web_application` や :ref:`batch_application` で :ref:`database_management` を使用して行う。

`AsyncMessageSendAction` 使用時に作成が必要な成果物:
1. 送信電文のデータを保持する一時テーブル（主キーは電文を一意に識別するIDカラム、送信する電文の各項目に対応するカラムを定義）
2. フォーマット定義ファイル（ファイル名: `<送信電文のリクエストID>_SEND.fmt`）
3. SQLファイル（ファイル名: `<送信電文のリクエストID>.sql`）。以下のSQL_IDを定義する:
   - `SELECT_SEND_DATA`: ステータスが未送信のデータを取得するSELECT文
   - `UPDATE_NORMAL_END`: 電文送信成功時にステータスを処理済みに更新するUPDATE文
   - `UPDATE_ABNORMAL_END`: 電文送信失敗時にステータスを送信失敗に更新するUPDATE文
4. ステータス更新用フォームクラス（ステータス更新に必要なテーブル項目に対応するプロパティのみ保持すればよい）

> **補足**: 一時テーブルのレイアウトをプロジェクト共通で定義することにより、単一のフォームクラスを全ての応答不要メッセージ送信処理で使用できる。

### 実装例

**送信電文データを保持する一時テーブル（INS_PROJECT_SEND_MESSAGE）:**

| 論理名 | 物理名 |
|---|---|
| 送信電文連番（PK） | SEND_MESSAGE_SEQUENCE |
| プロジェクト名 | PROJECT_NAME |
| プロジェクト種別 | PROJECT_TYPE |
| プロジェクト分類 | PROJECT_CLASS |
| ステータス | STATUS |
| 更新ユーザID | UPDATED_USER_ID |
| 更新日時 | UPDATED_DATE |

**フォーマット定義ファイル（ProjectInsertMessage_SEND.fmt）:**
```
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    2120    # 各レコードの長さ

[userData]
項目定義は省略
```

**SQLファイル（ProjectInsertMessage.sql）:**
```sql
SELECT_SEND_DATA =
SELECT
    省略
FROM
    INS_PROJECT_SEND_MESSAGE
WHERE
    STATUS = '0'
ORDER BY
    SEND_MESSAGE_SEQUENCE

UPDATE_NORMAL_END =
UPDATE
    INS_PROJECT_SEND_MESSAGE
SET
    STATUS = '1',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE
    SEND_MESSAGE_SEQUENCE = :sendMessageSequence

UPDATE_ABNORMAL_END =
UPDATE
    INS_PROJECT_SEND_MESSAGE
SET
    STATUS = '9',
    UPDATED_USER_ID = :updatedUserId,
    UPDATED_DATE = :updatedDate
WHERE
    SEND_MESSAGE_SEQUENCE = :sendMessageSequence
```

ステータス値: `'0'`=未送信、`'1'`=処理済み（正常終了）、`'9'`=送信失敗（異常終了）

**フォームクラス（SendMessagingForm.java）:**
```java
public class SendMessagingForm {
    private String sendMessageSequence;
    @UserId
    private String updatedUserId;
    @CurrentDateTime
    private java.sql.Timestamp updatedDate;
    // コンストラクタとアクセッサは省略
}
```

**AsyncMessageSendActionSettings の設定（`AsyncMessageSendActionSettings` をコンポーネント定義に追加）:**
```xml
<component name="asyncMessageSendActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="formatDir" value="format" />
  <property name="headerFormatName" value="header" />
  <property name="queueName" value="TEST.REQUEST" />
  <property name="sqlFilePackage" value="com.nablarch.example.sql" />
  <property name="formClassName" value="com.nablarch.example.form.SendMessagingForm" />
  <property name="headerItemList">
    <list>
      <value>sendMessageSequence</value>
    </list>
  </property>
</component>
```

**AsyncMessageSendAction の適用（:ref:`request_path_java_package_mapping` のコンポーネント定義に指定）:**
```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="com.nablarch.example.action.ExampleAsyncMessageSendAction" />
  <property name="immediate" value="false" />
</component>
```

## 同期応答でメッセージを送信する(同期応答メッセージ送信)

外部システムにメッセージを送信し応答を待機する（応答受信またはタイムアウトまでブロック）。:ref:`mom_system_messaging-async_message_send` と異なり応答電文を受信するため、通信先の処理がある程度保証される。タイムアウトした場合は、電文の再試行や障害通知などのエラー処理が必要。

**送信電文の共通プロトコルヘッダ** (:ref:`mom_system_messaging-common_protocol_header`)

| ヘッダ | 値 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| 関連メッセージID | 設定不要 |
| 送信宛先 | 送信宛先の論理名 |
| 応答宛先 | 応答宛先の論理名 |
| 有効期間 | 任意 |

送信宛先ヘッダに加え、応答時の送信宛先となる応答宛先ヘッダを設定しておく必要がある。

**応答電文の共通プロトコルヘッダ**（外部システムが作成）

アプリケーションは送信電文のメッセージIDと同じ関連メッセージIDを持つ電文が応答宛先で受信されるまで待機するため、外部システムは応答電文に関連メッセージIDを設定する必要がある。

| ヘッダ | 値 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| 関連メッセージID | 送信電文のメッセージIDヘッダの値 |
| 送信宛先 | 送信電文の応答宛先ヘッダの値 |
| 応答宛先 | 設定不要 |
| 有効期間 | 任意 |

**クラス**: `nablarch.fw.messaging.MessageSender`

フォーマット定義ファイル命名規則:
- 送信用: `<電文のリクエストID>_SEND.fmt`
- 受信用: `<電文のリクエストID>_RECEIVE.fmt`
- レコードタイプ名は `data` 固定

ProjectInsertMessage_SEND.fmt:
```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    2120
record-separator: "\r\n"

[data]
```

ProjectInsertMessage_RECEIVE.fmt:
```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    130
record-separator: "\r\n"

[data]
```

MessageSenderを使った送受信処理:
- 要求電文は `SyncMessage` で作成
- 送信は `MessageSender#sendSync` を使用
- `MessagingException` をキャッチして `TransactionAbnormalEnd` をスローする送信エラー処理が必要

```java
SyncMessage responseMessage = null;
try {
    responseMessage = MessageSender.sendSync(
        new SyncMessage("ProjectInsertMessage").addDataRecord(inputData));
} catch (MessagingException e) {
    // 送信エラー
    throw new TransactionAbnormalEnd(100, e, "error.sendServer.fail");
}
Map<String, Object> responseDataRecord = responseMessage.getDataRecord();
```

**MessageSender設定** (messaging.properties):
```properties
messageSender.DEFAULT.messagingProviderName=defaultMessagingProvider
messageSender.DEFAULT.destination=TEST.REQUEST
messageSender.DEFAULT.replyTo=TEST.RESPONSE
messageSender.DEFAULT.retryCount=10
messageSender.DEFAULT.formatDir=format
messageSender.DEFAULT.headerFormatName=HEADER
```

設定は :ref:`repository-environment_configuration` により行う。設定項目は :java:extdoc:`MessageSenderSettings<nablarch.fw.messaging.MessageSenderSettings.<init>(java.lang.String)>` を参照。

```xml
<config-file file="messaging/messaging.properties"/>
```

電文の変換処理を変更する場合は、`SyncMessageConvertor` を継承したクラスをコンポーネント定義に追加し、コンポーネント名を `messageSender.DEFAULT.messageConvertorName` に指定する。詳細は :ref:`mom_system_messaging-change_fw_header_sync_ex` を参照。

## 応答不要でメッセージを受信する(応答不要メッセージ受信)

特定の宛先に送信されるメッセージを受信する（受信またはタイムアウトまでブロック）。

**受信電文の共通プロトコルヘッダ**

| ヘッダ | 値 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| 関連メッセージID | 設定不要 |
| 送信宛先 | 宛先の論理名 |
| 応答宛先 | 設定不要 |
| 有効期間 | 任意 |

**クラス**: `nablarch.fw.messaging.action.AsyncMessageReceiveAction`

`AsyncMessageReceiveAction` は :ref:`mom_messaging` で動作するアクションクラス。受信した電文を一時テーブル（電文受信テーブル）に保存する。

> **補足**: 一時テーブルに保存したデータは、:ref:`batch_application` を用いてシステムの本テーブルに取り込む想定。

`AsyncMessageReceiveAction` 使用時に作成が必要な成果物:
- 電文を登録するための一時テーブル
- フォーマット定義ファイル
- SQL文（INSERTファイル）
- フォームクラス

**一時テーブル設計ルール**:
- 受信電文は電文の種類ごとに専用の一時テーブルに保存
- 主キーは :ref:`generator` でフレームワークが採番するID格納カラム
- テーブルの属性情報には受信電文の各項目に対応するカラムを定義する
- 各プロジェクトの方式に合わせて共通項目（登録ユーザIDや登録日時など）を定義する

**一時テーブル例 (INS_PROJECT_RECEIVE_MESSAGE)**:

| 論理名 | カラム名 |
|---|---|
| 受信メッセージ連番(PK) | RECEIVED_MESSAGE_SEQUENCE |
| プロジェクト名 | PROJECT_NAME |
| プロジェクト種別 | PROJECT_TYPE |
| プロジェクト分類 | PROJECT_CLASS |
| ステータス | STATUS |
| 登録ユーザID | INSERT_USER_ID |
| 登録日時 | INSERT_DATE |

**フォーマット定義ファイル命名規則**: `<受信電文のリクエストID>_RECEIVE.fmt`

```
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    2120

[userData]
```

**SQLファイル**:
- ファイル名: `<受信電文のリクエストID>.sql`
- SQL_IDは `INSERT_MESSAGE` 固定

**フォームクラス**:
- クラス名: `<受信電文のリクエストID>Form`
- `(String receivedMessageSequence, RequestMessage message)` の2引数コンストラクタが必要
  - `String` → 受信電文連番
  - `RequestMessage` → 受信電文

```java
public class ProjectInsertMessageForm {
    public ProjectInsertMessageForm(
            String receivedMessageSequence, RequestMessage message) {
        this.receivedMessageSequence = receivedMessageSequence;
        DataRecord data = message.getRecordOf("userData");
        projectName = data.getString("projectName");
    }
}
```

**AsyncMessageReceiveAction設定**: `AsyncMessageReceiveActionSettings` をコンポーネント定義に追加。

```xml
<component name="asyncMessageReceiveActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <property name="formClassPackage" value="com.nablarch.example.form" />
  <property name="receivedSequenceFormatter">
    <component class="nablarch.common.idgenerator.formatter.LpadFormatter">
      <property name="length" value="10" />
      <property name="paddingChar" value="0" />
    </component>
  </property>
  <property name="receivedSequenceGenerator" ref="idGenerator" />
  <property name="targetGenerateId" value="9991" />
  <property name="sqlFilePackage" value="com.nablarch.example.sql" />
</component>
```

`AsyncMessageReceiveAction` を :ref:`mom_messaging` で動作させるには、:ref:`request_path_java_package_mapping` のコンポーネント定義（`nablarch.fw.handler.RequestPathJavaPackageMapping`）で指定する。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"
            value="nablarch.fw.messaging.action.AsyncMessageReceiveAction" />
  <property name="immediate" value="false" />
</component>
```

## 同期応答でメッセージを受信する(同期応答メッセージ受信)

通信先から特定の宛先に送信されるメッセージを受信し、応答宛先に応答電文を送信する。受信電文のメッセージIDヘッダの値を、応答電文の関連メッセージIDヘッダに設定する。

![同期応答メッセージ受信フロー](../../knowledge/component/libraries/assets/libraries-mom_system_messaging/mom_system_messaging-sync_message_receive.png)

**送信電文の :ref:`共通プロトコルヘッダ<mom_system_messaging-common_protocol_header>` 設定内容**:

| ヘッダ | 設定内容 |
|---|---|
| メッセージID | 設定不要（送信後に採番される） |
| 関連メッセージID | 受信電文のメッセージIDヘッダの値 |
| 送信宛先 | 受信電文の応答宛先ヘッダの値 |
| 応答宛先 | 設定不要 |
| 有効期間 | 任意 |

`MessagingAction` を使用することで、作成が必要な成果物はフォーマット定義ファイルとアクションクラスのみとなる（:ref:`mom_messaging` で動作）。

**フォーマット定義ファイルの命名規則**:
- 受信用: `<電文のリクエストID>_RECEIVE.fmt`
- 送信用: `<電文のリクエストID>_SEND.fmt`

ProjectInsertMessage_RECEIVE.fmt:
```bash
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    2120
record-separator: "\r\n"

[data]
項目定義は省略
```

ProjectInsertMessage_SEND.fmt:
```bash
file-type:        "Fixed"
text-encoding:    "MS932"
record-length:    130
record-separator: "\r\n"

[data]
項目定義は省略
```

**アクションクラス実装のポイント**:
- `MessagingAction` を継承し、以下をオーバーライドする:
  - `MessagingAction#onReceive`
  - `MessagingAction#onError`
- 応答電文は `RequestMessage#reply` で作成する
- 要求電文と応答電文それぞれに対応したフォームクラスを作成する

```java
public class ProjectInsertMessageAction extends MessagingAction {

    @Override
    protected ResponseMessage onReceive(
            RequestMessage request, ExecutionContext context) {
        ProjectInsertMessageForm projectInsertMessageForm
            = BeanUtil.createAndCopy(
                ProjectInsertMessageForm.class, request.getParamMap());

        // バリデーション処理。エラー検知時はApplicationExceptionが送出される。
        ValidatorUtil.validate(projectInsertMessageForm);

        ProjectTemp projectTemp
            = BeanUtil.createAndCopy(ProjectTemp.class, projectInsertMessageForm);
        UniversalDao.insert(projectTemp);

        ProjectInsertMessageResponseForm resForm = new ProjectInsertMessageResponseForm("success", "");
        return request.reply().addRecord(resForm);
    }

    @Override
    protected ResponseMessage onError(
            Throwable e, RequestMessage request, ExecutionContext context) {
        if (e instanceof InvalidDataFormatException) {
            //要求電文データレコード部レイアウト不正
            resForm = new ProjectInsertMessageResponseForm("fatal", "invalid layout.");
        } else if (e instanceof ApplicationException) {
            //要求電文データレコード部項目バリデーションエラー
            resForm = new ProjectInsertMessageResponseForm("error.validation", "");
        } else {
            resForm = new ProjectInsertMessageResponseForm("fatal", "unexpected exception.");
        }
        return request.reply().addRecord(resForm);
    }
}
```

## 拡張例

**フレームワーク制御ヘッダの読み書きを変更する** (:ref:`mom_system_messaging-change_fw_header`):
外部システムで電文フォーマットが既に規定されている場合など、フレームワーク制御ヘッダの読み書きを変更する方法を送受信の種類ごとに示す。

**応答不要メッセージ送信の場合**:
以下のメソッドをオーバーライドして対応する:
- `AsyncMessageSendAction#createHeaderRecordFormatter`
- `AsyncMessageSendAction#createHeaderRecord`

**同期応答メッセージ送信の場合** (:ref:`mom_system_messaging-change_fw_header_sync_ex`):
`MessageSender` は変換処理を `SyncMessageConvertor` に委譲しており、このクラスがフレームワーク制御ヘッダを読み書きする。`SyncMessageConvertor` を継承したクラスを作成し、`MessageSender` の設定に指定する（設定は `MessageSenderSettings` を参照）。

**応答不要メッセージ受信の場合** (:ref:`mom_system_messaging-change_fw_header_async_receive`):
`FwHeaderReader` に設定された `FwHeaderDefinition` インタフェースを実装したクラスが読み込みを行う。デフォルトは `StandardFwHeaderDefinition`。プロジェクトで `FwHeaderDefinition` インタフェースを実装したクラスを作成し、コンポーネント定義で `FwHeaderReader#fwHeaderDefinition` プロパティに指定する。

**同期応答メッセージ受信の場合**:
- 読み込み: :ref:`応答不要メッセージ受信の場合<mom_system_messaging-change_fw_header_async_receive>` と同じ
- 書き込み: `FwHeaderDefinition` インタフェースを実装したクラスを作成し、コンポーネント定義で :ref:`message_reply_handler` の `fwHeaderDefinition` プロパティに指定する

## 送受信電文のデータモデル

MOMメッセージングでの送受信電文のデータモデル。

![送受信電文のデータモデル](../../knowledge/component/libraries/assets/libraries-mom_system_messaging/mom_system_messaging-data_model.png)

**プロトコルヘッダ** (:ref:`mom_system_messaging-protocol_header`):
MOMによるメッセージ送受信処理で使用される情報を格納したヘッダ領域。Mapインターフェースでアクセス可能。

**共通プロトコルヘッダ** (:ref:`mom_system_messaging-common_protocol_header`):
フレームワークが使用するヘッダで、特定のキー名でアクセス可能。

| ヘッダ名 | キー名 | 送信時 | 受信時 |
|---|---|---|---|
| メッセージID | MessageId | MOMが採番した値 | 送信側のMOMが発番した値 |
| 関連メッセージID | CorrelationId | 応答電文: 要求電文のメッセージID / 再送要求: 応答再送を要求する要求電文のメッセージID | |
| 送信宛先 | Destination | 送信キューの論理名 | 受信キューの論理名 |
| 応答宛先 | ReplyTo | 同期応答: 応答受信キューの論理名 / 応答不要: 設定不要 | 同期応答: 応答宛先キューの論理名 / 応答不要: 通常設定なし |
| 有効期間 | TimeToLive | 送信電文の有効期間(msec) | 設定なし |

> **補足**: 共通プロトコルヘッダ以外のヘッダは「個別プロトコルヘッダ」と呼ばれ、各メッセージングプロバイダが任意に定義可能。JMSの場合、全JMSヘッダ・JMS拡張ヘッダ・任意属性は個別プロトコルヘッダとして扱われる。

**メッセージボディ** (:ref:`mom_system_messaging-message_body`):
プロトコルヘッダを除いた電文のデータ領域。`MessagingProvider` はプロトコルヘッダ領域のみを使用し、それ以外は未解析のバイナリデータとして扱う。メッセージボディの解析は :ref:`data_format` で行い、フィールド名をキーとするMap形式で読み書き可能。

**フレームワーク制御ヘッダ** (:ref:`mom_system_messaging-fw_header`):
フレームワークの機能が使用する電文中の制御項目。デフォルトではメッセージボディの最初のデータレコード中に以下のフィールド名で定義する必要がある。

| 制御項目 | フィールド名 | 使用する主要ハンドラ |
|---|---|---|
| リクエストID | requestId | :ref:`request_path_java_package_mapping`, :ref:`message_resend_handler`, :ref:`permission_check_handler`, :ref:`ServiceAvailabilityCheckHandler` |
| ユーザID | userId | :ref:`permission_check_handler` |
| 再送要求フラグ | resendFlag | :ref:`message_resend_handler` |
| ステータスコード | statusCode | :ref:`message_reply_handler` |

標準的なフレームワーク制御ヘッダの定義例:

```bash
[NablarchHeader]
1   requestId   X(10)       # リクエストID
11  userId      X(10)       # ユーザID
21  resendFlag  X(1)  "0"   # 再送要求フラグ (0: 初回送信 1: 再送要求)
22  statusCode  X(4)  "200" # ステータスコード
26 ?filler      X(25)       # 予備領域
```

フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、任意ヘッダ項目としてアクセスでき、プロジェクト毎にフレームワーク制御ヘッダを簡易的に拡張できる。将来的な項目追加に備え、予備領域を設けることを強く推奨する。
