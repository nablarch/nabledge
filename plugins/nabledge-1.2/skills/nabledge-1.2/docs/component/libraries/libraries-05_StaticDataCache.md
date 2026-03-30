# 静的データのキャッシュ

## 概要

静的データをより速い媒体にキャッシュしてアクセスを高速化する機構。

- :ref:`repository` に登録して使用する。初期化処理は :ref:`repository` が実行する。
- 本機能は他の機能の一部として使用されることを想定しており、アプリケーションプログラマが直接使用することはない。

一括ロード使用時は、`StaticDataLoader` インタフェースの以下4メソッドを実装する必要がある。

| メソッド名 | 用途 |
|---|---|
| `loadAll` | キャッシュするデータを取得する。フレームワークはこのメソッドで返される全データをキャッシュの初期データとして保持する。 |
| `getId` | データからIDを取得する。フレームワークはこの戻り値を`java.util.Map`のキーとして使用するため、キャッシュ上で一意なオブジェクトでなければならない。複合キーの場合、`equals`と`hashCode`を適切に実装したクラスのインスタンスを返す。 |
| `getIndexNames` | 作成するインデックス名を全て返す。フレームワークはこの戻り値から作成するインデックスを決定する。 |
| `generateIndexKey` | インデックスのキーとなる値を生成する。`getId`がオブジェクトのキャッシュキーに使われるのに対し、これはインデックス上のどのキーにオブジェクトが属するかを示す。 |

<details>
<summary>keywords</summary>

StaticDataCache, 静的データキャッシュ, キャッシュ初期化, repository, StaticDataLoader, loadAll, getId, generateIndexKey, getIndexNames, 一括ロード, StaticDataLoaderインタフェース実装, キャッシュデータ取得

</details>

## 特徴

### 実装負荷軽減
キャッシュデータの保持とキャッシュミス時のロード処理はフレームワーク提供クラスが行う。実装者が用意する処理は「媒体からのロード処理」と「キャッシュした静的データの使用処理」の2つのみ。

### インデックス機能
ID以外のキー（インデックスキー）を指定して、複数の静的データを効率よく取得できる機能。1つのインデックスキーに複数の静的データを紐付けられる。

> **注意**: 下記コードはフレームワークが行う処理のサンプルであり、通常のアプリケーションでは実装不要。アプリケーション・プログラマはこのような実装を行わない。

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
            throw new IllegalArgumentException("invalid indexName: indexName = " + indexName);
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
                SqlPStatement stmt = connection.prepareStatement("select id, name from example_data order by id");
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

インデックス機能, 実装負荷軽減, インデックスキー, キャッシュ機能, ExampleDataLoader, StaticDataLoader, SimpleDbTransactionExecutor, SqlPStatement, SqlResultSet, SqlRow, AppDbConnection, 一括ロード実装例, StaticDataLoaderインタフェース実装例

</details>

## 要求

**実装済み:**
- 任意のクラスの静的データをキャッシュできる
- IDを指定してキャッシュから静的データを取得できる
- 任意のインデックスキーを指定してキャッシュから複数の静的データを取得できる
- アプリケーション起動時に静的データをロードできる
- 静的データが必要なタイミングでオンデマンドロードできる
- プロセス再起動なしで再ロードできる

**未検討（未実装）:**
- 頻繁に参照されない静的データをキャッシュから削除してメモリを節約
- 複数Javaプロセスでのキャッシュ共有
- ファイルからの静的データロード
- SQL記述のみでDBの静的データをキャッシュ

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

`BasicStaticDataCache` は初期化が必要（:ref:`repository_initialize` の `Initializable` インタフェースを実装）。以下のように初期化リストに追加すること。

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

オンデマンドロード, 一括ロード, 再ロード, キャッシュ機能要件, BasicStaticDataCache, loadOnStartup, BasicApplicationInitializer, Initializable, ExampleDataLoader, StaticDataUseExample, 一括ロード設定, 初期化設定

</details>

## 構成

![静的データキャッシュ クラス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_Class.jpg)

**クラス**: `nablarch.core.cache.BasicStaticDataCache`

`Initializable` インタフェースを実装しており、初期化設定が必要（:ref:`repository_initialize` 参照）。

<details>
<summary>keywords</summary>

StaticDataCache, StaticDataLoader, BasicStaticDataCache, クラス図, Initializable, repository_initialize, 初期化, 設定内容詳細

</details>

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.cache.StaticDataCache` | 静的データのキャッシュを保持するインタフェース |
| `nablarch.core.cache.StaticDataLoader` | 静的データをロードするインタフェース。RDBMSやXMLファイル等の媒体から静的データをロードするクラスはこのインタフェースを実装する |

**クラス**: `nablarch.core.cache.BasicStaticDataCache`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `loader` | ○ | `StaticDataLoader` インタフェースを実装したクラスのインスタンスを指定する。 |
| `loadOnStartup` | | 一括ロードの要否。指定しなければ一括ロードしない。 |

<details>
<summary>keywords</summary>

nablarch.core.cache.StaticDataCache, nablarch.core.cache.StaticDataLoader, インタフェース定義, 静的データロード, BasicStaticDataCache, loader, loadOnStartup, StaticDataLoader, 設定プロパティ

</details>

## クラス定義

| クラス名 | 概要 |
|---|---|
| `nablarch.core.cache.StaticDataCache` | StaticDataCacheインタフェースの基本実装クラス。静的データをHashMapに保持する |

元データが更新された際、静的データの再読み込みが必要。アプリケーションの再起動が頻繁に行えない場合、`StaticDataCache` インタフェースの `refresh` メソッドを呼び出すことで再起動なしに再読み込みできる。

> **注意**: 下記コードはプロジェクトのアーキテクトが作成するものであり、通常のアプリケーション・プログラマはこのような実装を行わない。

```java
public class StaticDataUseExample {
    private StaticDataCache<ExampleData> cache;

