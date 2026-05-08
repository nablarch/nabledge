## メッセージングコンテキスト管理ハンドラ

**クラス名:** `nablarch.fw.messaging.handler.MessagingContextHandler`

-----

### 概要

メッセージングコンテキストの管理を行うハンドラ。

リクエストスレッド毎にメッセージングコンテキスト初期化とスレッドローカル変数への格納、
および終端処理を行う。
メッセージングコンテキストをはじめとする、本フレームワークのメッセージング機能の内容については、
[システム間メッセージング機能](../../component/libraries/libraries-enterprise-messaging.md) を参照すること。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| マルチスレッド実行制御ハンドラ | nablarch.fw.handler.MultiThreadExecutionHandler | Object | MultiStatus | サブスレッドを作成し、後続ハンドラの処理を並行実行する。 実行コンテキスト上にデータリーダが存在しない場合は、コールバックを行う。 | 全スレッドの正常終了まで待機する。 | 処理中のスレッドが完了するまで待機し起因例外を再送出する。 | 1. 処理開始前 / 2. データリーダ作成 / 3. スレッド異常終了時 / 4. 処理完了時 |
| メッセージングコンテキスト管理ハンドラ | nablarch.fw.messaging.handler.MessagingContextHandler | Object | Object | メッセージングコンテキスト(MQ接続)を取得し、スレッドローカルに保持する。 | メッセージングコンテキストを開放する。（プールに戻す） | メッセージングコンテキストを開放する。（プールに戻す） | - |
| 電文応答制御ハンドラ | nablarch.fw.messaging.handler.MessageReplyHandler | Object | ResponseMessage | - | 後続ハンドラから返される応答電文オブジェクトの内容をもとに電文を作成して送信する。 | エラーオブジェクトの内容をもとに電文を作成して送信する。 | - |
| データリードハンドラ(FW制御ヘッダリーダ/メッセージリーダ利用) | nablarch.fw.handler.DataReadHandler_messaging | Object | Result | 要求電文を受信しFW制御ヘッダ部を解析して要求電文オブジェクト(RequestMessage)を作成し後続のハンドラに渡す。また、FW制御ヘッダのrequestId/userIdの値をメッセージコンテキストに設定する。 | - | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) (MessageReader使用時) | メッセージ受信処理では、 [受信電文リーダ](../../component/readers/readers-MessageReader.md) を使用して受信電文の読み込みを行うが、この際、 本ハンドラが初期化するメッセージングコンテキストを使用する。 そのため、 [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) は本ハンドラの後続に配置する必要がある。 |
| [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md) | メッセージ応答処理で、本ハンドラが初期化するメッセージングコンテキストを 使用するため、 [電文応答制御ハンドラ](../../component/handlers/handlers-MessageReplyHandler.md) は、 本ハンドラの後続に配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (メッセージングコンテキストの取得)**

本ハンドラに設定された **メッセージングプロバイダ** からメッセージングコンテキストを取得する。

**2. (メッセージングコンテキストをスレッドローカルに設定)**

**1.** で取得したインスタンスを、スレッドローカルに保持する。

**3. (後続ハンドラへの処理委譲)**

ハンドラキュー上の後続ハンドラに対して処理を委譲し、その結果を取得する。

**[復路での処理]**

**4. (終端処理)**

メッセージコンテキストをクローズすることで、使用していたメッセージングサーバへの接続をコネクションプールに返却し、
スレッドローカル上からメッセージングコンテキストへの参照を除去する。

**5. (正常終了)**

**3.** での処理結果をリターンし、終了する。

**[例外処理]**

**3a. (終端処理)**

本ハンドラ、および後続ハンドラの処理中に実行時例外/エラーが発生した場合でも、
**4.** の終端処理を実行してからエラーを再送出する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。
メッセージングプロバイダの設定については、 [システム間メッセージング機能](../../component/libraries/libraries-enterprise-messaging.md)  を参照すること。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| メッセージングプロバイダ | messagingProvider | MessagingProvider | 必須指定 |

**標準設定**

```xml
<!-- メッセージコンテキスト管理ハンドラ -->
<component class="nablarch.fw.messaging.handler.MessagingContextHandler">
  <property name="messagingProvider" ref="messagingProvider" />
</component>
```
