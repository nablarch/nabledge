# Logbookを用いたリクエスト/レスポンスログ出力サンプル

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/biz_samples/13/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/StandardOutputLogWriter.html)

## 提供パッケージ

**パッケージ**: `please.change.me.common.log.logbook`

**ソースコード**: [nablarch-biz-sample-all (v5-main)](https://github.com/nablarch/nablarch-biz-sample-all/tree/v5-main)

<details>
<summary>keywords</summary>

提供パッケージ, ソースコード, please.change.me.common.log.logbook, nablarch-biz-sample-all, biz-sample

</details>

## 概要

LogbookによるHTTPリクエスト/レスポンスのログ出力サンプル。

> **重要**: LogbookはJava 11以上が必要。

本サンプルの実装範囲:
- Logbookのログ出力に [SLF4Jアダプタ](../../component/adapters/adapters-slf4j_adaptor.md) を使用してNablarchログ機能と連携。ログは標準出力に出力
- リクエスト送信はJAX-RSクライアント（Jersey）を使用、メッセージ形式はJSON
- [JsonPath](https://github.com/json-path/JsonPath)を使用してJSON形式の特定項目にマスク処理

<details>
<summary>keywords</summary>

Logbook, HTTPリクエストログ, HTTPレスポンスログ, SLF4Jアダプタ, JAX-RSクライアント, Jersey, JsonPath, マスク処理, Java 11

</details>

## 依存ライブラリの追加

Logbook、Jersey、SLF4Jアダプタを使用可能にするため、プロジェクトの依存関係設定に以下の依存関係を追加する。

```xml
<dependencies>
  ...
  <!-- SLF4Jアダプタ -->
  <dependency>
    <groupId>com.nablarch.integration</groupId>
    <artifactId>slf4j-nablarch-adaptor</artifactId>
    <scope>runtime</scope>
  </dependency>

  <!-- Logbook -->
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-core</artifactId>
    <version>2.16.0</version>
  </dependency>
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-jaxrs</artifactId>
    <version>2.16.0</version>
  </dependency>
  <dependency>
    <groupId>org.zalando</groupId>
    <artifactId>logbook-json</artifactId>
    <version>2.16.0</version>
  </dependency>

  <!-- Jersey -->
  <dependency>
    <groupId>org.glassfish.jersey.core</groupId>
    <artifactId>jersey-client</artifactId>
    <version>2.35</version>
  </dependency>
  <dependency>
    <groupId>org.glassfish.jersey.media</groupId>
    <artifactId>jersey-media-json-jackson</artifactId>
    <version>2.35</version>
  </dependency>
  <dependency>
    <groupId>org.glassfish.jersey.inject</groupId>
    <artifactId>jersey-hk2</artifactId>
    <version>2.35</version>
  </dependency>
  ...
</dependencies>
```

> **補足**: JerseyはJAX-RSアダプタが使用しているJacksonのバージョンを考慮したバージョンを使用。依存関係のバージョンは実行環境に合わせて設定すること。

<details>
<summary>keywords</summary>

依存ライブラリ, logbook-core, logbook-jaxrs, logbook-json, jersey-client, jersey-media-json-jackson, jersey-hk2, slf4j-nablarch-adaptor

</details>

## log.propertiesの設定

Nablarchのログ出力機能でLogbookのログを出力するため、**log.properties** に以下の設定を行う。LogbookはTRACEレベルでログ出力するため、Logbook専用ロガーを定義することを推奨。

```properties
# 標準出力
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter
writer.stdout.formatter.className=nablarch.core.log.basic.BasicLogFormatter
writer.stdout.formatter.format=$date$ -$logLevel$- $runtimeLoggerName$ [$executionId$] boot_proc = [$bootProcess$] proc_sys = [$processingSystem$] req_id = [$requestId$] usr_id = [$userId$] $message$$information$$stackTrace$

# 利用可能なロガー名順序
availableLoggersNamesOrder=DEV,PER,SQL,MON,ACC,LOGBOOK,ROO

# Logbookの設定
loggers.LOGBOOK.nameRegex=org\.zalando\.logbook\..*
loggers.LOGBOOK.level=TRACE
loggers.LOGBOOK.writerNames=stdout
```

Nablarchのログ出力設定については、 [log-basic_setting](../../component/libraries/libraries-log.md) を参照。

<details>
<summary>keywords</summary>

log.properties設定, StandardOutputLogWriter, BasicLogFormatter, TRACEレベル, ログ出力設定, LOGBOOK, availableLoggersNamesOrder

</details>

## Logbookの構成

Logbookを使用するには、必要な設定を行った Logbook クラスのインスタンスを生成する。デフォルト設定ではすべてのリクエスト/レスポンスのボディを含む情報が出力される。BodyFilterでマスク処理を設定可能。

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

各種設定の詳細については、[LogbookのREADME](https://github.com/zalando/logbook/blob/main/README.md)を参照。

<details>
<summary>keywords</summary>

Logbook構成, BodyFilter, jsonPath, JsonPathBodyFilters, マスク処理設定

</details>

## JAX-RSクライアントにLogbookを登録

生成した Logbook インスタンスは使用するクライアントに登録することで使用できる。JAX-RSクライアントを使用する場合は `LogbookClientFilter` クラスを使用する。

```java
Client client = ClientBuilder.newClient()
                  .register(new LogbookClientFilter(logbook));
```

<details>
<summary>keywords</summary>

LogbookClientFilter, JAX-RSクライアント登録, ClientBuilder

</details>

## リクエスト/レスポンスのログを出力

Logbookを登録したJAX-RSクライアントでリクエスト送信/レスポンス受信するとログが出力される。Nablarchログ出力機能のフォーマットで出力され、メッセージ部分のみLogbookのフォーマット（メッセージ種別・ヘッダ・ボディ）で出力される。

```java
Response response = client.target("http://localhost:3000")
                      .path("/users")
                      .request()
                      .get();
```

出力例（リクエスト）:
```text
2023-05-11 09:38:06.438 -TRACE- org.zalando.logbook.Logbook [202305110938060580001] boot_proc = [] proc_sys = [jaxrs] req_id = [/logbook/get] usr_id = [guest] Outgoing Request: bb068bcf35bc5226
Remote: localhost
GET http://localhost:3000/users HTTP/1.1
```

出力例（レスポンス）:
```text
2023-05-11 09:38:06.496 -TRACE- org.zalando.logbook.Logbook [202305110938060580001] boot_proc = [] proc_sys = [jaxrs] req_id = [/logbook/get] usr_id = [guest] Incoming Response: bb068bcf35bc5226
Duration: 57 ms
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

[{"id":"81b8b153-5ed5-4d42-be13-346f257b368d","username":"Chasity91"},...]
```

マスク処理設定時のレスポンスボディ:
```text
[{"id":"*****","username":"*****"},{"id":"*****","username":"*****"},{"id":"*****","username":"*****"}]
```

<details>
<summary>keywords</summary>

ログ出力, リクエストログ, レスポンスログ, Outgoing Request, Incoming Response

</details>
