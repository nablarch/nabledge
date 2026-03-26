# 静的データのキャッシュ

## 概要

静的データキャッシュ機能は、静的データをよりアクセス速度が速い媒体にキャッシュすることで、アクセスを高速化する機構を提供する。

- 本機能はリポジトリに登録して使用する。初期化処理は :ref:`repository` が実行する。
- 本機能は他の機能の一部として使用されることを想定しており、単体では使用しない。アプリケーションプログラマは本機能を直接使用しない。

一括ロードを使用する際、`StaticDataLoader` インタフェースの以下4メソッドを実装する必要がある。

| メソッド名 | 用途 |
|---|---|
| `loadAll` | キャッシュするデータを全件取得する。返された全データがキャッシュの初期データとして保持される。 |
| `getId` | データのIDを取得する。戻り値は `java.util.Map` のキーとして使用されるため、キャッシュ上で一意のオブジェクトでなければならない。複合キーの場合は `equals` / `hashCode` を適切に実装したクラスのインスタンスを返すこと。 |
| `getIndexNames` | 作成するインデックス名を全て返す。 |
| `generateIndexKey` | インデックスのキーとなる値を生成する。`getId` がオブジェクトのキャッシュキーに使用されるのに対し、インデックス上のどのキーにオブジェクトが属するかを示す。 |

<details>
<summary>keywords</summary>

StaticDataCache, StaticDataLoader, 静的データキャッシュ, キャッシュ機構, repository, loadAll, getId, generateIndexKey, getIndexNames, 一括ロード, StaticDataLoader実装

</details>

## 特徴

**静的データキャッシュの実装負荷軽減**

キャッシュを使用する機能の実装は以下の2点のみに集約される:
1. 静的データをRDBMSやXMLファイル等の媒体からロードする処理
2. キャッシュした静的データを使用する処理

**インデックス機能**

ID以外の特定のキー（インデックスキー）を指定してキャッシュから静的データを取得できる機能。1つのキーに複数の静的データを紐付けられる。

**注意**: 下記のコードはフレームワークが行う処理であり、通常のアプリケーションでは実装する必要がない。従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

**クラス**: `ExampleDataLoader` implements `StaticDataLoader<ExampleData>`

```java
public class ExampleDataLoader implements StaticDataLoader<ExampleData> {

    public Object getId(ExampleData value) {
        return value.getId();
    }

    public Object generateIndexKey(String indexName, ExampleData value) {
        if (indexName.equals("name")) {
            return value.getName();
        } else {
            throw new IllegalArgumentException(
                    "invalid indexName: indexName = " + indexName);
        }
    }

    public List<String> getIndexNames() {
        List<String> indexNames = new ArrayList<String>();
        indexNames.add("name");
        return indexNames;
    }

    public List<ExampleData> loadAll() {
        return new SimpleDbTransactionExecutor<List<ExampleData>>(dbManager) {
            @Override
            public List<ExampleData> execute(AppDbConnection connection) {
                SqlPStatement stmt = connection
                        .prepareStatement("select id, name from example_data order by id");
                SqlResultSet results = stmt.retrieve();
                List<ExampleData> objs = new ArrayList<ExampleData>();
                for (SqlRow row : results) {
                    objs.add(createData(row));
                }
                return objs;
            }
        }.doTransaction();
    }
}
```

<details>
<summary>keywords</summary>

StaticDataCache, インデックス機能, インデックスキー, キャッシュ実装負荷軽減, 静的データキャッシュ, StaticDataLoader, ExampleDataLoader, SimpleDbTransactionExecutor, AppDbConnection, SqlPStatement, SqlResultSet, 一括ロード実装例

</details>

## 要求

**実装済み**
- 任意のクラスの静的データをキャッシュできる
- IDを指定してキャッシュから静的データを取得できる
- 任意のインデックスキーを指定して、キャッシュから複数の静的データを取得できる
- アプリケーション起動時に永続化した媒体から静的データをロードできる
- 静的データが必要になったタイミングで永続化した媒体からロードできる
- プロセスを再起動することなく再ロードできる

**未検討**
- 頻繁に参照されない静的データをキャッシュから削除することでメモリを節約できる
- 複数のJavaプロセスでキャッシュした静的データを共有できる
- ファイルから静的データをロードできる
- SQL文を記述するだけで、データベース上にある静的データをキャッシュできる

一括ロードを行う場合、`BasicStaticDataCache` の `loadOnStartup` プロパティに `true` を設定する必要がある。その他の設定はオンデマンドロード時と同様。

```xml
<component name="exampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader">
        <component class="nablarch.core.cache.example.ExampleDataLoader" />
    </property>
    <property name="loadOnStartup" value="true"/>
</component>

<component name="staticDataUseExample" class="nablarch.core.cache.example.StaticDataUseExample">
    <property name="cache" ref="exampleDataCache" />
</component>
```

