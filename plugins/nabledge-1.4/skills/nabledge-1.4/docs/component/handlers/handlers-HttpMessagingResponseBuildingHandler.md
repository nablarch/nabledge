## HTTPメッセージングレスポンス変換ハンドラ

**クラス名:** `nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler`

-----

-----

### 概要

後続ハンドラが作成した応答電文オブジェクト( ResponseMessage ) を
HTTPレスポンスオブジェクト( HttpResponse ) に変換するハンドラ。

応答電文中のプロトコルヘッダーの値を、対応するHTTPヘッダーに設定する。
また、応答電文に設定されたデータ(Map)を
XMLやJSON等の形式に直列化してHTTPレスポンスボディに設定する。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| HTTPメッセージングリクエスト変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingRequestParsingHandler | HttpRequest | Object | HTTPリクエストデータを解析し、後続ハンドラの引数（RequestMessage）のレコードとして設定する。 | - | - | - |
| HTTPメッセージングレスポンス変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler | Object | Object | - | 返却された応答データを解析し、HTTPレスポンスデータに変換する。 | エラー応答電文の内容を解析し、HTTPエラーレスポンスとして再送出する。 | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |
| HTTPメッセージングレスポンス変換ハンドラ | nablarch.fw.messaging.handler.HttpMessagingResponseBuildingHandler | Object | Object | - | 返却された応答データを解析し、HTTPレスポンスデータに変換する。 | エラー応答電文の内容を解析し、HTTPエラーレスポンスとして再送出する。 | - |
| 再送電文制御ハンドラ | nablarch.fw.messaging.handler.MessageResendHandler | RequestMessage | ResponseMessage | 再送要求に対し、以前応答した電文が保存されていれば、その内容をリターンする。(後続ハンドラは実行しない) | 業務トランザクションが正常終了(コミット)された場合のみ電文を保存する | - | - |
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |

**関連するハンドラ**

> **Warning:**
> 本ハンドラの復路処理にて応答電文オブジェクト(ResponseMessage)を HTTPレスポンスオブジェクト(HttpResponse)に
> 変換するため、応答電文オブジェクトをリターンするハンドラは全て本ハンドラの後続に配置する必要がある。
> 特にトランザクション制御ハンドラとの位置関係には特に留意が必要である。

| ハンドラ | 内容 |
|---|---|
| [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) | 本ハンドラは、トランザクション制御ハンドラの前後にそれぞれ配置する必要がある。 業務アクション側に配置するハンドラは、レスポンスメッセージのフォーマットエラー発生時に 業務トランザクションをロールバックするために必要である。 もう一方のハンドラは、エラー時に業務側で作成したエラー応答電文を HTTPレスポンスに変換するために必要である。 |
| [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md) | [再送電文制御ハンドラ](../../component/handlers/handlers-MessageResendHandler.md) は応答電文オブジェクトを返却するので、 本ハンドラの後続に配置する。 |
| [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-HttpMessagingRequestParsingHandler.md) | 本ハンドラでは既に受信電文は解析済みでることを前提として例外制御を行うため、 このハンドラは本ハンドラよりも上位に配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (後続ハンドラに対する処理委譲)**

ハンドラキュー上の後続ハンドラに対して処理を委譲し、その結果を取得する。

**[復路処理]**

**2. (応答電文オブジェクトをHTTPレスポンスオブジェクトに変換)**

**1.** の処理結果が応答電文オブジェクトであった場合は、
その内容を解析してHTTPレスポンスオブジェクトを作成する。

HTTPレスポンスオブジェクトのうち、本ハンドラで下記の項目を設定している。

| 設定項目 | プロパティ名 | 設定内容 |
|---|---|---|
| コンテントタイプ | contentType | 利用したデータフォーマッタに設定されたmimeType |
| 応答電文のボディ部 | bodyStream | 応答電文のボディ部のデータストリーム |
| ステータスコード | statusCode | 応答電文オブジェクトに設定されているステータスコード |

**3. (正常終了)**

**1.** で取得した処理結果、または、 **2.** で変換したHTTPレスポンスオブジェクトを
リターンして終了する。

**[例外処理]**

**3a. (メッセージングエラー発生)**

後続ハンドラの処理、もしくは、 **2.** の応答電文構築処理において
メッセージングエラー(MessagingException) および データフォーマットエラー(InvalidDataFormatException)
が送出された場合は、内部不具合とみなし、INFOレベルのログを出力後、
元例外をネストしたHTTPエラーレスポンスオブジェクト(ステータスコード500)を送出して終了する。

**3b. (後続ハンドラがエラー応答電文を送出)**

後続のハンドラからエラー応答電文が送出された場合は、 **2.** と同等の処理により
HTTPエラーレスポンスオブジェクトを構築して再送出する。
このときのステータスコードは元例外のステータスコードと同じ値となる。

**3c. (後続ハンドラが上記以外の実行時例外を送出した場合)**

上記以外の実行時例外が送出された場合は、本ハンドラではなにもせずに、再送出して終了する。

### 設定項目・拡張ポイント

**基本設定**

本ハンドラは [HTTPメッセージングリクエスト変換ハンドラ](../../component/handlers/handlers-HttpMessagingRequestParsingHandler.md) と同じ設定にする必要がある。
詳細は当該ハンドラの解説を参照すること。
