# Micrometerアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/micrometer_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/logging/LoggingMeterRegistryFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/DefaultMeterBinderListProvider.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/BasicApplicationDisposer.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/simple/SimpleMeterRegistryFactory.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/cloudwatch/CloudWatchMeterRegistryFactory.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/datadog/DatadogMeterRegistryFactory.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/statsd/StatsdMeterRegistryFactory.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/otlp/OtlpMeterRegistryFactory.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/MeterRegistryFactory.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/binder/jvm/NablarchGcCountMetrics.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/cloudwatch/CloudWatchAsyncClientProvider.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/GlobalMeterRegistryFactory.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/handler/TimerMetricsHandler.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/handler/HandlerMetricsMetaDataBuilder.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/http/HttpRequestTimeMetricsMetaDataBuilder.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/batch/BatchTransactionTimeMetricsLogger.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/CompositeCommitLogger.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/BasicCommitLogger.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/CommitLogger.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/batch/BatchProcessedRecordCountMetricsLogger.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/binder/logging/LogCountMetrics.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/binder/MetricsMetaData.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/LoggerManager.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogPublisher.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/basic/LogLevel.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/dao/SqlTimeMetricsDaoContext.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/dao/SqlTimeMetricsDaoContextFactory.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/DaoContext.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/binder/jmx/JmxGaugeMetrics.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/micrometer/instrument/binder/jmx/MBeanAttributeCondition.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/Initializable.html)

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-micrometer-adaptor</artifactId>
</dependency>
```

> **補足**: Micrometerのバージョン1.13.0を使用してテストを行っている。バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

**クラス**: `nablarch.integration.micrometer.DefaultMeterBinderListProvider`

`DefaultMeterBinderListProvider` が生成する `MeterBinder` のリストに含まれるクラス:

- JvmMemoryMetrics
- JvmGcMetrics
- JvmThreadMetrics
- ClassLoaderMetrics
- ProcessorMetrics
- FileDescriptorMetrics
- UptimeMetrics
- `NablarchGcCountMetrics`

収集されるメトリクス一覧:

| メトリクス名 | 説明 |
|---|---|
| `jvm.buffer.count` | バッファプール内のバッファの数 |
| `jvm.buffer.memory.used` | バッファプールの使用量 |
| `jvm.buffer.total.capacity` | バッファプールの合計容量 |
| `jvm.memory.used` | メモリプールのメモリ使用量 |
| `jvm.memory.committed` | メモリプールのコミットされたメモリ量 |
| `jvm.memory.max` | メモリプールの最大メモリ量 |
| `jvm.gc.max.data.size` | OLD領域の最大メモリ量 |
| `jvm.gc.live.data.size` | Full GC 後の OLD 領域のメモリ使用量 |
| `jvm.gc.memory.promoted` | GC 前後で増加した、OLD 領域のメモリ使用量の増分 |
| `jvm.gc.memory.allocated` | 前回の GC 後から今回の GC までの、Young 領域のメモリ使用量の増分 |
| `jvm.gc.concurrent.phase.time` | コンカレントフェーズの処理時間 |
| `jvm.gc.pause` | GC の一時停止に費やされた時間 |
| `jvm.threads.peak` | スレッド数のピーク数 |
| `jvm.threads.daemon` | 現在のデーモンスレッドの数 |
| `jvm.threads.live` | 現在の非デーモンスレッドの数 |
| `jvm.threads.states` | 現在のスレッドの状態ごとの数 |
| `jvm.classes.loaded` | 現在ロードされているクラスの数 |
| `jvm.classes.unloaded` | JVM が起動してから今までにアンロードされたクラスの数 |
| `system.cpu.count` | JVM で使用できるプロセッサーの数 |
| `system.load.average.1m` | 最後の1分のシステム負荷平均（[OperatingSystemMXBean](https://docs.oracle.com/javase/jp/11/docs/api/java.management/java/lang/management/OperatingSystemMXBean.html#getSystemLoadAverage())） |
| `system.cpu.usage` | システム全体の直近の CPU 使用率 |
| `process.cpu.usage` | JVM の直近のCPU使用率 |
| `process.files.open` | 開いているファイルディスクリプタの数 |
| `process.files.max` | ファイルディスクリプタの最大数 |
| `process.uptime` | JVM の稼働時間 |
| `process.start.time` | JVM の起動時刻（UNIX 時間） |
| `jvm.gc.count` | GC の回数 |
| `jvm.threads.started` | JVMで起動したスレッド数 |
| `process.cpu.time` | Java仮想マシン・プロセスによって使用されるCPU時間 |

各監視サービスとのMicrometer連携設定。共通手順:
1. 監視サービスや連携方法ごとに用意されたMicrometerのモジュールを依存関係に追加する
2. 使用するレジストリファクトリをコンポーネントとして定義する
3. その他、監視サービスごとに独自に設定する

対応サービス: Datadog、CloudWatch、Azure（Java 3.0エージェント経由）、StatsD（DogStatsD）、OpenTelemetry Protocol (OTLP)

アプリケーションの形式（ウェブ・バッチ）ごとに収集を推奨するメトリクスを示す。

## ウェブアプリケーション

**HTTPリクエストの処理時間**
- URLごとのアクセス数・処理時間確認
- パーセンタイル計測で大部分のリクエスト処理時間を把握
- [micrometer_timer_metrics_handler](#), [micrometer_timer_metrics_handler_percentiles](#)

**SQLの処理時間**
- 各SQLの処理時間確認、想定超過SQLの検出
- [micrometer_sql_time](#)

**ログレベルごとの出力回数**
- 警告ログの異常回数出力（攻撃検知）、エラーログ検知
- [micrometer_log_count](#)

**アプリケーションサーバ/ライブラリのリソース情報（JMX MBean）**
- スレッドプール・DBコネクションプール等の状態を収集し、障害時の原因特定に活用
- 多くのアプリケーションサーバはJMX MBeanでリソース状態を公開
- [micrometer_mbean_metrics](#)

## バッチアプリケーション

**バッチの処理時間**
- [micrometer_default_metrics](#s4) で収集される `process.uptime` で計測
- 平常時との差異で異常を迅速検知

**トランザクション単位の処理時間**
- マルチスレッドバッチの負荷分散確認
- 平常時からの逸脱検知
- [micrometer_adaptor_batch_transaction_time](#)

**バッチの処理件数**
- 進捗確認、処理速度・件数の妥当性確認
- [micrometer_batch_processed_count](#)

**SQLの処理時間**
- 各SQLの処理時間確認、想定超過SQLの検出
- [micrometer_sql_time](#)

**ログレベルごとの出力回数**
- 警告/エラーログ検知
- [micrometer_log_count](#)

**ライブラリのリソース情報（JMX MBean）**
- DBコネクションプール等の状態を収集し、障害時の原因特定に活用
- [micrometer_mbean_metrics](#)

**クラス**: `nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler`, `nablarch.integration.micrometer.instrument.handler.HandlerMetricsMetaDataBuilder`

`TimerMetricsHandler` をハンドラキューに設定すると、後続ハンドラの処理時間を計測しメトリクスとして収集できる。

`HandlerMetricsMetaDataBuilder` インタフェースの実装クラスを `handlerMetricsMetaDataBuilder` プロパティに設定する必要がある。構築するメタ情報：
- メトリクスの名前 (`getMetricsName()`)
- メトリクスの説明 (`getMetricsDescription()`)
- タグ一覧 (`buildTagList()`)

`buildTagList()` の引数: ハンドラに渡されたパラメータ、後続ハンドラの実行結果、スローされた例外（スローなしの場合は `null`）。戻り値: `List<io.micrometer.core.instrument.Tag>`。

**HandlerMetricsMetaDataBuilder 実装例**:
```java
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

