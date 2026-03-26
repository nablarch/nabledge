# HTTPメッセージング

## 概要

HTTPメッセージングは、本フレームワークが提供するシステム間メッセージング機能のうち、HTTPを使用した同期通信を行う機能。

**クラス**: `MessageSender`, `SyncMessage`, `HttpMessagingClient`

- **`MessageSender`**: 同期送信機能を実装したクラス
- **`SyncMessage`**: 送受信電文情報を格納するクラス
- **`HttpMessagingClient`** (`nablarch.fw.messaging.realtime.http.client.HttpMessagingClient`): HTTP通信プロトコル向けのHTTP通信インターフェース実装

### HTTPメッセージ送信

処理フロー:
1. 要求電文（`SyncMessage`）を作成
2. `MessageSender.sendSync()` で送信
3. 応答受信を待機（タイムアウトまで）
4. タイムアウト時は補償処理を実施

> **重要**: 規定時間内に応答を受信できずタイムアウトした場合は、補償処理を行う必要がある。

コード例（送信）:
```java
SyncMessage requestMessage = new SyncMessage("RM11AC0202")
    .addDataRecord(new HashMap() {{
        put("FIcode",     "9999");
        put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
        put("officeCode", "111");
    }});
SyncMessage responseMessage = MessageSender.sendSync(requestMessage);
```

HTTPヘッダーに独自項目を追加する場合:
```java
requestMessage.getHeaderRecord().put("Accept-Charset", "UTF-8");
```

### HTTP通信クライアント設定

コンポーネント定義:
```xml
<component
  name="defaultMessageSenderClient"
  class="nablarch.fw.messaging.realtime.http.client.HttpMessagingClient">
</component>
```

> **注意**: `HttpMessagingClient.sendSync(MessageSenderSettings, SyncMessage)` を用いたHTTPメッセージングにおいて、通信先からHTTPステータスコード「302」が返却された場合、フレームワーク側でリダイレクト処理が自動実施される。リダイレクト処理を無効化したい場合は、カスタム実装が必要。

リダイレクト無効化のカスタム実装:

コンポーネント定義にカスタムクライアントを設定:
```xml
<component
  name="defaultMessageSenderClient"
  class="please.change.me.common.CustomHttpMessagingClient">
</component>
```

`HttpMessagingClient` を継承したカスタムクライアント:
```java
public class CustomHttpMessagingClient extends HttpMessagingClient {
  protected HttpProtocolClient createHttpProtocolClient() {
    return new CustomHttpProtocolBasicClient();
  }
}
```

`HttpProtocolBasicClient` を継承してリダイレクトを無効化:
```java
public class CustomHttpProtocolBasicClient extends HttpProtocolBasicClient {
  @Override
  protected HttpURLConnection createHttpConnection(String targetUrl, HttpRequestMethodEnum method, Map<String, List<String>> headerInfo)
      throws IOException {
    HttpURLConnection httpConnection = super.createHttpConnection(targetUrl, method, headerInfo);
    httpConnection.setInstanceFollowRedirects(false);
    return httpConnection;
  }
}
```

<details>
<summary>keywords</summary>

HTTPメッセージング, システム間メッセージング, HTTP同期通信, MessageSender, SyncMessage, HttpMessagingClient, HttpProtocolBasicClient, HttpProtocolClient, CustomHttpMessagingClient, CustomHttpProtocolBasicClient, HttpURLConnection, HttpRequestMethodEnum, MessageSenderSettings, HTTP メッセージ送信, 同期送信, 通信クライアント, リダイレクト無効化, HTTPヘッダー設定, タイムアウト補償処理

</details>

## 要求

## 実装済み

- HTTP(S)を使用して同期通信可能
- 任意のHTTPメソッド、任意のHTTPヘッダ、メッセージボディにJSON/XML形式を使用した送受信
- HTTP接続タイムアウト設定（接続タイムアウト、読み取りタイムアウト）
- proxy経由接続
- 送受信時のデータ加工実装の差し込み（例：特定項目の暗号化/復号）

## 未実装

- BASIC認証、Digest認証は使用不可
- HTTPSのプライベート認証局発行証明書による通信は不可
- パラメータをURLの一部またはクエリストリングとした送受信は不可
- HTTPヘッダ以外（クエリパラメータや電文本文など）からのメッセージID/関連ID取得は不可

## 未検討

- マルチパート形式のメッセージボディ送信
- FORM認証
- HTTPリクエストの自動再送（NAF側での自動再送なし。actionでの再送処理実装は可能）
- Keep Alive対応
- 仕向け通信レスポンスの正常時/エラー時フォーマット切り替え

<details>
<summary>keywords</summary>

HTTP同期通信, HTTPメソッド, タイムアウト設定, proxy接続, データ加工, BASIC認証未実装, クエリストリング未実装

</details>

## 全体構成

本機能は以下の2つのレイヤで構成される。

**レイヤ（フレームワーク機能）**

メッセージング基盤APIを使用した機能。フレームワーク制御ヘッダーの利用を前提として設計されている。

- [../architectural_pattern/messaging](../../processing-pattern/mom-messaging/mom-messaging-messaging.md): 外部から送信される要求電文に対して適切な業務アプリケーションを実行する制御基盤。MOMを使用した場合と同一のインタフェースでメッセージ受信アプリケーションを実装可能。HTTPメッセージ受信処理を担う。
- [messaging_sender_util](libraries-messaging_sender_util.md): 対外システムへのメッセージ同期送信ユーティリティ。MOMを使用した場合と同一のインタフェースでメッセージ同期送信可能。

