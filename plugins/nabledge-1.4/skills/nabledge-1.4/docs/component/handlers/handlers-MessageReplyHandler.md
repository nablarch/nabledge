# 電文応答制御ハンドラ

## 

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, 電文応答制御ハンドラ

</details>

## 概要

後続ハンドラの処理結果である`ResponseMessage`オブジェクトをもとに応答電文を構築し送信する。送信した応答電文オブジェクトをこのハンドラの戻り値として返す。

<details>
<summary>keywords</summary>

MessageReplyHandler, ResponseMessage, 応答電文構築, 応答電文送信, メッセージング

</details>

## 

応答電文の内容を編集するハンドラは全てこのハンドラの後続に配置すること。

ハンドラキュー構成例（サブスレッド）: `MessagingContextHandler` → `MessageReplyHandler` → `DataReadHandler_messaging` → `TransactionManagementHandler`

**関連するハンドラ**

| ハンドラ | 配置要件 |
|---|---|
| [MessagingContextHandler](handlers-MessagingContextHandler.md) | スレッドローカルのメッセージングコンテキストを使用するため、本ハンドラより上位に配置すること |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | **2相コミット使用時**: DBトランザクションとJMSトランザクションをまとめてコミットするため、本ハンドラより先に実行すること。**2相コミット未使用時**: 応答送信前にDBトランザクションを終了させる必要があるため、本ハンドラの後に実行すること |
| [DataReadHandler](handlers-DataReadHandler.md) | 要求電文のフォーマット不正に起因する例外のエラー応答を本ハンドラで送信するには、本ハンドラの後続に配置すること |

<details>
<summary>keywords</summary>

MessagingContextHandler, TransactionManagementHandler, DataReadHandler, ハンドラ配置順序, 2相コミット, 関連するハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 特段の処理を行わず後続ハンドラに委譲し、処理結果を取得する。

**[復路処理]**
2. 処理結果が`ResponseMessage`の場合はキャストして以降の処理で使用する。
   - **2a.** 処理結果が`DataReader.NoMoreRecord`（受信待機タイムアウト）の場合は、応答処理を行わずそのままリターンする。
   - **2b.** 処理結果が`ResponseMessage`でも`DataReader.NoMoreRecord`でもない場合は、`java.lang.ClassCastException`を送出する。
3. フレームワーク制御ヘッダの処理結果コードが未設定の場合は、処理結果オブジェクトのステータスコードを設定する。
4. スレッドローカルのメッセージコンテキストを使用して応答電文を応答キューへPUTする。
5. 応答電文オブジェクトをリターンする（後続ハンドラで例外が発生していた場合はその例外を再送出する）。

**[例外処理]**
- **2c.** 後続ハンドラで実行時例外/エラーが発生した場合、エラー内容をもとに応答電文を作成し3.以降で使用する（元例外はハンドラ終了時に再送出）。
- **4a.** 送信処理中に例外が発生した場合は、応答を断念し例外を再送出する。
- **4b.** 送信中に例外が発生し、かつ後続ハンドラでも例外が発生していた場合（2c.）、送信例外をWARNINGレベルのログに出力し、2c.で捕捉した例外を再送出する。

<details>
<summary>keywords</summary>

ResponseMessage, DataReader.NoMoreRecord, 往路処理, 復路処理, 例外処理, ClassCastException, 応答キュー

</details>

## 設定項目・拡張ポイント

設定項目なし。

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler" />
```

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, 設定項目なし, component

</details>