`BasicStaticDataCache` クラスは初期化が必要なため :ref:`repository_initialize` に記述された `Initializable` インタフェースを実装している。以下のように初期化リストに追加すること。

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="exampleDataCache"/>
        </list>
    </property>
</component>
```

<details>
<summary>keywords</summary>

静的データキャッシュ, オンデマンドロード, 一括ロード, 再ロード, インデックスキー, BasicStaticDataCache, loadOnStartup, BasicApplicationInitializer, Initializable, 一括ロード設定, 初期化設定, ExampleDataLoader

</details>

## 構成

![静的データキャッシュ クラス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_Class.jpg)

`nablarch.core.cache.BasicStaticDataCache` の設定プロパティ名と設定内容の一覧。

<details>
<summary>keywords</summary>

StaticDataCache, StaticDataLoader, BasicStaticDataCache, クラス図, loader, loadOnStartup, 設定プロパティ

</details>

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.cache.StaticDataCache` | 静的データのキャッシュを保持するインタフェース |
| `nablarch.core.cache.StaticDataLoader` | 静的データをロードするインタフェース。RDBMSやXMLファイル等の媒体から静的データをロードするクラスはこのインタフェースを実装する |

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `loader` | ○ | `StaticDataLoader` インタフェースを実装したクラスのインスタンスを指定する。 |
| `loadOnStartup` | | 一括ロードの要否を設定する。未指定の場合は一括ロードしない。 |

<details>
<summary>keywords</summary>

nablarch.core.cache.StaticDataCache, nablarch.core.cache.StaticDataLoader, インタフェース定義, キャッシュインタフェース, BasicStaticDataCache, loader, loadOnStartup, StaticDataLoader, 設定プロパティ一覧

</details>

## クラス定義

| クラス名 | 概要 |
|---|---|
| `nablarch.core.cache.StaticDataCache` | StaticDataCacheインタフェースの基本実装クラス。静的データをHashMapに保持する |

元データが更新された際には静的データの再読み込みが必要。アプリケーションの再起動が頻繁に行えない場合、`StaticDataCache` インタフェースの `refresh` メソッドを呼び出すことで再起動なしに再読み込みできる。

**注意**: 下記のコードはプロジェクトのアーキテクトが作成するものである。通常、各アプリケーション・プログラマはこのような実装を行わない。

```java
public class StaticDataUseExample {
    private StaticDataCache<ExampleData> cache;

    public void setCache(StaticDataCache<ExampleData> cache) {
        this.cache = cache;
    }

    public void refreshAndGetValue(String name) {
        // キャッシュをリロードする
        cache.refresh();

        // キャッシュから静的データを取得する
        List<ExampleData> objs = cache.getValues("name", name);
        for (ExampleData obj : objs) {
            System.out.println(obj);
        }
    }
}
```

<details>
<summary>keywords</summary>

nablarch.core.cache.StaticDataCache, BasicStaticDataCache, HashMap, キャッシュ実装クラス, StaticDataCache, StaticDataUseExample, refresh, getValues, 静的データ再読み込み, キャッシュリフレッシュ

</details>

## キャッシュした静的データの取得

`StaticDataCache` インタフェースをフィールドに持ち、 :ref:`di-container` の機能で実装クラスを設定する。

`StaticDataCache#getValue` または `StaticDataCache#getValues` を使用して静的データを取得する。キャッシュにデータが存在しない場合は自動的にロードされるため、呼び出し元はキャッシュの有無を意識する必要がない。

<details>
<summary>keywords</summary>

StaticDataCache, getValue, getValues, DIコンテナ, 静的データ取得, キャッシュ取得, di-container

</details>

## キャッシュされるデータを保持するクラス(ExampleData)

```java
public class ExampleData {
    private String id;
    private String name;
    // setter, getterは省略
}
```

<details>
<summary>keywords</summary>

ExampleData, キャッシュデータクラス, StaticDataCache

</details>

## キャッシュしたデータを使用するクラス

```java
public class StaticDataUseExample {
    // DIによりStaticDataを設定
    private StaticDataCache<ExampleData> cache;

    public void setCache(StaticDataCache<ExampleData> cache) {
        this.cache = cache;
    }

    public void getById(String id) {
        // キャッシュからデータを取得する
        // 利用者は、キャッシュにデータがあるかを意識する必要はない
        ExampleData obj = cache.getValue(id);
        System.out.println("id = " + obj.getId());
        System.out.println("name = " + obj.getName());
    }
}
```

> **警告**: `StaticDataCache#getValue` または `StaticDataCache#getValues` で取得した静的データは、クラスおよびインスタンスのフィールドに保持しないこと。StaticDataCacheのリロード機能が呼ばれた際に更新されないためである。

<details>
<summary>keywords</summary>

StaticDataUseExample, StaticDataCache, getValue, フィールド保持禁止, リロード

</details>

## インデックスを使用した静的データの取得

本機能は、ID以外のキーを指定して静的データを取得できるインデックス機能を持つ。1つのキーに複数の静的データを紐付けられる。

