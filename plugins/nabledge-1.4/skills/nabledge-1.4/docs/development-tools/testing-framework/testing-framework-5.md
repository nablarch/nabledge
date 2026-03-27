# Windows上で成功していた画面オンライン処理のリクエスト単体テストをLinux上で実行すると、IOExceptionが発生してテストが失敗してしまいます。対処方法を教えてください

## Linux環境でIOException: File name too long が発生する場合の対処方法

## Linux環境でIOException: File name too long が発生する場合の対処方法

画面オンライン処理のリクエスト単体テストで出力されるHTMLダンプファイルのファイル名には「テストケースの説明」（テストケース一覧の `description` に記載した文言。旧バージョンのテスティングフレームワークではテストケース一覧の `case` に記載した文言）がそのまま含まれる。このファイル名がOSのファイル名長上限を超えると `java.io.IOException: File name too long` が発生する。

**対処方法**: 「テストケースの説明」の長さを短くする。

> **注意**: WindowsとLinuxではファイル名の長さの上限が異なる。Windows: 文字数（255文字）、Linux: バイト数（255バイト）。「テストケースの説明」に全角文字（マルチバイト文字）が含まれる場合、Windowsでは上限を超えなくてもLinuxでは上限を超えることがある。

<details>
<summary>keywords</summary>

IOException, File name too long, リクエスト単体テスト, HTMLダンプファイル, テストケースの説明, description, Linux ファイル名長, Windows ファイル名長, マルチバイト文字, 全角文字, HttpRequestTestSupport, HttpServer, AbstractHttpRequestTestTemplate

</details>
