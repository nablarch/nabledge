# システム間メッセージング機能

## 

なし

## 主要クラス

| クラス | 役割 |
|---|---|
| `MessagingContext` | 送受信機能の実装クラス。メッセージングプロバイダによって生成される |
| `SendingMessage` | 送信前の電文情報を格納するクラス |
| `ReceivedMessage` | 受信した電文情報を格納するクラス |

## 1. 応答不要メッセージ送信

ローカルキューへのPUT完了時点でリターン。対向システムへの正常送信は保証されない。補償電文などとの組み合わせが必要な場合がある。

**プロトコルヘッダー（必須: 送信宛先のみ）:**

| プロトコルヘッダー | 設定内容 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| 関連メッセージID | 設定不要 |
| **送信宛先** | **送信先論理名を設定** |
| 応答宛先 | 設定不要 |
| 有効期間 | 任意 |

```java
String messageId = messaging.sendSync(new SendingMessage()
    .setDestination(sendQueueName)
    .setTimeToLive(300)
    .setFormatter(formatter)
    .addRecord(new HashMap() {{ put("FIcode", "9999"); /* ... */ }})
);
```

## 2. 同期応答メッセージ送信

応答電文を受信するか待機タイムアウト時間が経過するまでブロック。タイムアウト時はnullを返す。タイムアウト時は補償処理が必要。

**プロトコルヘッダー（必須: 送信宛先 + 応答宛先）:**

| プロトコルヘッダー | 設定内容 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| 関連メッセージID | 設定不要 |
| **送信宛先** | **送信宛先の論理名を設定** |
| **応答宛先** | **応答宛先の論理名を設定** |
| 有効期間 | 任意 |

通信先システムが作成する応答電文のヘッダー要件:

| プロトコルヘッダー | 受信内容 |
|---|---|
| メッセージID | 送信先システム側で採番された一意文字列が設定される |
| **関連メッセージID** | 送信電文の**メッセージIDヘッダ**の値が設定される |
| **送信宛先** | 送信電文の**応答宛先ヘッダ**の値が設定される |
| 応答宛先 | N/A |
| 有効期間 | 任意 |

```java
ReceivedMessage reply = messaging.sendSync(new SendingMessage()
    .setDestination(sendQueueName)
    .setReplyTo(replyQueueName)
    .setTimeToLive(300)
    .setFormatter(formatter)
    .addRecord(new HashMap() {{ put("FIcode", "9999"); /* ... */ }}),
    timeout
);
// タイムアウト時はnullが返される
```

## 3. 応答不要メッセージ受信

メッセージを受信するか待機タイムアウト時間が経過するまでブロック。タイムアウト時はnullを返す。

**プロトコルヘッダー:**

| プロトコルヘッダー | 受信内容 |
|---|---|
| メッセージID | 送信先システム側で採番された一意文字列が設定される |
| 関連メッセージID | N/A |
| 送信宛先 | 宛先の論理名 |
| 応答宛先 | N/A |
| 有効期間 | 任意 |

```java
ReceivedMessage incomingRequest = messaging.receiveSync(queueName, timeout);
// タイムアウト時はnullが返される
```

## 4. 同期応答メッセージ受信

受信電文の応答宛先に応答電文を送信する。応答電文の関連メッセージIDには受信電文のメッセージIDを設定する。

**応答電文のプロトコルヘッダー設定:**

| プロトコルヘッダー | 設定内容 |
|---|---|
| メッセージID | 設定不要（送信後に採番） |
| **関連メッセージID** | **受信電文のメッセージIDヘッダの値** |
| **送信宛先** | **受信電文の応答宛先ヘッダの値** |
| 応答宛先 | 設定不要 |
| 有効期間 | 任意 |

```java
ReceivedMessage incomingRequest = messaging.receiveSync(queueName, timeout);
SendingMessage reply = incomingRequest.reply();
messaging.sendSync(reply.setFormatter(formatter)
    .addRecord(new HashMap() {{ put("data1", "value1"); }})
);
```

<details>
<summary>keywords</summary>

システム間メッセージング機能, メッセージング, MessagingContext, SendingMessage, ReceivedMessage, sendSync, receiveSync, reply, setDestination, setReplyTo, setTimeToLive, setFormatter, addRecord, 応答不要メッセージ送信, 同期応答メッセージ送信, 応答不要メッセージ受信, 同期応答メッセージ受信, プロトコルヘッダー, 送受信パターン

</details>

## システム間メッセージング機能

なし

メッセージング基盤APIの実装系を与えるモジュール。JMSメッセージングプロバイダと組込みメッセージングプロバイダの2種類がある。

<details>
<summary>keywords</summary>

システム間メッセージング機能, メッセージング基盤, メッセージングプロバイダ, フレームワーク機能, MessagingProvider, JMSメッセージングプロバイダ, 組込みメッセージングプロバイダ

</details>

