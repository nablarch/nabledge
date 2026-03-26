# ファイルアップロード

## 概要

ファイルアップロード機能は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) により実現される。アップロードされたファイルは当該HTTPリクエストに紐付けられ、アプリケーションからは `HttpRequest#getPart(java.lang.String)` で取得できる。

- ファイルサイズ上限値などアップロード機能の設定は [../../../handler/MultipartHandler](../handlers/handlers-MultipartHandler.md) を参照。
- ファイル移動・DB登録などの実装方法は [../../../common_library/file_upload_utility](libraries-file_upload_utility.md) を参照。

<details>
<summary>keywords</summary>

MultipartHandler, HttpRequest, getPart, ファイルアップロード, マルチパートリクエスト処理, アップロードファイル取得

</details>
