# ヘルスチェックエンドポイントハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.web.handler.HealthCheckEndpointHandler`

:ref:`web_application` と :ref:`restful_web_service` のヘルスチェックを行うエンドポイントを提供するハンドラ。本ハンドラはエンドポイントとなるため、後続ハンドラの呼び出しは行わない。

デフォルト実装として `DbHealthChecker` と :ref:`lettuce_adaptor` (Redis) のヘルスチェックを提供している。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

DBのヘルスチェックを行う場合:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-jdbc</artifactId>
</dependency>
```

## 制約

> **重要**: :ref:`http_response_handler` または :ref:`jaxrs_response_handler` より後ろに配置すること。本ハンドラで生成した `HttpResponse` を :ref:`http_response_handler` または :ref:`jaxrs_response_handler` が処理するため。

## ヘルスチェックのエンドポイントを作る

ハンドラ構成に追加するとヘルスチェックエンドポイントとなる。`nablarch.fw.RequestHandlerEntry` を使用して特定パスのみ実行するよう設定する。

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

デフォルト（`healthCheckers` 未設定）ではステータスコード200で以下のJSONを返す:
```json
{"status":"UP"}
```

DBなどリソースのヘルスチェックは `HealthChecker` の継承クラスを `healthCheckers` プロパティに指定する。

DBヘルスチェックの設定例:
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

レスポンス:
- 成功時（ステータスコード200）: `{"status":"UP","targets":[{"name":"DB","status":"UP"}]}`
- 失敗時（ステータスコード503）: `{"status":"DOWN","targets":[{"name":"DB","status":"DOWN"}]}`

`status` にヘルスチェック全体の結果、`targets` に対象ごとの結果を出力する。`targets` の1つでも失敗の場合、全体結果が失敗となる。

## ヘルスチェックを追加する

`HealthChecker` を継承したクラスを作成し、`healthCheckers` プロパティに指定するとヘルスチェックを追加できる。

```java
public class CustomHealthChecker extends HealthChecker {

    public CustomHealthChecker() {
        setName("Custom"); // 対象を表す名前を指定
    }

    @Override
    protected boolean tryOut(HttpRequest request, ExecutionContext context) throws Exception {
        // ヘルスチェックが失敗した場合は false を返すか例外を送出
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
      <component class="com.example.CustomHealthChecker"/>
    </list>
  </property>
</component>
```

## ヘルスチェック結果のレスポンスを変更する

`HealthCheckResponseBuilder` がレスポンスを作成する。

デフォルトのレスポンス:
- ステータスコード: 成功200 / 失敗503
- Content-Type: `application/json`
- ヘルスチェック結果ラベル: 成功`UP` / 失敗`DOWN`
- レスポンスボディのJSONは実際には改行なしの1行で出力される（フォーマット例は可読性のために整形したもの）
- `targets` 配列には、設定した `HealthChecker` の数だけエントリが含まれる

ステータスコード・ラベル・レスポンスボディ出力有無は設定で変更可能:

```xml
<component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
  <property name="healthCheckers"><!-- 省略 --></property>
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

| プロパティ名 | 説明 |
|---|---|
| healthyStatusCode | ヘルスチェック成功時のステータスコード（デフォルト: 200） |
| healthyStatus | ヘルスチェック成功時のラベル（デフォルト: UP） |
| unhealthyStatusCode | ヘルスチェック失敗時のステータスコード（デフォルト: 503） |
| unhealthyStatus | ヘルスチェック失敗時のラベル（デフォルト: DOWN） |
| writeBody | レスポンスボディを出力するか否か。出力しない場合は false を指定 |

レスポンスボディの内容を変更する場合は `HealthCheckResponseBuilder` を継承し、`getContentType()` と `buildResponseBody()` をオーバーライドする。`buildResponseBody()` では `HealthCheckResult` および `HealthCheckResult.Target` を使用して各ヘルスチェック対象の結果を取得できる。

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

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action/healthcheck" />
  <property name="handler">
    <component class="nablarch.fw.web.handler.HealthCheckEndpointHandler">
      <property name="healthCheckers"><!-- 省略 --></property>
      <property name="healthCheckResponseBuilder">
        <component class="com.nablarch.example.app.web.handler.health.CustomHealthCheckResponseBuilder" />
      </property>
    </component>
  </property>
</component>
```
