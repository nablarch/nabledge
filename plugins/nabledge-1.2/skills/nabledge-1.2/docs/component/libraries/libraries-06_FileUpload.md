# ファイルアップロード

## 概要

ファイルアップロード機能は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) により実現される。ハンドラはアップロードされたファイルを該当HTTPリクエストに紐付ける。アプリケーションからは `HttpRequest#getPart(java.lang.String)` で取得できる。

<details>
<summary>keywords</summary>

HttpRequest, getPart, MultipartHandler, ファイルアップロード, マルチパートリクエスト, アップロードファイル取得

</details>

## ファイルアップロード機能に関する設定

ファイルサイズ上限値などのアップロード機能に関する設定は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) を参照。

<details>
<summary>keywords</summary>

MultipartHandler, ファイルサイズ上限, アップロード設定

</details>

## アプリケーション実装方法

ファイルの移動やDB登録など具体的なアプリケーション実装方法は [../../../common_library/file_upload_utility](libraries-file_upload_utility.md) を参照。

<details>
<summary>keywords</summary>

file_upload_utility, ファイルアップロード実装, ファイル移動, DB登録

</details>