    public void setCache(StaticDataCache<ExampleData> cache) {
        this.cache = cache;
    }

    public void refreshAndGetValue(String name) {
        cache.refresh();
        List<ExampleData> objs = cache.getValues("name", name);
        for (ExampleData obj : objs) {
            System.out.println(obj);
        }
    }
}
```

<details>
<summary>keywords</summary>

nablarch.core.cache.StaticDataCache, BasicStaticDataCache, HashMap, キャッシュ実装クラス, StaticDataCache, refresh, 静的データ再読み込み, リロード, StaticDataUseExample

</details>

## キャッシュした静的データの取得

キャッシュを使用するクラスは `StaticDataCache` インタフェースをフィールドに持ち、:ref:`di-container` の機能で実装クラスを設定する。

**IDによるデータ取得:** `StaticDataCache#getValue(id)` または `StaticDataCache#getValues(id)` を使用。キャッシュにデータがない場合は自動ロードされるため、呼び出し元はキャッシュの存在を意識しなくてよい。

**インデックスによるデータ取得:** `StaticDataCache#getValues(indexName, key)` を使用。1つのキーに複数の静的データを紐付けられる。

```java
public void getByName(String name) {
    List<ExampleData> objs = cache.getValues("name", name);
    for (ExampleData obj : objs) {
        System.out.println("id = " + obj.getId());
        System.out.println("name = " + obj.getName());
    }
}
```

<details>
<summary>keywords</summary>

StaticDataCache, getValue, getValues, インデックス取得, di-container, DIコンテナ設定

</details>

## キャッシュされるデータを保持するクラス(ExampleData)

```java
public class ExampleData {
    private String id;
    private String name;
    // setter, getter省略
}
```

<details>
<summary>keywords</summary>

ExampleData, キャッシュデータクラス, 静的データ保持

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
        ExampleData obj = cache.getValue(id);
        System.out.println("id = " + obj.getId());
        System.out.println("name = " + obj.getName());
    }
}
```

> **警告**: `StaticDataCache#getValue` または `StaticDataCache#getValues` で取得した静的データをクラス/インスタンスのフィールドに保持してはならない。`StaticDataCache` のリロード機能呼び出し時に当該フィールドが更新されない問題があるためである。

<details>
<summary>keywords</summary>

StaticDataUseExample, StaticDataCache, getValue, フィールド保持禁止, リロード

</details>

## キャッシュにデータをロードする方法

**オンデマンドロード**: キャッシュにデータがないときに自動ロード。アプリ起動が速い。バッチやテストなど、使用データがキャッシュの一部に偏る場面に有利。

**一括ロード**: アプリケーション起動時に全データをロード。起動後はキャッシュミスが発生しないため、Webアプリのメッセージなどほぼすべてのデータを使う場面に有利。

いずれのロード方法でもキャッシュを使う実装にはロード方法を意識させない。

オンデマンドロード時の処理順序:
![オンデマンドロード シーケンス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_LoadOnDemandSequence.jpg)

一括ロード時の処理順序:
![一括ロード シーケンス図](../../../knowledge/component/libraries/assets/libraries-05_StaticDataCache/05_StaticDataCache_LoadOnStartupSequence.jpg)

<details>
<summary>keywords</summary>

オンデマンドロード, 一括ロード, キャッシュロード, ロード方法比較

</details>

## オンデマンドロードの使用方法

データをロードする処理は `StaticDataLoader` インタフェースを実装したクラスに実装する。

**IDを指定してデータを取得する場合**: `StaticDataLoader#getValue` メソッドのみ実装すればよい。

**インデックスを指定してデータを取得する場合**: 以下2メソッドを実装する:
- `getValues(String indexName, Object key)`: インデックスキーでデータをロードする目的で呼び出される
- `getId(T value)`: 同一静的データの2重保持を防ぐ目的でフレームワークから呼び出される。静的データを一意に決定する値を返すよう実装すること。

> **注意**: 下記コードはフレームワークが行う処理であり、通常のアプリケーションでは実装する必要がない。

```java
public class ExampleDataLoader implements StaticDataLoader<ExampleData> {
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
                } else {
                    throw new IllegalArgumentException("invalid indexName: indexName = " + indexName);
                }
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

StaticDataLoader, getValues, getId, オンデマンドロード実装, インデックスロード, ExampleDataLoader, SimpleDbTransactionExecutor

</details>

## ExampleDataをロードするクラス

> **注意**: 下記コードはフレームワークが行う処理であり、通常のアプリケーションでは実装する必要がない。

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
                } else {
                    return null;
                }
            }
        }.doTransaction();
    }
}
```

<details>
<summary>keywords</summary>

ExampleDataLoader, StaticDataLoader, getValue, SimpleDbTransactionExecutor, SimpleDbTransactionManager

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
            <!-- 他のコンポーネントは省略 -->
            <component-ref name="exampleDataCache"/>
        </list>
    </property>
</component>
```

<details>
<summary>keywords</summary>

BasicStaticDataCache, nablarch.core.cache.BasicStaticDataCache, ExampleDataLoader, BasicApplicationInitializer, XML設定, loader, StaticDataUseExample

</details>
