# 静的データのキャッシュ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/static_data_cache.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/StaticDataLoader.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/BasicStaticDataCache.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/cache/StaticDataCache.html)

## 機能概要

データベース・ファイル等に格納した静的データへのアクセスを高速化するキャッシュ機能。

> **重要**: キャッシュしたデータをヒープ上に保持する。大量のデータをキャッシュした場合、Full GCが頻発しパフォーマンスに悪影響を与える可能性があるので注意すること。

- この機能は単体では動作しない。データのロード処理を実装する必要がある（[static_data_cache-load_data](#) 参照）。
- 新たなデータをキャッシュしたい場合には、データをロードする処理のみを実装すればよい（キャッシュの制御はフレームワークが担当）。
- マルチスレッド環境下での同期処理などを行う必要がない。

<details>
<summary>keywords</summary>

静的データキャッシュ, キャッシュ機能, Full GC, マルチスレッド, StaticDataLoader, BasicStaticDataCache

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

nablarch-core, モジュール, 依存関係, Maven, com.nablarch.framework

</details>

## 任意のデータをキャッシュする

任意の静的データをキャッシュするための手順:
1. `StaticDataLoader` インタフェースを実装し、データロード処理を実装する。
2. `BasicStaticDataCache` クラスに `StaticDataLoader` の実装クラスを設定する。
3. キャッシュを使用するクラスに `BasicStaticDataCache` を設定する。

**StaticDataLoader 実装ルール**:

| メソッド | 実装内容 |
|---|---|
| `loadAll` | システム起動時に一括ロードする場合に実装。それ以外は `return null` |
| `getValue` | 静的データをIDで識別してロード。キャッシュにデータが存在しない場合に呼び出される |
| 上記以外のメソッド | インデックス毎管理用。実装が複雑でメリットもないため原則使用しない。`return null` でよい |

> **重要**: `BasicStaticDataCache` は必ず初期化対象に設定すること（[repository-initialize_object](libraries-repository.md) 参照）。

**キャッシュを使用するクラスの例**:

設定された `StaticDataCache` を使用してキャッシュしたデータを取得する例:

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

**設定例**:
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

StaticDataLoader, BasicStaticDataCache, StaticDataCache, loader, 静的データキャッシュ, loadAll, getValue, BasicApplicationInitializer

</details>

## データのキャッシュタイミングを制御する

キャッシュタイミングは以下の2パターンから選択できる:
- **一括ロード**: 起動時に全データをキャッシュ
- **オンデマンドロード**: 初めて取得要求があった時にキャッシュ

> **補足**: 原則起動時に一括ロードで問題ない。ただし、静的データが大量で一部しか使用しない場合（例: バッチアプリケーションのように一部のデータにしかアクセスしない場合）にはオンデマンドロードを選択すると良い。

`BasicStaticDataCache.loadOnStartup` プロパティで制御。`true` 設定で起動時一括ロード。

```xml
<component name="sampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="sampleLoader" />
  <property name="loadOnStartup" value="true" />
</component>
```

<details>
<summary>keywords</summary>

loadOnStartup, 一括ロード, オンデマンドロード, キャッシュタイミング制御, BasicStaticDataCache

</details>
