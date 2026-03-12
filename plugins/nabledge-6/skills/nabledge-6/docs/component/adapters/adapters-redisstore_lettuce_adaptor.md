# Redisストア(Lettuce)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor/redisstore_lettuce_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClientProvider.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/BasicApplicationInitializer.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/BasicApplicationDisposer.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceSimpleRedisClient.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceMasterReplicaRedisClient.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceClusterRedisClient.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClient.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/Initializable.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/Disposable.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionEntry.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeStateEncoder.html)

## 最小構成で動かす

セッションストアにRedisを使用すると、DBストアと比較して次のメリットが得られる:
- セッション情報を保存するためのテーブルを事前に用意する必要がない
- 有効期限が切れたセッション情報を削除するためのバッチを作る必要がない

> **補足**: ローカルで試す場合、Dockerを使って `docker run --name redis -d -p 6379:6379 redis:5.0.9` でRedisインスタンスを構築できる。停止: `docker stop redis`

## コンポーネント設定ファイルの修正

以下の2ファイルをコンポーネント設定ファイルに読み込む:

```xml
<config-file file="nablarch/webui/redisstore-lettuce.config" />
<config-file file="common.properties" />
<config-file file="env.properties" />

<import file="nablarch/webui/redisstore-lettuce.xml" />
```

- `nablarch/webui/redisstore-lettuce.config`: `redisstore-lettuce.xml` で使用するプレースホルダのデフォルト値を宣言
- `nablarch/webui/redisstore-lettuce.xml`: Redisストアに必要なコンポーネントが定義されている

> **重要**: `redisstore-lettuce.config` はアプリの環境設定ファイル（`env.properties` 等）より**前**に読み込むこと。これによりアプリ側でデフォルト値を上書きできる。

[repository-overwrite_environment_configuration_by_os_env_var](../libraries/libraries-repository.md) の方法を用いることで、実行環境ごとに接続先のRedisを切り替えられる。

> **補足**: デフォルトでは `localhost:6379` の単一Redisインスタンスに接続する設定になっている。

`redisstore-lettuce.xml` を使用すると `nablarch/webui/session-store.xml` は不要。:ref:`ウェブのアーキタイプ <firstStepGenerateWebBlankProject>` でプロジェクトを生成している場合、`session-store.xml` のインポートを削除し `redisstore-lettuce.xml` をインポートするよう修正する。

`LettuceRedisClientProvider` を `BasicApplicationInitializer` の `initializeList` に追加する（コンポーネント名 `lettuceRedisClientProvider` は `redisstore-lettuce.xml` で定義済みのため名前参照で指定可能）:

```xml
<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="lettuceRedisClientProvider"/>
    </list>
  </property>
</component>
```

`BasicApplicationDisposer` の `disposableList` にも追加する（[repository-dispose_object](../libraries/libraries-repository.md) 参照）:

```xml
<component name="disposer"
           class="nablarch.core.repository.disposal.BasicApplicationDisposer">
  <property name="disposableList">
    <list>
      <component-ref name="lettuceRedisClientProvider"/>
    </list>
  </property>
</component>
```

## 環境設定値の修正

```properties
nablarch.sessionManager.defaultStoreName=redis
```

> **補足**: :ref:`ウェブのアーキタイプ <firstStepGenerateWebBlankProject>` でプロジェクトを生成している場合、`src/main/resources/common.properties` に `nablarch.sessionManager.defaultStoreName` が宣言されている。

各クライアントクラスは `Disposable` を実装しており、`dispose()` でRedisへの接続を閉じることができる。

`BasicApplicationDisposer` の `disposableList` プロパティに使用するクライアントクラスのコンポーネントを設定することで、アプリケーション終了時にRedisとの接続を閉じることができる。

```xml
<component name="disposer"
           class="nablarch.core.repository.disposal.BasicApplicationDisposer">
  <property name="disposableList">
    <list>
      <component-ref name="lettuceRedisClientProvider"/>
    </list>
  </property>
</component>
```

`BasicApplicationInitializer` の `initializeList` と同様で、`disposableList` プロパティに `LettuceRedisClientProvider` コンポーネントを指定することで、実際に使用されるクライアントクラスの廃棄処理が実行される。

<details>
<summary>keywords</summary>

LettuceRedisClientProvider, lettuceRedisClientProvider, BasicApplicationInitializer, BasicApplicationDisposer, initializeList, disposableList, nablarch.sessionManager.defaultStoreName, redisstore-lettuce.config, redisstore-lettuce.xml, Redisストア最小構成, セッションストア設定, コンポーネント定義修正, 環境設定値, Disposable, dispose, Redisコネクション廃棄, アプリケーション終了処理

</details>

## Redis の構成に合わせて設定する

