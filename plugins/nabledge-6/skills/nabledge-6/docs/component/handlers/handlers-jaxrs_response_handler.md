# Jakarta RESTful Web Servicesレスポンスハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/jaxrs_response_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsResponseHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ErrorResponseBuilder.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsErrorLogWriter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ResponseFinisher.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/AdoptHandlerResponseFinisher.html)

## 概要

本ハンドラは、後続のハンドラ（リソース（アクション）クラスや `body_convert_handler`）から戻されたレスポンス情報をクライアントに返却する。後続のハンドラで例外及びエラーが送出された場合には、エラー及び例外に対応したレスポンス情報を構築してクライアントに返却する。

本ハンドラでは以下の処理を行う。

- 例外及びエラー発生時のレスポンス情報を生成する（`errorResponseBuilder`プロパティ）
- 例外及びエラー発生時のログを出力する（`errorLogWriter`プロパティ）
- クライアントへのレスポンスを返却する

> **補足（名称変更について）**: Nablarch5までは「JAX-RSレスポンスハンドラ」という名称だった。Java EEがEclipse Foundationに移管され仕様名が変わったことに伴い、Nablarch6から「Jakarta RESTful Web Servicesレスポンスハンドラ」に名称変更された。変更されたのは名称のみで、機能的な差はない。

<details>
<summary>keywords</summary>

Jakarta RESTful Web Servicesレスポンスハンドラ, JAX-RSレスポンスハンドラ, JaxRsResponseHandler, レスポンスハンドラ概要, 名称変更, Nablarch6, エラーレスポンス, エラーログ, クライアント返却

</details>

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsResponseHandler`

<details>
<summary>keywords</summary>

JaxRsResponseHandler, nablarch.fw.jaxrs.JaxRsResponseHandler, レスポンスハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-jaxrs, モジュール, 依存関係, com.nablarch.framework

</details>

## 制約

このハンドラに固有の制約はない。

<details>
<summary>keywords</summary>

制約, JaxRsResponseHandler制約

</details>

## 例外及びエラーに応じたレスポンスの生成

例外・エラー発生時のレスポンス生成は `errorResponseBuilder` プロパティに設定した `ErrorResponseBuilder` が行う。発生した例外が `HttpErrorResponse` の場合は `HttpErrorResponse#getResponse()` から返される `HttpResponse` をクライアントに返す。

設定省略時はデフォルト実装の `ErrorResponseBuilder` を使用。プロジェクト要件を満たせない場合はデフォルト実装を継承して対応する。

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="errorResponseBuilder">
    <component class="sample.SampleErrorResponseBuilder" />
  </property>
</component>
```

> **重要**: `ErrorResponseBuilder`処理中に例外が発生するとレスポンスが生成できずクライアントに返せない状態となる。カスタマイズ時は処理中に例外が発生しないよう実装すること。処理中に例外が発生した場合、フレームワークはWARNレベルでログ出力し、ステータスコード500のレスポンスを生成して後続処理を継続する。

<details>
<summary>keywords</summary>

ErrorResponseBuilder, nablarch.fw.jaxrs.ErrorResponseBuilder, HttpErrorResponse, nablarch.fw.web.HttpErrorResponse, HttpResponse, errorResponseBuilder, エラーレスポンス生成, 例外処理

</details>

## 例外及びエラーに応じたログ出力

例外・エラー発生時のログ出力は `errorLogWriter` プロパティに設定した `JaxRsErrorLogWriter` が行う。設定省略時はデフォルト実装を使用。プロジェクト要件を満たせない場合はデフォルト実装を継承して対応する。

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="errorLogWriter">
    <component class="sample.SampleJaxRsErrorLogWriter" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

JaxRsErrorLogWriter, nablarch.fw.jaxrs.JaxRsErrorLogWriter, errorLogWriter, エラーログ出力, 例外ログ

</details>

## エラー時のレスポンスにメッセージを設定する

バリデーションエラー発生時など、エラーレスポンスのボディにエラーメッセージを設定して返却したい場合は、`ErrorResponseBuilder` の継承クラスを作成して対応する。

```java
public class SampleErrorResponseBuilder extends ErrorResponseBuilder {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public HttpResponse build(final HttpRequest request,
            final ExecutionContext context, final Throwable throwable) {
        if (throwable instanceof ApplicationException) {
            return createResponseBody((ApplicationException) throwable);
        } else {
            return super.build(request, context, throwable);
        }
    }

    private HttpResponse createResponseBody(final ApplicationException ae) {
        final HttpResponse response = new HttpResponse(400);
        response.setContentType(MediaType.APPLICATION_JSON);
        try {
            response.write(objectMapper.writeValueAsString(errorMessages));
        } catch (JsonProcessingException ignored) {
            return new HttpResponse(500);
        }
        return response;
    }
}
```

<details>
<summary>keywords</summary>

ErrorResponseBuilder, ApplicationException, エラーレスポンスカスタマイズ, バリデーションエラー, エラーメッセージ設定, エラーレスポンスボディ

</details>

## 特定のエラーの場合に個別に定義したエラーレスポンスを返却する

後続処理で発生したエラーに対して個別にステータスコードやボディを定義したレスポンスを返したい場合は、`ErrorResponseBuilder` の継承クラスを作成し、例外に応じたレスポンス生成処理を個別に実装する。

```java
public class SampleErrorResponseBuilder extends ErrorResponseBuilder {

    @Override
    public HttpResponse build(final HttpRequest request,
            final ExecutionContext context, final Throwable throwable) {
        if (throwable instanceof NoDataException) {
            return new HttpResponse(404);
        } else {
            return super.build(request, context, throwable);
        }
    }
}
```

<details>
<summary>keywords</summary>

ErrorResponseBuilder, NoDataException, 個別エラーレスポンス, ステータスコード, エラーレスポンスカスタマイズ

</details>

## クライアントに返すレスポンスに共通処理を追加する

正常時・エラー発生時を問わず、CORS対応やセキュリティ対応でレスポンスヘッダを共通指定したい場合は、`ResponseFinisher` インタフェースを実装したクラスを作成し、`responseFinishers`プロパティに指定する。

```java
public class CustomResponseFinisher implements ResponseFinisher {
    @Override
    public void finish(HttpRequest request, HttpResponse response, ExecutionContext context) {
        // レスポンスヘッダを設定するなど、共通処理を行う。
    }
}
```

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="responseFinishers">
    <list>
      <component class="sample.CustomResponseFinisher" />
    </list>
  </property>
</component>
```

既存ハンドラ（`secure_handler` 等）を`ResponseFinisher`として使用したい場合は `AdoptHandlerResponseFinisher` を使用する。`AdoptHandlerResponseFinisher`で使用できるハンドラは、自らレスポンスを作成せず後続ハンドラが返すレスポンスに変更を加えるハンドラに限定される。

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="responseFinishers">
    <list>
      <component class="nablarch.fw.jaxrs.AdoptHandlerResponseFinisher">
        <property name="handler" ref="secureHandler" />
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

ResponseFinisher, nablarch.fw.jaxrs.ResponseFinisher, AdoptHandlerResponseFinisher, nablarch.fw.jaxrs.AdoptHandlerResponseFinisher, responseFinishers, レスポンスヘッダ, CORS対応, secure_handler

</details>
