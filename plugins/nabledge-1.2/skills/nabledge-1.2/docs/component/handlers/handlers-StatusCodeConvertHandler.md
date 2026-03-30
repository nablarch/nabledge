# ステータスコード→プロセス終了コード変換ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.StatusCodeConvertHandler`

ステータスコードをプロセスの終了コードに変換するハンドラ。[Main](handlers-Main.md) の直後のハンドラとして設定する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | 本ハンドラの戻り値を終了コードとして使用する |
| [GlobalErrorHandler](handlers-GlobalErrorHandler.md) | 本ハンドラでは例外制御を行わないため、後続ハンドラで例外/エラーが送出された場合はそのまま [Main](handlers-Main.md) に送出される。本ハンドラの直後に [GlobalErrorHandler](handlers-GlobalErrorHandler.md) を配置し、本ハンドラへのエラー送出を防ぐこと |

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, nablarch.fw.handler.StatusCodeConvertHandler, ステータスコード変換, プロセス終了コード変換, Main, GlobalErrorHandler

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**
2. 後続ハンドラから返された処理結果オブジェクトのステータスコード値をもとに、プロセス終了コードを決定して返す。

| ステータスコード | プロセス終了コード |
|---|---|
| -1 以下 | 1 |
| 0 | 0 |
| 1 ～ 199 | (ステータスコードと同じ) |
| 200 ～ 399 | 0 |
| 400 | 10 |
| 401 | 11 |
| 403 | 12 |
| 404 | 13 |
| 409 | 14 |
| 上記以外の400～499 | 15 |
| 500以上 | 20 |

**[例外処理]**
1a. 後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

往路処理, 復路処理, 例外処理, ステータスコード, プロセス終了コード, 終了コードマッピング

</details>

## 設定項目・拡張ポイント

本ハンドラには特段の設定項目はない。

```xml
<component class="nablarch.fw.handler.StatusCodeConvertHandler" />
```

終了コードをプロジェクト固有の体系に変更したい場合は、本ハンドラを別実装に差し替えること。

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, DIリポジトリ設定, XML設定, 終了コードカスタマイズ, プロジェクト固有実装

</details>
