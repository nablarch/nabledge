# JAX-RSレスポンスハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/jaxrs_response_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsResponseHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ErrorResponseBuilder.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpErrorResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsErrorLogWriter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/ResponseFinisher.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/AdoptHandlerResponseFinisher.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.JaxRsResponseHandler`

<details>
<summary>keywords</summary>

JaxRsResponseHandler, nablarch.fw.jaxrs.JaxRsResponseHandler, ハンドラクラス名, JAX-RSレスポンスハンドラ

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

nablarch-fw-jaxrs, Maven依存関係, モジュール

</details>

## 制約

なし

<details>
<summary>keywords</summary>

制約, なし, JAX-RSレスポンスハンドラ制約

</details>

## 例外及びエラーに応じたレスポンスの生成

後続ハンドラから例外・エラーが発生した場合のレスポンス生成は、`errorResponseBuilder` プロパティの `ErrorResponseBuilder` で行う。

発生した例外が `HttpErrorResponse` の場合は、`HttpErrorResponse#getResponse()` が返す `HttpResponse` をクライアントに返却する。

省略時はデフォルト実装の `ErrorResponseBuilder` を使用。プロジェクト要件を満たせない場合はデフォルト実装クラスを継承してカスタマイズする。

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="errorResponseBuilder">
    <component class="sample.SampleErrorResponseBuilder" />
  </property>
</component>
```

> **重要**: `ErrorResponseBuilder` の処理中に例外が発生しないよう実装すること。例外が発生した場合、フレームワークはWARNレベルでログ出力し、ステータスコード500のレスポンスを生成して後続処理を継続する。

<details>
<summary>keywords</summary>

ErrorResponseBuilder, HttpErrorResponse, HttpResponse, errorResponseBuilder, エラーレスポンス生成, 例外処理, カスタマイズ

</details>

## 例外及びエラーに応じたログ出力

例外・エラー発生時のログ出力は `errorLogWriter` プロパティの `JaxRsErrorLogWriter` で行う。

省略時はデフォルト実装を使用。プロジェクト要件を満たせない場合はデフォルト実装クラスを継承してカスタマイズする。

```xml
<component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
  <property name="errorLogWriter">
    <component class="sample.SampleJaxRsErrorLogWriter" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

JaxRsErrorLogWriter, errorLogWriter, エラーログ出力, ログカスタマイズ

</details>

## 拡張例: エラー時のレスポンスにメッセージを設定する

バリデーションエラー等でエラーレスポンスのボディにメッセージを設定する場合は、`ErrorResponseBuilder` の継承クラスを作成して対応する。

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

SampleErrorResponseBuilder, ApplicationException, ErrorResponseBuilder, ObjectMapper, JsonProcessingException, エラーレスポンスメッセージ設定, バリデーションエラー

</details>

## 拡張例: 特定のエラーの場合に個別に定義したエラーレスポンスを返却する

特定の例外に対して個別のステータスコードやボディを返す場合は、`ErrorResponseBuilder` の継承クラスを作成し、送出された例外に応じたレスポンス生成を実装する。

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

SampleErrorResponseBuilder, NoDataException, ErrorResponseBuilder, 個別エラーレスポンス, ステータスコード

</details>

## 拡張例: クライアントに返すレスポンスに共通処理を追加する

正常時・エラー時を問わず共通のレスポンスヘッダ（CORS対応、セキュリティ対応等）を設定する場合は、`ResponseFinisher` インタフェースを実装したクラスを作成し、`responseFinishers` プロパティに指定する。

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

[secure_handler](handlers-secure_handler.md) のような既存ハンドラをResponseFinisherとして使用する場合は、`AdoptHandlerResponseFinisher` を使用する。使用できるハンドラは自らレスポンスを作成せず、後続ハンドラのレスポンスに変更を加えるハンドラに限定される。

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

CustomResponseFinisher, ResponseFinisher, AdoptHandlerResponseFinisher, responseFinishers, 共通レスポンスヘッダ, CORS対応, セキュリティヘッダ

</details>
