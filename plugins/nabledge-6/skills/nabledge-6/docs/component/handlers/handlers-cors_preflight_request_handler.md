# CORSプリフライトリクエストハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/cors_preflight_request_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/CorsPreflightRequestHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/CorsResponseFinisher.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/Cors.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/cors/BasicCors.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html)

## ハンドラクラス名

本ハンドラは :ref:`restful_web_service` でCORS(Cross-Origin Resource Sharing)を実現するために使用する。プリフライトリクエストは本ハンドラで処理し、実際のリクエストに対する処理は `CorsResponseFinisher` で処理する。

**クラス名**: `nablarch.fw.jaxrs.CorsPreflightRequestHandler`

<details>
<summary>keywords</summary>

CorsPreflightRequestHandler, nablarch.fw.jaxrs.CorsPreflightRequestHandler, CorsResponseFinisher, CORSプリフライトリクエストハンドラ, RESTfulウェブサービス

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

nablarch-fw-jaxrs, com.nablarch.framework, Maven依存関係, モジュール依存関係

</details>

## 制約

> **重要**: :ref:`jaxrs_response_handler` より後ろに配置すること。本ハンドラで生成した `HttpResponse` を :ref:`jaxrs_response_handler` が処理するため、本ハンドラは :ref:`jaxrs_response_handler` より後ろに配置する必要がある。

<details>
<summary>keywords</summary>

jaxrs_response_handler, JaxRsResponseHandler, ハンドラ配置順序, HttpResponse, 制約

</details>

## CORSを実現する

CORSを実現するには本ハンドラと `CorsResponseFinisher` を設定する。CORSの処理は `Cors` インタフェースが行う。フレームワークの基本実装として `BasicCors` クラスを提供しており、本ハンドラと `CorsResponseFinisher` にBasicCorsを指定する。

**設定例**:
```xml
<component name="cors" class="nablarch.fw.jaxrs.cors.BasicCors">
  <!-- 許可するOriginの指定。この設定は必須 -->
  <property name="allowOrigins">
    <list>
      <value>https://www.example.com</value>
    </list>
  </property>
</component>

<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.jaxrs.JaxRsResponseHandler">
        <property name="responseFinishers">
          <list>
            <component class="nablarch.fw.jaxrs.cors.CorsResponseFinisher">
              <property name="cors" ref="cors" />
            </component>
          </list>
        </property>
      </component>
      <component class="nablarch.fw.jaxrs.CorsPreflightRequestHandler">
        <property name="cors" ref="cors" />
      </component>
    </list>
  </property>
</component>
```

**BasicCorsのデフォルト動作**

プリフライトリクエスト（CorsPreflightRequestHandlerが呼び出す）:
- 判定条件（以下の条件をすべて満たす場合にプリフライトリクエストと判定）:
  - HTTPメソッド: OPTIONS
  - Originヘッダ: 存在する
  - Access-Control-Request-Methodヘッダ: 存在する
- プリフライトリクエストと判定した場合のレスポンス:
  - ステータスコード: 204
  - Access-Control-Allow-Methods: OPTIONS, GET, POST, PUT, DELETE, PATCH
  - Access-Control-Allow-Headers: Content-Type, X-CSRF-TOKEN
  - Access-Control-Max-Age: -1
  - 実際のリクエストと同じレスポンスヘッダも設定する

実際のリクエスト（CorsResponseFinisherが呼び出す）:
- Access-Control-Allow-Origin: リクエストのOriginヘッダ（許可Originに含まれる場合のみ設定）
- Vary: Origin（許可Originに含まれる場合のみ設定）
- Access-Control-Allow-Credentials: true

レスポンスヘッダの内容は設定で変更可能。

<details>
<summary>keywords</summary>

BasicCors, nablarch.fw.jaxrs.cors.BasicCors, CorsResponseFinisher, nablarch.fw.jaxrs.cors.CorsResponseFinisher, Cors, nablarch.fw.jaxrs.cors.Cors, allowOrigins, CORS設定, プリフライトリクエスト処理, Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers, Access-Control-Allow-Credentials, Access-Control-Max-Age, JaxRsResponseHandler, WebFrontController, nablarch.fw.web.servlet.WebFrontController

</details>