**TimerMetricsHandler XML設定例**:
```xml
<component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
  <property name="meterRegistry" ref="meterRegistry" />
  <property name="handlerMetricsMetaDataBuilder">
    <component class="xxx.CustomHandlerMetricsMetaDataBuilder" />
  </property>
</component>
```

`meterRegistry` プロパティには、使用しているレジストリファクトリが生成した `MeterRegistry` を渡す。

Nablarchが提供する `HandlerMetricsMetaDataBuilder` の実装: [micrometer_adaptor_http_request_process_time_metrics](#)

## パーセンタイルを収集する

`TimerMetricsHandler` のパーセンタイル関連プロパティ（デフォルトは全て未設定のため、パーセンタイルは収集されない。収集する場合は明示的に設定すること）：

| プロパティ名 | 説明 |
|---|---|
| `percentiles` | 収集するパーセンタイル値のリスト（例: 95パーセンタイルは `0.95`） |
| `enablePercentileHistogram` | ヒストグラムバケットを監視サービスに連携するかどうか。監視サービスがヒストグラムによるパーセンタイル計算をサポートしない場合は無視される |
| `serviceLevelObjectives` | ヒストグラムに追加するバケット値のリスト（単位: ミリ秒、SLOに基づいて設定） |
| `minimumExpectedValue` | ヒストグラムバケットの最小値（単位: ミリ秒） |
| `maximumExpectedValue` | ヒストグラムバケットの最大値（単位: ミリ秒） |

詳細は [Micrometerのドキュメント](https://docs.micrometer.io/micrometer/reference/concepts/histogram-quantiles.html) を参照。

**パーセンタイル設定例**:
```xml
<component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
  <property name="meterRegistry" ref="meterRegistry" />
  <property name="handlerMetricsMetaDataBuilder">
    <component class="nablarch.integration.micrometer.instrument.http.HttpRequestTimeMetricsMetaDataBuilder" />
  </property>
  <!-- 98, 90, 50 パーセンタイルを収集 -->
  <property name="percentiles">
    <list>
      <value>0.98</value>
      <value>0.90</value>
      <value>0.50</value>
    </list>
  </property>
  <property name="enablePercentileHistogram" value="true" />
  <!-- SLO として 1000ms, 1500ms を設定 -->
  <property name="serviceLevelObjectives">
    <list>
      <value>1000</value>
      <value>1500</value>
    </list>
  </property>
  <property name="minimumExpectedValue" value="500" />
  <property name="maximumExpectedValue" value="3000" />
</component>
```

> **補足**: 本アダプタが提供する `MeterRegistry` では `OtlpMeterRegistry` のみがヒストグラムバケットをサポートする。
>
> `PrometheusMeterRegistry` の `MeterRegistryFactory` は本アダプタでは提供していない。`PrometheusMeterRegistry` を使用したい場合は、以下のようなクラスを自前で用意すること。
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

**クラス**: `nablarch.integration.micrometer.instrument.http.HttpRequestTimeMetricsMetaDataBuilder`

`HttpRequestTimeMetricsMetaDataBuilder` はHTTPリクエストの処理時間計測のためのメタ情報を構築する。

- メトリクス名: `http.server.requests`

生成するタグ：

| タグ名 | 説明 |
|---|---|
| `class` | リクエストを処理したアクションクラス名（`Class.getName()`）。取得不可の場合は `UNKNOWN` |
| `method` | アクションクラスのメソッド名と引数の型名（`Class.getCanonicalName()`）をアンダースコアで連結した文字列。取得不可の場合は `UNKNOWN` |
| `httpMethod` | HTTPメソッド |
| `status` | HTTPステータスコード |
| `outcome` | ステータスコードの種類（1XX: `INFORMATION`, 2XX: `SUCCESS`, 3XX: `REDIRECTION`, 4XX: `CLIENT_ERROR`, 5XX: `SERVER_ERROR`, その他: `UNKNOWN`） |
| `exception` | スローされた例外の単純名（なしの場合は `None`） |

リクエスト全体の処理時間を計測するため、`TimerMetricsHandler` はハンドラキューの先頭に設定すること。

**XML設定例**:
```xml
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.integration.micrometer.instrument.handler.TimerMetricsHandler">
        <property name="meterRegistry" ref="meterRegistry" />
        <property name="handlerMetricsMetaDataBuilder">
          <component class="nablarch.integration.micrometer.instrument.http.HttpRequestTimeMetricsMetaDataBuilder" />
        </property>
      </component>
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler"/>
    </list>
  </property>
</component>
```

**クラス**: `nablarch.integration.micrometer.instrument.batch.BatchProcessedRecordCountMetricsLogger`

[nablarch_batch](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch_batch.md) が処理した入力データの件数をCounterを使って `batch.processed.record.count` という名前で計測する。メトリクス名は `setMetricsName(String)` で変更可能。

**メトリクスタグ**:

| タグ名 | 説明 |
|---|---|
| `class` | アクションのクラス名（[-requestPath](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) から取得した値） |

`CommitLogger` の仕組みを利用して処理件数を計測する。詳細は [micrometer_adaptor_batch_transaction_time](#) を参照。

**設定例** (`CompositeCommitLogger` と組み合わせる):

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

**クラス**: `nablarch.integration.micrometer.instrument.binder.jmx.JmxGaugeMetrics`

Gaugeを使用してMBeanから取得した値を計測する `MeterBinder` の実装クラス。`DefaultMeterBinderListProvider` を継承したクラスで `createMeterBinderList()` をオーバーライドし、`JmxGaugeMetrics` を含む `MeterBinder` リストを返す実装が必要。

> **補足**: [micrometer_adaptor_declare_default_meter_binder_list_provider_as_component](#s2) を参照。

**JmxGaugeMetricsコンストラクタ引数**:

| 引数 | クラス | 説明 |
|---|---|---|
| 第1引数 | `MetricsMetaData` | メトリクスの名前・説明・タグなどのメタ情報 |
| 第2引数 | `MBeanAttributeCondition` | 収集するMBeanのオブジェクト名と属性名 |

### Tomcatのスレッドプールの状態を取得する

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider {
    @Override
    protected List<MeterBinder> createMeterBinderList() {
        List<MeterBinder> meterBinderList = new ArrayList<>(super.createMeterBinderList());
        meterBinderList.add(new JmxGaugeMetrics(
            new MetricsMetaData("thread.count.current", "Current thread count."),
            new MBeanAttributeCondition("Catalina:type=ThreadPool,name=\"http-nio-8080\"", "currentThreadCount")
        ));
        return meterBinderList;
    }
}
```

> **補足**: TomcatのMBeanのオブジェクト名・属性名はJDK付属のJConsoleで確認できる。

`LoggingMeterRegistry` を使用した場合、以下のようにメトリクスが出力されることが確認できる。

```
thread.count.current{} value=10
```

### HikariCPのコネクションプールの状態を取得する

HikariCPのMBeanによる情報公開を有効にするには、`com.zaxxer.hikari.HikariDataSource` の `registerMbeans` プロパティを `true` に設定する。

```xml
<component name="dataSource" class="com.zaxxer.hikari.HikariDataSource" autowireType="None">
  <property name="driverClassName" value="${nablarch.db.jdbcDriver}"/>
  <property name="jdbcUrl" value="${nablarch.db.url}"/>
  <property name="username" value="${nablarch.db.user}"/>
  <property name="password" value="${nablarch.db.password}"/>
  <property name="maximumPoolSize" value="${nablarch.db.maxPoolSize}"/>
  <property name="registerMbeans" value="true"/>
</component>
```

コネクションプールの最大数とアクティブ数を計測する実装例:

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

`LoggingMeterRegistry` を使用した場合、正常時は以下のようにメトリクスが出力されることが確認できる。

```
2020-12-24 16:37:57.143 [INFO ] i.m.c.i.l.LoggingMeterRegistry: db.pool.active{} value=0
2020-12-24 16:37:57.143 [INFO ] i.m.c.i.l.LoggingMeterRegistry: db.pool.total{} value=5
```

### サーバ起動時の警告ログについて

MicrometerがClient pushes方式（Datadog、CloudWatchなど）の場合、`MeterRegistry` 生成後すぐにメトリクス送信が開始される。HikariCPのコネクションプールは最初のDBアクセス時に初めて作成されるため、プール生成前にメトリクス送信が実行されると `JmxGaugeMetrics` が存在しないMBeanを参照して以下のような警告ログが出力される。

```
Failed to apply the value function for the gauge 'db.pool.active'. Note that subsequent logs will be logged at debug level.
```

なお、コネクションプールが生成されていない間、メトリクスの値は `NaN` となる。

```
db.pool.active{} value=NaN
db.pool.total{} value=NaN
```

この警告ログは最初の一度だけ出力され、2回目以降は抑制される。実害はないので無視して問題ない。

警告ログを抑制するには、`CustomMeterBinderListProvider` で `Initializable` を実装し、`initialize()` メソッド内でDBに接続することで回避できる。

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider implements Initializable {
    private DataSource dataSource;

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

コンポーネント定義で `dataSource` プロパティを設定し、初期化対象コンポーネントに追加する:

```xml
<component name="meterBinderListProvider" class="example.micrometer.CustomMeterBinderListProvider">
  <property name="dataSource" ref="dataSource" />
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="meterBinderListProvider" />
    </list>
  </property>
</component>
```

メトリクスの送信間隔はデフォルトで1分なので、たいていの場合メトリクス送信よりも前にコネクションプールが作成されるようになり、警告ログは出力されなくなる。

> **警告**: メトリクス送信間隔が非常に短い場合、システムリポジトリ初期化前にメトリクスが送信されて警告ログが出力される可能性がある。

<details>
<summary>keywords</summary>

nablarch-micrometer-adaptor, Micrometerアダプタ, モジュール依存関係, Maven依存関係, メトリクス収集, DefaultMeterBinderListProvider, MeterBinder, NablarchGcCountMetrics, JvmMemoryMetrics, JvmGcMetrics, JvmThreadMetrics, ClassLoaderMetrics, ProcessorMetrics, FileDescriptorMetrics, UptimeMetrics, JVMメトリクス収集, メトリクス一覧, jvm.gc.count, jvm.memory.used, process.cpu.usage, jvm.buffer.count, jvm.buffer.memory.used, jvm.buffer.total.capacity, jvm.memory.committed, jvm.memory.max, jvm.gc.max.data.size, jvm.gc.live.data.size, jvm.gc.memory.promoted, jvm.gc.memory.allocated, jvm.gc.concurrent.phase.time, jvm.gc.pause, jvm.threads.peak, jvm.threads.daemon, jvm.threads.live, jvm.threads.states, jvm.classes.loaded, jvm.classes.unloaded, system.cpu.count, system.cpu.usage, system.load.average.1m, process.files.open, process.files.max, process.uptime, process.start.time, jvm.threads.started, process.cpu.time, 監視サービス連携, Micrometerモジュール, レジストリファクトリ, DatadogMeterRegistryFactory, CloudWatchMeterRegistryFactory, StatsdMeterRegistryFactory, OtlpMeterRegistryFactory, GlobalMeterRegistryFactory, ウェブアプリケーション メトリクス収集, バッチアプリケーション メトリクス収集, HTTPリクエスト処理時間, SQL処理時間計測, ログレベル出力回数, バッチ処理件数, JMX MBean リソース情報, トランザクション単位処理時間, コネクションプール監視, TimerMetricsHandler, HandlerMetricsMetaDataBuilder, HttpRequestTimeMetricsMetaDataBuilder, OtlpMeterRegistry, PrometheusMeterRegistry, MeterRegistryFactory, NablarchMeterRegistryConfig, MicrometerConfiguration, percentiles, enablePercentileHistogram, serviceLevelObjectives, minimumExpectedValue, maximumExpectedValue, 処理時間計測, パーセンタイル収集, メトリクスタグ設定, http.server.requests, BatchProcessedRecordCountMetricsLogger, batch.processed.record.count, CompositeCommitLogger, BasicCommitLogger, CommitLogger, setMetricsName, バッチ処理件数計測, Counter, meterRegistry, JmxGaugeMetrics, MetricsMetaData, MBeanAttributeCondition, Initializable, BasicApplicationInitializer, HikariDataSource, registerMbeans, LoggingMeterRegistry, MBeanメトリクス計測, JMX連携, HikariCPコネクションプール監視, Tomcatスレッドプール監視, 警告ログ抑制

</details>

## Micrometerアダプタを使用するための設定を行う

`ComponentFactory` を使ってレジストリを [repository](../libraries/libraries-repository.md) に登録する。

### DefaultMeterBinderListProviderの宣言

`DefaultMeterBinderListProvider` はJVMのメモリ使用量・CPU使用率などの MeterBinder リストを提供するクラス。廃棄処理が必要。`src/main/resources/web-component-configuration.xml` に宣言を追加する。

Micrometerには `MeterBinder` というインタフェースがあり、よく使用するメトリクスの収集クラスがあらかじめ用意されている（例：JVMのメモリ使用量は `JvmMemoryMetrics`、CPU使用率は `ProcessorMetrics`）。

```xml
<component name="meterBinderListProvider"
           class="nablarch.integration.micrometer.DefaultMeterBinderListProvider" />
```

収集されるメトリクスの詳細は [micrometer_default_metrics](#s4) を参照。

### 廃棄処理対象への登録

`DefaultMeterBinderListProvider` は廃棄処理が必要なコンポーネントなので、廃棄処理対象として宣言する。オブジェクトの廃棄処理については [repository-dispose_object](../libraries/libraries-repository.md) を参照。

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

### レジストリファクトリクラスの宣言

`meterBinderListProvider` と `applicationDisposer` の2つのプロパティを設定する。それぞれ上で宣言した `DefaultMeterBinderListProvider` と `BasicApplicationDisposer` を設定する。ファクトリクラスの一覧は [micrometer_registry_factory](#s2) を参照。

```xml
<component class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

### micrometer.propertiesの作成

`src/main/resources` の下に `micrometer.properties` を配置する。

> **重要**: `micrometer.properties` は内容が空であっても必ず配置しなければならない。

```properties
# 5秒ごとにメトリクスを出力（デフォルトは1分）
nablarch.micrometer.logging.step=5s
# stepで指定した時間よりも早くアプリケーションが終了した場合でも廃棄処理でログが出力されるよう設定
nablarch.micrometer.logging.logInactive=true
```

### 実行結果

アプリケーションを起動すると、`LoggingMeterRegistry` により収集されたメトリクスが標準出力に出力される。ログフォーマットは `i.m.c.i.l.LoggingMeterRegistry: <metric>{<tags>} value=...` の形式。

```text
2020-09-04 15:33:40.689 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.gc.count{memory.manager.name=PS Scavenge} throughput=2.6/s
2020-09-04 15:33:40.691 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.buffer.count{id=mapped} value=0 buffers
2020-09-04 15:33:40.692 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.buffer.memory.used{id=direct} value=124 KiB
2020-09-04 15:33:40.693 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.classes.loaded{} value=9932 classes
2020-09-04 15:33:40.694 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.memory.committed{area=heap,id=PS Old Gen} value=182.5 MiB
2020-09-04 15:33:40.697 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.memory.used{area=nonheap,id=Code Cache} value=28.618713 MiB
2020-09-04 15:33:40.698 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.threads.live{} value=29 threads
2020-09-04 15:33:40.698 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.threads.daemon{} value=28 threads
2020-09-04 15:33:40.702 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: jvm.threads.states{state=runnable} value=9 threads
2020-09-04 15:33:41.199 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.cpu.usage{} value=0.111672
2020-09-04 15:33:41.199 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.uptime{} value=26.729s
2020-09-04 15:33:41.200 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.count{} value=8
2020-09-04 15:33:41.200 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.usage{} value=0.394545
```

**クラス**: `nablarch.integration.micrometer.MeterRegistryFactory`

`tags` プロパティ（型: `Map<String, String>`）で、すべてのメトリクスに共通するタグを設定できる。ホスト、インスタンス、リージョンなどの識別情報の設定に使用する。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <!-- tags プロパティで共通のタグを設定 -->
  <property name="tags">
    <map>
      <entry key="foo" value="FOO" />
      <entry key="bar" value="BAR" />
    </map>
  </property>
</component>
```

`<map>` タグで設定。マップのキーがタグ名、マップの値がタグ値に対応する。

上記設定の場合、収集されるメトリクスは次のようになる。

```
（省略）
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.start.time{bar=BAR,foo=FOO} value=444224h 29m 38.875000064s
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: process.uptime{bar=BAR,foo=FOO} value=27.849s
2020-09-04 17:30:06.656 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.count{bar=BAR,foo=FOO} value=8
2020-09-04 17:30:06.657 [INFO ]      i.m.c.i.l.LoggingMeterRegistry: system.cpu.usage{bar=BAR,foo=FOO} value=0.475654
```

全てのメトリクスに、`foo=FOO`、`bar=BAR` のタグが設定されていることが確認できる。

## Datadog と連携する

**モジュール**:
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-datadog</artifactId>
  <version>1.13.0</version>
</dependency>
```

**クラス**: `nablarch.integration.micrometer.datadog.DatadogMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.datadog.DatadogMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

設定プロパティ（`micrometer.properties`）:
- `nablarch.micrometer.datadog.apiKey=XXXXXXXXXXXXXXXX` — APIキー
- `nablarch.micrometer.datadog.uri=<サイトURL>` — サイトURL
- `nablarch.micrometer.datadog.enabled=false` — 連携無効化（環境変数で上書き可能）

> **重要**: 連携を無効にした場合も、`nablarch.micrometer.datadog.apiKey` には何らかの値（ダミー可）を設定しておく必要がある。

**クラス**: `nablarch.integration.micrometer.instrument.batch.BatchTransactionTimeMetricsLogger`

`BatchTransactionTimeMetricsLogger` を使用することで、[nablarch_batch](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch_batch.md) のトランザクション単位の処理時間をメトリクスとして計測できる。

- メトリクス名: `batch.transaction.time`（`setMetricsName(String)` で変更可能）

タグ：

| タグ名 | 説明 |
|---|---|
| `class` | アクションのクラス名（[-requestPath](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md) から取得した値） |

`BatchTransactionTimeMetricsLogger` は `CommitLogger` インタフェースを実装し、`increment(long)` の呼び出し間隔を計測することでトランザクション単位の時間を計測する。このため、`commitLogger` という名前でコンポーネント定義することで動作する。

`BatchTransactionTimeMetricsLogger` を直接 `commitLogger` という名前で定義すると、デフォルトの `BasicCommitLogger` が動作しなくなる。`CompositeCommitLogger` を使用して `BasicCommitLogger` と併用すること。

**XML設定例**:
```xml
<component name="commitLogger"
           class="nablarch.core.log.app.CompositeCommitLogger">
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

`CompositeCommitLogger` を `commitLogger` という名前でコンポーネントとして定義し、`commitLoggerList` プロパティに `BasicCommitLogger` と `BatchTransactionTimeMetricsLogger` を設定する。これにより [loop_handler](../handlers/handlers-loop_handler.md) がトランザクションをコミットする際に両方が呼び出される。

**クラス**: `nablarch.integration.micrometer.instrument.binder.logging.LogCountMetrics`

ログレベルごとの出力回数をCounterを使って `log.count` という名前で計測する。メトリクス名は `MetricsMetaData` を受け取る `コンストラクタ` で変更可能。

**メトリクスタグ**:

| タグ名 | 説明 |
|---|---|
| `level` | ログレベル |
| `logger` | `LoggerManager` からロガーを取得するときに使用した名前 |

<details>
<summary>keywords</summary>

DefaultMeterBinderListProvider, LoggingMeterRegistryFactory, BasicApplicationDisposer, MeterBinder, JvmMemoryMetrics, ProcessorMetrics, micrometer.properties, JVMメトリクス収集, メトリクス設定, 廃棄処理, meterBinderListProvider, applicationDisposer, 実行結果, LoggingMeterRegistry, jvm.gc.count, jvm.memory.committed, jvm.threads.live, process.cpu.usage, system.cpu.count, MeterRegistryFactory, tags, 共通タグ設定, メトリクスタグ, Map<String, String>, DatadogMeterRegistryFactory, Datadogメトリクス連携, micrometer-registry-datadog, nablarch.micrometer.datadog.apiKey, nablarch.micrometer.datadog.uri, nablarch.micrometer.datadog.enabled, BatchTransactionTimeMetricsLogger, CompositeCommitLogger, BasicCommitLogger, CommitLogger, setMetricsName, バッチ処理時間計測, トランザクション単位処理時間, commitLogger設定, batch.transaction.time, LogCountMetrics, log.count, LoggerManager, MetricsMetaData, ログレベル出力回数計測, Counter, level, logger

</details>

## レジストリファクトリ

| レジストリ | ファクトリクラス | バージョン |
|---|---|---|
| SimpleMeterRegistry | `SimpleMeterRegistryFactory` | 1.0.0以上 |
| LoggingMeterRegistry | `LoggingMeterRegistryFactory` | 1.0.0以上 |
| CloudWatchMeterRegistry | `CloudWatchMeterRegistryFactory` | 1.0.0以上 |
| DatadogMeterRegistry | `DatadogMeterRegistryFactory` | 1.0.0以上 |
| StatsdMeterRegistry | `StatsdMeterRegistryFactory` | 1.0.0以上 |
| OtlpMeterRegistry | `OtlpMeterRegistryFactory` | 1.3.0以上 |

## CloudWatch と連携する

**モジュール**:
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-cloudwatch2</artifactId>
  <version>1.13.0</version>
</dependency>
```

**クラス**: `nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.cloudwatch.CloudWatchMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

リージョン・アクセスキーはAWS SDKの方法で設定する（`micrometer-registry-cloudwatch2`はAWS SDKを使用）:
```bash
export AWS_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=YYYYYYYYYYYYYYYYYYYYY
```

設定プロパティ（`micrometer.properties`）:
- `nablarch.micrometer.cloudwatch.namespace=test` — カスタム名前空間
- `nablarch.micrometer.cloudwatch.enabled=false` — 連携無効化（環境変数で上書き可能）

> **重要**: 連携を無効にした場合も、`nablarch.micrometer.cloudwatch.namespace` と環境変数 `AWS_REGION` には何らかの値（ダミー可）を設定しておく必要がある。

### より詳細な設定（カスタムプロバイダ）

OS環境変数や設定ファイルでは指定できない詳細な設定が必要な場合は、`CloudWatchAsyncClientProvider` を実装したカスタムプロバイダを作成する。

**カスタムプロバイダの実装例**:
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

`CloudWatchAsyncClientProvider` は `CloudWatchAsyncClient` を提供する `provide()` メソッドを持つ。カスタムプロバイダでは、任意の設定を行った `CloudWatchAsyncClient` を構築して返すように `provide()` メソッドを実装する。

**カスタムプロバイダのコンポーネント定義**:
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

作成したカスタムプロバイダは `CloudWatchMeterRegistryFactory` の `cloudWatchAsyncClientProvider` プロパティに設定する。これにより、カスタムプロバイダが生成した `CloudWatchAsyncClient` がメトリクスの連携で使用されるようになる。

> **補足**: デフォルトでは [CloudWatchAsyncClient.create()](https://javadoc.io/static/software.amazon.awssdk/cloudwatch/2.13.4/software/amazon/awssdk/services/cloudwatch/CloudWatchAsyncClient.html#create--) で作成されたインスタンスが使用される。

`LogCountMetrics` はログ出力イベントを検知するために `LogPublisher` の仕組みを使用している。

したがって `LogCountMetrics` を使い始めるためには、まず `LogPublisher` の設定をする必要がある。`LogPublisher` の設定については、[log-publisher_usage](../libraries/libraries-log.md) を参照のこと。

<details>
<summary>keywords</summary>

SimpleMeterRegistry, LoggingMeterRegistry, CloudWatchMeterRegistry, DatadogMeterRegistry, StatsdMeterRegistry, OtlpMeterRegistry, SimpleMeterRegistryFactory, LoggingMeterRegistryFactory, CloudWatchMeterRegistryFactory, DatadogMeterRegistryFactory, StatsdMeterRegistryFactory, OtlpMeterRegistryFactory, レジストリファクトリ一覧, CloudWatchメトリクス連携, micrometer-registry-cloudwatch2, CloudWatchAsyncClientProvider, CustomCloudWatchAsyncClientProvider, cloudWatchAsyncClientProvider, nablarch.micrometer.cloudwatch.namespace, nablarch.micrometer.cloudwatch.enabled, AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, LogPublisher, log-publisher_usage, LogCountMetrics, ログ出力イベント検知

</details>

## 設定ファイル

### 配置場所

クラスパス直下に `micrometer.properties` という名前で配置する。

### フォーマット

```
nablarch.micrometer.<subPrefix>.<key>=設定する値
```

`<subPrefix>` はレジストリファクトリごとに以下の値を指定する:

| レジストリファクトリ | subPrefix |
|---|---|
| SimpleMeterRegistryFactory | simple |
| LoggingMeterRegistryFactory | logging |
| CloudWatchMeterRegistryFactory | cloudwatch |
| DatadogMeterRegistryFactory | datadog |
| StatsdMeterRegistryFactory | statsd |
| OtlpMeterRegistryFactory | otlp |

`<key>` には Micrometerが各レジストリ用に提供している [設定クラス](https://javadoc.io/doc/io.micrometer/micrometer-core/1.13.0/io/micrometer/core/instrument/config/MeterRegistryConfig.html) で定義されたメソッドと同じ名前を指定する。例: `DatadogMeterRegistry` に対しては `DatadogConfig` という設定クラスが用意されており、`nablarch.micrometer.datadog.apiKey=XXXXXXXXXXXXXXXXXXXX` のように設定できる。

### OS環境変数・システムプロパティによる上書き

設定値の優先度（高い順）:
1. システムプロパティ
2. OS環境変数
3. `micrometer.properties` の設定値

OS環境変数で上書きする場合の名前ルールは [OS環境変数の名前について](../libraries/libraries-repository.md) を参照。

### プレフィックスの変更

各レジストリファクトリの `prefix` プロパティ（`MeterRegistryFactory` が提供）で変更できる。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="prefix" value="sample.prefix" />
</component>
```

上記設定後、`micrometer.properties` に `sample.prefix.step=10s` のように記述できる。

### 設定ファイルの場所の変更

`xmlConfigPath` プロパティ（`MeterRegistryFactory` が提供）に、設定ファイルを読み込むXMLファイルのパスを指定する。

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.logging.LoggingMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
  <property name="xmlConfigPath" value="config/metrics.xml" />
</component>
```

`xmlConfigPath` で指定した場所に設定ファイルを読み込むXMLを配置する（コンポーネント設定ファイルと同じ書式）:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<component-configuration
        xmlns="http://tis.co.jp/nablarch/component-configuration"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration https://nablarch.github.io/schema/component-configuration.xsd">
  <config-file file="config/metrics.properties" />
</component-configuration>
```

> **補足**: このXMLファイルでコンポーネントを定義しても、システムリポジトリから参照を取得できない。

## Azure と連携する

MicrometerでAzureに連携するには、Java 3.0エージェントを使用する。Java 3.0エージェントはMicrometerの[グローバルレジストリ](https://docs.micrometer.io/micrometer/reference/concepts/registry.html#_global_registry)に出力されたメトリクスを自動収集してAzureに連携する。

> **重要**: Java 3.0エージェントは初期化処理中に大量のjarファイルをロードするためGCが頻発する。アプリケーション起動後しばらくはGCの影響で性能が一時的に劣化する可能性がある。また高負荷時にはエージェントの処理によるオーバーヘッドが性能に影響する可能性があるため、性能試験では本番同様にJava 3.0エージェントを導入して想定内の性能になることを確認すること。

設定手順:
1. 起動オプションにJava 3.0エージェントを追加する（[Azureのドキュメント](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/opentelemetry-enable?tabs=java#modify-your-application)参照）
2. `MeterRegistry`にグローバルレジストリを使うコンポーネントを定義する

**クラス**: `nablarch.integration.micrometer.GlobalMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.GlobalMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

> **補足**: Java 3.0エージェントを使う方法ではAzure用の`MeterRegistry`は使用しないため、Azure用モジュールを依存関係に追加しなくてもメトリクスを連携できる。

> **重要**: 本アダプタ用の設定ファイル `micrometer.properties` は使用できないが、ファイルは配置しておく必要がある（内容は空で可）。

連携を無効にするには、Java 3.0エージェントを使用せずにアプリケーションを起動する。詳細設定はJava 3.0エージェントが提供する方法で行う（[構成オプション](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/java-standalone-config)参照）。

`LogCountMetrics` は `MeterBinder` の実装クラスとして提供されている。したがって、`DefaultMeterBinderListProvider` を継承したクラスを作り、`LogCountMetrics` を含んだ `MeterBinder` のリストを返すように実装する必要がある。

`DefaultMeterBinderListProvider` の説明については、[micrometer_adaptor_declare_default_meter_binder_list_provider_as_component](#s2) を参照。

```java
public class CustomMeterBinderListProvider extends DefaultMeterBinderListProvider {
    @Override
    protected List<MeterBinder> createMeterBinderList() {
        // デフォルトの MeterBinder リストに LogCountMetrics を追加
        List<MeterBinder> meterBinderList = new ArrayList<>(super.createMeterBinderList());
        meterBinderList.add(new LogCountMetrics());
        return meterBinderList;
    }
}
```

最後に、`MeterRegistryFactory` コンポーネントの `meterBinderListProvider` プロパティに、作成したカスタムの `DefaultMeterBinderListProvider` を設定する。以上で、`LogCountMetrics` が使用できるようになる。

<details>
<summary>keywords</summary>

micrometer.properties, nablarch.micrometer, subPrefix, システムプロパティ, OS環境変数, prefix, xmlConfigPath, 設定ファイル, 設定上書き, プレフィックス変更, MeterRegistryFactory, DatadogConfig, Azureメトリクス連携, GlobalMeterRegistryFactory, Java 3.0エージェント, グローバルレジストリ, Azure Monitor Application Insights, DefaultMeterBinderListProvider, MeterBinder, LogCountMetrics, CustomMeterBinderListProvider, createMeterBinderList, meterBinderListProvider, micrometer_adaptor_declare_default_meter_binder_list_provider_as_component

</details>

## StatsD で連携する

## StatsD で連携する

Datadogは[DogStatsD](https://docs.datadoghq.com/ja/developers/dogstatsd/?tab=hostagent)というStatsDプロトコルを使った連携をサポートしている。`micrometer-registry-statsd`モジュールでStatsDによるDatadog連携が可能。

**モジュール**:
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-statsd</artifactId>
  <version>1.13.0</version>
</dependency>
```

**クラス**: `nablarch.integration.micrometer.statsd.StatsdMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.statsd.StatsdMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

デフォルト値はDogStatsDをデフォルト構成でインストールした場合と一致するため、デフォルト構成のDogStatsDでは明示的な設定不要。デフォルト以外の構成の場合は`StatsdConfig`を参照して設定する。

設定プロパティ（`micrometer.properties`）:
- `nablarch.micrometer.statsd.port=9999` — ポート変更例
- `nablarch.micrometer.statsd.enabled=false` — 連携無効化（環境変数で上書き可能）

デフォルトでは、`WARN` 以上のログ出力回数のみが集計の対象となる。

集計対象のログレベルのしきい値は、`LogCountMetrics` のコンストラクタに `LogLevel` を渡すことで変更できる。以下の実装例では、しきい値を `INFO` に変更している。

```java
meterBinderList.add(new LogCountMetrics(LogLevel.INFO)); // LogLevel のしきい値を指定
```

> **重要**: ログレベルのしきい値を下げすぎると、アプリケーションによっては大量のメトリクスが収集される可能性がある。使用する監視サービスの料金体系によっては使用料金が増大する可能性があるため、注意して設定すること。

<details>
<summary>keywords</summary>

StatsdMeterRegistryFactory, StatsDメトリクス連携, micrometer-registry-statsd, DogStatsD, nablarch.micrometer.statsd.enabled, nablarch.micrometer.statsd.port, LogLevel, LogCountMetrics, WARN, INFO, ログレベルしきい値, 集計対象

</details>

## OpenTelemetry Protocol (OTLP) で連携する

## OpenTelemetry Protocol (OTLP) で連携する

多くの監視サービスがOpenTelemetryをサポートしており、`micrometer-registry-otlp`モジュールでOTLPによる各種監視サービス連携が可能。

> **重要**: どの連携方法が利用可能かは監視サービスによって異なるため、使用する監視サービスの情報を確認すること（例: [Datadog](https://docs.datadoghq.com/ja/opentelemetry/)、[New Relic](https://docs.newrelic.com/jp/docs/opentelemetry/opentelemetry-introduction)、[Prometheus OTLP Receiver](https://prometheus.io/docs/prometheus/latest/querying/api/#otlp-receiver)）。

**モジュール**:
```xml
<dependency>
  <groupId>io.micrometer</groupId>
  <artifactId>micrometer-registry-otlp</artifactId>
  <version>1.13.0</version>
</dependency>
```

**クラス**: `nablarch.integration.micrometer.otlp.OtlpMeterRegistryFactory`

```xml
<component name="meterRegistry" class="nablarch.integration.micrometer.otlp.OtlpMeterRegistryFactory">
  <property name="meterBinderListProvider" ref="meterBinderListProvider" />
  <property name="applicationDisposer" ref="disposer" />
</component>
```

設定プロパティ（`micrometer.properties`）:
- `nablarch.micrometer.otlp.url=http://localhost:9090/api/v1/otlp/v1/metrics` — 送信先URL
- `nablarch.micrometer.otlp.headers=key1=value1,key2=value2` — 認証APIキー等のヘッダ情報
- `nablarch.micrometer.otlp.enabled=false` — 連携無効化（環境変数で上書き可能）

**クラス**: `nablarch.integration.micrometer.instrument.dao.SqlTimeMetricsDaoContext`

[universal_dao](../libraries/libraries-universal_dao.md) を通じて実行したSQLの処理時間をTimerを使って `sql.process.time` という名前で計測する。メトリクス名はファクトリクラス `SqlTimeMetricsDaoContextFactory` の `setMetricsName(String)` で変更可能。

**メトリクスタグ**:

| タグ名 | 説明 |
|---|---|
| `sql.id` | `DaoContext` のメソッド引数に渡されたSQLID（SQLIDが無い場合は `"None"`） |
| `entity` | エンティティクラスの名前（`Class.getName()`） |
| `method` | 実行された `DaoContext` のメソッド名 |

**設定方法**: `SqlTimeMetricsDaoContextFactory` を **`daoContextFactory`** という名前でコンポーネント定義する。これにより [universal_dao](../libraries/libraries-universal_dao.md) が使用する `DaoContext` が `SqlTimeMetricsDaoContext` に置き換わる。

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

<details>
<summary>keywords</summary>

OtlpMeterRegistryFactory, OTLPメトリクス連携, micrometer-registry-otlp, OpenTelemetry, nablarch.micrometer.otlp.url, nablarch.micrometer.otlp.headers, nablarch.micrometer.otlp.enabled, SqlTimeMetricsDaoContext, SqlTimeMetricsDaoContextFactory, sql.process.time, DaoContext, daoContextFactory, SQL処理時間計測, UniversalDAO, Timer, setMetricsName, sql.id, entity, method, BasicDaoContextFactory, SequenceIdGenerator

</details>
