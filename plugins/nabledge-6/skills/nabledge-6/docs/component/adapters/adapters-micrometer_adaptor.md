# Micrometerアダプタ

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-micrometer-adaptor</artifactId>
</dependency>
```

> **補足**: Micrometer 1.13.0でテスト済み。バージョンを変更する場合はプロジェクト側でテストを行い問題ないことを確認すること。

## Micrometerアダプタを使用するための設定を行う

レジストリを :ref:`repository` に登録するための `ComponentFactory` を使用してメトリクス収集を設定する。

> **補足**: `LoggingMeterRegistry` は、SLF4J または Java Util Logging を使ってメトリクスをログに出力する機能を提供する。特に設定をしていない場合は、Java Util Logging を使って標準出力にメトリクスが出力されるため、簡単な動作確認をするのに適している。他のレジストリは連携先のサービスの準備や、収集したメトリクスを出力する実装を作りこむなどの手間がかかる。このため、まず最も簡単に動作を確認できる `LoggingMeterRegistry` を使用して設定方法を説明する。

### DefaultMeterBinderListProviderをコンポーネントとして宣言する

`DefaultMeterBinderListProvider` はJVMのメモリ使用量やCPU使用率などのメトリクスを収集する `MeterBinder` のリストを提供するクラス。よく使用するメトリクスの収集はMicrometerが提供する `MeterBinder` 実装クラスとしてあらかじめ用意されている（例：JVMのメモリ使用量は `JvmMemoryMetrics`、CPU使用率は `ProcessorMetrics`）。`src/main/resources/web-component-configuration.xml` に以下を追加する:

```xml
<component name="meterBinderListProvider"
           class="nablarch.integration.micrometer.DefaultMeterBinderListProvider" />
```

収集されるメトリクスの詳細は :ref:`micrometer_default_metrics` を参照。

### DefaultMeterBinderListProviderを廃棄処理対象にする

`DefaultMeterBinderListProvider` は廃棄処理が必要なコンポーネント。`BasicApplicationDisposer` の `disposableList` に追加する（:ref:`repository-dispose_object` 参照）。

```xml
<component name="disposer"
    class="nablarch.core.repository.disposal.BasicApplicationDisposer">
  <property name="disposableList">
    <list>
      <component-ref name="meterBinderListProvider"/>
    </list>
  </property>
</component>
```

### レジストリのファクトリクラスをコンポーネントとして宣言する

使用するレジストリごとのファクトリクラスをコンポーネントとして宣言する。`meterBinderListProvider` と `applicationDisposer` の2つのプロパティを設定する。ファクトリクラス一覧は :ref:`micrometer_registry_factory` を参照。

```xml
<component class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

### 設定ファイルを作成する

`src/main/resources/micrometer.properties` を作成する。

```properties
# 5秒ごとにメトリクスを出力（デフォルトは1分）
nablarch.micrometer.logging.step=5s
# step指定時間より早くアプリケーションが終了しても廃棄処理でログを出力
nablarch.micrometer.logging.logInactive=true
```

> **重要**: `micrometer.properties` は内容が空であっても必ず配置しなければならない。

## 実行結果

`LoggingMeterRegistry` を用いたメトリクス収集の設定完了後、アプリケーションを起動すると以下のように収集されたメトリクスが標準出力に出力されていることを確認できる。

```text
2020-09-04 15:33:40.689 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.gc.count{memory.manager.name=PS Scavenge} throughput=2.6/s
2020-09-04 15:33:40.690 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.gc.count{memory.manager.name=PS MarkSweep} throughput=0.4/s
2020-09-04 15:33:40.691 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.buffer.count{id=mapped} value=0 buffers
2020-09-04 15:33:40.691 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.buffer.count{id=direct} value=2 buffers
2020-09-04 15:33:40.692 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.buffer.memory.used{id=direct} value=124 KiB
2020-09-04 15:33:40.693 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.classes.loaded{} value=9932 classes
2020-09-04 15:33:40.694 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.memory.committed{area=heap,id=PS Old Gen} value=182.5 MiB
2020-09-04 15:33:40.697 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.memory.used{area=heap,id=PS Old Gen} value=69.320663 MiB
2020-09-04 15:33:40.698 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.threads.live{} value=29 threads
2020-09-04 15:33:41.199 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.cpu.usage{} value=0.111672
2020-09-04 15:33:41.200 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.count{} value=8
2020-09-04 15:33:41.200 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.usage{} value=0.394545
```

## レジストリファクトリ

| レジストリ | ファクトリクラス | 提供バージョン |
|---|---|---|
| SimpleMeterRegistry | `SimpleMeterRegistryFactory` | 1.0.0以上 |
| LoggingMeterRegistry | `LoggingMeterRegistryFactory` | 1.0.0以上 |
| CloudWatchMeterRegistry | `CloudWatchMeterRegistryFactory` | 1.0.0以上 |
| DatadogMeterRegistry | `DatadogMeterRegistryFactory` | 1.0.0以上 |
| StatsdMeterRegistry | `StatsdMeterRegistryFactory` | 1.0.0以上 |
| OtlpMeterRegistry | `OtlpMeterRegistryFactory` | 1.3.0以上 |

## 設定ファイル

### 配置場所

クラスパス直下に `micrometer.properties` という名前で配置する。

### フォーマット

```
nablarch.micrometer.<subPrefix>.<key>=設定する値
```

`<subPrefix>` はレジストリファクトリごとに以下の値を使用する:

| レジストリファクトリ | subPrefix |
|---|---|
| `SimpleMeterRegistryFactory` | `simple` |
| `LoggingMeterRegistryFactory` | `logging` |
| `CloudWatchMeterRegistryFactory` | `cloudwatch` |
| `DatadogMeterRegistryFactory` | `datadog` |
| `StatsdMeterRegistryFactory` | `statsd` |
| `OtlpMeterRegistryFactory` | `otlp` |

