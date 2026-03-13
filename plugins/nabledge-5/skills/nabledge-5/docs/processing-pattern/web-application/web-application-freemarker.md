# FreeMarkerを使用した画面開発

**公式ドキュメント**: [FreeMarkerを使用した画面開発](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/view/freemarker.html)

## FreeMarkerを依存ライブラリに追加する

**モジュール** (動作確認済みバージョン):
```xml
<dependency>
  <groupId>org.freemarker</groupId>
  <artifactId>freemarker-gae</artifactId>
  <version>2.3.27-incubating</version>
</dependency>
```

> **注**: 上記のバージョンにて動作確認している。

<details>
<summary>keywords</summary>

freemarker-gae, org.freemarker, FreeMarker導入, Maven依存関係追加, freemarker-gae 2.3.27-incubating

</details>

## FreeMarkerServletの設定を行う

`web.xml` に `freemarker.ext.servlet.FreemarkerServlet` を登録し、`*.ftl` にマッピングする。

```xml
<servlet>
  <servlet-name>freemarker</servlet-name>
  <servlet-class>freemarker.ext.servlet.FreemarkerServlet</servlet-class>
</servlet>

<servlet-mapping>
  <servlet-name>freemarker</servlet-name>
  <url-pattern>*.ftl</url-pattern>
  <init-param>
    <param-name>TemplatePath</param-name>
    <param-value>/</param-value>
    <!-- 上記以外については、ドキュメントを参照し必要なパラメータを設定すること -->
  </init-param>
</servlet-mapping>
```

`TemplatePath`: テンプレートファイル(ftl)の配置ディレクトリ。`/` を指定するとWARのルートディレクトリになる。`TemplatePath` 以外のパラメータが必要な場合は、FreeMarkerのドキュメントを参照して設定する。

<details>
<summary>keywords</summary>

FreemarkerServlet, freemarker.ext.servlet.FreemarkerServlet, TemplatePath, FreeMarkerServlet設定, web.xml設定, *.ftlマッピング

</details>

## テンプレートファイル(ftlファイル)を作成しActionを実装する

ActionクラスでHTTPResponseとしてftlファイルへのパスを返す。

```java
return new HttpResponse("/WEB-INF/template/index.ftl");
```

> **補足**: FreeMarkerによるHTML生成の流れ:
> 1. [http_response_handler](../../component/handlers/handlers-http_response_handler.md) が `/WEB-INF/template/index.ftl` に対してServlet forwardを行う。
> 2. 拡張子 `ftl` に反応し `FreeMarkerServlet` が実行され、テンプレートとリクエストスコープ等のデータを元にhtmlを生成する。
> 3. 生成したhtmlをクライアントに返す。

<details>
<summary>keywords</summary>

HttpResponse, ftlテンプレート作成, Action実装, FreeMarkerレンダリング, Servlet forward, http_response_handler

</details>

## 2重サブミットを防止する

2重サブミットを防止する場合は、[use_token_interceptor](../../component/handlers/handlers-use_token.md) を参照してAction及びテンプレートファイル(ftlファイル)を作成する。

<details>
<summary>keywords</summary>

2重サブミット防止, use_token_interceptor, トークン, ftlファイル

</details>
