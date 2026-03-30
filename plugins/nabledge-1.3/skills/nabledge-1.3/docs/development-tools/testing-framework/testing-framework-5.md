# Windows上で成功していた画面オンライン処理のリクエスト単体テストをLinux上で実行すると、IOExceptionが発生してテストが失敗してしまいます。対処方法を教えてください

## Linux上でリクエスト単体テストがIOException(File name too long)で失敗する場合の対処

## Linux上でリクエスト単体テストがIOException(File name too long)で失敗する場合の対処

**症状**: Windows上では正常終了する画面オンライン処理のリクエスト単体テストが、Linux上で `java.io.IOException: File name too long` により失敗する。

**原因**: 画面オンライン処理のリクエスト単体テストで出力されるHTMLダンプファイルのファイル名に「テストケースの説明」（テストケース一覧の `description` フィールド、旧バージョンでは `case` フィールド）がそのまま含まれる仕様のため、OSのファイル名長上限を超えるとIOExceptionが発生する。

WindowsとLinuxではファイル名長上限が異なる:
- Windows: **255文字**
- Linux: **255バイト**

全角文字（マルチバイト文字）を含む説明文は、Windows上では255文字以内でも、Linuxでは255バイトを超える場合がある。

**対処方法**: テストケースの説明（`description`）の長さを短くする。特に全角文字を含む場合はバイト数に注意する。

**関連クラス**:
- `nablarch.fw.web.HttpServer` (`dumpHttpMessage` メソッドでファイル書き出し)
- `nablarch.test.core.http.HttpRequestTestSupport`
- `nablarch.test.core.http.AbstractHttpRequestTestTemplate`

<details>
<summary>keywords</summary>

HttpServer, HttpRequestTestSupport, AbstractHttpRequestTestTemplate, IOException, File name too long, リクエスト単体テスト, HTMLダンプファイル, テストケースの説明, ファイル名長上限, Linux Windows 差異

</details>
