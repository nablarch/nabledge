# ステータスコード→プロセス終了コード変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/status_code_convert_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/StatusCodeConvertHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.StatusCodeConvertHandler`

<details>
<summary>keywords</summary>

StatusCodeConvertHandler, nablarch.fw.handler.StatusCodeConvertHandler, ハンドラクラス

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, モジュール依存関係, Maven依存関係

</details>

## 制約

:ref:`main` の直後に設定すること。本ハンドラが処理結果のステータスコードをプロセスの終了コードに変換するため。

<details>
<summary>keywords</summary>

制約, ハンドラ設定順序, main直後, 設定制約

</details>

## ステータスコード→プロセス終了コード変換

> **重要**: アプリケーションのエラー処理でステータスコードを指定する場合は、100～199を使用する。

| ステータスコード | プロセス終了コード |
|---|---|
| -1以下 | 1 |
| 0～199 | 0～199（変換なし） |
| 200～399 | 0 |
| 400 | 10 |
| 401 | 11 |
| 403 | 12 |
| 404 | 13 |
| 409 | 14 |
| 上記以外の400～499 | 15 |
| 500以上 | 20 |

> **補足**: 変換ルールは設定で切り替えできない。要件を満たせない場合はプロジェクト固有の変換ハンドラを作成すること。

<details>
<summary>keywords</summary>

ステータスコード変換, プロセス終了コード, エラーコード変換ルール, 終了コードマッピング, 100～199, アプリケーションエラー処理

</details>
