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

> **補足**: テスト済みバージョンはThymeleaf 3.0.9.RELEASE。バージョンを変更する場合はプロジェクト側でテストを行うこと。

<details>
<summary>keywords</summary>

nablarch-web-thymeleaf-adaptor, com.nablarch.integration, Thymeleaf, モジュール依存関係, Thymeleafアダプタ

</details>

## ウェブアプリケーション Thymeleafアダプタを使用するための設定を行う

`ThymeleafResponseWriter` を `HttpResponseHandler` の `customResponseWriter` プロパティに設定する。`ThymeleafResponseWriter` には Thymeleaf の `TemplateEngine` を設定する必要がある。

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

> **補足**: `ITemplateResolver` インタフェースの実装クラスに `org.thymeleaf.templateresolver.ServletContextTemplateResolver` が存在するが、以下の理由により `[repository](../libraries/libraries-repository.md)` にコンポーネントとして登録できない。
> - コンストラクタ引数に `javax.servlet.ServletContext` が必須（デフォルトコンストラクタなし）
> - システムリポジトリ構築時には `javax.servlet.ServletContext` にアクセスできず、ファクトリによるオブジェクト生成もできない
>
> このため、`ServletContextTemplateResolver` ではなく `ClassLoaderTemplateResolver` 等の別の実装クラスを使用すること。

<details>
<summary>keywords</summary>

ThymeleafResponseWriter, nablarch.fw.web.handler.responsewriter.thymeleaf.ThymeleafResponseWriter, HttpResponseHandler, nablarch.fw.web.handler.HttpResponseHandler, TemplateEngine, ClassLoaderTemplateResolver, ITemplateResolver, ServletContextTemplateResolver, org.thymeleaf.templateresolver.ServletContextTemplateResolver, customResponseWriter, コンポーネント設定

</details>

## 処理対象判定について

`ThymeleafResponseWriter` は `HttpResponse` のコンテンツパスの内容によってテンプレートエンジンを使用してレスポンスを出力するか否かを判断する。デフォルトではコンテンツパスが `.html` で終了している場合に処理対象と判定しテンプレートエンジンにより出力する。

```java
// 処理対象（.html で終了）
return new HttpResponse("template/index.html");

// 処理対象外 → サーブレットフォワードが実行される
return new HttpResponse("/path/to/anotherServlet");
```

`pathPattern` プロパティで判定条件（正規表現）を変更可能（デフォルト値: `.*\.html`）。この正規表現にコンテンツパスがマッチした場合、テンプレートエンジンの処理対象と判定される。

> **重要**: Thymeleafではテンプレートのパスを解決する際にサフィックスを省略する設定ができるが、本アダプタを使用する場合はサフィックスの省略を行わないこと。
> - OK: `return new HttpResponse("index.html");`
> - NG: `return new HttpResponse("index");`
>
> サフィックスを省略した場合、セッションストアからリクエストスコープへの移送が行われず、テンプレートからセッションストアの値を参照できなくなる。

<details>
<summary>keywords</summary>

ThymeleafResponseWriter, HttpResponse, nablarch.fw.web.HttpResponse, pathPattern, 処理対象判定, サーブレットフォワード, html, 正規表現, セッションストア

</details>

## テンプレートエンジンを使用する

テンプレートファイルの配置場所は `TemplateEngine` の設定による。

`ClassLoaderTemplateResolver` に `prefix` が設定されている場合はプレフィックスを省略したパスを `HttpResponse` に指定する:

```java
return new HttpResponse("index.html");
```

プレフィックスを指定しない場合はフルパスをそのまま指定する:

```java
return new HttpResponse("template/index.html");
```

<details>
<summary>keywords</summary>

HttpResponse, nablarch.fw.web.HttpResponse, ClassLoaderTemplateResolver, TemplateEngine, prefix, テンプレートファイル配置, レスポンス出力

</details>