本番環境では以下の構成のRedisに接続できる必要がある:
- Sentinelを使用したMaster-Replica構成
- Cluster構成

## 構成ごとのクライアントクラス

`LettuceRedisClient` を実装したクラスが構成ごとに用意されている:

- `LettuceSimpleRedisClient`: 単一Redisインスタンスへの直接接続
- `LettuceMasterReplicaRedisClient`: Master-Replica構成（Sentinel経由も含む）
- `LettuceClusterRedisClient`: Cluster構成

> **補足**: これらのコンポーネントは `redisstore-lettuce.xml` で定義されているので、利用者側で定義する必要はない。

## クライアントクラスの選択

環境設定値 `nablarch.lettuce.clientType` で使用するクライアントクラスを設定する:

| 設定値 | クライアントクラス |
|---|---|
| `simple` | `LettuceSimpleRedisClient` |
| `masterReplica` | `LettuceMasterReplicaRedisClient` |
| `cluster` | `LettuceClusterRedisClient` |

> **補足**: `nablarch.lettuce.clientType` のデフォルト値は `simple`（`redisstore-lettuce.config` で設定）。

## 接続URIの設定

| Redisの構成 | 環境設定値 | デフォルト値 |
|---|---|---|
| 単一 | `nablarch.lettuce.simple.uri` | `redis://localhost:6379` |
| Master-Replica | `nablarch.lettuce.masterReplica.uri` | `redis-sentinel://localhost:26379,localhost:26380,localhost:26381?sentinelMasterId=masterGroupName` |
| Cluster | `nablarch.lettuce.cluster.uriList` | `redis://localhost:6379,redis://localhost:6380,redis://localhost:6381` |

