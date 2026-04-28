## HTTPアクセスログハンドラ

**クラス名:** `nablarch.common.web.handler.HttpAccessLogHandler`

-----

-----

### 概要

このハンドラでは、往路と復路で、それぞれリクエストとレスポンスに関するHTTPアクセスログを出力する。

出力されるアクセスログの詳細や、出力形式の設定については、 [HTTPアクセスログの出力](../../component/libraries/libraries-04-HttpAccessLog.md) を参照すること。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.threadcontext.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - |
| HTTPアクセスログハンドラ | nablarch.common.web.handler.HttpAccessLogHandler | HttpRequest | HttpResponse | HTTPリクエストの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 | 送信するHTTPレスポンスの内容についてログに出力する。 |
| HTTPエラー制御ハンドラ | nablarch.fw.web.handler.HttpErrorHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容が設定されていない場合は、ステータスコードに応じたデフォルトページを遷移先に設定する。 | 送出されたエラーに応じた遷移先のHTTPレスポンスオブジェクトを返却する。送出されたエラーはリクエストスコープに設定される。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラがログに出力する項目には、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) が設定する項目が含まれるため、 本ハンドラより上位に配置する必要がある。 |
| [HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md) | HTTPエラーレスポンス以外の例外は [HTTPエラー制御ハンドラ](../../component/handlers/handlers-HttpErrorHandler.md) によって HTTPレスポンスオブジェクトに変換されるので 本ハンドラの後続に配置する必要がある。 |

### ハンドラ処理フロー

**[往路での処理]**

**1. (HTTPリクエストログの出力)**

引数となるHTTPリクエストオブジェクトおよび実行コンテキストの内容をもとに、HTTPアクセスログを出力する。
**(ログレベル: INFO、 ログカテゴリ: HTTP_ACCESS)**

**2. (後続ハンドラへの処理委譲)**

後続ハンドラに処理を委譲し、その結果としてHTTPレスポンスオブジェクトを取得する。

**[復路での処理]**

**3. (HTTPレスポンスログの出力)**

HTTPリクエストオブジェクトおよび実行コンテキストに加え、後続ハンドラの処理結果であるHTTPレスポンスオブジェクトの内容をもとに、
HTTPアクセスログを出力する。
**(ログレベル: INFO、 ログカテゴリ: HTTP_ACCESS)**

**4. (正常終了)**

HTTPレスポンスオブジェクトをリターンして終了する。

**[例外処理]**

**2a. (HTTPエラーレスポンスに対するログ出力)**

後続ハンドラの処理中に、HTTPエラーレスポンスが送出された場合、そのエラーレスポンスの内容と、
HTTPリクエスト、実行コンテキストの内容をもとにHTTPアクセスログを出力した上で、捕捉した例外を再送出する。

**2b. (HTTPエラーレスポンス以外のエラーに対するログ出力)**

後続ハンドラの処理中に、HTTPエラーレスポンス以外の例外が送出された場合は
HTTPリクエスト、実行コンテキストの内容をもとにHTTPアクセスログを出力した上で、例外を再送出する。

### 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。
ロガー側の設定については、 [HTTPアクセスログの出力](../../component/libraries/libraries-04-HttpAccessLog.md) を参照すること。

**標準設定**

以下はDI設定の記述例である。

```xml
<!-- HTTPレスポンスハンドラ -->
<component name="httpAccessLogHandler"
           class="nablarch.common.web.handler.HttpAccessLogHandler" />
```