## 全体構成

**1. メッセージング基盤API**
以下の4種類の送受信処理APIを提供するクラス群:
- 応答不要メッセージ送信
- 同期応答メッセージ送信
- 応答不要メッセージ受信
- 同期応答メッセージ受信

**2. メッセージングプロバイダ**
メッセージング基盤APIの実装系:
- **JMSメッセージングプロバイダ**: JMSインターフェース実装。JMS互換のメッセージングミドルウェアで利用可能。
- **組込みメッセージングプロバイダ**: JVM上のサブスレッドとして動作するMOMを使用。自動テスト専用。

**3. フレームワーク機能**
メッセージング基盤APIを使用した機能群。フレームワーク制御ヘッダの利用を前提として設計。
- [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md): 外部からの要求電文に適切な業務アプリケーションを実行する制御基盤。
- [messaging_sending_batch](libraries-messaging_sending_batch.md): 監視テーブルのレコードからメッセージを作成・送信する常駐バッチ。業務側はINSERT文のみでメッセージ送信可能。応答不要メッセージ送信で使用。
- [messaging_sender_util](libraries-messaging_sender_util.md): 対外システムへの同期メッセージ送信ユーティリティ。フレームワーク制御ヘッダの再送電文フラグによる再送/タイムアウト機構を実装。応答なしメッセージ送信には [messaging_sending_batch](libraries-messaging_sending_batch.md) を使用。

JMSインターフェース実装を使用したメッセージングコンテキストの実装。JMS互換のメッセージングミドルウェアであれば利用可能。

**クラス**: `nablarch.fw.messaging.provider.JndiLookingUpJmsMessagingProvider`

## Poison電文の退避

JMSXDeliveryCountヘッダに依存するため、同ヘッダをサポートしない一部のMOM製品/バージョンでは利用不可。サポート確認済みMOM: Websphere MQ、WebLogic MQ、ActiveMQ。

## 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| connectionFactoryJndiName | String | ○ | | JMSコネクションファクトリのJNDI名 |
| destinationNamePairs | Map<String, String> | ○ | | キュー論理名とJNDI名のMap |
| defaultResponseTimeout | long | | 5分 | 同期送信時の応答タイムアウト(msec) |
| defaultTimeToLive | long | | 1分 | 送信電文の有効期間デフォルト値(msec) |
| redeliveryLimit | int | | 0 | 受信リトライ上限回数。JMSXDeliveryCountがこの値を超えると退避キューへ転送して実行時例外を送出。0以下で退避処理無効 |
| defaultPoisonQueue | String | | "DEFAULT.POISON" | デフォルト退避キューの論理名 |
| poisonQueueNamePattern | String | | "%s.POISON" | 退避キュー論理名パターン（%s=受信キュー名） |

## リポジトリによる初期化設定例（WebLogicMQ）

```xml
<component name="messagingProvider"
           class="nablarch.fw.messaging.provider.JndiLookingUpJmsMessagingProvider">
    <property name="jndiHelper">
        <component class="nablarch.core.repository.jndi.JndiHelper">
            <property name="jndiProperties">
                <map>
                    <entry key="java.naming.factory.initial" value="weblogic.jndi.WLInitialContextFactory"/>
                    <entry key="java.naming.provider.url"    value="t3://192.168.160.125:7001"/>
                </map>
            </property>
        </component>
    </property>
    <property name="connectionFactoryJndiName" value="javax.jms.QueueConnectionFactory"/>
    <property name="destinationNamePairs">
        <map>
            <entry key="TEST.REQUEST"  value="TEST.REQUEST"/>
            <entry key="TEST.RESPONSE" value="TEST.RESPONSE"/>
        </map>
    </property>
</component>
```

<details>
<summary>keywords</summary>

メッセージング基盤API, JMSメッセージングプロバイダ, 組込みメッセージングプロバイダ, 応答不要メッセージ送信, 同期応答メッセージ送信, 応答不要メッセージ受信, 同期応答メッセージ受信, フレームワーク機能, JndiLookingUpJmsMessagingProvider, JmsMessagingProvider, connectionFactoryJndiName, destinationNamePairs, defaultResponseTimeout, defaultTimeToLive, redeliveryLimit, defaultPoisonQueue, poisonQueueNamePattern, JMSXDeliveryCount, Poison電文, JMS, JNDI, ConnectionFactory, JndiHelper, jndiHelper

</details>

## 

なし

開発・テスト環境向けのメッセージングプロバイダ。JVM上のサブスレッドとして動作するMOMを使用。外部接続不要で、キュー論理名の設定のみで動作する。

**クラス**: `nablarch.test.core.messaging.EmbeddedMessagingProvider`

## リポジトリによる初期化設定例

