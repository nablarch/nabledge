# ステータスコード→プロセス終了コード変換ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.StatusCodeConvertHandler`

[Main](handlers-Main.md) の直後のハンドラとして設定することで、後続ハンドラの処理結果ステータスコードをプロセス終了コードに変換する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | 本ハンドラの戻り値を終了コードとして使用する |
| [GlobalErrorHandler](handlers-GlobalErrorHandler.md) | 本ハンドラは例外制御を行わないため、後続ハンドラで例外/エラーが送出された場合はそのままMainに送出される。そのため、本ハンドラの直後に配置し、本ハンドラに対してエラーが送出されないようにする必要がある |

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, nablarch.fw.handler.StatusCodeConvertHandler, ステータスコード変換, プロセス終了コード変換, Mainハンドラ連携, GlobalErrorHandler連携

</details>

## ハンドラ処理フロー

**[往路処理]**
1. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**
2. 後続ハンドラから返されたステータスコードをもとにプロセス終了コードを決定する。

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
1a. 後続ハンドラの処理中にエラーが発生した場合、そのまま再送出する。

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, ステータスコード, プロセス終了コード, 終了コードマッピング, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

設定項目なし。

```xml
<component class="nablarch.fw.handler.StatusCodeConvertHandler" />
```

> **補足**: 終了コードをプロジェクト固有の体系に変更したい場合は、本ハンドラを別実装したものに差し替えること。

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, XML設定, 終了コードカスタマイズ, ハンドラ差し替え

</details>
