# HTTPメッセージングレスポンス変換ハンドラ

## 概要

**クラス名**: `nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler`

後続ハンドラが作成した応答電文オブジェクト(ResponseMessage)をHTTPレスポンスオブジェクト(HttpResponse)に変換するハンドラ。応答電文中のプロトコルヘッダーの値を対応するHTTPヘッダーに設定し、応答電文に設定されたデータ(Map)をXMLやJSON等の形式に直列化してHTTPレスポンスボディに設定する。

**ハンドラキュー上の位置** (Context: handler sub_thread data_read):
1. HttpMessagingRequestParsingHandler
2. HttpMessagingResponseBuildingHandler
3. TransactionManagementHandler
4. HttpMessagingResponseBuildingHandler
5. MessageResendHandler
6. MessagingAction

> **警告**: 応答電文オブジェクト(ResponseMessage)をリターンするハンドラは全て本ハンドラの後続に配置する必要がある。特にトランザクション制御ハンドラとの位置関係には特に留意が必要である。

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 本ハンドラはトランザクション制御ハンドラの前後にそれぞれ配置する必要がある。業務アクション側に配置するハンドラはレスポンスメッセージのフォーマットエラー発生時に業務トランザクションをロールバックするために必要。もう一方はエラー時に業務側で作成したエラー応答電文をHTTPレスポンスに変換するために必要。 |
| [MessageResendHandler](handlers-MessageResendHandler.md) | 応答電文オブジェクトを返却するので、本ハンドラの後続に配置する。 |
| [HttpMessagingRequestParsingHandler](handlers-HttpMessagingRequestParsingHandler.md) | 本ハンドラでは受信電文が解析済みであることを前提として例外制御を行うため、本ハンドラよりも上位に配置する必要がある。 |

<details>
<summary>keywords</summary>

HttpMessagingResponseBuildingHandler, nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler, ResponseMessage, HttpResponse, HTTPメッセージングレスポンス変換, TransactionManagementHandler, MessageResendHandler, HttpMessagingRequestParsingHandler, ハンドラ配置順序, プロトコルヘッダー変換

</details>

## ハンドラ処理フロー

**[往路処理]**
1. ハンドラキュー上の後続ハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**
2. 処理結果が応答電文オブジェクトであった場合、以下の項目を設定したHTTPレスポンスオブジェクトを作成する。

| 設定項目 | プロパティ名 | 設定内容 |
|---|---|---|
| コンテントタイプ | contentType | 利用したデータフォーマッタに設定されたmimeType |
| 応答電文のボディ部 | bodyStream | 応答電文のボディ部のデータストリーム |
| ステータスコード | statusCode | 応答電文オブジェクトに設定されているステータスコード |

3. 取得した処理結果または変換したHTTPレスポンスオブジェクトをリターンして終了する。

**[例外処理]**
- **3a. (メッセージングエラー発生)**: MessagingException または InvalidDataFormatException が発生した場合、内部不具合とみなしINFOレベルのログを出力後、元例外をネストしたステータスコード500のHTTPエラーレスポンスを送出する。
- **3b. (後続ハンドラがエラー応答電文を送出)**: 後続ハンドラからエラー応答電文が送出された場合、復路処理(2)と同等の処理でHTTPエラーレスポンスオブジェクトを構築して再送出する。このときのステータスコードは元例外のステータスコードと同じ値となる。
- **3c. (上記以外の実行時例外)**: 上記以外の実行時例外が発生した場合、本ハンドラでは何もせず再送出して終了する。

<details>
<summary>keywords</summary>

HTTPレスポンス変換, MessagingException, InvalidDataFormatException, contentType, bodyStream, statusCode, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

本ハンドラは [HttpMessagingRequestParsingHandler](handlers-HttpMessagingRequestParsingHandler.md) と同じ設定にする必要がある。

<details>
<summary>keywords</summary>

設定項目, HttpMessagingRequestParsingHandler, ハンドラ設定

</details>
