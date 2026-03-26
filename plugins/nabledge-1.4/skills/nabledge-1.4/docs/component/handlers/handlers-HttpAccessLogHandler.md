# HTTPアクセスログハンドラ

## 概要

**クラス名**: `nablarch.common.web.handler.HttpAccessLogHandler`

往路と復路でHTTPリクエスト・レスポンスのアクセスログを出力する。

**関連するハンドラ（配置制約）**

| ハンドラ | 配置制約 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラがログに出力する項目には [ThreadContextHandler](handlers-ThreadContextHandler.md) が設定する項目が含まれるため、本ハンドラより**上位**に配置する必要がある。 |
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | HTTPエラーレスポンス以外の例外は [HttpErrorHandler](handlers-HttpErrorHandler.md) によってHTTPレスポンスオブジェクトに変換されるので、本ハンドラの**後続**に配置する必要がある。 |

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.common.web.handler.HttpAccessLogHandler, HTTPアクセスログ出力, ThreadContextHandler, HttpErrorHandler, ハンドラ配置順序, 上位ハンドラ, 後続ハンドラ

</details>

## ハンドラ処理フロー

**[往路での処理]**

1. HTTPリクエストオブジェクトおよび実行コンテキストをもとにHTTPアクセスログを出力する（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する

**[復路での処理]**

3. HTTPリクエスト、実行コンテキスト、HTTPレスポンスオブジェクトをもとにHTTPアクセスログを出力する（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
4. HTTPレスポンスオブジェクトをリターンして終了する

**[例外処理]**

- 2a. HTTPエラーレスポンスが送出された場合: エラーレスポンスの内容とHTTPリクエスト、実行コンテキストをもとにHTTPアクセスログを出力した上で、例外を再送出する。
- 2b. HTTPエラーレスポンス以外の例外が送出された場合: HTTPリクエスト、実行コンテキストをもとにHTTPアクセスログを出力した上で、例外を再送出する。

<details>
<summary>keywords</summary>

往路処理, 復路処理, 例外処理, HTTP_ACCESS, ログカテゴリ, HTTPアクセスログ, HTTPエラーレスポンス, ログレベルINFO

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。ロガー側の設定については [../02_FunctionDemandSpecifications/01_Core/01/04_HttpAccessLog](../libraries/libraries-04_HttpAccessLog.md) を参照すること。

```xml
<component name="httpAccessLogHandler"
           class="nablarch.common.web.handler.HttpAccessLogHandler" />
```

<details>
<summary>keywords</summary>

DI設定, httpAccessLogHandler, XML設定例, 設定項目なし, nablarch.common.web.handler.HttpAccessLogHandler

</details>
