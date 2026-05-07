# 静的データのキャッシュ

**目次**

* 機能概要

  * 任意のデータをキャッシュできる
* モジュール一覧
* 使用方法

  * 任意のデータをキャッシュする
  * データのキャッシュタイミングを制御する

データベースやファイルなどに格納した静的データへのアクセスを高速化するためのキャッシュ機能を提供する。

この機能は単体では動作しない。
静的データをキャッシュしたい場合には、 [任意のデータをキャッシュする](../../component/libraries/libraries-static-data-cache.md#任意のデータをキャッシュする) を参照し、データのロード処理を実装すること。

> **Important:**
> この機能では、キャシュしたデータをヒープ上に保持する。
> 大量のデータをキャッシュした場合、Full GCが頻発しパフォーマンスに悪影響を与える可能性があるので、注意すること。

## 機能概要

### 任意のデータをキャッシュできる

この機能が提供するインタフェースを実装することで、容易に任意のデータをキャッシュできる。

なお、データのキャッシュの制御はこの機能が提供するクラスで行っている。
このため、新たなデータをキャッシュしたい場合には、データをロードする処理のみを実装すればよい。
特に、マルチスレッド環境下での同期処理などを行う必要がないのは大きなメリットである。

詳細は、 [任意のデータをキャッシュする](../../component/libraries/libraries-static-data-cache.md#任意のデータをキャッシュする) を参照。

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>
```

## 使用方法

### 任意のデータをキャッシュする

任意の静的データをキャッシュする場合、以下の作業が必要となる。

1. StaticDataLoader インタフェースを実装し、データをロードする処理を実装する。
2. BasicStaticDataCache クラスに、 StaticDataLoader の実装クラスを設定する。
3. キャッシュを使用するクラスに BasicStaticDataCache を設定する。

以下に詳細な手順を示す。

StaticDataLoaderインタフェースを実装しローダーを作成する

StaticDataLoader を実装し、任意のストアから静的データをロードする処理を実装する。

幾つか実装すべきメソッドがあるが、以下のルールにもとづいて実装すると良い。

システム起動時に一括ロードを行う場合に実装する。それ以外の場合は、 return null で良い。

静的データを一意に識別するidに対応するデータをロードする。
このメソッドは、キャッシュにデータが存在しなかった場合に呼び出される。

インデックス毎に静的データを管理したい場合に使用する。
この機能は実装方法が複雑になるだけでなく、使用するメリットもないため原則使用しない。

実装としては、 return null で良い。

BasicStaticDataCacheクラスにローダーを設定する

StaticDataLoader を実装したローダーを、 BasicStaticDataCache.loader に設定する。

設定例は、 [静的データキャッシュの設定ファイル例](../../component/libraries/libraries-static-data-cache.md#任意のデータをキャッシュする) を参照。

> **Important:**
> 設定例でも行っているように、 BasicStaticDataCache は必ず初期化対象に設定すること。
> 初期化の詳細は、 [オブジェクトの初期化処理を行う](../../component/libraries/libraries-repository.md#オブジェクトの初期化処理を行う) を参照。

キャッシュを使用するクラスにBasicStaticDataCacheを設定する

キャッシュを使用するクラスに、ローダーを持つ BasicStaticDataCache を設定することで、キャッシュされたデータにアクセスできる。

以下にキャッシュを使用するクラスの例を示す。

この例では、設定された StaticDataCache を使用して、キャッシュしたデータを取得している。

設定例は、 [静的データキャッシュの設定ファイル例](../../component/libraries/libraries-static-data-cache.md#任意のデータをキャッシュする) を参照。

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

設定ファイル例

```xml
<!-- ローダー -->
<component name="sampleLoader" class="sample.SampleLoader" />

<!-- ローダーでロードしたデータをキャシュするBasicStaticDataCache -->
<component name="sampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="sampleLoader" />
</component>

<!--
ローダーでロードしたキャッシュを使用するクラス。
このクラスに設定した、BasicStaticDataCacheを使ってキャッシュにアクセスする。
-->
<component class="sample.SampleService">
  <property name="sampleCache" ref="sampleDataCache" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">

  <property name="initializeList">
    <list>
      <!-- BasicStaticDataCacheを初期化する -->
      <component-ref name="sampleDataCache" />
    </list>
  </property>

</component>
```

### データのキャッシュタイミングを制御する

データのキャッシュタイミングは、以下の2パターンから選択できる。

* 一括ロード(起動時全てのデータがキャッシュされる)
* オンデマンドロード(初めて取得要求があった時にキャッシュされる)

> **Tip:**
> 原則起動時に一括ロードで問題ないが、静的データが大量で一部しか使用しない場合には、オンデマンドロードを選択すると良い。
> 例えば、バッチアプリケーションのように一部のデータにしかアクセスしない場合には、オンデマンドロードを選択すると良い。

ロードタイミングの変更は、ローダを設定した BasicStaticDataCache.loadOnStartup で行う。
このプロパティに true が設定されていると、起動時に一括でロードされる。

以下の例では、 true を設定しているため起動時に一括でデータがキャッシュされる。

```xml
<component name="sampleLoader" class="sample.SampleLoader" />

<component name="sampleDataCache" class="nablarch.core.cache.BasicStaticDataCache">
  <property name="loader" ref="sampleLoader" />
  <property name="loadOnStartup" value="true" />
</component>
```
