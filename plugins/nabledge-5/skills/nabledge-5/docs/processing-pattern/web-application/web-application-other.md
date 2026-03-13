# その他のテンプレートエンジンを使用した画面開発

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/view/other.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/responsewriter/CustomResponseWriter.html)

## その他のテンプレートエンジンの対応方法

## その他のテンプレートエンジンの対応方法

[web_thymeleaf_adaptor](../../component/adapters/adapters-web_thymeleaf_adaptor.md) や [FreeMarker](web-application-freemarker.md) 以外のテンプレートエンジンを使用する場合の対応方法は、Servletの有無によって異なる。

- **Servletを提供している場合**: [FreeMarker](web-application-freemarker.md) と同様に `web.xml` にServletを登録するだけで対応できる。
- **Servletを提供していない場合**: [web_thymeleaf_adaptor](../../component/adapters/adapters-web_thymeleaf_adaptor.md) と同様に `CustomResponseWriter` の実装クラスを作成することで対応できる。

参考: [ウェブアプリケーション Thymeleafアダプタのソースコード](https://github.com/nablarch/nablarch-web-thymeleaf-adaptor)

<details>
<summary>keywords</summary>

CustomResponseWriter, nablarch.fw.web.handler.responsewriter.CustomResponseWriter, テンプレートエンジン, 画面開発, Servlet, web.xml登録

</details>
