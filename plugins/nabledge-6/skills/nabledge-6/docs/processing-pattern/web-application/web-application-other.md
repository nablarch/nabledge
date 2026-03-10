# その他のテンプレートエンジンを使用した画面開発

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/view/other.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/responsewriter/CustomResponseWriter.html)

## その他のテンプレートエンジンを使用した画面開発

- **テンプレートエンジンがServlet forwardを使用するServletを提供している場合**: `web.xml`にServletを登録するだけで対応できる
- **Servletを提供していないテンプレートエンジンの場合**: :ref:`web_thymeleaf_adaptor`と同様に、`CustomResponseWriter`の実装クラスを作成する

参考: [ウェブアプリケーション Thymeleafアダプタのソースコード](https://github.com/nablarch/nablarch-web-thymeleaf-adaptor)

<details>
<summary>keywords</summary>

CustomResponseWriter, nablarch.fw.web.handler.responsewriter.CustomResponseWriter, テンプレートエンジン, web.xml, Servlet forward, カスタムレスポンスライター

</details>
