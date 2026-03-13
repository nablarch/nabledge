# ヘルスチェックエンドポイントハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/web/health_check_endpoint_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/HealthCheckEndpointHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/health/DbHealthChecker.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/health/HealthChecker.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/handler/health/HealthCheckResponseBuilder.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HealthCheckEndpointHandler`

<details>
<summary>keywords</summary>

HealthCheckEndpointHandler, nablarch.fw.web.handler.HealthCheckEndpointHandler, ヘルスチェックエンドポイントハンドラ, ハンドラクラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>

<!-- DBのヘルスチェックを行う場合 -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-core-jdbc, モジュール一覧, 依存関係, DBヘルスチェック

</details>

## 制約

> **重要**: [http_response_handler](handlers-http_response_handler.md) または [jaxrs_response_handler](handlers-jaxrs_response_handler.md) より後ろに配置すること。本ハンドラで生成した `HttpResponse` を [http_response_handler](handlers-http_response_handler.md) または [jaxrs_response_handler](handlers-jaxrs_response_handler.md) が処理するため。

<details>
<summary>keywords</summary>

http_response_handler, jaxrs_response_handler, HttpResponse, nablarch.fw.web.HttpResponse, ハンドラ配置順, 制約

</details>

## ヘルスチェックのエンドポイントを作る

本ハンドラをハンドラ構成に追加するとヘルスチェックエンドポイントとなる。後続ハンドラの呼び出しは行わない。`RequestHandlerEntry` で特定パスにのみ実行するよう設定する。

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.web.handler.HttpResponseHandler"/>
      <component class="nablarch.fw.RequestHandlerEntry">
        <property name="requestPattern" value="/action/healthcheck" />
        <property name="handler">
          <component class="nablarch.fw.web.handler.HealthCheckEndpointHandler"/>
        </property>
      </component>
    </list>
  </property>
</component>
```

デフォルトではDB等のヘルスチェックを行わず、ステータスコード200で以下のJSONレスポンスを返す。

```json
{"status":"UP"}
```

DB等リソースのヘルスチェックは `HealthChecker` を継承したクラスを `healthCheckers` プロパティに指定して使用する。デフォルトで `DbHealthChecker` と [Redis](../adapters/adapters-lettuce_adaptor.md) のヘルスチェックが提供されている。

DbHealthCheckerの設定例:

```xml
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <property name="healthCheckers">
    <list>
      <component class="nablarch.fw.web.handler.health.DbHealthChecker">
        <property name="dataSource" ref="dataSource" />
        <property name="dialect" ref="dialect" />
      </component>
    </list>
  </property>
</component>
```

レスポンス例:
- 成功時（ステータスコード200）: `{"status":"UP","targets":[{"name":"DB","status":"UP"}]}`
- 失敗時（ステータスコード503）: `{"status":"DOWN","targets":[{"name":"DB","status":"DOWN"}]}`

<details>
<summary>keywords</summary>

HealthCheckEndpointHandler, DbHealthChecker, nablarch.fw.web.handler.health.DbHealthChecker, healthCheckers, RequestHandlerEntry, ヘルスチェックエンドポイント設定, ステータスコード200, ステータスコード503, dataSource, dialect

</details>

## ヘルスチェックを追加する

`HealthChecker` を継承したクラスを作成し、`healthCheckers` プロパティに指定するとヘルスチェックを追加できる。

```java
public class CustomHealthChecker extends HealthChecker {
    public CustomHealthChecker() {
        setName("Custom"); // 対象を表す名前を指定
    }

    @Override
    protected boolean tryOut(HttpRequest request, ExecutionContext context) throws Exception {
        // ヘルスチェックが失敗した場合はfalseを返すか例外を送出
        CustomClient client = ...;
        client.execute();
        return true;
    }
}
```

```xml
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <property name="healthCheckers">
    <list>
      <component class="nablarch.fw.web.handler.health.DbHealthChecker">
        <!-- 省略 -->
      </component>
      <!-- HealthCheckerを継承して作成したクラスを指定 -->
      <component class="com.example.CustomHealthChecker">
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

HealthChecker, nablarch.fw.web.handler.health.HealthChecker, tryOut, healthCheckers, ヘルスチェック追加, カスタムヘルスチェック, CustomHealthChecker

</details>

## ヘルスチェック結果のレスポンスを変更する

ヘルスチェック結果のレスポンスは `HealthCheckResponseBuilder` が作成する。

デフォルトのレスポンス仕様:

| 項目 | 成功 | 失敗 |
|---|---|---|
| ステータスコード | 200 | 503 |
| ラベル | UP | DOWN |
| Content-Type | application/json | application/json |

レスポンスボディのフォーマット:
```json
{"status":"ヘルスチェック全体の結果","targets":[{"name":"対象1","status":"対象1の結果"}]}
```

> **重要**: ヘルスチェック全体の結果はtargetsのうち1つでも失敗の場合に失敗となる。targetsは指定された `HealthChecker` の数だけ含まれる。

ステータスコード、ラベル、レスポンスボディ出力有無は `healthCheckResponseBuilder` プロパティで変更可能:

| プロパティ名 | 説明 |
|---|---|
| healthyStatusCode | ヘルスチェック成功時のステータスコード（デフォルト: 200） |
| healthyStatus | ヘルスチェック成功時のラベル（デフォルト: UP） |
| unhealthyStatusCode | ヘルスチェック失敗時のステータスコード（デフォルト: 503） |
| unhealthyStatus | ヘルスチェック失敗時のラベル（デフォルト: DOWN） |
| writeBody | レスポンスボディを出力するか（falseで出力しない） |

```xml
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <property name="healthCheckResponseBuilder">
    <component class="nablarch.fw.web.handler.health.HealthCheckResponseBuilder">
      <property name="healthyStatusCode" value="201" />
      <property name="healthyStatus" value="OK" />
      <property name="unhealthyStatusCode" value="500" />
      <property name="unhealthyStatus" value="NG" />
      <property name="writeBody" value="false" />
    </component>
  </property>
</component>
```

レスポンスボディの内容を変更する場合は `HealthCheckResponseBuilder` を継承して `getContentType()` と `buildResponseBody()` をオーバーライドする。

```java
public class CustomHealthCheckResponseBuilder extends HealthCheckResponseBuilder {
    @Override
    protected String getContentType() {
        return "text/plain";
    }
    @Override
    protected String buildResponseBody(
            HttpRequest request, ExecutionContext context, HealthCheckResult result) {
        StringBuilder builder = new StringBuilder();
        builder.append("All=" + getStatus(result.isHealthy()));
        for (HealthCheckResult.Target target : result.getTargets()) {
            builder.append(", " + target.getName() + "=" + getStatus(target.isHealthy()));
        }
        return builder.toString();
    }
}
```

設定例:

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action/healthcheck" />
  <property name="handler">
    <component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
      <property name="healthCheckResponseBuilder">
        <component class="com.nablarch.example.app.web.handler.health.CustomHealthCheckResponseBuilder" />
      </property>
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

HealthCheckResponseBuilder, nablarch.fw.web.handler.health.HealthCheckResponseBuilder, healthyStatusCode, healthyStatus, unhealthyStatusCode, unhealthyStatus, writeBody, レスポンスカスタマイズ, HealthCheckResult, CustomHealthCheckResponseBuilder, getContentType, buildResponseBody

</details>
