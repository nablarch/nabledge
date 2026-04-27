# MOMメッセージング

**目次**

* 機能概要

  * 多様なMOMに対応できる
* モジュール一覧
* 使用方法

  * MOMメッセージングを使うための設定
  * 応答不要でメッセージを送信する(応答不要メッセージ送信)
  * 同期応答でメッセージを送信する(同期応答メッセージ送信)
  * 応答不要でメッセージを受信する(応答不要メッセージ受信)
  * 同期応答でメッセージを受信する(同期応答メッセージ受信)
* 拡張例

  * フレームワーク制御ヘッダの読み書きを変更する
* 送受信電文のデータモデル

MOMを使ったメッセージの送受信を行う機能を提供する。
なお、ここでは、MOMメッセージングに使うメッセージキューのことをMQと称す。

MOMメッセージングでは、 [送受信電文のデータモデル](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-data-model) に示したデータモデルを前提としている。
また、メッセージのフォーマットには、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#data-format) を使用する。

> **Important:**
> [送受信電文のデータモデル](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-data-model) の中で、
> [フレームワーク制御ヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-fw-header) については、
> Nablarchで独自に規定している項目となり、 [メッセージボディ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-message-body) に含めることを想定している。

> プロジェクト側で電文フォーマットを設計できる場合は問題ないが、
> 外部システムにより既に電文フォーマットが規定されている場合は、
> この想定が適合しない場合がある。

> この場合は、 [フレームワーク制御ヘッダの読み書きを変更する](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-change-fw-header) を参照し、
> プロジェクトで実装を追加して対応することになる。

MOMメッセージングは送受信の種類により、想定している実行制御基盤が異なる。

