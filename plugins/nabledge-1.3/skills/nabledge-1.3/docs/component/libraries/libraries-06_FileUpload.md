# ファイルアップロード

## 概要

**クラス**: `MultipartHandler`

ファイルアップロード機能は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) により実現される。アップロードされたファイルはHTTPリクエストに紐付けられる。

**メソッド**: `HttpRequest#getPart(java.lang.String)` でアップロードされたファイルを取得できる。

<details>
<summary>keywords</summary>

MultipartHandler, HttpRequest, getPart, ファイルアップロード, マルチパートリクエスト処理

</details>

## ファイルアップロード機能に関する設定

ファイルサイズ上限値などのアップロード設定は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) を参照。

<details>
<summary>keywords</summary>

MultipartHandler, ファイルサイズ上限値, アップロード設定, ファイルサイズ制限

</details>

## アプリケーション実装方法

ファイルの移動・DB登録などの具体的な実装方法は [../../../common_library/file_upload_utility](libraries-file_upload_utility.md) を参照。

<details>
<summary>keywords</summary>

file_upload_utility, ファイル移動, DBへのファイル登録, ファイルアップロード実装

</details>