インデックスを使用する場合は `StaticDataCache#getValues` メソッドを使用する。

```java
public class StaticDataUseExample {
    // DIによりStaticDataを設定
    private StaticDataCache<ExampleData> cache;

    public void setCache(StaticDataCache<ExampleData> cache) {
        this.cache = cache;
    }

    public void getByName(String name) {
        // キャッシュからデータを取得する
        // 利用者は、キャッシュにデータがあるかを意識する必要はない
        List<ExampleData> objs = cache.getValues("name", name);
        for (ExampleData obj : objs) {
            System.out.println("id = " + obj.getId());
            System.out.println("name = " + obj.getName());
        }
    }
}
```

<details>
<summary>keywords</summary>

StaticDataUseExample, StaticDataCache, getValues, インデックス取得, インデックスキー

</details>

## キャッシュにデータをロードする方法

**オンデマンドロード**: キャッシュにデータがなかった際に自動的にロード。使用するデータがキャッシュデータの一部に偏る場面（バッチ処理、テスト時のメッセージ等）に有利。起動が速い。

![オンデマンドロード シーケンス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_LoadOnDemandSequence.jpg)

**一括ロード**: アプリケーション起動時に全データをロード。キャッシュミスヒット時の遅延を回避でき、使用するデータがキャッシュデータのほぼ全てとなる場面（Webアプリケーションのメッセージ等）に有利。

![一括ロード シーケンス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_LoadOnStartupSequence.jpg)

いずれの方法でも、キャッシュを使用する実装はデータのロード方法を意識する必要がない。

<details>
<summary>keywords</summary>

オンデマンドロード, 一括ロード, キャッシュロード, バッチ, Webアプリケーション, ロード方法

</details>

## オンデマンドロードの使用方法

**IDを指定してデータを取得する場合**: `StaticDataLoader#getValue` のみを実装すればよい。

**インデックスを指定してデータを取得する場合**: 以下の2メソッドを実装する必要がある:
- `getValues`: データをロードする目的でフレームワークから呼び出される
- `getId`: 同一の静的データを2重に保持しないためにフレームワークから呼び出される。静的データを一意に決定する値を返すように実装する必要がある

<details>
<summary>keywords</summary>

StaticDataLoader, getValue, getValues, getId, オンデマンドロード, インデックス, データロード実装

</details>

## ExampleDataをロードするクラス

> **注意**: 下記はフレームワークが行う処理であり、通常のアプリケーション開発者は実装不要。

```java
public class ExampleDataLoader implements StaticDataLoader<ExampleData> {
    private SimpleDbTransactionManager dbManager;

    public ExampleData getValue(final Object id) {
        return new SimpleDbTransactionExecutor<ExampleData>(dbManager) {
            @Override
            public ExampleData execute(AppDbConnection connection) {
                SqlPStatement stmt = connection.prepareStatement(
                    "select id, name from example_data where id = ? order by id");
                stmt.setString(1, (String) id);
                SqlResultSet results = stmt.retrieve();
                if (results.size() > 0) {
                    return createData(results.get(0));
                }
                return null;
            }
        }.doTransaction();
    }

    public List<ExampleData> getValues(final String indexName, final Object key) {
        return new SimpleDbTransactionExecutor<List<ExampleData>>(dbManager) {
            @Override
            public List<ExampleData> execute(AppDbConnection connection) {
                if (indexName.equals("name")) {
                    SqlPStatement stmt = connection.prepareStatement(
                        "select id, name from example_data where name = ? order by id");
                    stmt.setString(1, (String) key);
                    SqlResultSet results = stmt.retrieve();
                    List<ExampleData> objs = new ArrayList<ExampleData>();
                    for (SqlRow row : results) {
                        objs.add(createData(row));
                    }
                    return objs;
                }
                throw new IllegalArgumentException("invalid indexName: indexName = " + indexName);
            }
        }.doTransaction();
    }

    public Object getId(ExampleData value) {
        return value.getId();
    }
}
```

<details>
<summary>keywords</summary>

ExampleDataLoader, StaticDataLoader, SimpleDbTransactionExecutor, getValue, getValues, getId, データロード実装, AppDbConnection, SqlPStatement, SqlResultSet, SqlRow

</details>

## 設定ファイル

```xml
<!-- cashLoaderの定義 -->
<component name="exampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader">
        <component class="nablarch.core.cache.example.ExampleDataLoader" />
    </property>
</component>

<!-- cacheを使用するコンポーネントの定義 -->
<component name="staticDataUseExample" class="nablarch.core.cache.example.StaticDataUseExample">
    <property name="cache" ref="exampleDataCache" />
</component>
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="exampleDataCache"/>
        </list>
    </property>
</component>
```

<details>
<summary>keywords</summary>

BasicStaticDataCache, ExampleDataLoader, BasicApplicationInitializer, XML設定, キャッシュ設定, initializeList, loader

</details>