**レイヤ（通信クライアント）**

- HTTP通信クライアント: HTTP通信インターフェースの実装系を使用したHTTP通信の実装。HTTPメッセージ送信処理を担う。

<details>
<summary>keywords</summary>

メッセージング基盤API, HTTP通信クライアント, MessagingAction, HTTPメッセージ受信, HTTPメッセージ送信, messaging_sender_util

</details>

## データモデル

**プロトコルヘッダー**

Webコンテナによるメッセージ送受信処理において使用される情報を格納するヘッダー領域。Mapインターフェースでアクセス可能。

**共通プロトコルヘッダー**

プロトコルヘッダーのうち、特定のキー名でアクセス可能なヘッダー。

| ヘッダー論理名 | キー名 | 内容 | HTTP通信実装の場合 |
|---|---|---|---|
| メッセージID | X-Message-Id | 電文ごとに一意採番される文字列。送信時は採番した値が設定される。受信時は送信側の発番した値が設定される。 | HTTPヘッダーの値を設定 |
| 関連メッセージID | X-Correlation-Id | 電文が関連する電文のメッセージID。応答電文では要求電文のメッセージIDを設定。再送要求では応答再送を要求する要求電文のメッセージIDを設定。 | HTTPヘッダーの値を設定 |

**メッセージボディ**

HTTPリクエストのデータ領域。フレームワーク機能はプロトコルヘッダー領域のみを使用し、それ以外のデータ領域は未解析のバイナリデータとして扱う。メッセージボディの解析は [record_format](libraries-record_format.md) で行い、フィールド名をキーとするMap形式で読み書き可能。

**フレームワーク制御ヘッダー**

フレームワーク機能の多くは、電文中に特定の制御項目（フレームワーク制御ヘッダ）が定義されていることを前提として設計されている。

フレームワーク制御ヘッダーと使用する主要ハンドラの対応:

| フレームワーク制御ヘッダ | 役割 | 使用する主要ハンドラ |
|---|---|---|
| リクエストID | 実行すべき業務処理を識別するID | [../handler/RequestPathJavaPackageMapping](../handlers/handlers-RequestPathJavaPackageMapping.md), [../handler/RequestHandlerEntry](../handlers/handlers-RequestHandlerEntry.md), [../handler/ServiceAvailabilityCheckHandler](../handlers/handlers-ServiceAvailabilityCheckHandler.md), [../handler/PermissionCheckHandler](../handlers/handlers-PermissionCheckHandler.md), [../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) など |
| ユーザID | 実行権限を表す文字列 | [../handler/PermissionCheckHandler](../handlers/handlers-PermissionCheckHandler.md) |
| 再送要求フラグ | 再送要求電文送信時に設定されるフラグ | [../handler/MessageResendHandler](../handlers/handlers-MessageResendHandler.md) |
| ステータスコード | 要求電文に対する処理結果を表すコード値（応答電文に設定） | [../handler/MessageReplyHandler](../handlers/handlers-MessageReplyHandler.md) |

デフォルト設定でのフィールド名:

| フレームワーク制御ヘッダ | フィールド名 |
|---|---|
| リクエストID | requestId |
| ユーザID | userId |
| 再送要求フラグ | resendFlag |
| ステータスコード | statusCode |

フレームワーク制御ヘッダの定義例:

```
[NablarchHeader]
1   requestId   X(10)       # リクエストID
11  userId      X(10)       # ユーザID
21  resendFlag  X(1)  "0"   # 再送要求フラグ (0: 初回送信 1: 再送要求)
22  statusCode  X(4)  "200" # ステータスコード
26 ?filler      X(25)       # 予備領域
```

> **補足**: フォーマット定義にフレームワーク制御ヘッダ以外の項目を含めた場合、任意ヘッダ項目としてアクセスでき、PJ毎のフレームワーク制御ヘッダの簡易的な拡張に利用できる。将来的な任意項目の追加やヘッダ追加に備えて予備領域を設けることを強く推奨する。

<details>
<summary>keywords</summary>

プロトコルヘッダー, X-Message-Id, X-Correlation-Id, メッセージボディ, フレームワーク制御ヘッダー, requestId, userId, resendFlag, statusCode, NablarchHeader

</details>

## フレームワーク機能

使用するクラス:

- **クラス**: `MessagingAction` — メッセージ受信時に実行されるアクションクラスの基底クラス。業務アプリケーションは本クラスを継承する必要がある。
- **クラス**: `ReceivedMessage` — 受信した電文に関する情報を格納するクラス。

**HTTPメッセージ受信**

通信先システムからメッセージを受信し、その応答を送信する処理パターン。受信処理はフレームワーク機能により自動的に業務アプリケーションクラスが実行されるため、明示的に受信処理を行うコードを記述する必要はない。

```java
public class SampleAction extends MessagingAction {
    protected ResponseMessage onReceive(RequestMessage request,
                                        ExecutionContext context) {
        // 受信データ処理
        Map<String, Object> reqData = request.getParamMap();
        
        // 応答データ返却
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

<details>
<summary>keywords</summary>

MessagingAction, ReceivedMessage, HTTPメッセージ受信, onReceive, ResponseMessage, RequestMessage, ExecutionContext

</details>
