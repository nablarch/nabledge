# その他のテンプレートエンジンを使用した画面開発

## その他のテンプレートエンジンを使用した画面開発

- **テンプレートエンジンがServlet forwardを使用するServletを提供している場合**: `web.xml`にServletを登録するだけで対応できる
- **Servletを提供していないテンプレートエンジンの場合**: :ref:`web_thymeleaf_adaptor`と同様に、`CustomResponseWriter`の実装クラスを作成する

参考: [ウェブアプリケーション Thymeleafアダプタのソースコード](https://github.com/nablarch/nablarch-web-thymeleaf-adaptor)