```xml
<component name="messagingProvider"
           class="nablarch.test.core.messaging.EmbeddedMessagingProvider">
    <property name="queueNames">
        <list>
            <value>TEST.REQUEST</value>
            <value>TEST.REQUEST.POISON</value>
            <value>TEST.RESPONSE</value>
            <value>TEST.RESPONSE.POISON</value>
        </list>
    </property>
    <property name="defaultTimeToLive" value="0" />
</component>
```

<details>
<summary>keywords</summary>

message_model, メッセージデータモデル, EmbeddedMessagingProvider, queueNames, defaultTimeToLive, 組込みメッセージングプロバイダ, テスト用メッセージングプロバイダ, ローカルキュー

</details>

## 基本概念

**プロトコルヘッダー**
MOMによるメッセージ送受信処理で使用される情報を格納したヘッダー領域。Mapインターフェースでアクセス可能。

**共通プロトコルヘッダー**
メッセージングコンテキストが使用するヘッダー群。特定のキー名でアクセス可能。

| ヘッダー論理名 | キー名 | 内容 | JMS実装 |
|---|---|---|---|
| メッセージID | MessageId | MOMが電文ごとに一意採番する文字列。送信時:MOMが採番した値。受信時:送信側MOMが発番した値。 | MessageID JMSヘッダー |
| 関連メッセージID | CorrelationId | 関連電文のメッセージID。応答電文:要求電文のMessageId。再送要求:応答再送を要求する要求電文のMessageId。 | CorrelationID JMSヘッダー |
| 送信宛先 | Destination | 電文の送信宛先論理名。送信時:送信キュー論理名。受信時:受信キュー論理名。 | 送信キューのDestinationオブジェクト論理名 |
| 応答宛先 | ReplyTo | 応答送信先論理名。同期応答送信時:応答受信キュー論理名。応答不要送信時:設定不要。受信時(同期応答):応答宛先キュー論理名が設定されている。受信時(応答不要):通常は何も設定されていない。 | 応答受信キューのDestinationオブジェクト論理名 |
| 有効期間 | TimeToLive | 送信処理開始時点からの電文有効期間(msec)。受信時は設定されない。 | Expiration JMSヘッダーに(送信時刻+有効期間)を設定 |

共通プロトコルヘッダー以外のヘッダーは**個別プロトコルヘッダ**としてプロバイダ側で任意に定義可能。JMSの場合、JMSヘッダー・JMS拡張ヘッダー・任意属性はすべて個別プロトコルヘッダとして扱われる。

**メッセージボディ**
プロトコルヘッダーを除いたデータ領域。メッセージングコンテキストはプロトコルヘッダー領域のみ使用し、それ以外は未解析のバイナリデータとして扱う。メッセージボディの解析は [record_format](libraries-record_format.md) で行い、フィールド名をキーとするMap形式で読み書き可能。

**フレームワーク制御ヘッダー**
フレームワーク機能が電文中に定義されていることを前提とする制御項目群。

| フレームワーク制御ヘッダ | フィールド名 | 役割 | 使用するハンドラ |
|---|---|---|---|
| リクエストID | requestId | 実行すべき業務処理を識別するID | [../handler/RequestPathJavaPackageMapping](../handlers/handlers-RequestPathJavaPackageMapping.md), [../handler/RequestHandlerEntry](../handlers/handlers-RequestHandlerEntry.md), [../handler/ServiceAvailabilityCheckHandler](../handlers/handlers-ServiceAvailabilityCheckHandler.md), [../handler/PermissionCheckHandler](../handlers/handlers-PermissionCheckHandler.md), [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) 他 |
| ユーザID | userId | 電文の実行権限を表す文字列 | [../handler/PermissionCheckHandler](../handlers/handlers-PermissionCheckHandler.md) |
| 再送要求フラグ | resendFlag | 再送要求電文送信時に設定されるフラグ | [../handler/MessageResendHandler](../handlers/handlers-MessageResendHandler.md) |
| ステータスコード | statusCode | 要求電文に対する処理結果コード（応答電文に設定） | [../handler/MessageReplyHandler](../handlers/handlers-MessageReplyHandler.md) |

デフォルトではメッセージボディの最初のデータレコードに上記フィールド名で定義する必要がある。

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

フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、任意ヘッダ項目としてPJごとに簡易拡張可能。将来の項目追加に備えて予備領域を設けることを強く推奨。

<details>
<summary>keywords</summary>

プロトコルヘッダー, 共通プロトコルヘッダー, フレームワーク制御ヘッダー, MessageId, CorrelationId, Destination, ReplyTo, TimeToLive, requestId, userId, resendFlag, statusCode, NablarchHeader, メッセージボディ, 個別プロトコルヘッダ, RequestPathJavaPackageMapping, RequestHandlerEntry, ServiceAvailabilityCheckHandler, PermissionCheckHandler, FwHeaderReader, MessageResendHandler, MessageReplyHandler

</details>

## 

なし

<details>
<summary>keywords</summary>

messaging_api, メッセージング基盤API

</details>
