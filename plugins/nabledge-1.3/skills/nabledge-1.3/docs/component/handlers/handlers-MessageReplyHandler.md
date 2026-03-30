# 電文応答制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.MessageReplyHandler`

後続ハンドラの処理結果である`ResponseMessage`オブジェクトをもとに応答電文を構築・送信し、送信した応答電文オブジェクトを戻り値として返す。

**関連ハンドラ（配置制約）**

応答電文の内容を編集する必要のあるハンドラは、全てこのハンドラの後続に配置する必要がある。

| ハンドラ | 配置制約 |
|---|---|
| [MessagingContextHandler](handlers-MessagingContextHandler.md) | スレッドローカル上のメッセージングコンテキストを使用するため、本ハンドラより上位に配置する必要がある |
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 2相コミット使用時: DBトランザクションとJMSトランザクションをトランザクションマネージャー側でまとめてコミットするため、本ハンドラより先に実行する必要がある。非使用時: 応答送信前にDBトランザクションを終了させ業務処理結果を確定させるため、本ハンドラの後に実行する必要がある |
| [DataReadHandler](handlers-DataReadHandler.md) | 要求電文フォーマット不正のエラー応答を本ハンドラで送信するため、本ハンドラの後続に配置する必要がある |

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, MessagingContextHandler, TransactionManagementHandler, DataReadHandler, 電文応答制御ハンドラ, 応答電文送信, メッセージング, 関連ハンドラ配置制約, 2相コミット

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 往路では特段の処理を行わず、後続ハンドラに処理を委譲し処理結果を取得する。

**[復路処理]**

1. 処理結果の型が`ResponseMessage`の場合、応答電文オブジェクトにキャストして以降の処理で使用する。
2. 受信待機タイムアウト: 処理結果が`DataReader.NoMoreRecord`の場合、応答処理は行わずそのままリターンして終了する。
3. 処理結果タイプエラー: 処理結果が`ResponseMessage`でも`DataReader.NoMoreRecord`でもない場合、`java.lang.ClassCastException`を送出する。
4. フレームワーク制御ヘッダの処理結果コードが未設定の場合、処理結果オブジェクトのステータスコードを設定する。
5. スレッドローカル上のメッセージコンテキストを使用して、応答電文オブジェクトを応答キューへPUT（送信）する。
6. 応答電文オブジェクトをリターンする。後続ハンドラで例外が送出されていた場合はその例外を再送出する。

**[例外処理]**

- エラー応答電文作成: 後続ハンドラの処理中に実行時例外/エラーが発生した場合、エラー内容をもとに応答電文を作成し3.以降で使用する。元例外は本ハンドラの処理終了時に再送出する。
- 応答電文送信エラー: 送信処理中に例外が送出された場合、送信元への応答を断念し例外を再送出して終了する。
- エラー応答電文送信エラー: 送信処理中に例外が発生し、かつ後続ハンドラの処理でも例外が発生していた場合、送信処理中の例外はワーニングレベルのログとして出力し、後続ハンドラで捕捉していた例外を再送出する。

<details>
<summary>keywords</summary>

ResponseMessage, DataReader.NoMoreRecord, ClassCastException, java.lang.ClassCastException, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, 応答電文キュー, 受信待機タイムアウト

</details>

## 設定項目・拡張ポイント

本ハンドラに設定項目はない。

**標準設定**:

```xml
<component class="nablarch.fw.messaging.handler.MessageReplyHandler" />
```

<details>
<summary>keywords</summary>

MessageReplyHandler, nablarch.fw.messaging.handler.MessageReplyHandler, XML設定, 設定項目なし, コンポーネント設定

</details>
