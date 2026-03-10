# 静的データのキャッシュ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/static_data_cache.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/StaticDataLoader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/BasicStaticDataCache.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/StaticDataCache.html)

## 機能概要

データベースやファイルなどに格納した静的データへのアクセスを高速化するキャッシュ機能を提供する。この機能は単体では動作しない。静的データをキャッシュしたい場合には、:ref:`static_data_cache-load_data` を参照しデータのロード処理を実装すること。

> **重要**: キャッシュしたデータをヒープ上に保持する。大量のデータをキャッシュした場合、Full GCが頻発しパフォーマンスに悪影響を与える可能性があるため注意すること。

**任意のデータをキャッシュできる**: この機能が提供するインタフェースを実装することで任意のデータをキャッシュできる。新たなデータをキャッシュしたい場合にはデータをロードする処理のみを実装すればよい。マルチスレッド環境下での同期処理を行う必要がない。

<details>
<summary>keywords</summary>

静的データキャッシュ, ヒープキャッシュ, Full GC, キャッシュ機能, マルチスレッド同期不要

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, モジュール依存関係, com.nablarch.framework

</details>

## 任意のデータをキャッシュする

任意の静的データをキャッシュする手順:

1. `StaticDataLoader` インタフェースを実装し、データロード処理を実装する。
2. `BasicStaticDataCache` に `StaticDataLoader` 実装クラスを設定する。
3. キャッシュを使用するクラスに `BasicStaticDataCache` を設定する。

**StaticDataLoaderの実装ルール**:

| メソッド | 実装内容 |
|---|---|
| loadAll | 起動時一括ロードする場合に実装。それ以外は `return null` |
| getValue | idに対応するデータをロード。キャッシュにデータが存在しない場合に呼び出される |
| 上記以外 | `return null` で良い（インデックス毎の管理機能は原則使用しない） |

> **重要**: `BasicStaticDataCache` は必ず初期化対象に設定すること（:ref:`repository-initialize_object` 参照）。

キャッシュを使用するクラスの例:

```java
public class SampleService {
  private StaticDataCache<Integer> sampleCache;

  public int calc(int n) {
      return sampleCache.getValue(n);
  }

  public void setSampleCache(StaticDataCache<Integer> sampleCache) {
      this.sampleCache = sampleCache;
  }
}
```

設定ファイル例（:ref:`static_data_cache-config_sample`）:

```xml
<component name="sampleLoader" class="sample.SampleLoader" />

<component name="sampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="sampleLoader" />
</component>

<component class="sample.SampleService">
  <property name="sampleCache" ref="sampleDataCache" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="sampleDataCache" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

StaticDataLoader, BasicStaticDataCache, StaticDataCache, BasicApplicationInitializer, loader, データロード, キャッシュ初期化, loadAll, getValue

</details>

## データのキャッシュタイミングを制御する

データのキャッシュタイミングは以下の2パターンから選択できる（:ref:`static_data_cache-cache_timing`）:

- **一括ロード**: 起動時に全データをキャッシュ
- **オンデマンドロード**: 初めて取得要求があった時にキャッシュ

> **補足**: 静的データが大量で一部しか使用しない場合（バッチアプリケーションなど）はオンデマンドロードを選択すると良い。

`BasicStaticDataCache.loadOnStartup` プロパティで制御する。`true` を設定すると起動時に一括ロードされる。

```xml
<component name="sampleLoader" class="sample.SampleLoader" />

<component name="sampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="sampleLoader" />
  <property name="loadOnStartup" value="true" />
</component>
```

<details>
<summary>keywords</summary>

BasicStaticDataCache, loadOnStartup, 一括ロード, オンデマンドロード, キャッシュタイミング

</details>