| 送受信の種類 | 実行制御基盤 |
|---|---|
| [応答不要メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-async-message-send) | [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md#nablarch-batch) |
| [同期応答メッセージ送信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-send) | 実行制御基盤に依存しない |
| [応答不要メッセージ受信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-async-message-receive) | [MOMによるメッセージング](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) |
| [同期応答メッセージ受信](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-sync-message-receive) | [MOMによるメッセージング](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) |

## 機能概要

### 多様なMOMに対応できる

MOMメッセージングでは、多様なMOMに対応するため、
MessagingProvider インタフェースを設けている。
MOMに依存するMQ接続やメッセージ送受信は、このインタフェースを実装したクラスが行う。
そのため、 MessagingProvider インタフェースを実装したクラスを作成することで、
本機能を様々なMOMで使用できる。

MOMメッセージングはJakarta Messagingに対応しており、
JmsMessagingProvider を提供している。
詳細は、リンク先のJavadocを参照。

さらに、MOMとして使用実績が多い IBM MQ にも対応している。
詳細は、 [IBM MQアダプタ](../../component/adapters/adapters-webspheremq-adaptor.md#webspheremq-adaptor) を参照。

## モジュール一覧

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

## 使用方法

### MOMメッセージングを使うための設定

MOMメッセージングでは、以下のクラスをコンポーネント定義に追加する。

* MessagingProvider の実装クラス (MQ接続、MQに対する送受信)
* [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-messaging-context-handler.md#messaging-context-handler) (MQ接続の管理)

以下に設定例を示す。

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

さらに、メッセージ受信の場合は、データリーダの設定が必要となる。
以下のクラスをコンポーネント定義に追加する。

* MessageReader (MQから電文の読み込み)
* FwHeaderReader (電文からフレームワーク制御ヘッダの読み込み)

以下に設定例を示す。

ポイント
* データリーダのコンポーネント名には `dataReader` を指定する。
* MessageReader は
  FwHeaderReader の
  messageReader
  プロパティに指定する。

```xml
<!-- FwHeaderReader -->
<component name="dataReader"
           class="nablarch.fw.messaging.reader.FwHeaderReader">
  <!-- MessageReader -->
  <property name="messageReader">
    <component class = "nablarch.fw.messaging.reader.MessageReader">
      <!-- 設定項目はJavadocを参照 -->
    </component>
  </property>
</component>
```

### 応答不要でメッセージを送信する(応答不要メッセージ送信)

外部システムに対してメッセージを送信する。

![mom_system_messaging-async_message_send.png](../../../knowledge/assets/libraries-mom-system-messaging/mom_system_messaging-async_message_send.png)

送信電文に設定する [共通プロトコルヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-common-protocol-header) の内容
設定する必要があるのは、基本的に送信宛先ヘッダのみである。

設定不要(送信後に採番される)

設定不要

送信宛先の論理名

設定不要

任意

応答不要メッセージ送信では、送信電文のデータを保持するテーブル(一時テーブルと呼ぶ)から送信対象のデータを取得し、
電文の作成及び送信の共通的なアクションとして、
AsyncMessageSendAction
を提供している。
AsyncMessageSendAction は、
[Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md#nablarch-batch) で動作するアクションクラスである。

> **Tip:**
> 一時テーブルへの送信電文の登録は、 [ウェブアプリケーション編](../../processing-pattern/web-application/web-application-web.md#web-application) や [バッチアプリケーション編](../../processing-pattern/nablarch-batch/nablarch-batch-batch.md#batch-application) で、
> [データベースアクセス](../../component/libraries/libraries-database-management.md#database-management) を使用して行うことを想定している。

AsyncMessageSendAction
を使用することにより、以下の成果物のみを作成すればよく、
非常に簡単に電文の送信処理を実装できるようになっている。

* 送信電文のデータを保持する一時テーブル
* 電文のレイアウトを表すフォーマット定義ファイル
* SQLファイル(3種類のSQL文を定義する)

* ステータスが未送信のデータを取得するためのSELECT文
* 電文送信に成功した場合に、該当データのステータスを処理済みに更新するためのUPDATE文
* 電文送信に失敗した場合に、該当データのステータスを送信失敗に更新するためのUPDATE文

* ステータス更新用のフォームクラス

> **Tip:**
> フォームクラスに必要なプロパティは、ステータス更新に必要なテーブル項目に対応するもののみで良い。
> これにより、一時テーブルのテーブルレイアウトをプロジェクト共通で定義することにより、
> 単一のフォームクラスを全ての応答不要メッセージ送信処理で使用することが出来るようになる。

[Exampleアプリケーション](../../about/about-nablarch/about-nablarch-examples.md#example-application-mom-system-messaging) をベースに、
プロジェクト情報を送信する場合の実装例を以下に示す。

実装例
送信電文のデータを保持する一時テーブル
ポイント
* 主キーは、電文を一意に識別するためのIDを格納するカラムとする。
* テーブルの属性情報には、送信する電文の各項目に対応するカラムを定義する。
* 各プロジェクトの方式に合わせて共通項目(更新ユーザIDや更新日時など)を定義する。
INS_PROJECT_SEND_MESSAGE
| 送信電文連番(PK) | SEND_MESSAGE_SEQUENCE |
|---|---|
| プロジェクト名 | PROJECT_NAME |
| プロジェクト種別 | PROJECT_TYPE |
| プロジェクト分類 | PROJECT_CLASS |
| ：(省略) |  |
| ステータス | STATUS |
| 更新ユーザID | UPDATED_USER_ID |
| 更新日時 | UPDATED_DATE |
フォーマット定義ファイル
ポイント
* ファイル名は `<送信電文のリクエストID>_SEND.fmt` とする。
ProjectInsertMessage_SEND.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    2120    # 各レコードの長さ

[userData]
項目定義は省略
```
SQLファイル
ポイント
* ファイル名は `<送信電文のリクエストID>.sql` とする。
* SQL_IDは次の通りとする。

* `SELECT_SEND_DATA`: ステータスが未送信のデータを取得するためのSELECT文
* `UPDATE_NORMAL_END`: ステータスを処理済みに更新するためのUPDATE文
* `UPDATE_ABNORMAL_END`: ステータスを送信失敗に更新するためのUPDATE文
ProjectInsertMessage.sql
```bash
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
ステータス更新用のフォームクラス
ポイント
* このフォームクラスは、ステータス更新専用のクラスとなるため、
  プロパティとして一時テーブルの属性を全て保持する必要はない。
SendMessagingForm.java
```java
public class SendMessagingForm {

    /** 送信電文連番 */
    private String sendMessageSequence;

    /** 更新ユーザID */
    @UserId
    private String updatedUserId;

    /** 更新日時 */
    @CurrentDateTime
    private java.sql.Timestamp updatedDate;

    // コンストラクタとアクセッサは省略
}
```
AsyncMessageSendActionの設定
ポイント
* AsyncMessageSendAction
  を使用する場合は、送信先のキュー名やフォーマット定義ファイルの格納ディレクトリなどの設定が必要となる。
  設定は、
  AsyncMessageSendActionSettings
  をコンポーネント定義に追加することで行う。
  設定項目については、リンク先のJavadocを参照。
messaging-async-send-component-configuration.xml
```xml
<component name="asyncMessageSendActionSettings"
           class="nablarch.fw.messaging.action.AsyncMessageSendActionSettings">
  <property name="formatDir" value="format" />
  <property name="headerFormatName" value="header" />
  <property name="queueName" value="TEST.REQUEST" />
  <property name="sqlFilePackage" value="com.nablarch.example.sql" />
  <property name="formClassName"
            value="com.nablarch.example.form.SendMessagingForm" />
  <property name="headerItemList">
    <list>
      <value>sendMessageSequence</value>
    </list>
  </property>
</component>
```
AsyncMessageSendActionの適用
ポイント
* AsyncMessageSendAction を
  [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md#nablarch-batch) で動作させるためには、
  [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#request-path-java-package-mapping) のコンポーネント定義で
  AsyncMessageSendAction を指定する。
messaging-async-send-component-configuration.xml
```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"
            value="com.nablarch.example.action.ExampleAsyncMessageSendAction" />
  <property name="immediate" value="false" />
</component>
```

### 同期応答でメッセージを送信する(同期応答メッセージ送信)

外部システムに対してメッセージを送信し、その応答を待機する。応答メッセージを受信するか、待機タイムアウト時間が経過するまでブロックする。

![mom_system_messaging-sync_message_send.png](../../../knowledge/assets/libraries-mom-system-messaging/mom_system_messaging-sync_message_send.png)

[応答不要でメッセージを送信する(応答不要メッセージ送信)](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-async-message-send) とは異なり、応答電文を受信するので、
通信先で処理が正しく行われることをある程度保証できる。
ただし、何らかの問題により、規定時間内に応答を受信できずにタイムアウトした場合は、何らかのエラー処理(例えば、電文の再試行や障害通知など)を行う必要がある。

送信電文に設定する [共通プロトコルヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-common-protocol-header) の内容
送信宛先ヘッダに加え、応答時の送信宛先となる応答宛先ヘッダを設定しておく必要がある。

設定不要(送信後に採番される)

設定不要

送信宛先の論理名

応答宛先の論理名

任意
外部システムが作成する応答電文の [共通プロトコルヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-common-protocol-header) の内容
送信処理完了後、アプリケーションは、送信した電文のメッセージIDと同じ関連メッセージIDをもつ電文が応答宛先上で受信されるまで待機する。
そのため、外部システムは応答電文に関連メッセージIDを設定しておく必要がある。

設定不要(送信後に採番される)

送信電文のメッセージIDヘッダの値

送信電文の応答宛先ヘッダの値

設定不要

任意

同期応答メッセージ送信では、定型的な処理をラップしたユーティリティクラスとして、
MessageSender を提供している。
MessageSender
を使用することにより、以下の成果物のみを作成すればよく、
簡便に同期応答メッセージの送信処理を作成できるようになっている。

* 送受信に使用するフォーマット定義ファイル
* MessageSender を使った送受信処理

[Exampleアプリケーション](../../about/about-nablarch/about-nablarch-examples.md#example-application-mom-system-messaging) をベースに、
テーブルに格納された送信データから、
バッチアクションでプロジェクト情報を送信する場合の実装例を以下に示す。
テーブルからのデータ読み込み部分は、メッセージ送信に関係しないので実装例を省略する。

実装例
送受信に使用するフォーマット定義ファイル
ポイント
* ファイル名は以下とする。

* 送信用： `<電文のリクエストID>_SEND.fmt`
* 受信用： `<電文のリクエストID>_RECEIVE.fmt`

* レコードタイプ名は `data` 固定である。
ProjectInsertMessage_SEND.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    2120    # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

[data]
項目定義は省略
```
ProjectInsertMessage_RECEIVE.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    130     # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

[data]
項目定義は省略
```
MessageSenderを使った送受信処理
ポイント
* 要求電文は、 SyncMessage で作成する。
* メッセージ送信には、
  MessageSender#sendSync
  を使用する。
  使い方については、リンク先のJavadocを参照。
SendProjectInsertMessageAction.java
```java
public Result handle(SqlRow inputData, ExecutionContext ctx) {

    // インプットデータを使った業務処理は省略

    SyncMessage responseMessage = null;
    try {
        responseMessage = MessageSender.sendSync(
            new SyncMessage("ProjectInsertMessage").addDataRecord(inputData));
    } catch (MessagingException e) {
        // 送信エラー
        throw new TransactionAbnormalEnd(100, e, "error.sendServer.fail");
    }

    Map<String, Object> responseDataRecord = responseMessage.getDataRecord();

    // レスポンスデータを使った業務処理は省略

    return new Success();
}
```
MessageSenderの設定
ポイント
* MessageSender を使用する場合は、
  送受信先のキュー名やフォーマット定義ファイルの格納ディレクトリなどの設定が必要となる。
  設定は、 [依存値を設定する](../../component/libraries/libraries-repository.md#repository-environment-configuration) により行う。
  設定項目については、
  MessageSenderSettings<nablarch.fw.messaging.MessageSenderSettings.
  を参照。
* 送受信する電文の変換処理を変更する場合は、コンポーネント設定ファイルに SyncMessageConvertor
  を継承したクラスを定義して、コンポーネントの名前を `messageSender.DEFAULT.messageConvertorName` に指定することで変更できる。
  詳細については、 [フレームワーク制御ヘッダの読み書きを変更する（同期応答メッセージ送信の場合）](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-change-fw-header-sync-ex) を参照。
messaging.properties
```properties
messageSender.DEFAULT.messagingProviderName=defaultMessagingProvider
messageSender.DEFAULT.destination=TEST.REQUEST
messageSender.DEFAULT.replyTo=TEST.RESPONSE
messageSender.DEFAULT.retryCount=10
messageSender.DEFAULT.formatDir=format
messageSender.DEFAULT.headerFormatName=HEADER
```
コンポーネント設定ファイル
```xml
<!-- MessageSender設定を読込 -->
<config-file file="messaging/messaging.properties"/>
```

### 応答不要でメッセージを受信する(応答不要メッセージ受信)

特定の宛先に送信されるメッセージを受信する。メッセージを受信するか待機タイムアウト時間が経過するまでブロックする。

![mom_system_messaging-async_message_receive.png](../../../knowledge/assets/libraries-mom-system-messaging/mom_system_messaging-async_message_receive.png)

外部システムが作成する受信電文の [共通プロトコルヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-common-protocol-header) の内容
設定不要(送信後に採番される)

設定不要

宛先の論理名

設定不要

任意

応答不要メッセージ受信では、受信した電文を一時テーブル(電文受信テーブル)に保存するための共通的なアクションとして、
AsyncMessageReceiveAction
を提供している。
AsyncMessageReceiveAction
は、[MOMによるメッセージング](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) で動作するアクションクラスである。

> **Tip:**
> 一時テーブルに保存したデータは、 [バッチアプリケーション編](../../processing-pattern/nablarch-batch/nablarch-batch-batch.md#batch-application) を用いて、
> システムの本テーブルに取り込みを行うことを想定している。

AsyncMessageReceiveAction
を使用することにより、以下の成果物のみを作成すればよく、 非常に簡易的に電文をテーブルに保存することが可能となっている。

* 電文を登録するための一時テーブル
* 電文のレイアウトを表すフォーマット定義ファイル
* 電文を登録するためのINSERT文(SQLファイル)
* 電文を登録する際に使用するフォームクラス

[Exampleアプリケーション](../../about/about-nablarch/about-nablarch-examples.md#example-application-mom-system-messaging) をベースに、
プロジェクト情報を受信する場合の実装例を以下に示す。

実装例
電文を登録するための一時テーブル
ポイント
* 受信した電文は、電文の種類毎に専用の一時テーブルに保存する。
* 主キーは、電文を一意に識別するためのIDを格納するカラムとする。
  このカラムに格納する値は、 [サロゲートキーの採番](../../component/libraries/libraries-generator.md#generator) を用いてフレームワークで採番を行う。
* テーブルの属性情報には、受信した電文の各項目に対応するカラムを定義する。
* 各プロジェクトの方式に合わせて共通項目(登録ユーザIDや登録日時など)を定義する。
INS_PROJECT_RECEIVE_MESSAGE
| 受信メッセージ連番(PK) | RECEIVED_MESSAGE_SEQUENCE |
|---|---|
| プロジェクト名 | PROJECT_NAME |
| プロジェクト種別 | PROJECT_TYPE |
| プロジェクト分類 | PROJECT_CLASS |
| ：(省略) |  |
| ステータス | STATUS |
| 登録ユーザID | INSERT_USER_ID |
| 登録日時 | INSERT_DATE |
フォーマット定義ファイル
ポイント
* ファイル名は `<受信電文のリクエストID>_RECEIVE.fmt` とする。
ProjectInsertMessage_RECEIVE.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    2120    # 各レコードの長さ

[userData]
項目定義は省略
```
SQLファイル
ポイント
* ファイル名は `<受信電文のリクエストID>.sql` とする。
* SQL_IDは `INSERT_MESSAGE` とする。
ProjectInsertMessage.sql
```bash
INSERT_MESSAGE =
INSERT INTO INS_PROJECT_RECEIVE_MESSAGE (
    RECEIVED_MESSAGE_SEQUENCE,
    PROJECT_NAME,
    PROJECT_TYPE,
    PROJECT_CLASS,
    以下省略
```
電文を登録する際に使用するフォームクラス
ポイント
* クラス名は `<受信電文のリクエストID>Form` とする。
* String、RequestMessage
  の2つの引数を持つコンストラクタを定義する。それぞれのパラメータの意味は以下の通り。

  * String -> 受信電文連番
  * RequestMessage -> 受信電文
ProjectInsertMessageForm.java
```java
public class ProjectInsertMessageForm {

    /** 受信電文連番 */
    private String receivedMessageSequence;

    /** プロジェクト名 */
    private String projectName;

    // 他のフィールドは省略

    public ProjectInsertMessageForm(
            String receivedMessageSequence, RequestMessage message) {
        this.receivedMessageSequence = receivedMessageSequence;

        DataRecord data = message.getRecordOf("userData");

        projectName = data.getString("projectName");

        // 以降の処理は省略
    }

    // アクセッサは省略
}
```
AsyncMessageReceiveActionの設定
ポイント
* AsyncMessageReceiveAction
  を使用する場合は、フォーマット定義ファイルやSQLファイルの配置場所などの設定が必要となる。
  設定は、
  AsyncMessageReceiveActionSettings
  をコンポーネント定義に追加することで行う。
  設定項目については、リンク先のJavadocを参照。
messaging-async-receive-component-configuration.xml
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
AsyncMessageReceiveActionの適用
ポイント
* AsyncMessageReceiveAction を
  [MOMによるメッセージング](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) で動作させるためには、
  [リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#request-path-java-package-mapping) のコンポーネント定義で
  AsyncMessageReceiveAction を指定する。
messaging-async-receive-component-configuration.xml
```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"
            value="nablarch.fw.messaging.action.AsyncMessageReceiveAction" />
  <property name="immediate" value="false" />
</component>
```

### 同期応答でメッセージを受信する(同期応答メッセージ受信)

通信先から特定の宛先に送信されるメッセージを受信し、そこに設定されていた応答宛先に対して応答電文を送信する。
このとき、受信した電文のメッセージIDヘッダの値を、応答電文の関連メッセージIDヘッダに設定する。

![mom_system_messaging-sync_message_receive.png](../../../knowledge/assets/libraries-mom-system-messaging/mom_system_messaging-sync_message_receive.png)

送信電文に設定する [共通プロトコルヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-common-protocol-header) の内容

設定不要(送信後に採番される)

受信電文のメッセージIDヘッダの値

受信電文の応答宛先ヘッダの値

設定不要

任意

同期応答メッセージ受信では、定型的な処理を行うテンプレートクラスとして、
MessagingAction を提供している。
MessagingAction は、
[MOMによるメッセージング](../../processing-pattern/mom-messaging/mom-messaging-mom.md#mom-messaging) で動作するアクションクラスである。

MessagingAction
を使用することにより、以下の成果物のみを作成すればよい。

* 電文のレイアウトを表すフォーマット定義ファイル
* 電文受信時とエラー発生時の処理(アクションクラス)

[Exampleアプリケーション](../../about/about-nablarch/about-nablarch-examples.md#example-application-mom-system-messaging) をベースに、
プロジェクト情報を受信する場合の実装例を以下に示す。

実装例
フォーマット定義ファイル
ポイント
* ファイル名は以下とする。

* 受信用： `<電文のリクエストID>_RECEIVE.fmt`
* 送信用： `<電文のリクエストID>_SEND.fmt`
ProjectInsertMessage_RECEIVE.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    2120    # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

[data]
項目定義は省略
```
ProjectInsertMessage_SEND.fmt
```bash
file-type:        "Fixed" # 固定長
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    130     # 各レコードの長さ
record-separator: "\r\n"  # 改行コード

[data]
項目定義は省略
```
電文受信時とエラー発生時の処理(アクションクラス)
ポイント
* MessagingAction を継承し、
  以下のメソッドをオーバーライドする。

  * MessagingAction#onReceive
  * MessagingAction#onError
* 応答電文は、 RequestMessage#reply で作成する。
* 要求電文と応答電文の内容を保持するため、それぞれに対応したフォームクラスを作成する。
ProjectInsertMessageAction.java
```java
public class ProjectInsertMessageAction extends MessagingAction {

    @Override
    protected ResponseMessage onReceive(
            RequestMessage request, ExecutionContext context) {
         ProjectInsertMessageForm projectInsertMessageForm
            = BeanUtil.createAndCopy(
                ProjectInsertMessageForm.class, request.getParamMap());

        // バリデーション処理を行う。エラー検知時は、ApplicationExceptionが送出される。
        ValidatorUtil.validate(projectInsertMessageForm);

        ProjectTemp projectTemp
            = BeanUtil.createAndCopy(
                ProjectTemp.class, projectInsertMessageForm);

        // データ設定は省略

        UniversalDao.insert(projectTemp);

        // 応答データ返却
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

### フレームワーク制御ヘッダの読み書きを変更する

外部システムで既に電文フォーマットが規定されている場合など、
フレームワーク制御ヘッダの読み書きを変更したい場合がある。
この場合は、プロジェクトで実装を追加することで対応する。
以下に、送受信の種類ごとに対応方法を示す。

応答不要メッセージ送信の場合
フレームワーク制御ヘッダの書き込みは、以下のメソッドにより行っているので、
以下のメソッドをオーバーライドして対応すればよい。

* AsyncMessageSendAction#createHeaderRecordFormatter
* AsyncMessageSendAction#createHeaderRecord

同期応答メッセージ送信の場合
MessageSender では、送受信する電文の変換処理を変更できるように、
変換処理を SyncMessageConvertor に委譲しており、
このクラスがフレームワーク制御ヘッダを読み書きしている。

そのため、SyncMessageConvertor を継承したクラスを作成し、
MessageSender の設定に指定すればよい。
MessageSender の設定については、
MessageSenderSettings を参照。

応答不要メッセージ受信の場合
フレームワーク制御ヘッダの読み込みは、
FwHeaderReader に設定された
FwHeaderDefinition インタフェースを実装したクラスが行う。
デフォルトでは、 StandardFwHeaderDefinition が使用される。

そのため、 StandardFwHeaderDefinition を参考に、
プロジェクトで FwHeaderDefinition インタフェースを実装したクラスを作成し、
コンポーネント定義で
FwHeaderReader#fwHeaderDefinition
プロパティに指定すればよい。
同期応答メッセージ受信の場合
フレームワーク制御ヘッダの読み込みは、
[応答不要メッセージ受信の場合](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-change-fw-header-async-receive) と同じである。

フレームワーク制御ヘッダの書き込みについても、
FwHeaderDefinition インタフェースを実装したクラスを作成することは同じであるが、
コンポーネント定義で作成したクラスを [電文応答制御ハンドラ](../../component/handlers/handlers-message-reply-handler.md#message-reply-handler) の
fwHeaderDefinition
プロパティに指定すればよい。

## 送受信電文のデータモデル

MOMメッセージングでは、送受信電文の内容を以下のデータモデルで表現する。

![mom_system_messaging-data_model.png](../../../knowledge/assets/libraries-mom-system-messaging/mom_system_messaging-data_model.png)

プロトコルヘッダ
主にMOMによるメッセージ送受信処理において使用される情報を格納したヘッダ領域である。
プロトコルヘッダはMapインターフェースでアクセスすることが可能となっている。

共通プロトコルヘッダ
プロトコルヘッダのうち、フレームワークが使用する以下のヘッダについては、特定のキー名でアクセスできる。
キー名をカッコで示す。

メッセージID(MessageId)
電文ごとにMOMが採番する文字列

MOMが採番した値

送信側のMOMが発番した値
関連メッセージID(CorrelationId)
電文が関連する電文のメッセージID

要求電文のメッセージID

応答再送を要求する要求電文のメッセージID
送信宛先(Destination)
電文の送信宛先を表す論理名

送信キューの論理名

受信キューの論理名
応答宛先(ReplyTo)
この電文に応答を送信する際に使用する宛先を表す論理名

同期応答の場合は応答受信キューの論理名。
応答不要の場合は設定不要

同期応答の場合は応答宛先キューの論理名。
応答不要の場合は通常設定なし
有効期間(TimeToLive)
送信処理開始時点を起点とする電文の有効期間(msec)

送信電文の有効期間

設定なし

> **Tip:**
> 共通プロトコルヘッダ以外のヘッダについては、各メッセージングプロバイダ側で任意に定義可能である。
> このようなヘッダは **個別プロトコルヘッダ** と呼ばれる。
> 例えば、JMSメッセージングプロバイダの場合、全てのJMSヘッダ、JMS拡張ヘッダおよび任意属性は、個別プロトコルヘッダとして扱われる。

メッセージボディ
プロトコルヘッダを除いた電文のデータ領域をメッセージボディと呼ぶ。
MOMに依存する MessagingProvider は、
原則としてプロトコルヘッダ領域のみを使用する。
それ以外のデータ領域については、未解析の単なるバイナリデータとして扱うものとする。

メッセージボディの解析は、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#data-format) によって行う。
これにより、電文の内容をフィールド名をキーとするMap形式で読み書き可能である。

フレームワーク制御ヘッダ
本フレームワークが提供する機能の中には、電文中に特定の制御項目が定義されていることを前提として設計されているものが多く存在する。
そのような制御項目のことを `フレームワーク制御ヘッダ` とよぶ。

フレームワーク制御ヘッダとそれを使用するハンドラの対応は以下のとおり。

リクエストID
この電文を受信したアプリケーションが実行すべき業務処理を識別するためのID。

このヘッダを使用する主要なハンドラ：

[リクエストディスパッチハンドラ](../../component/handlers/handlers-request-path-java-package-mapping.md#request-path-java-package-mapping)
[再送電文制御ハンドラ](../../component/handlers/handlers-message-resend-handler.md#message-resend-handler)
[認可チェックハンドラ](../../component/handlers/handlers-permission-check-handler.md#permission-check-handler)
[サービス提供可否チェックハンドラ](../../component/handlers/handlers-ServiceAvailabilityCheckHandler.md#serviceavailabilitycheckhandler)
ユーザID
この電文の実行権限を表す文字列

このヘッダを使用する主要なハンドラ：

[認可チェックハンドラ](../../component/handlers/handlers-permission-check-handler.md#permission-check-handler)
再送要求フラグ
再送要求電文の送信時に設定されるフラグ

このヘッダを使用する主要なハンドラ：

[再送電文制御ハンドラ](../../component/handlers/handlers-message-resend-handler.md#message-resend-handler)
ステータスコード
要求電文に対する処理結果を表すコード値

このヘッダを使用する主要なハンドラ：

[電文応答制御ハンドラ](../../component/handlers/handlers-message-reply-handler.md#message-reply-handler)

フレームワーク制御ヘッダは、デフォルトの設定では、
メッセージボディの最初のデータレコード中に、それぞれ以下のフィールド名で定義されている必要がある。

requestId

userId

resendFlag

statusCode

以下は、標準的なフレームワーク制御ヘッダの定義例である。

```bash
#===================================================================
# フレームワーク制御ヘッダ部 (50byte)
#===================================================================
[NablarchHeader]
1   requestId   X(10)       # リクエストID
11  userId      X(10)       # ユーザID
21  resendFlag  X(1)  "0"   # 再送要求フラグ (0: 初回送信 1: 再送要求)
22  statusCode  X(4)  "200" # ステータスコード
26 ?filler      X(25)       # 予備領域
#====================================================================
```

フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、
フレームワーク制御ヘッダの任意ヘッダ項目としてアクセスでき、
プロジェクト毎にフレームワーク制御ヘッダを簡易的に拡張する目的で使用できる。

また、将来的な任意項目の追加およびフレームワークの機能追加に伴うヘッダ追加に対応するため、
予備領域を設けておくことを強く推奨する。
