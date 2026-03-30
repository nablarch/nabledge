# HTTPアクセスログハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpAccessLogHandler`

往路と復路でHTTPリクエスト/レスポンスのアクセスログを出力する。ログの詳細・出力形式は [../02_FunctionDemandSpecifications/01_Core/01/04_HttpAccessLog](../libraries/libraries-04_HttpAccessLog.md) を参照。

**関連するハンドラ**

| ハンドラ | 配置要件 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | ログ出力項目にThreadContextHandlerが設定する項目が含まれるため、本ハンドラより上位に配置する必要がある |
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | HTTPエラーレスポンス以外の例外はHttpErrorHandlerによってHTTPレスポンスオブジェクトに変換されるため、本ハンドラの後続に配置する必要がある |

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.fw.web.handler.HttpAccessLogHandler, HTTPアクセスログ, ThreadContextHandler, HttpErrorHandler, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**[往路での処理]**

1. HTTPリクエストログを出力（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得

**[復路での処理]**

3. HTTPレスポンスログを出力（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
4. HTTPレスポンスオブジェクトをリターンして終了

**[例外処理]**

2a. HTTPエラーレスポンスが送出された場合: HTTPリクエスト・実行コンテキスト・エラーレスポンスの内容をもとにアクセスログを出力した上で、捕捉した例外を再送出する

2b. HTTPエラーレスポンス以外の例外が送出された場合: HTTPリクエスト・実行コンテキストの内容をもとにアクセスログを出力した上で、例外を再送出する

<details>
<summary>keywords</summary>

HTTPアクセスログ出力, 往路処理, 復路処理, 例外処理, HTTP_ACCESS, ログレベルINFO

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。ロガー側の設定は [../02_FunctionDemandSpecifications/01_Core/01/04_HttpAccessLog](../libraries/libraries-04_HttpAccessLog.md) を参照。

```xml
<component name="httpAccessLogHandler"
           class="nablarch.common.web.handler.HttpAccessLogHandler" />
```

<details>
<summary>keywords</summary>

XML設定例, nablarch.common.web.handler.HttpAccessLogHandler, コンポーネント設定, httpAccessLogHandler

</details>
