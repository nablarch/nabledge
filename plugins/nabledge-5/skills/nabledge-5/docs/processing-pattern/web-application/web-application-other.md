# その他のテンプレートエンジンを使用した画面開発

[ウェブアプリケーション Thymeleafアダプタ](../../component/adapters/adapters-web-thymeleaf-adaptor.md#ウェブアプリケーション-thymeleafアダプタ) や [FreeMarker](../../processing-pattern/web-application/web-application-freemarker.md#freemarkerを使用した画面開発) 以外のテンプレートエンジンを使用したい場合の対応方法を説明する。

使用するテンプレートエンジンが、Servlet forwardを使用してクライアントにレスポンスを返すためのServletを提供している場合には、
[FreeMarker](../../processing-pattern/web-application/web-application-freemarker.md#freemarkerを使用した画面開発) と同じように `web.xml` にServletを登録するだけで対応できる。

Servletを提供していないテンプレートエンジンの場合には、
[ウェブアプリケーション Thymeleafアダプタ](../../component/adapters/adapters-web-thymeleaf-adaptor.md#ウェブアプリケーション-thymeleafアダプタ) と同じように CustomResponseWriter の実装クラスを作成することで対応できる。

実装方法や設定方法などの詳細は、以下の解説書やソースコードを参照すること。

* [ウェブアプリケーション Thymeleafアダプタ](../../component/adapters/adapters-web-thymeleaf-adaptor.md#ウェブアプリケーション-thymeleafアダプタ)
* [ウェブアプリケーション Thymeleafアダプタのソースコード](https://github.com/nablarch/nablarch-web-thymeleaf-adaptor)
