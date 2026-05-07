# HTTPメッセージング

**目次**

* 機能概要

  * [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging) と同じ作り方ができる
* モジュール一覧
* 使用方法

  * HTTPメッセージングを使うための設定
  * メッセージを受信する(HTTPメッセージ受信)
  * メッセージを送信する(HTTPメッセージ送信)
* 拡張例

  * フレームワーク制御ヘッダの読み書きを変更する
  * HTTPメッセージ送信のHTTPクライアント処理を変更する
* 送受信電文のデータモデル

HTTPを使ったメッセージの送受信を行う機能を提供する。

HTTPメッセージングでは、 [送受信電文のデータモデル](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-data-model) に示したデータモデルを前提としている。
また、メッセージのフォーマットには、 [汎用データフォーマット](../../component/libraries/libraries-data-format.md#data-format) を使用する。

> **Important:**
> [送受信電文のデータモデル](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-data-model) の中で、
> [フレームワーク制御ヘッダ](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging-fw-header) については、
> Nablarchで独自に規定している項目となり、 [メッセージボディ](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-message-body) に含めることを想定している。

> プロジェクト側で電文フォーマットを設計できる場合は問題ないが、外部システムにより既に電文フォーマットが規定されている場合は、この想定が適合しない場合がある。

> このため、本機能ではなく以下の機能を使用することを推奨する。

> * >   サーバサイド(メッセージ受信)については、 [RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) の使用を推奨する。
> * >   クライアントサイド(メッセージ送信)については、Jakarta RESTful Web Servicesにて提供されるClient機能の使用を推奨する。

> なお、本機能をやむを得ない事情にて使用しなければならない場合は、 [フレームワーク制御ヘッダの読み書きを変更する](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-change-fw-header) を参照し、プロジェクトで実装を追加して対応すること。

HTTPメッセージングは送受信の種類により、想定している実行制御基盤が異なる。

| 送受信の種類 | 実行制御基盤 |
|---|---|
| [HTTPメッセージ受信](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-message-receive) | [HTTPメッセージング](../../processing-pattern/http-messaging/http-messaging-http-messaging.md#http-messaging) |
| [HTTPメッセージ送信](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-message-send) | 実行制御基盤に依存しない |

## 機能概要

### [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging) と同じ作り方ができる

HTTPメッセージングでは、メッセージの送受信の実装を [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging) と同じ以下のAPIで行う。
そのため、 [MOMメッセージング](../../component/libraries/libraries-mom-system-messaging.md#mom-system-messaging) の経験があれば、少ない学習時間で実装できる。

* MessagingAction
* MessageSender

## モジュール一覧

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

## 使用方法

### HTTPメッセージングを使うための設定

メッセージ受信の場合は、実行制御基盤のハンドラ構成以外に特に設定は不要である。

メッセージ送信の場合は、以下のクラスをコンポーネント定義に追加する。

* MessageSenderClient の実装クラス (HTTPの送受信)

以下に設定例を示す。

ポイント

* MessageSenderClient のデフォルト実装として
  HttpMessagingClient を提供している。
* ルックアップして使用されるため、コンポーネント名は `messageSenderClient` と指定する。

```xml
<component name="messageSenderClient"
           class="nablarch.fw.messaging.realtime.http.client.HttpMessagingClient" />
```

### メッセージを受信する(HTTPメッセージ受信)

外部システムからメッセージを受信し、その応答を送信する。

![http_system_messaging-message_receive.png](../../../knowledge/assets/libraries-http-system-messaging/http_system_messaging-message_receive.png)

実装例

ポイント

* HTTPメッセージ受信は、 MessagingAction で作成する。
* 応答電文は、 RequestMessage.reply で作成する。

```java
public class SampleAction extends MessagingAction {
    protected ResponseMessage onReceive(RequestMessage request,
                                        ExecutionContext context) {
        // 受信データ処理
        Map<String, Object> reqData = request.getParamMap();

        // (省略)

        // 応答データ返却
        return request.reply()
                .setStatusCodeHeader("200")
                .addRecord(new HashMap() {{     // メッセージボディの内容
                     put("FIcode",     "9999");
                     put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
                     put("officeCode", "111");
                     /*
                      * (後略)
                      */
                  }});
    }
}
```

### メッセージを送信する(HTTPメッセージ送信)

外部システムに対してメッセージを送信し、その応答を受信する。
応答メッセージを受信するか、待機タイムアウト時間が経過するまで待機する。

規定時間内に応答を受信できずにタイムアウトした場合は、何らかの補償処理を行う必要がある。

![http_system_messaging-message_send.png](../../../knowledge/assets/libraries-http-system-messaging/http_system_messaging-message_send.png)

実装例

ポイント

* 要求電文は、 SyncMessage で作成する。
* メッセージ送信には、 MessageSender#sendSync を使用する。
  使い方の詳細は、リンク先のJavadocを参照。

```java
// 要求電文の作成
SyncMessage requestMessage = new SyncMessage("RM11AC0202")        // メッセージIDを設定
                               .addDataRecord(new HashMap() {{    // メッセージボディの内容
                                    put("FIcode",     "9999");
                                    put("FIname",     "ﾅﾌﾞﾗｰｸｷﾞﾝｺｳ");
                                    put("officeCode", "111");
                                    /*
                                     * (後略)
                                     */
                                }})
// 要求電文の送信
SyncMessage responseMessage = MessageSender.sendSync(requestMessage);
```

また、HTTPヘッダとして独自の項目を送信したい場合は、下記のように作成したメッセージのヘッダレコードに設定する。

```java
// メッセージヘッダの内容
requestMessage.getHeaderRecord().put("Accept-Charset", "UTF-8");
```

## 拡張例

### フレームワーク制御ヘッダの読み書きを変更する

外部システムで既に電文フォーマットが規定されている場合など、
フレームワーク制御ヘッダの読み書きを変更したい場合がある。
この場合は、プロジェクトで実装を追加することで対応する。
以下に、送受信の種類ごとに対応方法を示す。

HTTPメッセージ送信の場合

フレームワーク制御ヘッダの読み書きは、メッセージボディのフォーマット定義により行う。
そのため、変更内容に合わせてメッセージボディのフォーマット定義を変更すればよい。

HTTPメッセージ受信の場合

フレームワーク制御ヘッダの読み書きは、
FwHeaderDefinition インタフェースを実装したクラスが行う。
デフォルトでは、 StandardFwHeaderDefinition が使用される。

そのため、 StandardFwHeaderDefinition を参考に、
プロジェクトで FwHeaderDefinition インタフェースを実装したクラスを作成し、
[HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-http-messaging-request-parsing-handler.md#http-messaging-request-parsing-handler) と [HTTPメッセージングレスポンス変換ハンドラ](../../component/handlers/handlers-http-messaging-response-building-handler.md#http-messaging-response-building-handler) に設定すればよい。

> **Tip:**
> フレームワーク制御ヘッダを使用するか否かは任意に選択できる。
> このため、特別要件がない限りフレームワーク制御ヘッダを使用する必要はない。

### HTTPメッセージ送信のHTTPクライアント処理を変更する

HTTPメッセージ送信では、 [HTTPメッセージングを使うための設定](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-settings) で説明した通り、
HttpMessagingClient を使用している。

HttpMessagingClient
では、HTTPクライアントとして様々な処理を行っている。
例えば、送信するメッセージのHTTPヘッダに、 `Accept: text/json,text/xml` が固定で設定される。

もし、HttpMessagingClient
のデフォルト動作がプロジェクトの要件に合わない場合は、
HttpMessagingClient
を継承したクラスを作成し、 [HTTPメッセージングを使うための設定](../../component/libraries/libraries-http-system-messaging.md#http-system-messaging-settings) に示した方法でコンポーネント定義に追加することでカスタマイズを行うこと。

## 送受信電文のデータモデル

HTTPメッセージングでは、送受信電文の内容を以下のデータモデルで表現する。

![http_system_messaging-data_model.png](../../../knowledge/assets/libraries-http-system-messaging/http_system_messaging-data_model.png)

プロトコルヘッダ

主にウェブコンテナによるメッセージ送受信処理において使用される情報を格納したヘッダ領域である。
プロトコルヘッダはMapインターフェースでアクセスすることが可能となっている。

共通プロトコルヘッダ

プロトコルヘッダのうち、フレームワークが使用する以下のヘッダについては、特定のキー名でアクセスできる。
キー名をカッコで示す。

メッセージID(X-Message-Id)

電文ごとに一意採番される文字列

送信処理の際に採番した値

送信側が発番した値

関連メッセージID(X-Correlation-Id)

電文が関連する電文のメッセージID

要求電文のメッセージID

応答再送を要求する要求電文のメッセージID

メッセージボディ

HTTPリクエストのデータ領域をメッセージボディと呼ぶ。
フレームワーク機能は、原則としてプロトコルヘッダ領域のみを使用する。
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
