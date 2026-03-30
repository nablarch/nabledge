# 電文応答制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

後続ハンドラの処理結果である`ResponseMessage`オブジェクトの内容をもとに応答電文を構築し送信する。送信した応答電文オブジェクトを戻り値として返す。

**関連するハンドラ**

> **重要**: 応答電文の内容を編集する必要のあるハンドラは、すべてこのハンドラの後続に配置すること。

| ハンドラ | 配置条件 |
|---|---|
| [MessagingContextHandler](handlers-MessagingContextHandler.md) | スレッドローカル上のメッセージングコンテキストを使用するため、本ハンドラより上位に配置すること |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | **2相コミット使用時**: DBトランザクションとJMSトランザクションをまとめてコミットするため、トランザクション制御ハンドラは本ハンドラより先に実行する。**2相コミット未使用時**: 応答送信前にDBトランザクションを終了させる必要があるため、トランザクション制御ハンドラは本ハンドラの後に実行する |
| [DataReadHandler](handlers-DataReadHandler.md) | 要求電文フォーマット不正による例外のエラー応答電文を本ハンドラで送信するには、[DataReadHandler](handlers-DataReadHandler.md) を本ハンドラの後続に配置すること |

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, ResponseMessage, MessagingContextHandler, TransactionManagementHandler, DataReadHandler, 電文応答制御, 応答電文送信, メッセージング, 2相コミット

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 特段の処理を行わず後続ハンドラに委譲し、処理結果を取得する。

**[復路処理]**

2. 処理結果の型が`ResponseMessage`の場合、応答電文オブジェクトにキャストして以降の処理で使用する。
3. (受信待機タイムアウト) 処理結果が`DataReader.NoMoreRecord`の場合、応答処理を行わずそのままリターンして終了する。
4. (処理結果タイプエラー) 処理結果が`ResponseMessage`でも`DataReader.NoMoreRecord`でもない場合、`java.lang.ClassCastException`を送出する。
5. フレームワーク制御ヘッダの処理結果コードが未設定の場合、処理結果オブジェクトのステータスコードを設定する。
6. スレッドローカル上のメッセージコンテキストを使用して応答電文オブジェクトを応答キュー（PUT）に送信する。
7. 応答電文オブジェクトをリターンする。後続ハンドラ処理で例外が発生していた場合はその例外を再送出する。

**[例外処理]**

- 後続ハンドラ処理中に例外が発生した場合、エラー内容をもとに応答電文を作成し、送信処理に使用する。元例外はハンドラ処理終了時に再送出する。
- 応答電文送信中に例外が発生した場合、応答を断念して例外を再送出する。
- 送信中の例外発生前に後続ハンドラでも例外が発生していた場合、送信中に発生した例外はワーニングレベルのログとして出力し、後続ハンドラで捕捉していた例外を再送出する。

<details>
<summary>keywords</summary>

ResponseMessage, DataReader.NoMoreRecord, java.lang.ClassCastException, 往路処理, 復路処理, 例外処理, ハンドラ処理フロー, 応答キューPUT, 受信待機タイムアウト

</details>

## 設定項目・拡張ポイント

設定項目なし。

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler" />
```

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, XML設定, 設定項目なし, component

</details>
