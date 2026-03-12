# ウェブアプリケーション Thymeleafアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/web_thymeleaf_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/responsewriter/thymeleaf/ThymeleafResponseWriter.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HttpResponseHandler.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-web-thymeleaf-adaptor</artifactId>
</dependency>
```

> **補足**: Thymeleaf 3.1.1.RELEASE でテスト済み。バージョンを変更する場合は、プロジェクト側でテストを行うこと。

<details>
<summary>keywords</summary>

nablarch-web-thymeleaf-adaptor, com.nablarch.integration, Thymeleafアダプタ, モジュール依存関係, テンプレートエンジン

</details>

## ウェブアプリケーション Thymeleafアダプタを使用するための設定を行う

コンポーネント設定ファイルで `ThymeleafResponseWriter` を `HttpResponseHandler` の `customResponseWriter` プロパティに設定する。`ThymeleafResponseWriter` には `templateEngine` プロパティに Thymeleaf の `TemplateEngine` を設定する必要がある。

```xml
<component name="templateEngine" class="org.thymeleaf.TemplateEngine" autowireType="None">
  <property name="templateResolver">
    <component class="org.thymeleaf.templateresolver.ClassLoaderTemplateResolver">
      <property name="prefix" value="template/"/>
    </component>
  </property>
</component>

<component name="thymeleafResponseWriter"
           class="nablarch.fw.web.handler.responsewriter.thymeleaf.ThymeleafResponseWriter"
           autowireType="None">
  <property name="templateEngine" ref="templateEngine" />
</component>

<component name="httpResponseHandler"
           class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="customResponseWriter" ref="thymeleafResponseWriter"/>
</component>
```

> **補足**: `org.thymeleaf.templateresolver.ServletContextTemplateResolver` は [repository](../libraries/libraries-repository.md) にコンポーネントとして登録できない。コンストラクタ引数に `jakarta.servlet.ServletContext` が必須（デフォルトコンストラクタなし）であり、システムリポジトリ構築時には `jakarta.servlet.ServletContext` にアクセスできず [ファクトリ](../libraries/libraries-repository.md) によるオブジェクト生成もできないため。`ITemplateResolver` インタフェースの実装クラスとして `ServletContextTemplateResolver` の代わりに `ClassLoaderTemplateResolver` 等の別の実装クラスを使用すること。

<details>
<summary>keywords</summary>

ThymeleafResponseWriter, HttpResponseHandler, TemplateEngine, ITemplateResolver, ClassLoaderTemplateResolver, ServletContextTemplateResolver, templateEngine, customResponseWriter, Thymeleaf設定

</details>

## 処理対象判定について

`ThymeleafResponseWriter` は `HttpResponse` のコンテンツパスによって処理対象か判断する。デフォルトではコンテンツパスが `.html` で終わる場合テンプレートエンジンで出力し、それ以外はサーブレットフォワードが実行される。

`pathPattern` プロパティで判定条件を変更可能（デフォルト値: `.*\.html`）。コンテンツパスが正規表現にマッチした場合、テンプレートエンジンの処理対象と判定される。

> **重要**: サフィックスを省略しないこと。
> - OK: `return new HttpResponse("index.html");`
> - NG: `return new HttpResponse("index");`
>
> サフィックスを省略した場合、セッションストアからリクエストスコープへの移送が行われず、テンプレートからセッションストアの値を参照できなくなる。

<details>
<summary>keywords</summary>

ThymeleafResponseWriter, HttpResponse, pathPattern, 処理対象判定, サーブレットフォワード, .html, コンテンツパス, サフィックス省略

</details>

## テンプレートエンジンを使用する

テンプレートファイルの配置場所は `TemplateEngine` の設定による。`ClassLoaderTemplateResolver` に `prefix` を設定した場合（例: `template/`）、クラスパス上のそのプレフィックスディレクトリ配下にテンプレートファイルを配置する。

テンプレートを使うには、テンプレートファイルへのパスを指定した `HttpResponse` をアクションクラスの戻り値として返す。

- `prefix` 設定あり: プレフィックスを省略したパスを指定（例: `return new HttpResponse("index.html");`）
- `prefix` 設定なし: パスをそのまま指定（例: `return new HttpResponse("template/index.html");`）

<details>
<summary>keywords</summary>

TemplateEngine, ClassLoaderTemplateResolver, HttpResponse, prefix, テンプレートファイル配置, テンプレートパス指定

</details>
