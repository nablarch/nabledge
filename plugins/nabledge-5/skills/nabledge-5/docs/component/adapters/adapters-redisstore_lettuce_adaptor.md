# Redisストア(Lettuce)アダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/lettuce_adaptor/redisstore_lettuce_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClientProvider.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/BasicApplicationInitializer.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/BasicApplicationDisposer.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceSimpleRedisClient.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceMasterReplicaRedisClient.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceClusterRedisClient.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/redisstore/lettuce/LettuceRedisClient.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/di/ComponentFactory.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/initialization/Initializable.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/repository/disposal/Disposable.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionEntry.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeStateEncoder.html)

## 最小構成で動かす

セッションストアにRedisを使用することでDBストアと比較して次のメリットが得られる:
- セッション情報を保存するためのテーブルを事前に用意する必要がない
- 有効期限が切れたセッション情報を削除するためのバッチを作る必要がない

`localhost:6379` で起動する単一Redisインスタンスへの接続設定。

> **補足**: ローカル確認はDockerで実行可能: `docker run --name redis -d -p 6379:6379 redis:5.0.9`、停止: `docker stop redis`

## コンポーネント設定ファイルの修正

```xml
<config-file file="nablarch/webui/redisstore-lettuce.config" />
<config-file file="common.properties" />
<config-file file="env.properties" />

<import file="nablarch/webui/redisstore-lettuce.xml" />
```

- `nablarch/webui/redisstore-lettuce.config`: `redisstore-lettuce.xml` で使用するプレースホルダのデフォルト値を定義
- `nablarch/webui/redisstore-lettuce.xml`: Redisストアに必要なコンポーネントを定義

> **重要**: `redisstore-lettuce.config` はアプリケーションの環境設定ファイル（`env.properties` 等）より**前**に読み込むこと。これによりデフォルト値をアプリケーション側で上書き可能になる。[repository-overwrite_environment_configuration_by_os_env_var](../libraries/libraries-repository.md) の方法でRedis接続先を実行環境ごとに切り替えられる。

> **補足**: デフォルトは `localhost:6379` の単一Redisインスタンスに接続するよう設定済み。

`redisstore-lettuce.xml` 使用時は `nablarch/webui/session-store.xml` は不要。:ref:`ウェブのアーキタイプ <firstStepGenerateWebBlankProject>` 生成プロジェクトではデフォルトで `session-store.xml` が使用されているため、削除して `redisstore-lettuce.xml` に差し替えること。

