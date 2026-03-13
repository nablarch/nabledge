# HTTPメッセージング

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/system_messaging/http_system_messaging.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessageSender.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/MessageSenderClient.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/realtime/http/client/HttpMessagingClient.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/SyncMessage.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/FwHeaderDefinition.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/StandardFwHeaderDefinition.html)

## 機能概要

> **重要**: フレームワーク制御ヘッダは [メッセージボディ](#s5) に含めることを想定しているため、外部システムで既に電文フォーマットが規定されている場合は適合しない可能性がある。推奨代替機能:
> - サーバサイド(メッセージ受信): :ref:`restful_web_service` を使用推奨
> - クライアントサイド(メッセージ送信): JSR339(JAX-RS2.0)のClient機能を使用推奨
>
> やむを得ず本機能を使用する場合は [http_system_messaging-change_fw_header](#s4) を参照してプロジェクトで実装を追加すること。

送受信の種類と実行制御基盤:

| 送受信の種類 | 実行制御基盤 |
|---|---|
| [http_system_messaging-message_receive](#s3) (HTTPメッセージ受信) | :ref:`http_messaging` |
| [http_system_messaging-message_send](#s3) (HTTPメッセージ送信) | 実行制御基盤に依存しない |

[mom_system_messaging](libraries-mom_system_messaging.md) と同じ以下のAPIでメッセージ送受信を実装できる:
- `MessagingAction`
- `MessageSender`

<details>
<summary>keywords</summary>

HTTPメッセージング, MessagingAction, MessageSender, 送受信の種類, 実行制御基盤, MOMメッセージング, mom_system_messaging

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-messaging-http</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-messaging, nablarch-fw-messaging-http, モジュール依存関係, Maven

</details>

## 使用方法

### HTTPメッセージングを使うための設定

- メッセージ受信: 実行制御基盤のハンドラ構成以外に特に設定不要
- メッセージ送信: `MessageSenderClient` の実装クラスをコンポーネント定義に追加する

デフォルト実装の `HttpMessagingClient` を使用する場合、コンポーネント名は `messageSenderClient` と指定する:

```xml
<component name="messageSenderClient"
           class="nablarch.fw.messaging.realtime.http.client.HttpMessagingClient" />
```

### メッセージを受信する(HTTPメッセージ受信)

`MessagingAction` を継承して作成する。応答電文は `RequestMessage.reply` で作成する。

```java
public class SampleAction extends MessagingAction {
    protected ResponseMessage onReceive(RequestMessage request, ExecutionContext context) {
        Map<String, Object> reqData = request.getParamMap();
        return request.reply()
                .setStatusCodeHeader("200")
                .addRecord(new HashMap() {{
                     put("FIcode",     "9999");
                     put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
                     put("officeCode", "111");
                  }});
    }
}
```

### メッセージを送信する(HTTPメッセージ送信)

- 要求電文は `SyncMessage` で作成する
- 送信には `MessageSender.sendSync` を使用する
- 規定時間内に応答を受信できずにタイムアウトした場合は補償処理が必要

```java
SyncMessage requestMessage = new SyncMessage("RM11AC0202")
                               .addDataRecord(new HashMap() {{
                                    put("FIcode",     "9999");
                                    put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
                                    put("officeCode", "111");
                                }});
SyncMessage responseMessage = MessageSender.sendSync(requestMessage);
```

HTTPヘッダに独自項目を追加する場合はヘッダレコードに設定する:

```java
requestMessage.getHeaderRecord().put("Accept-Charset", "UTF-8");
```

<details>
<summary>keywords</summary>

MessageSenderClient, HttpMessagingClient, MessagingAction, RequestMessage, ResponseMessage, SyncMessage, MessageSender, messageSenderClient, HTTPメッセージ受信, HTTPメッセージ送信, 設定方法, sendSync

</details>

## 拡張例

### フレームワーク制御ヘッダの読み書きを変更する

- **HTTPメッセージ送信の場合**: メッセージボディのフォーマット定義を変更する
- **HTTPメッセージ受信の場合**: `FwHeaderDefinition` インタフェースを実装したクラスを作成し、[http_messaging_request_parsing_handler](../handlers/handlers-http_messaging_request_parsing_handler.md) と [http_messaging_response_building_handler](../handlers/handlers-http_messaging_response_building_handler.md) に設定する。デフォルト実装は `StandardFwHeaderDefinition`

> **補足**: フレームワーク制御ヘッダの使用は任意。特別要件がない限り使用不要。

### HTTPメッセージ送信のHTTPクライアント処理を変更する

`HttpMessagingClient` のデフォルト動作がプロジェクト要件に合わない場合は、同クラスを継承したクラスを作成し、[http_system_messaging-settings](#s3) の方法でコンポーネント定義に追加する。

デフォルト動作例: HTTPヘッダに `Accept: text/json,text/xml` が固定設定される。

<details>
<summary>keywords</summary>

FwHeaderDefinition, StandardFwHeaderDefinition, HttpMessagingClient, http_messaging_request_parsing_handler, http_messaging_response_building_handler, フレームワーク制御ヘッダ変更, HTTPクライアントカスタマイズ, Accept

</details>

## 送受信電文のデータモデル

![送受信電文のデータモデル](../../../knowledge/component/libraries/assets/libraries-http_system_messaging/http_system_messaging-data_model.png)

**プロトコルヘッダ**: ウェブコンテナによるメッセージ送受信処理で使用される情報を格納したヘッダ領域。Mapインターフェースでアクセス可能。

**共通プロトコルヘッダ** (フレームワークが使用する特定キーでアクセス可能):

| ヘッダ名 | キー名 | 説明 |
|---|---|---|
| メッセージID | X-Message-Id | 電文ごとに一意採番。送信時は送信処理で採番した値、受信時は送信側が発番した値 |
| 関連メッセージID | X-Correlation-Id | 応答電文では要求電文のメッセージID、再送要求では応答再送を要求する要求電文のメッセージID |

**メッセージボディ**: HTTPリクエストのデータ領域。[data_format](libraries-data_format.md) で解析し、フィールド名をキーとするMap形式で読み書き可能。フレームワーク機能はプロトコルヘッダ領域のみを使用し、それ以外は未解析のバイナリデータとして扱う。

**フレームワーク制御ヘッダ** (デフォルトではメッセージボディの最初のデータレコードに定義):

| 制御項目 | フィールド名 | 使用ハンドラ |
|---|---|---|
| リクエストID | requestId | [request_path_java_package_mapping](../handlers/handlers-request_path_java_package_mapping.md), [message_resend_handler](../handlers/handlers-message_resend_handler.md), :ref:`permission_check_handler`, :ref:`ServiceAvailabilityCheckHandler` |
| ユーザID | userId | :ref:`permission_check_handler` |
| 再送要求フラグ | resendFlag | [message_resend_handler](../handlers/handlers-message_resend_handler.md) |
| ステータスコード | statusCode | [message_reply_handler](../handlers/handlers-message_reply_handler.md) |

フォーマット定義例:
```
[NablarchHeader]
1   requestId   X(10)       # リクエストID
11  userId      X(10)       # ユーザID
21  resendFlag  X(1)  "0"   # 再送要求フラグ (0: 初回送信 1: 再送要求)
22  statusCode  X(4)  "200" # ステータスコード
26 ?filler      X(25)       # 予備領域
```

フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、任意ヘッダ項目としてアクセスでき、フレームワーク制御ヘッダを簡易拡張できる。将来的な項目追加に備え予備領域を設けることを強く推奨する。

<details>
<summary>keywords</summary>

プロトコルヘッダ, 共通プロトコルヘッダ, メッセージボディ, フレームワーク制御ヘッダ, X-Message-Id, X-Correlation-Id, requestId, userId, resendFlag, statusCode, データモデル, NablarchHeader, ServiceAvailabilityCheckHandler

</details>
