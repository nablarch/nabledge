# ファイルアップロード

## 概要

ファイルアップロード機能は、 [マルチパートリクエストハンドラ](../../component/handlers/handlers-MultipartHandler.md) により実現される。
本ハンドラは、アップロードされたファイルを当該HTTPリクエストに紐付ける。
アプリケーションからは、 `HttpRequest#getPart(java.lang.String)`
により取得できる。

## ファイルアップロード機能に関する設定

ファイルサイズ上限値など、アップロード機能に関する設定については、
 [マルチパートリクエストハンドラ](../../component/handlers/handlers-MultipartHandler.md) を参照。

## アプリケーション実装方法

ファイルを移動する、DBに登録する、といった具体的なアプリケーション実装方法については、
 [ファイルアップロード業務処理用ユーティリティ](../../component/libraries/libraries-file-upload-utility.md) を参照。