`LettuceRedisClientProvider` を `BasicApplicationInitializer` の `initializeList` に追加（詳細は [redisstore_initialize_client](#s3) 参照）:

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

`LettuceRedisClientProvider` を `BasicApplicationDisposer` の `disposableList` に追加（詳細は [repository-dispose_object](../libraries/libraries-repository.md) 参照）:

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

> **補足**: :ref:`ウェブのアーキタイプ <firstStepGenerateWebBlankProject>` 生成プロジェクトでは `src/main/resources/common.properties` に `nablarch.sessionManager.defaultStoreName` が宣言済み。

各クライアントクラスは `Disposable` を実装しており、`dispose()` メソッドでRedisへの接続を閉じる。アプリケーション終了時に接続を閉じるには、クライアントクラスのコンポーネントを `BasicApplicationDisposer` の `disposableList` プロパティに設定する。

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

`disposableList` に `LettuceRedisClientProvider` コンポーネントを指定することで、実際に使用されるクライアントクラスの廃棄処理が実行される。

<details>
<summary>keywords</summary>

LettuceRedisClientProvider, BasicApplicationInitializer, BasicApplicationDisposer, lettuceRedisClientProvider, nablarch.sessionManager.defaultStoreName, redisstore-lettuce.config, redisstore-lettuce.xml, session-store.xml, Redis セッションストア 最小構成, コンポーネント設定, 環境設定値, initializeList, disposableList, DBストア テーブル不要, 期限切れセッション削除バッチ不要, Redisメリット, Disposable, 廃棄処理, 接続クローズ, アプリケーション終了時

</details>

## Redis の構成に合わせて設定する

本番環境では以下のRedis構成に対応する必要がある:
- Sentinelを使用したMaster-Replica構成
- Cluster構成

## 構成ごとのクライアントクラス

| クライアントクラス | 用途 |
|---|---|
| `LettuceSimpleRedisClient` | 単一Redisインスタンスへの直接接続 |
| `LettuceMasterReplicaRedisClient` | Master-Replica構成（Sentinel経由含む） |
| `LettuceClusterRedisClient` | Cluster構成 |

> **補足**: これらのコンポーネントは `redisstore-lettuce.xml` で定義済みのため、利用者側での定義不要。

## 使用するクライアントクラスの設定

環境設定値 `nablarch.lettuce.clientType` で設定する。デフォルト値は `redisstore-lettuce.config` で `simple` に設定済み。

| 設定値 | クライアントクラス |
|---|---|
| `simple` | `LettuceSimpleRedisClient` |
| `masterReplica` | `LettuceMasterReplicaRedisClient` |
| `cluster` | `LettuceClusterRedisClient` |

```properties
nablarch.lettuce.clientType=cluster
```

## 接続URIの設定

| Redisの構成 | 環境設定値 | デフォルト値 |
|---|---|---|
| 単一 | `nablarch.lettuce.simple.uri` | `redis://localhost:6379` |
| Master-Replica | `nablarch.lettuce.masterReplica.uri` | `redis-sentinel://localhost:26379,localhost:26380,localhost:26381?sentinelMasterId=masterGroupName` |
| Cluster | `nablarch.lettuce.cluster.uriList` | `redis://localhost:6379,redis://localhost:6380,redis://localhost:6381` |

Clusterの `uriList` は各ノードのURIを半角カンマで列挙する。URIフォーマットの詳細は [Lettuceのドキュメント](https://redis.github.io/lettuce/user-guide/connecting-redis/#uri-syntax) を参照。

## より高度な設定（カスタムクライアントクラス）

環境設定値で設定できるのはクライアントクラスの種類とURIのみ。より細かい設定が必要な場合は各クライアントクラスを継承したカスタムクラスを作成する。

各クライアントクラスの `protected` メソッド:

| クライアントクラス | メソッド | 戻り値の型 |
|---|---|---|
| `LettuceSimpleRedisClient` | `createClient()` | [RedisClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/RedisClient.html) |
| | `createConnection(RedisClient)` | [StatefulRedisConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/api/StatefulRedisConnection.html) |
| `LettuceMasterReplicaRedisClient` | `createClient()` | [RedisClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/RedisClient.html) |
| | `createConnection(RedisClient)` | [StatefulRedisMasterReplicaConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/masterreplica/StatefulRedisMasterReplicaConnection.html) |
| `LettuceClusterRedisClient` | `createClient()` | [RedisClusterClient](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/cluster/RedisClusterClient.html) |
| | `createConnection(RedisClusterClient)` | [StatefulRedisClusterConnection\<byte[], byte[]\>](https://www.javadoc.io/static/io.lettuce/lettuce-core/5.3.0.RELEASE/io/lettuce/core/cluster/api/StatefulRedisClusterConnection.html) |

これらのメソッドをオーバーライドして独自のLettuceインスタンスを返すことで任意の設定が可能。差し替えは元のコンポーネントと同じ名前でカスタムクラスのコンポーネントを定義する。

各クライアントクラスのコンポーネント名:

| クライアントクラス | コンポーネント名 |
|---|---|
| `LettuceSimpleRedisClient` | `lettuceSimpleRedisClient` |
| `LettuceMasterReplicaRedisClient` | `lettuceMasterReplicaRedisClient` |
| `LettuceClusterRedisClient` | `lettuceClusterRedisClient` |

### 例: Clusterのトポロジ更新監視を有効にする

`LettuceClusterRedisClient` を継承してカスタムクラスを作成し `createClient()` をオーバーライド:

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

コンポーネント定義（`lettuceClusterRedisClient` という名前で上書き）:

```xml
<import file="nablarch/webui/redisstore-lettuce.xml" />

<component name="lettuceClusterRedisClient" class="com.nablarch.example.redisstore.CustomClusterRedisClient">
  <property name="uriList" ref="redisClusterUriListFactory" />
</component>
```

`uriList` プロパティの設定は `redisstore-lettuce.xml` の設定をそのまま流用する（他のクライアントクラス拡張時も同様）。

セッション情報は `nablarch.session.<セッションID>` というキーで保存される。

デフォルトでは `JavaSerializeStateEncoder` でエンコードされたバイナリ形式で保存される。エンコーダーは `serializeEncoder` という名前でコンポーネントを定義することで変更できる。

<details>
<summary>keywords</summary>

LettuceSimpleRedisClient, LettuceMasterReplicaRedisClient, LettuceClusterRedisClient, LettuceRedisClient, nablarch.lettuce.clientType, nablarch.lettuce.simple.uri, nablarch.lettuce.masterReplica.uri, nablarch.lettuce.cluster.uriList, lettuceSimpleRedisClient, lettuceMasterReplicaRedisClient, lettuceClusterRedisClient, Redis Sentinel Master-Replica Cluster, クライアントクラス選択, 接続URI設定, カスタムクライアントクラス, トポロジ更新, createClient, createConnection, JavaSerializeStateEncoder, SessionEntry, serializeEncoder, セッション情報, セッションキー形式, エンコーダー変更

</details>

## 使用するクライアントクラスの決定の仕組み

`LettuceRedisClientProvider` が、`nablarch.lettuce.clientType` の値に基づき使用するクライアントクラスを決定する。

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

- `clientList`: 候補クライアントクラスのコンポーネントリスト
- `clientType`: 使用するクライアントクラスの識別子

各クライアントクラスは `getType()` メソッドで自身の識別子を返す。`LettuceRedisClientProvider` は `clientType` と各コンポーネントの `getType()` を比較して一致したものを使用クライアントとして決定する。

`LettuceRedisClientProvider` は `ComponentFactory` を実装しており、`createObject()` は決定された `LettuceRedisClient` コンポーネントを返す。

本アダプタはセッション有効期限の管理にRedisのTTL機能を使用する。有効期限が切れたセッション情報は自動的に削除されるため、削除用バッチを用意する必要はない。

有効期限は [pttl コマンド（外部サイト、英語）](https://redis.io/docs/latest/commands/pttl/) で確認できる。

```shell
127.0.0.1:6379> pttl "nablarch.session.8b00bce5-d19f-4f63-b1fe-d14ecca9a4f6"
(integer) 879774
```

<details>
<summary>keywords</summary>

LettuceRedisClientProvider, LettuceRedisClient, ComponentFactory, nablarch.lettuce.clientType, clientType, clientList, getType, クライアントクラス決定, ComponentFactory実装, createObject, 有効期限, TTL, 自動削除, セッション期限切れ, pttl, 削除バッチ不要

</details>

## クライアントクラスの初期化

3つのクライアントクラスはいずれもRedisへの接続確立のために初期化が必要。各クライアントクラスは `Initializable` を実装しており、`initialize()` でRedis接続が確立される。

使用するクライアントクラスのコンポーネントを `BasicApplicationInitializer` の `initializeList` に設定する必要がある。実際の設定は [redisstore_mechanism_to_decide_client](#s2) で説明した `LettuceRedisClientProvider` のコンポーネントを使用する:

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

`lettuceRedisClientProvider` を設定することで、コンポーネント定義を変更せずに、決定されたクライアントクラスのコンポーネントを初期化できる。

<details>
<summary>keywords</summary>

Initializable, BasicApplicationInitializer, LettuceRedisClientProvider, lettuceRedisClientProvider, initializeList, initialize, Redis接続初期化

</details>