Clusterの `uriList` は各ノードのURIを半角カンマで列挙する。URIフォーマットの詳細は [Lettuceのドキュメント](https://redis.github.io/lettuce/user-guide/connecting-redis/#uri-syntax) を参照。

## より高度な設定

環境設定値で指定できるのはクライアントクラスの種類とURIのみ。より細かい設定には各クライアントクラスを継承したカスタムクライアントクラスを作成する。

各クライアントクラスに用意されている `protected` メソッド:

| クライアントクラス | メソッド | 戻り値の型 |
|---|---|---|
| `LettuceSimpleRedisClient` | `createClient()` | [RedisClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/RedisClient.html) |
| | `createConnection(RedisClient)` | [StatefulRedisConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/api/StatefulRedisConnection.html) |
| `LettuceMasterReplicaRedisClient` | `createClient()` | [RedisClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/RedisClient.html) |
| | `createConnection(RedisClient)` | [StatefulRedisMasterReplicaConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/masterreplica/StatefulRedisMasterReplicaConnection.html) |
| `LettuceClusterRedisClient` | `createClient()` | [RedisClusterClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/cluster/RedisClusterClient.html) |
| | `createConnection(RedisClusterClient)` | [StatefulRedisClusterConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/cluster/api/StatefulRedisClusterConnection.html) |

これらのメソッドをオーバーライドして独自設定したLettuceインスタンスを返すように実装し、元のコンポーネントと同じ名前でコンポーネント定義することでクライアントクラスを差し替えられる:

| クライアントクラス | コンポーネント名 |
|---|---|
| `LettuceSimpleRedisClient` | `lettuceSimpleRedisClient` |
| `LettuceMasterReplicaRedisClient` | `lettuceMasterReplicaRedisClient` |
| `LettuceClusterRedisClient` | `lettuceClusterRedisClient` |

**例: Clusterのトポロジ更新監視を有効にする**

`LettuceClusterRedisClient` を継承し `createClient()` をオーバーライドしてカスタムクライアントクラスを作成する:

```java
public class CustomClusterRedisClient extends LettuceClusterRedisClient {

    @Override
    protected RedisClusterClient createClient() {
        List<RedisURI> redisUriList = uriList.stream().map(RedisURI::create).collect(Collectors.toList());
        RedisClusterClient client = RedisClusterClient.create(redisUriList);

        ClusterTopologyRefreshOptions clusterTopologyRefreshOptions = ClusterTopologyRefreshOptions.builder()
                .enableAllAdaptiveRefreshTriggers()
                .enablePeriodicRefresh(Duration.ofSeconds(10))
                .build();

        ClusterClientOptions clusterClientOptions = ClusterClientOptions.builder()
                .topologyRefreshOptions(clusterTopologyRefreshOptions)
                .build();

        client.setOptions(clusterClientOptions);

        return client;
    }
}
```

`lettuceClusterRedisClient` という名前でコンポーネント定義することで元のコンポーネントを上書きできる:

```xml
<import file="nablarch/webui/redisstore-lettuce.xml" />

<component name="lettuceClusterRedisClient" class="com.nablarch.example.redisstore.CustomClusterRedisClient">
  <property name="uriList" ref="redisClusterUriListFactory" />
</component>
```

> **補足**: `uriList` プロパティは `redisstore-lettuce.xml` の設定をそのまま流用すること。他のクライアントクラスを拡張する場合も同様。Lettuceの詳細は [Lettuceのドキュメント](https://redis.github.io/lettuce/advanced-usage/#cluster-specific-options) を参照。

Redisに保存されたセッション情報のキー形式: `nablarch.session.<セッションID>`

```shell
127.0.0.1:6379> keys *
1) "nablarch.session.8b00bce5-d19f-4f63-b1fe-d14ecca9a4f6"
```

セッション情報（`SessionEntry` のリスト）は、デフォルトで `JavaSerializeStateEncoder` でエンコードされたバイナリ形式で保存される。

エンコーダーの変更: `serializeEncoder` という名前で別のエンコーダーコンポーネントを定義することで変更できる。

<details>
<summary>keywords</summary>

LettuceSimpleRedisClient, LettuceMasterReplicaRedisClient, LettuceClusterRedisClient, LettuceRedisClient, lettuceSimpleRedisClient, lettuceMasterReplicaRedisClient, lettuceClusterRedisClient, nablarch.lettuce.clientType, nablarch.lettuce.simple.uri, nablarch.lettuce.masterReplica.uri, nablarch.lettuce.cluster.uriList, Redis構成設定, Sentinel, Cluster構成, Master-Replica構成, カスタムクライアントクラス, createClient, createConnection, RedisClient, RedisClusterClient, StatefulRedisConnection, StatefulRedisMasterReplicaConnection, StatefulRedisClusterConnection, ClusterTopologyRefreshOptions, ClusterClientOptions, JavaSerializeStateEncoder, SessionEntry, serializeEncoder, セッションキー形式, セッション情報エンコード, nablarch.session

</details>

## 使用するクライアントクラスの決定の仕組み

`LettuceRedisClientProvider` が使用するクライアントクラスを決定する。`clientType` プロパティの値と各クライアントクラスの `getType()` メソッドの戻り値を比較し、一致したコンポーネントを使用するクライアントクラスとして決定する。

`redisstore-lettuce.xml` での定義:

```xml
<component name="lettuceRedisClientProvider" class="nablarch.integration.redisstore.lettuce.LettuceRedisClientProvider">
    <property name="clientType" value="${nablarch.lettuce.clientType}" />
    <property name="clientList">
        <list>
            <component-ref name="lettuceSimpleRedisClient" />
            <component-ref name="lettuceMasterReplicaRedisClient" />
            <component-ref name="lettuceClusterRedisClient" />
        </list>
    </property>
</component>
```

- `clientList`: 候補となるクライアントクラスのコンポーネントリスト
- `clientType`: 使用するクライアントクラスの識別子（`nablarch.lettuce.clientType` 環境設定値から取得）

`LettuceRedisClientProvider` は `ComponentFactory` を実装しており、`createObject()` は決定された `LettuceRedisClient` のコンポーネントを返す。

本アダプタはセッションの有効期限管理にRedisの有効期限の仕組みを使用している。有効期限が切れたセッション情報は自動的に削除されるため、ゴミデータを削除するバッチを用意する必要はない。

有効期限の確認は [pttl コマンド（外部サイト、英語）](https://redis.io/docs/latest/commands/pttl/) で行える。

```shell
127.0.0.1:6379> pttl "nablarch.session.8b00bce5-d19f-4f63-b1fe-d14ecca9a4f6"
(integer) 879774
```

<details>
<summary>keywords</summary>

LettuceRedisClientProvider, ComponentFactory, LettuceRedisClient, clientType, clientList, getType, createObject, クライアントクラス決定, Redis有効期限, TTL, セッション有効期限管理, 自動削除, pttl, 有効期限切れセッション

</details>

## クライアントクラスの初期化

3つのクライアントクラスはいずれも `Initializable` を実装しており、`initialize()` メソッドの実行によりRedisへの接続が確立される。使用するクライアントクラスのコンポーネントを `BasicApplicationInitializer` の `initializeList` に設定する必要がある。

`initializeList` には個別のクライアントクラスではなく `lettuceRedisClientProvider` を使用する。こうすることで、コンポーネント定義を変更することなく [redisstore_mechanism_to_decide_client](#s2) で決定されたクライアントクラスを初期化できる:

```xml
<component name="initializer"
           class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="lettuceRedisClientProvider"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

Initializable, initialize, BasicApplicationInitializer, LettuceRedisClientProvider, initializeList, クライアント初期化, Redis接続確立

</details>