`<key>` にはMicrometerがレジストリごとに提供する[設定クラス](https://javadoc.io/doc/io.micrometer/micrometer-core/1.13.0/io/micrometer/core/instrument/config/MeterRegistryConfig.html)（`MeterRegistryConfig`）で定義されたメソッド名を指定する。例えば、`DatadogMeterRegistry` に対しては `DatadogConfig` という設定クラスが用意されており、[`DatadogConfig#apiKey()`](https://javadoc.io/doc/io.micrometer/micrometer-registry-datadog/1.13.0/io/micrometer/datadog/DatadogConfig.html#apiKey()) に対応して `nablarch.micrometer.datadog.apiKey=XXXX` と記述する。

### OS環境変数・システムプロパティで上書きする

設定値の優先度（高→低）:
1. システムプロパティ
2. OS環境変数
3. `micrometer.properties` の設定値

例えば、次のような条件で設定したとする。

**micrometer.properties**:
```text
nablarch.micrometer.example.one=PROPERTIES
nablarch.micrometer.example.two=PROPERTIES
nablarch.micrometer.example.three=PROPERTIES
```

**OS環境変数**:
```text
$ export NABLARCH_MICROMETER_EXAMPLE_TWO=OS_ENV
$ export NABLARCH_MICROMETER_EXAMPLE_THREE=OS_ENV
```

**システムプロパティ**:
```text
-Dnablarch.micrometer.example.three=SYSTEM_PROP
```

この場合、それぞれの設定値は最終的に次の値が採用される:

| key | 採用される値 |
|---|---|
| `one` | `PROPERTIES` |
| `two` | `OS_ENV` |
| `three` | `SYSTEM_PROP` |

OS環境変数での命名規則は :ref:`OS環境変数の名前について <repository-overwrite_environment_configuration_by_os_env_var_naming_rule>` を参照。

### 設定のプレフィックスを変更する

各レジストリファクトリの `prefix` プロパティを指定することで、設定プレフィックス（`nablarch.micrometer.<subPrefix>`）を変更できる。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="prefix" value="sample.prefix" />
</component>
```

この場合、`micrometer.properties` では `sample.prefix.step=10s` のように設定する。

### 設定ファイルの場所を変更する

`xmlConfigPath` プロパティに設定ファイルを読み込むXMLファイルのパスを指定することで変更できる。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="xmlConfigPath" value="config/metrics.xml" />
</component>
```

`xmlConfigPath` で指定したXMLファイルにコンポーネント設定ファイルと同じ書式で設定ファイルのパスを記述する（例: `<config-file file="config/metrics.properties" />`）。このXMLでコンポーネントを定義してもシステムリポジトリから参照取得はできない。

## Datadog と連携する

## 依存関係を追加する

```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-datadog</artifactId>
  <version>1.13.0</version>
</dependency>
```

## レジストリファクトリを宣言する

**クラス**: `nablarch.integration.micrometer.datadog.DatadogMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.datadog.DatadogMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

## micrometer.properties での設定

- APIキー: `nablarch.micrometer.datadog.apiKey=XXXXXXXXXXXXXXXX`
- サイトURL: `nablarch.micrometer.datadog.uri=<サイトURL>`
- 連携無効化: `nablarch.micrometer.datadog.enabled=false`（環境変数で上書き可能。本番環境のみ `true` に上書きして有効化可能）

その他の設定については `DatadogConfig`（外部サイト、英語）を参照。

> **重要**: 連携を無効にした場合も、`nablarch.micrometer.datadog.apiKey` には何らかの値（ダミー可）を設定しておく必要がある。

Datadog と連携するには、以下の手順で設定する。

**依存関係の追加:**
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-datadog</artifactId>
  <version>1.13.0</version>
</dependency>
```

**レジストリファクトリの宣言:**
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.datadog.DatadogMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

**APIキーの設定:**
```
nablarch.micrometer.datadog.apiKey=XXXXXXXXXXXXXXXX
```
APIキーは `nablarch.micrometer.datadog.apiKey` で設定できる。

**サイトURLの設定:**
```
nablarch.micrometer.datadog.uri=<サイトURL>
```
サイトURLは `nablarch.micrometer.datadog.uri` で設定できる。

**連携を無効にする:**
```
nablarch.micrometer.datadog.enabled=false
nablarch.micrometer.datadog.apiKey=XXXXXXXXXXXXXXXX
```
`micrometer.properties` で `nablarch.micrometer.datadog.enabled` に `false` を設定することで、メトリクスの連携を無効にできる。この設定は環境変数で上書きできるので、本番環境のみ環境変数で `true` に上書きして連携を有効にできる。

**重要:** 連携を無効にした場合も、`nablarch.micrometer.datadog.apiKey` には何らかの値を設定しておく必要がある。値はダミーで問題ない。

## CloudWatch と連携する

## 依存関係を追加する

```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-cloudwatch2</artifactId>
  <version>1.13.0</version>
</dependency>
```

## レジストリファクトリを宣言する

**クラス**: `nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

## リージョン・アクセスキーの設定

リージョンやアクセスキーなどの設定は AWS SDK の方法に準拠する。

```bash
export AWS_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYYYYYY
```

詳細は [AWSのドキュメント](https://docs.aws.amazon.com/ja_jp/sdk-for-java/v1/developer-guide/setup-credentials.html) を参照。

名前空間設定: `nablarch.micrometer.cloudwatch.namespace=test`

その他の設定については `CloudWatchConfig`（外部サイト、英語）を参照。

## より詳細な設定（カスタムプロバイダ）

OS環境変数や設定ファイルでは指定できない、より詳細な設定が必要な場合は、`CloudWatchAsyncClientProvider` を実装したカスタムプロバイダを作成することで対応できる。

`CloudWatchAsyncClientProvider` は `CloudWatchAsyncClient` を提供する `provide()` メソッドを持つ。カスタムプロバイダでは、任意の設定を行った `CloudWatchAsyncClient` を構築して返すように `provide()` メソッドを実装する。

```java
package example.micrometer.cloudwatch;

import nablarch.integration.micrometer.cloudwatch.CloudWatchAsyncClientProvider;
import software.amazon.awssdk.services.cloudwatch.CloudWatchAsyncClient;

public class CustomCloudWatchAsyncClientProvider implements CloudWatchAsyncClientProvider {
    @Override
    public CloudWatchAsyncClient provide() {
        return CloudWatchAsyncClient
                .builder()
                .asyncConfiguration(...) // 任意の設定を行う
                .build();
    }
}
```

作成したカスタムプロバイダは、`CloudWatchMeterRegistryFactory` の `cloudWatchAsyncClientProvider` プロパティに設定する。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <!-- cloudWatchAsyncClientProvider プロパティにカスタムプロバイダを設定する -->
  <property name="cloudWatchAsyncClientProvider">
    <component class="example.micrometer.cloudwatch.CustomCloudWatchAsyncClientProvider" />
  </property>
</component>
```

これにより、カスタムプロバイダが生成した `CloudWatchAsyncClient` がメトリクスの連携で使用されるようになる。

> **補足**: デフォルトでは、[CloudWatchAsyncClient.create()](https://javadoc.io/static/software.amazon.awssdk/cloudwatch/2.13.4/software/amazon/awssdk/services/cloudwatch/CloudWatchAsyncClient.html#create--) で作成されたインスタンスが使用される。

## 連携を無効にする

```text
nablarch.micrometer.cloudwatch.enabled=false
nablarch.micrometer.cloudwatch.namespace=test
```

`micrometer.properties` で `nablarch.micrometer.cloudwatch.enabled` に `false` を設定することで無効にできる。環境変数で上書き可能。

> **重要**: 連携を無効にした場合も、`nablarch.micrometer.cloudwatch.namespace` には何らかの値（ダミー可）を設定しておく必要がある。また、環境変数 `AWS_REGION` も設定しておく必要がある（ダミー可）。

CloudWatch と連携するには、以下の手順で設定する。

**依存関係の追加:**
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-cloudwatch2</artifactId>
  <version>1.13.0</version>
</dependency>
```

**レジストリファクトリの宣言:**
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

**リージョンやアクセスキーの設定:**
```bash
$ export AWS_REGION=ap-northeast-1
$ export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXX
$ export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYYYYYY
```
`micrometer-registry-cloudwatch2` モジュールは AWS SDK を使用している。したがって、リージョンやアクセスキーなどの設定は AWS SDK の方法に準拠する。

**名前空間の設定:**
```
nablarch.micrometer.cloudwatch.namespace=test
```
メトリクスのカスタム名前空間は `nablarch.micrometer.cloudwatch.namespace` で設定できる。

**カスタムプロバイダによる詳細設定:**
OS環境変数や設定ファイルでは指定できない詳細な設定が必要な場合は、`CloudWatchAsyncClientProvider` を実装したカスタムプロバイダを作ることで対応できる。

```java
public class CustomCloudWatchAsyncClientProvider implements CloudWatchAsyncClientProvider {
    @Override
    public CloudWatchAsyncClient provide() {
        return CloudWatchAsyncClient
                .builder()
                .asyncConfiguration(...) // 任意の設定を行う
                .build();
    }
}
```

カスタムプロバイダは `CloudWatchMeterRegistryFactory` の `cloudWatchAsyncClientProvider` プロパティに設定する:
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="cloudWatchAsyncClientProvider">
    <component class="example.micrometer.cloudwatch.CustomCloudWatchAsyncClientProvider" />
  </property>
</component>
```

デフォルトでは、`CloudWatchAsyncClient.create()` で作成されたインスタンスが使用される。カスタムプロバイダを設定することで、任意の設定を行った `CloudWatchAsyncClient` をメトリクスの連携で使用できるようになる。

**連携を無効にする:**
```
nablarch.micrometer.cloudwatch.enabled=false
nablarch.micrometer.cloudwatch.namespace=test
```
`micrometer.properties` で `nablarch.micrometer.cloudwatch.enabled` に `false` を設定することで、メトリクスの連携を無効にできる。

**重要:** 連携を無効にした場合も、`nablarch.micrometer.cloudwatch.namespace` には何らかの値を設定しておく必要がある。また、環境変数 `AWS_REGION` を設定しておく必要がある。いずれも、値はダミーで問題ない。

## Azure と連携する

Azure は Java 3.0 エージェントを用いて Micrometer の[グローバルレジストリ](https://docs.micrometer.io/micrometer/reference/concepts/registry.html#_global_registry)に出力したメトリクスを自動的に収集し、Azureに連携する仕組みを提供している。

> **重要**: Java 3.0 エージェントは初期化処理中に大量のjarファイルをロードするため、初期化中はGCが頻発することがある。アプリケーション起動後しばらくは性能が一時的に劣化する可能性がある。また、高負荷時はエージェント処理によるオーバーヘッドが性能に影響する可能性があるため、性能試験では本番同様にJava 3.0 エージェントを導入して想定内の性能になることを確認すること。

## MicrometerアダプタでAzureに連携するための設定

1. アプリケーション起動オプションにJava 3.0 エージェントを追加する（[Azureのドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/opentelemetry-enable?tabs=java#modify-your-application)参照）
2. `MeterRegistry` にグローバルレジストリを使うコンポーネントを定義する

**クラス**: `nablarch.integration.micrometer.GlobalMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.GlobalMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

> **補足**: この方法ではAzure用の `MeterRegistry` を使用しないため、Azure用モジュールを依存関係に追加しなくてもメトリクスを連携できる。

Java 3.0 エージェントの設定方法は :ref:`azure_distributed_tracing` を参照。

## 詳細設定について

メトリクス連携に関する設定はすべてJava 3.0 エージェントが提供する方法で行う。詳細は[構成オプション](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/java-standalone-config)を参照。

> **重要**: `micrometer.properties` はAzure連携の設定には使用できないが、ファイル自体は配置しておく必要がある（内容は空で構わない）。

## 連携を無効にする

Java 3.0 エージェントを使用せずにアプリケーションを起動することで、メトリクスの連携を無効にできる。

AzureへのMicrometer連携は、Azureが提供する **Java 3.0 エージェント** を経由して行う。

**仕組み:**
Java 3.0 エージェントは、Micrometerの「グローバルレジストリ」に出力したメトリクスを自動的に収集し、Azureに連携する。

**設定手順:**
1. アプリケーションの起動オプションに Java 3.0 エージェントを追加する（Azureのドキュメント参照）
2. `MeterRegistry` にグローバルレジストリを使うようにコンポーネントを定義する

**レジストリファクトリの宣言（グローバルレジストリ）:**
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.GlobalMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```
この設定により、メトリクスの収集はグローバルレジストリによって行われ、Java 3.0 エージェントによってAzureに連携される。

**Azure用モジュール不要:** Java 3.0 エージェントを使うこの方法では、Azure用の `MeterRegistry` は使用しない。したがって、Azure用のモジュールを依存関係に追加しなくてもメトリクスを連携できる。

**重要（パフォーマンス警告）:** Java 3.0 エージェントは、初期化処理中に大量のjarファイルをロードする。これにより、初期化処理中はGCが頻発することがある。アプリケーション起動後しばらくは、GCの影響により性能が一時的に劣化する可能性がある。また、高負荷時はエージェントの処理によるオーバーヘッドが性能に影響を与える可能性がある。したがって、**性能試験では本番同様に Java 3.0 エージェントを導入し、想定内の性能になることを確認すること。**

**重要（設定ファイルの制約）:** 本アダプタ用の設定ファイルである `micrometer.properties` は使用できないが、**ファイルは配置しておく必要がある**（内容は空で構わない）。

**連携を無効にする:** Java 3.0 エージェントを使用せずにアプリケーションを起動することで、メトリクスの連携を無効にできる。

## StatsD で連携する

Datadog は [DogStatsD](https://docs.datadoghq.com/ja/developers/dogstatsd/?tab=hostagent) という [StatsD](https://github.com/statsd/statsd) プロトコルを使った連携をサポートしている。`micrometer-registry-statsd` モジュールを用いることで、StatsD で Datadog と連携できる。

DogStatsD のインストール方法などについては [Datadogのサイト](https://docs.datadoghq.com/ja/agent/) を参照。

## 依存関係を追加する

```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-statsd</artifactId>
  <version>1.13.0</version>
</dependency>
```

## レジストリファクトリを宣言する

**クラス**: `nablarch.integration.micrometer.statsd.StatsdMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.statsd.StatsdMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

## 設定ファイル

デフォルト値は DogStatsD をデフォルト構成でインストールした場合と一致するため、デフォルト構成の場合は設定不要。デフォルト構成以外でインストールしている場合は `StatsdConfig`（外部サイト、英語）を参照して実際の環境に合わせた設定を行うこと。

```text
# ポートを変更
nablarch.micrometer.statsd.port=9999
```

## 連携を無効にする

```text
nablarch.micrometer.statsd.enabled=false
```

`micrometer.properties` で `nablarch.micrometer.statsd.enabled` に `false` を設定することで無効にできる。環境変数で上書き可能。

StatsD プロトコルを使って監視サービスと連携できる。DatadogはDogStatsDというStatsDプロトコルを使った連携をサポートしており、`micrometer-registry-statsd` モジュールを用いることでDatadogとStatsD連携できる。

**依存関係の追加:**
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-statsd</artifactId>
  <version>1.13.0</version>
</dependency>
```

**レジストリファクトリの宣言:**
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.statsd.StatsdMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

**設定について:**
StatsD デーモンと連携するための設定は、デフォルト値が DogStatsD をデフォルト構成でインストールした場合と一致するように調整されている。したがって、DogStatsD をデフォルトの構成でインストールしている場合は、特に設定を明示しなくても DogStatsD による連携が動作する。

デフォルト構成以外でインストールしている場合は `StatsdConfig` を参照して実際の環境に合わせた設定を行うこと。

```
# ポートを変更
nablarch.micrometer.statsd.port=9999
```

**連携を無効にする:**
```
nablarch.micrometer.statsd.enabled=false
```
`micrometer.properties` で `nablarch.micrometer.statsd.enabled` に `false` を設定することで、メトリクスの連携を無効にできる。この設定は環境変数で上書きできるので、本番環境のみ環境変数で `true` に上書きして連携を有効にできる。

## OpenTelemetry Protocol (OTLP) で連携する

多くの監視サービスがOTLPをサポートしており、`micrometer-registry-otlp` モジュールで様々な監視サービスと連携できる。

> **重要**: OTLPでの連携方法が適しているか（利用可能か）は監視サービスによって異なるため、使用する監視サービスの情報を確認すること。（例: [Datadog](https://docs.datadoghq.com/ja/opentelemetry/)、[New Relic](https://docs.newrelic.com/jp/docs/opentelemetry/opentelemetry-introduction)、[Prometheus](https://prometheus.io/docs/prometheus/latest/querying/api/#otlp-receiver)）

## 依存関係を追加する

```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-otlp</artifactId>
  <version>1.13.0</version>
</dependency>
```

## レジストリファクトリを宣言する

**クラス**: `nablarch.integration.micrometer.otlp.OtlpMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.otlp.OtlpMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

## micrometer.properties での設定

- 送信先URL: `nablarch.micrometer.otlp.url=http://localhost:9090/api/v1/otlp/v1/metrics`
- ヘッダ情報（認証APIキー等）: `nablarch.micrometer.otlp.headers=key1=value1,key2=value2`
- 連携無効化: `nablarch.micrometer.otlp.enabled=false`（環境変数で上書き可能）

OpenTelemetry Protocol (OTLP) を使って様々な監視サービスと連携できる。多くの監視サービスはOpenTelemetryをサポートしており、`micrometer-registry-otlp` モジュールを用いることで OTLP 経由で連携できる。

**重要:** OpenTelemetryによるメトリクスの収集では、どういった連携方法が適しているか（利用可能か）は監視サービスによって異なるため、使用する監視サービスの情報を確認すること。

**依存関係の追加:**
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-otlp</artifactId>
  <version>1.13.0</version>
</dependency>
```

**レジストリファクトリの宣言:**
```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.otlp.OtlpMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

**送信先URLの設定:**
```
# 送信先を変更
nablarch.micrometer.otlp.url=http://localhost:9090/api/v1/otlp/v1/metrics
```

**ヘッダ情報の設定:**
```
nablarch.micrometer.otlp.headers=key1=value1,key2=value2
```
認証で使用するAPIキー等のヘッダ情報が必要な場合、`nablarch.micrometer.otlp.headers` で設定できる。

**連携を無効にする:**
```
nablarch.micrometer.otlp.enabled=false
```
`micrometer.properties` で `nablarch.micrometer.otlp.enabled` に `false` を設定することで、メトリクスの連携を無効にできる。この設定は環境変数で上書きできるので、本番環境のみ環境変数で `true` に上書きして連携を有効にできる。

## サーバ起動時に出力される警告ログについて

**サーバ起動時に出力される警告ログについて**

Micrometerが監視サービスにメトリクスを連携する方法には、大きく次の２つの方法がある。

| 方式 | 説明 | 代表例 |
|---|---|---|
| Client pushes | 一定間隔でアプリケーションが監視サービスにメトリクスを送信する | Datadog, CloudWatch など |
| Server polls | 一定間隔で監視サービスがアプリケーションにメトリクスを問い合わせに来る | Prometheus など |

**警告ログが発生する条件:**

Client pushes型の場合、`MeterRegistry`はコンポーネント生成後すぐに一定間隔でメトリクスの送信を開始する。一方、HikariCPのコネクションプールは最初のDBアクセス時に初めて生成される仕様となっている。

このため、最初のDBアクセスが発生する前にメトリクスの送信が実行されると、`JmxGaugeMetrics`は存在しないコネクションプールのMBeanを参照することになり、Micrometerが警告ログを出力する。

> **注意**: Server polls型（Prometheusなど）の場合は監視サービス側がアプリケーションに問い合わせに来るため、この問題は発生しない。

プール未生成時のメトリクス値は`NaN`となる。

```
24-Dec-2020 17:01:31.443 情報 [logging-metrics-publisher] io.micrometer.core.instrument.logging.LoggingMeterRegistry.lambda$publish$3 db.pool.active{} value=NaN
24-Dec-2020 17:01:31.443 情報 [logging-metrics-publisher] io.micrometer.core.instrument.logging.LoggingMeterRegistry.lambda$publish$3 db.pool.total{} value=NaN
```

この警告ログは最初の一度だけ出力され、2回目以降は抑制される。実害はないため無視して問題ない。

**警告ログを抑制する方法:**

警告ログを抑制したい場合は、`DefaultMeterBinderListProvider`に`Initializable`を実装し、`initialize()`メソッド内でDBに接続する。

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider implements Initializable {
    private static final Logger LOGGER = LoggerManager.get(CustomMeterBinderListProvider.class);
    private DataSource dataSource;

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void initialize() {
        try (Connection con = dataSource.getConnection()) {
            // 初期化時にコネクションを確立してMBeanが取れないことによる警告ログ出力を抑制
        } catch (SQLException e) {
            LOGGER.logWarn("Failed initial connection.", e);
        }
    }
}
```

コンポーネント定義で`DataSource`をプロパティで渡し、初期化対象コンポーネント一覧に追加する:

```xml
<component name="meterBinderListProvider"
           class="example.micrometer.CustomMeterBinderListProvider">
  <property name="dataSource" ref="dataSource" />
</component>

<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="meterBinderListProvider" />
    </list>
  </property>
</component>
```

> **注意**: メトリクスの送信間隔はデフォルト1分。送信間隔を非常に短く設定した場合、システムリポジトリ初期化前にメトリクスが送信されて警告ログが出力される可能性がある。

## DefaultMeterBinderListProviderで収集されるメトリクス

`DefaultMeterBinderListProvider` が生成するMeterBinderリストに含まれるクラス:

- `JvmMemoryMetrics`
- `JvmGcMetrics`
- `JvmThreadMetrics`
- `ClassLoaderMetrics`
- `ProcessorMetrics`
- `FileDescriptorMetrics`
- `UptimeMetrics`
- `NablarchGcCountMetrics`

収集されるメトリクス:

| メトリクス名 | 説明 |
|---|---|
| `jvm.buffer.count` | バッファプール内のバッファの数 |
| `jvm.buffer.memory.used` | バッファプールの使用量 |
| `jvm.buffer.total.capacity` | バッファプールの合計容量 |
| `jvm.memory.used` | メモリプールのメモリ使用量 |
| `jvm.memory.committed` | メモリプールのコミットされたメモリ量 |
| `jvm.memory.max` | メモリプールの最大メモリ量 |
| `jvm.gc.max.data.size` | OLD領域の最大メモリ量 |
| `jvm.gc.live.data.size` | Full GC後のOLD領域のメモリ使用量 |
| `jvm.gc.memory.promoted` | GC前後で増加したOLD領域のメモリ使用量の増分 |
| `jvm.gc.memory.allocated` | 前回のGC後から今回のGCまでのYoung領域のメモリ使用量の増分 |
| `jvm.gc.concurrent.phase.time` | コンカレントフェーズの処理時間 |
| `jvm.gc.pause` | GCの一時停止に費やされた時間 |
| `jvm.threads.peak` | スレッド数のピーク数 |
| `jvm.threads.daemon` | 現在のデーモンスレッドの数 |
| `jvm.threads.live` | 現在の非デーモンスレッドの数 |
| `jvm.threads.states` | 現在のスレッドの状態ごとの数 |
| `jvm.classes.loaded` | 現在ロードされているクラスの数 |
| `jvm.classes.unloaded` | JVM起動からアンロードされたクラスの数 |
| `system.cpu.count` | JVMで使用できるプロセッサーの数 |
| `system.load.average.1m` | 最後の1分のシステム負荷平均（参考: [OperatingSystemMXBean](https://docs.oracle.com/javase/jp/17/docs/api/java.management/java/lang/management/OperatingSystemMXBean.html#getSystemLoadAverage())） |
| `system.cpu.usage` | システム全体の直近のCPU使用率 |
| `process.cpu.usage` | JVMの直近のCPU使用率 |
| `process.files.open` | 開いているファイルディスクリプタの数 |
| `process.files.max` | ファイルディスクリプタの最大数 |
| `process.uptime` | JVMの稼働時間 |
| `process.start.time` | JVMの起動時刻（UNIX時間） |
| `jvm.gc.count` | GCの回数 |
| `jvm.threads.started` | JVMで起動したスレッド数 |
| `process.cpu.time` | Java仮想マシン・プロセスによって使用されるCPU時間 |

## 共通のタグを設定する

`tags` プロパティで、全メトリクスに共通するタグを設定できる。ホスト、インスタンス、リージョンなどの識別情報の設定に使用できる。

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| tags | `Map<String, String>` | | | 全メトリクスに共通するタグ。マップのキー=タグ名、マップの値=タグ値 |

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="tags">
    <map>
      <entry key="foo" value="FOO" />
      <entry key="bar" value="BAR" />
    </map>
  </property>
</component>
```

上記設定の場合、収集されるメトリクスは次のようになる。

```text
（省略）
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.start.time{bar=BAR,foo=FOO} value=444224h 29m 38.875000064s
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.uptime{bar=BAR,foo=FOO} value=27.849s
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.count{bar=BAR,foo=FOO} value=8
2020-09-04 17:30:06.657 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.usage{bar=BAR,foo=FOO} value=0.475654
```

全てのメトリクスに、 `foo=FOO`、`bar=BAR` のタグが設定されていることが確認できる。

## 監視サービスと連携する（概要）

監視サービスと連携するためには、大きく次のとおり設定する必要がある。

1. 監視サービスや連携方法ごとに用意された Micrometer のモジュールを依存関係に追加する
2. 使用するレジストリファクトリをコンポーネントとして定義する
3. その他、監視サービスごとに独自に設定する

対応している監視サービス: Datadog、CloudWatch、Azure（Java 3.0 エージェント経由）、StatsD、OpenTelemetry Protocol (OTLP)

## アプリケーションの形式ごとに収集するメトリクスの例

## ウェブアプリケーションで収集するメトリクスの例

**HTTPリクエストの処理時間**: URLごとのアクセス数・処理時間確認。パーセンタイル計測で大部分のリクエスト処理時間の把握が可能。
実装: :ref:`micrometer_timer_metrics_handler`, :ref:`micrometer_timer_metrics_handler_percentiles`

**SQLの処理時間**: 各SQLの処理時間確認・遅延SQL検知。
実装: :ref:`micrometer_sql_time`

**ログレベルごとの出力回数**: 警告ログの異常検知（攻撃検知）・エラーログ検知。
実装: :ref:`micrometer_log_count`

**アプリケーションサーバ・ライブラリのリソース情報**: スレッドプール・DBコネクションプール等の状態を収集し障害時の原因特定に活用。多くのアプリケーションサーバはJMXのMBeanでリソース状態を公開。
実装: :ref:`micrometer_mbean_metrics`

## バッチアプリケーションで収集するメトリクスの例

**バッチの処理時間**: :ref:`micrometer_default_metrics` で収集される `process.uptime` で計測。平常時との乖離で異常を迅速検知。

**トランザクション単位の処理時間**: マルチスレッドバッチの処理分散状況確認・異常検知。
実装: :ref:`micrometer_adaptor_batch_transaction_time`

**バッチの処理件数**: 進捗・速度・処理件数の確認。
実装: :ref:`micrometer_batch_processed_count`

**SQLの処理時間**: 各SQLの処理時間確認・遅延SQL検知。
実装: :ref:`micrometer_sql_time`

**ログレベルごとの出力回数**: 警告ログ・エラーログの検知。
実装: :ref:`micrometer_log_count`

**ライブラリのリソース情報**: DBコネクションプール等の状態収集（障害時の原因特定に活用）。ライブラリによってはJMXのMBeanでリソース状態を公開。
実装: :ref:`micrometer_mbean_metrics`

## 処理時間を計測するハンドラ

`TimerMetricsHandler` をハンドラキューに設定すると、後続ハンドラの処理時間をメトリクスとして収集できる。

`HandlerMetricsMetaDataBuilder` インタフェースの実装クラスのインスタンスを設定する必要がある。収集したメトリクスに設定するメタ情報を構築する:
- `getMetricsName()`: メトリクスの名前を返す
- `getMetricsDescription()`: メトリクスの説明を返す
- `buildTagList(TData, ExecutionContext, TResult, Throwable)`: メトリクスに設定するタグの一覧を返す。後続ハンドラがスローした例外が渡される（例外がスローされていない場合は`null`）

`HandlerMetricsMetaDataBuilder`の実装例:

```java
import io.micrometer.core.instrument.Tag;
import nablarch.fw.ExecutionContext;
import nablarch.integration.micrometer.instrument.handler.HandlerMetricsMetaDataBuilder;

import java.util.Arrays;
import java.util.List;

public class CustomHandlerMetricsMetaDataBuilder<TData, TResult>
    implements HandlerMetricsMetaDataBuilder<TData, TResult> {

    @Override
    public String getMetricsName() {
        return "metrics.name";
    }

    @Override
    public String getMetricsDescription() {
        return "Description of this metrics.";
    }

    @Override
    public List<Tag> buildTagList(TData param, ExecutionContext executionContext, TResult tResult, Throwable thrownThrowable) {
        return Arrays.asList(Tag.of("foo", "FOO"), Tag.of("bar", "BAR"));
    }
}
```

```xml
<!-- ハンドラキュー構成 -->
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- 省略 -->
      <component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
        <property name="meterRegistry" ref="meterRegistry" />
        <property name="handlerMetricsMetaDataBuilder">
          <component class="xxx.CustomHandlerMetricsMetaDataBuilder" />
        </property>
      </component>
      <!-- 省略 -->
    </list>
  </property>
</component>
```

`meterRegistry`プロパティには、使用しているレジストリファクトリが生成したMeterRegistryを設定する。これにより、ここより後ろのハンドラの処理時間をメトリクスとして収集できるようになる。

Nablarchでは`HandlerMetricsMetaDataBuilder`の実装として :ref:`micrometer_adaptor_http_request_process_time_metrics` を提供している。

## パーセンタイルを収集する

以下のプロパティはデフォルトで全て未設定のため、パーセンタイルの情報は収集されない。収集する場合は明示的に設定すること。

| プロパティ名 | 説明 |
|---|---|
| `percentiles` | 収集するパーセンタイル値のリスト（例: 95パーセンタイルは`0.95`と指定） |
| `enablePercentileHistogram` | 収集したヒストグラムのバケットを監視サービスに連携するかどうかのフラグ。監視サービスがヒストグラムによるパーセンタイル計算をサポートしていない場合は無視される |
| `serviceLevelObjectives` | ヒストグラムに追加するバケット値のリスト（単位: ミリ秒、SLOに基づいて設定） |
| `minimumExpectedValue` | ヒストグラムバケットの最小値（単位: ミリ秒） |
| `maximumExpectedValue` | ヒストグラムバケットの最大値（単位: ミリ秒） |

```xml
<component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
  <property name="meterRegistry" ref="meterRegistry" />
  <property name="handlerMetricsMetaDataBuilder">
    <component class="nablarch.integration.micrometer.instrument.http.HttpRequestTimeMetricsMetaDataBuilder" />
  </property>
  <!-- 98, 90, 50 パーセンタイルを収集する -->
  <property name="percentiles">
    <list>
      <value>0.98</value>
      <value>0.90</value>
      <value>0.50</value>
    </list>
  </property>
  <!-- ヒストグラムバケットを監視サービスに連携する -->
  <property name="enablePercentileHistogram" value="true" />
  <!-- SLO として 1000ms, 1500ms を設定 -->
  <property name="serviceLevelObjectives">
    <list>
      <value>1000</value>
      <value>1500</value>
    </list>
  </property>
  <!-- バケットの最小値に 500 ms を設定 -->
  <property name="minimumExpectedValue" value="500" />
  <!-- バケットの最大値に 3000 ms を設定 -->
  <property name="maximumExpectedValue" value="3000" />
</component>
```

ヒストグラムバケットをサポートする`MeterRegistry`を使用した場合、上記設定により次のようなメトリクスが収集できるようになる:

```
http_server_requests_seconds{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",quantile="0.98",} 1.475346432
http_server_requests_seconds{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",quantile="0.9",} 1.408237568
http_server_requests_seconds{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",quantile="0.5",} 0.737148928
http_server_requests_seconds_bucket{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",le="0.5",} 9.0
http_server_requests_seconds_bucket{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",le="1.0",} 18.0
http_server_requests_seconds_bucket{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",le="1.5",} 32.0
http_server_requests_seconds_bucket{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",le="3.0",} 32.0
http_server_requests_seconds_bucket{class="com.nablarch.example.app.web.action.MetricsAction",exception="None",httpMethod="GET",method="index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext",outcome="SUCCESS",status="200",le="+Inf",} 32.0
```

> **補足**: 本アダプタで提供している`MeterRegistry`では`OtlpMeterRegistry`のみがヒストグラムバケットをサポートする。
>
> 例ではヒストグラムバケットの具体例を示すために`PrometheusMeterRegistry`を使用している（Prometheusは、ヒストグラムによるパーセンタイルの計算をサポートしている）。ただし、`PrometheusMeterRegistry`の`MeterRegistryFactory`は本アダプタでは提供していない。実際に`PrometheusMeterRegistry`を試したい場合は、以下のようなクラスを自前で用意すること。
>
> ```java
> package example.micrometer.prometheus;
>
> import io.micrometer.prometheusmetrics.PrometheusConfig;
> import io.micrometer.prometheusmetrics.PrometheusMeterRegistry;
> import nablarch.core.repository.di.DiContainer;
> import nablarch.integration.micrometer.MeterRegistryFactory;
> import nablarch.integration.micrometer.MicrometerConfiguration;
> import nablarch.integration.micrometer.NablarchMeterRegistryConfig;
>
> public class PrometheusMeterRegistryFactory extends MeterRegistryFactory<PrometheusMeterRegistry> {
>
>     @Override
>     protected PrometheusMeterRegistry createMeterRegistry(MicrometerConfiguration micrometerConfiguration) {
>         return new PrometheusMeterRegistry(new Config(prefix, micrometerConfiguration));
>     }
>
>     @Override
>     public PrometheusMeterRegistry createObject() {
>         return doCreateObject();
>     }
>
>     static class Config extends NablarchMeterRegistryConfig implements PrometheusConfig {
>
>         public Config(String prefix, DiContainer diContainer) {
>             super(prefix, diContainer);
>         }
>
>         @Override
>         protected String subPrefix() {
>             return "prometheus";
>         }
>     }
> }
> ```

## HTTPリクエストの処理時間を収集する

Nablarchによってあらかじめ用意されている`HandlerMetricsMetaDataBuilder`の実装クラス。

`HttpRequestTimeMetricsMetaDataBuilder` はHTTPリクエストの処理時間計測のためのメトリクスのメタ情報を構築する。メトリクス名は`http.server.requests`。

リクエスト全体の処理時間を計測するため、`TimerMetricsHandler`はハンドラキューの先頭に設定する。

タグ一覧:

| タグ名 | 説明 |
|---|---|
| `class` | リクエストを処理したアクションクラスの名前（`Class.getName()`）。取得できない場合は`UNKNOWN` |
| `method` | アクションクラスのメソッド名と引数の型名（`Class.getCanonicalName()`）をアンダースコアで連結した文字列（取得できない場合は`UNKNOWN`） |
| `httpMethod` | HTTPメソッド |
| `status` | HTTPステータスコード |
| `outcome` | ステータスコードの種類（1XX:`INFORMATION`, 2XX:`SUCCESS`, 3XX:`REDIRECTION`, 4XX:`CLIENT_ERROR`, 5XX:`SERVER_ERROR`, その他:`UNKNOWN`） |
| `exception` | スローされた例外の単純名（例外なしの場合は`None`） |

```xml
<!-- ハンドラキュー構成 -->
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- HTTPリクエストの処理時間のメトリクス収集ハンドラ -->
      <component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
        <!-- レジストリファクトリが生成する MeterRegistry を meterRegistry プロパティに設定する -->
        <property name="meterRegistry" ref="meterRegistry" />
        <!-- HttpRequestTimeMetricsMetaDataBuilder を handlerMetricsMetaDataBuilder に設定する -->
        <property name="handlerMetricsMetaDataBuilder">
          <component class="nablarch.integration.micrometer.instrument.http.HttpRequestTimeMetricsMetaDataBuilder" />
        </property>
      </component>
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler"/>
      <!-- 省略 -->
    </list>
  </property>
</component>
```

`LoggingMeterRegistry`を使用していた場合、以下のようなメトリクスが収集される:

```
2020-10-06 13:52:10.309 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: http.server.requests{class=com.nablarch.example.app.web.action.AuthenticationAction,exception=None,httpMethod=POST,method=login_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext,outcome=REDIRECTION,status=303} throughput=0.2/s mean=0.4617585s max=0.4617585s
2020-10-06 13:52:10.309 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: http.server.requests{class=com.nablarch.example.app.web.action.IndustryAction,exception=None,httpMethod=GET,method=find,outcome=SUCCESS,status=200} throughput=0.2/s mean=0.103277s max=0.103277s
2020-10-06 13:52:10.310 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: http.server.requests{class=com.nablarch.example.app.web.action.AuthenticationAction,exception=None,httpMethod=GET,method=index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext,outcome=SUCCESS,status=200} throughput=0.2/s mean=4.7409146s max=4.7409146s
2020-10-06 13:52:10.310 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: http.server.requests{class=com.nablarch.example.app.web.action.ProjectAction,exception=None,httpMethod=GET,method=index_nablarch.fw.web.HttpRequest_nablarch.fw.ExecutionContext,outcome=SUCCESS,status=200} throughput=0.2/s mean=0.5329547s max=0.5329547s
```

## バッチのトランザクション単位の処理時間を計測する

`BatchTransactionTimeMetricsLogger` を使用することで、:ref:`nablarch_batch` のトランザクション単位の処理時間をメトリクスとして計測できる。

Timerを使って`batch.transaction.time`という名前でメトリクスを収集する。メトリクス名は `setMetricsName(String)` で変更できる。

タグ:

| タグ名 | 説明 |
|---|---|
| `class` | アクションのクラス名（:ref:`-requestPath <nablarch_batch-resolve_action>` から取得した値） |

> **重要**: `BatchTransactionTimeMetricsLogger`をそのまま`commitLogger`という名前で定義した場合、デフォルトの `BasicCommitLogger` が動作しなくなる。`CompositeCommitLogger` を使用して`BasicCommitLogger`と`BatchTransactionTimeMetricsLogger`を併用すること。

```xml
<component name="commitLogger" class="nablarch.core.log.app.CompositeCommitLogger">
  <property name="commitLoggerList">
    <list>
      <component class="nablarch.core.log.app.BasicCommitLogger">
        <property name="interval" value="${nablarch.commitLogger.interval}" />
      </component>
      <component class="nablarch.integration.micrometer.instrument.batch.BatchTransactionTimeMetricsLogger">
        <property name="meterRegistry" ref="meterRegistry" />
      </component>
    </list>
  </property>
</component>
```

`BatchTransactionTimeMetricsLogger` は `CommitLogger` インタフェースを実装しており、`increment(long)`の呼び出し間隔を計測することでトランザクション単位の時間を計測する。

`LoggingMeterRegistry`を使用している場合、`BatchTransactionTimeMetricsLogger`の計測結果は以下のように出力される:

```
12 17, 2020 1:50:33 午後 io.micrometer.core.instrument.logging.LoggingMeterRegistry lambda$publish$5
情報: batch.transaction.time{class=MetricsTestAction} throughput=1/s mean=2.61463556s max=3.0790852s
```

## バッチの処理件数を計測する

**クラス**: `nablarch.integration.micrometer.instrument.batch.BatchProcessedRecordCountMetricsLogger`

:ref:`nablarch_batch` が処理した入力データの件数をCounterで計測する。メトリクス名: `batch.processed.record.count`（`setMetricsName(String)` で変更可能）。

| タグ名 | 説明 |
|---|---|
| `class` | アクションのクラス名（:ref:`-requestPath <nablarch_batch-resolve_action>` から取得した値） |

```xml
<component name="commitLogger"
           class="nablarch.core.log.app.CompositeCommitLogger">
  <property name="commitLoggerList">
    <list>
      <component class="nablarch.core.log.app.BasicCommitLogger">
        <property name="interval" value="${nablarch.commitLogger.interval}" />
      </component>
      <component class="nablarch.integration.micrometer.instrument.batch.BatchProcessedRecordCountMetricsLogger">
        <property name="meterRegistry" ref="meterRegistry" />
      </component>
    </list>
  </property>
</component>
```

`CommitLogger` の仕組みを利用して処理件数を計測する。詳細は :ref:`micrometer_adaptor_batch_transaction_time` 参照。

`LoggingMeterRegistry` を使用している場合、以下のようにメトリクスが出力されることを確認できる。

```text
batch.processed.record.count{class=MetricsTestAction} throughput=10/s
```

## ログレベルごとの出力回数を計測する

**クラス**: `nablarch.integration.micrometer.instrument.binder.logging.LogCountMetrics`

ログレベルごとの出力回数をCounterで計測する。メトリクス名: `log.count`（`MetricsMetaData` を受け取る :java:extdoc:`コンストラクタ <nablarch.integration.micrometer.instrument.binder.logging.LogCountMetrics.<init>(nablarch.integration.micrometer.instrument.binder.MetricsMetaData)>` で変更可能）。

| タグ名 | 説明 |
|---|---|
| `level` | ログレベル |
| `logger` | `LoggerManager` からロガーを取得するときに使用した名前 |

**LogPublisher設定**: `LogCountMetrics` はログ出力イベント検知に `LogPublisher` の仕組みを使用するため、事前に `LogPublisher` の設定が必要。設定方法は :ref:`log-publisher_usage` 参照。

**DefaultMeterBinderListProvider実装**: `DefaultMeterBinderListProvider` を継承したクラスを作成し、`LogCountMetrics` を含む `MeterBinder` リストを返すよう実装する。最後に `MeterRegistryFactory` コンポーネントの `meterBinderListProvider` プロパティに設定する。詳細は :ref:`micrometer_adaptor_declare_default_meter_binder_list_provider_as_component` 参照。

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider {
    @Override
    protected List<MeterBinder> createMeterBinderList() {
        List<MeterBinder> meterBinderList = new ArrayList<>(super.createMeterBinderList());
        meterBinderList.add(new LogCountMetrics());
        return meterBinderList;
    }
}
```

`LoggingMeterRegistry` を使用した場合、以下のようにメトリクスが出力されることが確認できる。

```text
log.count{level=WARN,logger=com.nablarch.example.app.web.action.MetricsAction} throughput=0.4/s
log.count{level=ERROR,logger=com.nablarch.example.app.web.action.MetricsAction} throughput=1.4/s
```

**集計対象ログレベル**: デフォルトは `WARN` 以上のみ。コンストラクタに `LogLevel` を渡すことでしきい値を変更可能。

```java
meterBinderList.add(new LogCountMetrics(LogLevel.INFO)); // LogLevel のしきい値を指定
```

> **重要**: ログレベルのしきい値を下げすぎると、アプリケーションによっては大量のメトリクスが収集される可能性がある。使用する監視サービスの料金体系によっては使用料金が増大する可能性があるため、注意して設定すること。

## SQLの処理時間を計測する

**クラス**: `nablarch.integration.micrometer.instrument.dao.SqlTimeMetricsDaoContext`
**ファクトリクラス**: `nablarch.integration.micrometer.instrument.dao.SqlTimeMetricsDaoContextFactory`

:ref:`universal_dao` を通じて実行したSQLの処理時間をTimerで計測する。メトリクス名: `sql.process.time`（`SqlTimeMetricsDaoContextFactory` の `setMetricsName(String)` で変更可能）。

| タグ名 | 説明 |
|---|---|
| `sql.id` | `DaoContext` のメソッド引数に渡されたSQLID（SQLIDが無い場合は `"None"`） |
| `entity` | エンティティクラスの名前（`Class.getName()`） |
| `method` | 実行された `DaoContext` のメソッド名 |

`SqlTimeMetricsDaoContextFactory` を `daoContextFactory` という名前でコンポーネントとして定義することで、:ref:`universal_dao` が使用する `DaoContext` が `SqlTimeMetricsDaoContext` に置き換わる。

```xml
<component name="daoContextFactory"
           class="nablarch.integration.micrometer.instrument.dao.SqlTimeMetricsDaoContextFactory">
  <property name="delegate">
    <component class="nablarch.common.dao.BasicDaoContextFactory">
      <property name="sequenceIdGenerator">
        <component class="nablarch.common.idgenerator.SequenceIdGenerator" />
      </property>
    </component>
  </property>
  <property name="meterRegistry" ref="meterRegistry" />
</component>
```

`LoggingMeterRegistry` を使用した場合、以下のようにメトリクスが出力されることが確認できる（throughput、mean、maxの各フィールドが含まれる）。

```text
sql.process.time{entity=com.nablarch.example.app.entity.Project,method=delete,sql.id=None} throughput=0.2/s mean=0.0005717s max=0.0005717s
```

## Tomcatのスレッドプールの状態をMBeanから取得してメトリクスとして計測する

**クラス**: `JmxGaugeMetrics`

`JmxGaugeMetrics`はGaugeを使ってMBeanから取得した値をメトリクスとして計測する。`MeterBinder`の実装クラスとして提供されている。

`DefaultMeterBinderListProvider`を継承したクラスを作り、`JmxGaugeMetrics`を含む`MeterBinder`リストを返すように`createMeterBinderList()`を実装する。詳細は:ref:`micrometer_adaptor_declare_default_meter_binder_list_provider_as_component`を参照。

**コンストラクタ引数:**

| クラス | 役割 |
|---|---|
| `MetricsMetaData` | メトリクスの名前・説明・タグなどのメタ情報 |
| `MBeanAttributeCondition` | 収集するMBeanのオブジェクト名と属性名 |

**Tomcatスレッドプール計測例:**

```java
meterBinderList.add(new JmxGaugeMetrics(
    new MetricsMetaData("thread.count.current", "Current thread count."),
    new MBeanAttributeCondition("Catalina:type=ThreadPool,name=\"http-nio-8080\"", "currentThreadCount")
));
```

> **ヒント**: TomcatのMBeanのオブジェクト名・属性名は、JDKに付属のJConsoleで確認できる。JConsoleでTomcatを実行しているJVMに接続し「MBeans」タブを開くと、接続しているJVMで取得可能なMBeanの一覧が表示される。詳細は[モニタリングおよび管理ガイド](https://docs.oracle.com/javase/jp/17/management/using-jconsole.html#GUID-77416B38-7F15-4E35-B3D1-34BFD88350B5)を参照。

以上の設定で`LoggingMeterRegistry`を使用した場合、以下のようにメトリクスが出力されることが確認できる。

```
24-Dec-2020 16:20:24.467 情報 [logging-metrics-publisher] io.micrometer.core.instrument.logging.LoggingMeterRegistry.lambda$publish$3 thread.count.current{} value=10
```

## HikariCPのコネクションプールの状態をMBeanから取得してメトリクスとして計測する

HikariCPのMBeanを有効にするには、`HikariDataSource`の`registerMbeans`プロパティに`true`を設定する。

```xml
<component name="dataSource" class="com.zaxxer.hikari.HikariDataSource" autowireType="None">
  <property name="driverClassName" value="${nablarch.db.jdbcDriver}"/>
  <property name="jdbcUrl"         value="${nablarch.db.url}"/>
  <property name="username"        value="${nablarch.db.user}"/>
  <property name="password"        value="${nablarch.db.password}"/>
  <property name="maximumPoolSize" value="${nablarch.db.maxPoolSize}"/>
  <!-- MBeanによる情報公開を有効にする -->
  <property name="registerMbeans"  value="true"/>
</component>
```

コネクションプールの最大数とアクティブ数の計測例（オブジェクト名・属性名の仕様は[MBean (JMX) Monitoring and Management](https://github.com/brettwooldridge/HikariCP/wiki/MBean-(JMX)-Monitoring-and-Management)参照）:

```java
// 最大数
meterBinderList.add(new JmxGaugeMetrics(
    new MetricsMetaData("db.pool.total", "Total DB pool count."),
    new MBeanAttributeCondition("com.zaxxer.hikari:type=Pool (HikariPool-1)", "TotalConnections")
));
// アクティブ数
meterBinderList.add(new JmxGaugeMetrics(
    new MetricsMetaData("db.pool.active", "Active DB pool count."),
    new MBeanAttributeCondition("com.zaxxer.hikari:type=Pool (HikariPool-1)", "ActiveConnections")
));
```

以上の設定で`LoggingMeterRegistry`を使用した場合、以下のようにメトリクスが出力されることが確認できる。

```
2020-12-24 16:37:57.143 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: db.pool.active{} value=0
2020-12-24 16:37:57.143 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: db.pool.total{} value=5
```

## サーバ起動時に出力される警告ログについて

Micrometerが監視サービスにメトリクスを連携する方法には、大きく次の2つの方法がある。

| 方式 | 説明 | 例 |
|---|---|---|
| **Client pushes** | 一定間隔でアプリケーションが監視サービスにメトリクスを送信する | Datadog, CloudWatch |
| **Server polls** | 一定間隔で監視サービスがアプリケーションにメトリクスを問い合わせに来る | Prometheus |

**警告ログが出力される原因:**

Client pushes方式の場合、`MeterRegistry`はコンポーネント生成後に一定間隔でメトリクスの送信を開始する。一方、HikariCPのコネクションプールは最初のデータベースアクセス時に初めて作成される。そのため、最初のDBアクセスが発生する前にメトリクス送信が実行されると、`JmxGaugeMetrics`は存在しないコネクションプールの情報を参照し、以下の警告ログが出力される。

```
24-Dec-2020 16:57:16.729 警告 [logging-metrics-publisher] io.micrometer.core.util.internal.logging.WarnThenDebugLogger.log Failed to apply the value function for the gauge 'db.pool.active'. Note that subsequent logs will be logged at debug level.
        java.lang.RuntimeException: javax.management.InstanceNotFoundException: com.zaxxer.hikari:type=Pool (HikariPool-1)
                at nablarch.integration.micrometer.instrument.binder.jmx.JmxGaugeMetrics.obtainGaugeValue(JmxGaugeMetrics.java:59)
                ...
```

コネクションプールが生成されていない間、メトリクスの値は`NaN`となる。

```
24-Dec-2020 17:01:31.443 情報 [logging-metrics-publisher] ... db.pool.active{} value=NaN
24-Dec-2020 17:01:31.443 情報 [logging-metrics-publisher] ... db.pool.total{} value=NaN
```

**この警告ログは最初の一度だけ出力され、2回目以降は抑制される。** コネクションプールが生成された後は正常に値が収集される。実害はないため無視しても問題はない。

**警告ログを抑制したい場合:**

カスタムの`DefaultMeterBinderListProvider`で`Initializable`を実装することで回避できる。`DataSource`をプロパティとして受け取り、`initialize()`メソッド内でデータベースに接続してコネクションプールを事前に生成する。

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider implements Initializable {
    private static final Logger LOGGER = LoggerManager.get(CustomMeterBinderListProvider.class);

    private DataSource dataSource;

    @Override
    protected List<MeterBinder> createMeterBinderList() {
        // 省略
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void initialize() {
        try (Connection con = dataSource.getConnection()) {
            // 初期化時にコネクションを確立することで、MBeanが取れないことによる警告ログの出力を抑制する
        } catch (SQLException e) {
            LOGGER.logWarn("Failed initial connection.", e);
        }
    }
}
```

コンポーネント定義では、`DataSource`をプロパティで渡し、`BasicApplicationInitializer`の初期化対象に追加する。

```xml
<component name="meterBinderListProvider"
           class="example.micrometer.CustomMeterBinderListProvider">
  <!-- DataSource を設定する -->
  <property name="dataSource" ref="dataSource" />
</component>

<!-- 初期化が必要なコンポーネント -->
<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <!-- 省略 -->
      <!-- 初期化対象のコンポーネントとして追加 -->
      <component-ref name="meterBinderListProvider" />
    </list>
  </property>
</component>
```

この修正により、システムリポジトリ初期化時にデータベース接続が行われる。メトリクスの送信間隔はデフォルトで1分なので、たいていの場合メトリクス送信よりも前にコネクションプールが作成され、警告ログが出力されなくなる。

> **注意**: メトリクスの送信間隔を非常に短い時間に設定している場合、システムリポジトリが初期化される前にメトリクスが送信されて警告ログが出力される可能性がある。
