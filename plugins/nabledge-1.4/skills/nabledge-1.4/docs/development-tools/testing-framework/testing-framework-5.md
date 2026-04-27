# Windows上で成功していた画面オンライン処理のリクエスト単体テストをLinux上で実行すると、IOExceptionが発生してテストが失敗してしまいます。対処方法を教えてください

> **question:**
> Windows上では正常終了していたリクエスト単体テストをLinux上で実行すると異常終了します。

> スタックトレースを見ると、ファイル名が長すぎることが原因でIOExceptionが発生しているようなのですが、原因が分かりません。

> 対処方法を教えてください。

> ```bash
> エラーメッセージ
> 
> java.io.IOException: File name too long
> 
> スタックトレース
> 
> java.lang.RuntimeException: java.io.IOException: File name too long
>     at nablarch.fw.web.HttpServer.dumpHttpMessage(HttpServer.java:549)
>     at nablarch.fw.web.HttpServer.handle(HttpServer.java:438)
>     at nablarch.test.core.http.HttpRequestTestSupport.execute(HttpRequestTestSupport.java:272)
>     at nablarch.test.core.http.HttpRequestTestSupport.execute(HttpRequestTestSupport.java:146)
>     at nablarch.test.core.http.AbstractHttpRequestTestTemplate.executeTestCase(AbstractHttpRequestTestTemplate.java:229)
>     at nablarch.test.core.http.AbstractHttpRequestTestTemplate.execute(AbstractHttpRequestTestTemplate.java:169)
>     at nablarch.test.core.http.AbstractHttpRequestTestTemplate.execute(AbstractHttpRequestTestTemplate.java:144)
>     at nablarch.test.core.http.AbstractHttpRequestTestTemplate.execute(AbstractHttpRequestTestTemplate.java:120)
>     at nablarch.sample.ss11AA.W11AA01ActionRequestTest.testRW11AA0101Normal(W11AA01ActionRequestTest.java:31)
> Caused by: java.io.IOException: File name too long
>     at java.io.UnixFileSystem.createFileExclusively(Native Method)
>     at java.io.File.createNewFile(File.java:883)
>     at nablarch.fw.web.HttpServer.dumpHttpMessage(HttpServer.java:522)
> ```

> **answer:**
> 「テストケースの説明」の長さを短くしてください。

> 「テストケースの説明」とは、テストケース一覧の  description に記載した文言（※旧バージョンのテスティングフレームワークではテストケース一覧の case に記載した文言）のことを指します。

> 画面オンライン処理のリクエスト単体テストで出力されるHTMLダンプファイルのファイル名には、
> 「テストケースの説明」がそのまま含まれる仕様となっております。
> このファイル名が、OSで規定されたファイル名の長さの上限を超えた場合、IOExceptionが発生するので、上限を超えないように「テストケースの説明」の長さを短くしてください。

> 今回Linuxでのみテストが失敗したのは、WindowsとLinuxでファイル名の長さの上限が異なることが原因となっています。

> ファイル名の長さの上限は、Windowsは文字数(255文字)、Linuxはバイト数(255バイト)なので、
> 「テストケースの説明」に全角文字(マルチバイト文字)が含まれる場合、Windowsでは上限を超えなくてもLinuxではファイル名の上限を超えることがあります。
