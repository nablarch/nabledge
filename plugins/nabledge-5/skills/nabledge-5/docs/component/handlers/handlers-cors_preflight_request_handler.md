# CORSプリフライトリクエストハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/cors_preflight_request_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/CorsPreflightRequestHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/CorsResponseFinisher.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/Cors.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/BasicCors.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## ハンドラクラス名

:ref:`RESTfulウェブサービス<restful_web_service>` でCORSを実現するために使用するハンドラ。プリフライトリクエストを処理する。実際のリクエストに対する処理は [jaxrs_response_handler-response_finisher](handlers-jaxrs_response_handler.md) で説明している `CorsResponseFinisher` で行う。

**クラス名**: `nablarch.fw.jaxrs.CorsPreflightRequestHandler`

<details>
<summary>keywords</summary>

CorsPreflightRequestHandler, nablarch.fw.jaxrs.CorsPreflightRequestHandler, CORSプリフライトリクエストハンドラ, RESTfulウェブサービス, CorsResponseFinisher

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

nablarch-fw-jaxrs, com.nablarch.framework, モジュール依存関係

</details>

## 制約

> **重要**: [jaxrs_response_handler](handlers-jaxrs_response_handler.md) より後ろに配置すること。本ハンドラが生成した `HttpResponse` を [jaxrs_response_handler](handlers-jaxrs_response_handler.md) が処理するため、本ハンドラは [jaxrs_response_handler](handlers-jaxrs_response_handler.md) より後ろに配置する必要がある。

<details>
<summary>keywords</summary>

jaxrs_response_handler, JaxRsResponseHandler, ハンドラ配置順序, HttpResponse, 制約

</details>

## CORSを実現する

CORSの実現には本ハンドラと `CorsResponseFinisher` の両方を設定する。CORSの処理は `Cors` インタフェースが行い、基本実装として `BasicCors` が提供されている。本ハンドラとCorsResponseFinisherの両方に同一のBasicCorsインスタンスを指定する。

**BasicCors プロパティ**:

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| allowOrigins | List\<String\> | ○ | | 許可するOriginのリスト |

**設定例**:
```xml
<!-- BasicCors -->
<component name="cors" class="nablarch.fw.jaxrs.cors.BasicCors">
  <!-- 許可するOriginの指定。この設定は必須 -->
  <property name="allowOrigins">
    <list>
      <value>https://www.example.com</value>
    </list>
  </property>
</component>

<!-- ハンドラキュー構成 -->
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- JaxRsResponseHandler -->
      <component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
        <property name="responseFinishers">
          <list>
            <!-- CorsResponseFinisher -->
            <component class="nablarch.fw.jaxrs.cors.CorsResponseFinisher">
              <property name="cors" ref="cors" />
            </component>
          </list>
        </property>
      </component>
      <!-- CorsPreflightRequestHandler -->
      <component class="nablarch.fw.jaxrs.CorsPreflightRequestHandler">
        <property name="cors" ref="cors" />
      </component>
    </list>
  </property>
</component>
```

**BasicCorsのデフォルト動作**

プリフライトリクエスト判定条件（以下の全条件を満たす場合にプリフライトリクエストと判定）:
- HTTPメソッド：OPTIONS
- Originヘッダ：存在する
- Access-Control-Request-Methodヘッダ：存在する

プリフライトリクエストの場合のレスポンス:
- ステータスコード：204
- Access-Control-Allow-Methods：OPTIONS, GET, POST, PUT, DELETE, PATCH
- Access-Control-Allow-Headers：Content-Type, X-CSRF-TOKEN
- Access-Control-Max-Age：-1
- 実際のリクエスト用レスポンスヘッダも同時に設定

実際のリクエスト（CorsResponseFinisherが処理）のレスポンスヘッダ:
- Access-Control-Allow-Origin：リクエストのOriginヘッダ値（許可するOriginに含まれる場合のみ設定）
- Vary：Origin（許可するOriginに含まれる場合のみ設定）
- Access-Control-Allow-Credentials：true

レスポンスヘッダの内容は設定で変更可能。詳細は `BasicCors` のJavadocを参照。

<details>
<summary>keywords</summary>

BasicCors, CorsResponseFinisher, Cors, nablarch.fw.jaxrs.cors.BasicCors, nablarch.fw.jaxrs.cors.CorsResponseFinisher, nablarch.fw.jaxrs.cors.Cors, allowOrigins, CORS設定, プリフライトリクエスト判定, Access-Control-Allow-Origin, Access-Control-Allow-Credentials, Access-Control-Request-Method, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Access-Control-Max-Age, Vary, JaxRsResponseHandler, WebFrontController

</details>
