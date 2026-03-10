# Logbookを用いたリクエスト/レスポンスログ出力サンプル

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/biz_samples/13/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/StandardOutputLogWriter.html)

## サンプル概要

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-logbook)

<details>
<summary>keywords</summary>

Logbook, ソースコード, nablarch-biz-sample-all, HTTPリクエストログ, レスポンスログ

</details>

## 概要

[Logbook](https://github.com/zalando/logbook) を使用してHTTPリクエストおよびレスポンスのログ出力を行うサンプル。

<details>
<summary>keywords</summary>

Logbook, HTTPリクエストログ, レスポンスログ, ログ出力サンプル, zalando

</details>

## 本サンプルで取り扱う範囲

本サンプルで取り扱う範囲:
- Logbookのログ出力にはNablarchのログ出力機能を使用する
  - Nablarchとの連携は :ref:`SLF4Jアダプタ <slf4j_adaptor>` を使用して実現する
  - ログは標準出力に出力する
- リクエスト送信にはJAX-RSクライアントを使用し、メッセージ形式はJSON
  - JAX-RSクライアントの実装としてJerseyを使用する
- [JsonPath](https://github.com/json-path/JsonPath) を使用してJSON形式の特定項目にマスク処理を行う

<details>
<summary>keywords</summary>

SLF4Jアダプタ, slf4j_adaptor, 標準出力, JAX-RSクライアント, Jersey, JsonPath, マスク処理, ログ出力機能連携

</details>

## 依存ライブラリの追加

Logbook（3.9.0）、Jersey（3.1.1）、SLF4Jアダプタを依存関係に追加する:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.zalando</groupId>
      <artifactId>logbook-bom</artifactId>
      <version>3.9.0</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
    <dependency>
      <groupId>org.glassfish.jersey</groupId>
      <artifactId>jersey-bom</artifactId>
      <version>3.1.1</version>
      <type>pom</type>
    </dependency>
  </dependencies>
</dependencyManagement>
<dependencies>
  <dependency>
    <groupId>com.nablarch.integration</groupId>
    <artifactId>slf4j-nablarch-adaptor</artifactId>
    <scope>runtime</scope>
  </dependency>
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-core</artifactId>
  </dependency>
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-jaxrs</artifactId>
  </dependency>
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-json</artifactId>
  </dependency>
  <dependency>
    <groupId>org.glassfish.jersey.core</groupId>
    <artifactId>jersey-client</artifactId>
  </dependency>
  <dependency>
    <groupId>org.glassfish.jersey.media</groupId>
    <artifactId>jersey-media-json-jackson</artifactId>
  </dependency>
  <dependency>
    <groupId>org.glassfish.jersey.inject</groupId>
    <artifactId>jersey-hk2</artifactId>
  </dependency>
</dependencies>
```

> **補足**: 依存関係のバージョンは実行環境に合わせて適切なバージョンを設定すること。

<details>
<summary>keywords</summary>

logbook-bom, logbook-core, logbook-jaxrs, logbook-json, jersey-bom, jersey-client, jersey-media-json-jackson, jersey-hk2, slf4j-nablarch-adaptor, dependencyManagement, 依存ライブラリ

</details>

## log.propertiesの設定

LogbookはTRACEレベルでログ出力するため、Logbook専用ロガーを個別定義することを推奨する。

```properties
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter
writer.stdout.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.stdout.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

availableLoggersNamesOrder=DEV,PER,SQL,MON,ACC,LOGBOOK,ROO

loggers.LOGBOOK.nameRegex=org\\.zalando\\.logbook\\..*
loggers.LOGBOOK.level=TRACE
loggers.LOGBOOK.writerNames=stdout
```

Nablarchのログ出力設定については :ref:`log-basic_setting` を参照。

<details>
<summary>keywords</summary>

log.properties, StandardOutputLogWriter, BasicLogFormatter, TRACE, LOGBOOK, availableLoggersNamesOrder, nameRegex, log-basic_setting, Logbookロガー設定

</details>

## Logbookの構成

`Logbook.builder().build()` でインスタンスを生成する。デフォルト設定ではすべてのリクエスト/レスポンスのボディを含む情報が出力される。

Logbookには様々な設定があり、出力条件を設定する `condition` やマスク処理を設定する `Filtering` 等を設定できる。BodyFilterを設定することでボディのマスク処理が可能:

```java
// デフォルト設定
Logbook logbook = Logbook.builder().build();

// ボディのid項目をマスク
Logbook logbook = Logbook.builder()
        .bodyFilter(jsonPath("$.id").replace("*****"))
        .build();

// 配列内のidとusername項目をマスク
Logbook logbook = Logbook.builder()
        .bodyFilter(JsonPathBodyFilters.jsonPath("$[*].id").replace("*****"))
        .bodyFilter(JsonPathBodyFilters.jsonPath("$[*].username").replace("*****"))
        .build();
```

各種設定の詳細は [LogbookのREADME](https://github.com/zalando/logbook/blob/main/README.md) を参照。

<details>
<summary>keywords</summary>

Logbook.builder, BodyFilter, JsonPathBodyFilters, condition, Filtering, jsonPath, replace, ボディマスク処理, Logbook設定

</details>

## JAX-RSクライアントにLogbookを登録

`LogbookClientFilter` クラスを使用してJAX-RSクライアントにLogbookを登録する:

```java
Client client = ClientBuilder.newClient()
                  .register(new LogbookClientFilter(logbook));
```

<details>
<summary>keywords</summary>

LogbookClientFilter, ClientBuilder, JAX-RSクライアント登録, register

</details>

## リクエスト/レスポンスのログを出力

Logbookを登録したJAX-RSクライアントでリクエストを送信するとログが出力される:

```java
Response response = client.target("http://localhost:3000")
                      .path("/users")
                      .request()
                      .get();
```

Nablarchのログ出力機能に設定したフォーマットで出力され、メッセージ部分のみLogbookのフォーマット（メッセージ種類、ヘッダ、ボディ）で出力される。

リクエストのログ出力例:

```
2023-05-11 09:38:06.438 -TRACE- org.zalando.logbook.Logbook [202305110938060580001] boot_proc = [] proc_sys = [jaxrs] req_id = [/logbook/get] usr_id = [guest] Outgoing Request: bb068bcf35bc5226
Remote: localhost
GET http://localhost:3000/users HTTP/1.1
```

レスポンスのログ出力例（HTTPヘッダとボディが含まれる）:

```
2023-05-11 09:38:06.496 -TRACE- org.zalando.logbook.Logbook [202305110938060580001] boot_proc = [] proc_sys = [jaxrs] req_id = [/logbook/get] usr_id = [guest] Incoming Response: bb068bcf35bc5226
Duration: 57 ms
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 213
Content-Type: application/json; charset=utf-8
Date: Thu, 11 May 2023 00:38:06 GMT
Keep-Alive: timeout=5

[{"id":"81b8b153-5ed5-4d42-be13-346f257b368d","username":"Chasity91"},{"id":"6b1e7b91-6a1f-4424-be3c-4e3d28dd59c0","username":"Felton_Rohan"},{"id":"622677a4-04e3-4b70-85dd-a0b7f7161678","username":"Bella_Purdy"}]
```

:ref:`logbook_settings` のマスク設定（配列内の `id` と `username` をマスク）が有効な場合、ボディの該当項目が `*****` に変換されて出力される:

```
2023-05-11 09:48:37.513 -TRACE- org.zalando.logbook.Logbook [202305110948374650002] boot_proc = [] proc_sys = [jaxrs] req_id = [/logbook/get/mask] usr_id = [guest] Incoming Response: e1ba3d95197a4539
Duration: 9 ms
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 213
Content-Type: application/json; charset=utf-8
Date: Thu, 11 May 2023 00:48:37 GMT
Keep-Alive: timeout=5

[{"id":"*****","username":"*****"},{"id":"*****","username":"*****"},{"id":"*****","username":"*****"}]
```

<details>
<summary>keywords</summary>

Outgoing Request, Incoming Response, Remote, Duration, ログフォーマット, マスク出力, 標準出力ログ例, HTTPヘッダ, レスポンスボディ

</details>
