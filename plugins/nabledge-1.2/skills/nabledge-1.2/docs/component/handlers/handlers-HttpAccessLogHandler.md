# HTTPアクセスログハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.HttpAccessLogHandler`

往路と復路で、それぞれリクエストとレスポンスに関するHTTPアクセスログを出力する。

**関連するハンドラ（配置順序制約）**:

| ハンドラ | 配置制約 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラがログに出力する項目にはThreadContextHandlerが設定する項目が含まれるため、本ハンドラより上位に配置する必要がある。 |
| [HttpErrorHandler](handlers-HttpErrorHandler.md) | HTTPエラーレスポンス以外の例外はHttpErrorHandlerによってHTTPレスポンスオブジェクトに変換されるので、本ハンドラの後続に配置する必要がある。 |

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.fw.web.handler.HttpAccessLogHandler, ThreadContextHandler, HttpErrorHandler, HTTPアクセスログ, ハンドラ配置順序制約

</details>

## ハンドラ処理フロー

**[往路での処理]**

1. HTTPリクエストオブジェクトおよび実行コンテキストの内容をもとにHTTPアクセスログを出力する（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
2. 後続ハンドラに処理を委譲し、HTTPレスポンスオブジェクトを取得する

**[復路での処理]**

3. HTTPリクエスト・実行コンテキスト・HTTPレスポンスオブジェクトの内容をもとにHTTPアクセスログを出力する（ログレベル: INFO、ログカテゴリ: HTTP_ACCESS）
4. HTTPレスポンスオブジェクトをリターンして終了する

**[例外処理]**

- 2a. HTTPエラーレスポンスが送出された場合: エラーレスポンス・HTTPリクエスト・実行コンテキストの内容をもとにHTTPアクセスログを出力した上で、捕捉した例外を再送出する
- 2b. HTTPエラーレスポンス以外の例外が送出された場合: HTTPリクエスト・実行コンテキストの内容をもとにHTTPアクセスログを出力した上で、例外を再送出する

<details>
<summary>keywords</summary>

HTTPアクセスログ, 往路処理, 復路処理, 例外処理, HTTP_ACCESS, HTTPエラーレスポンス, ログカテゴリ

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。

**DI設定例**:

```xml
<component name="httpAccessLogHandler"
           class="nablarch.common.web.handler.HttpAccessLogHandler" />
```

<details>
<summary>keywords</summary>

HttpAccessLogHandler, nablarch.common.web.handler.HttpAccessLogHandler, DI設定, httpAccessLogHandler, 設定項目なし

</details>
