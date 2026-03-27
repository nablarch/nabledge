# SQLクエリ結果のキャッシュ

## キャッシュ機能

SQLクエリ結果をキャッシュし、SQL IDとパラメータが等価である参照系クエリに対してキャッシュした結果を返却（DBアクセスが発生しない）する機能。

同一クエリの判定条件（以下4要素がすべて等価の場合に同一とみなす）:
1. SQL ID
2. パラメータ
3. 検索開始位置（省略時: 1=先頭）
4. 検索最大件数（省略時: 0=無制限）

提供機能:
- アプリケーションから明示的にキャッシュをクリアできる
- キャッシュ実装クラスを差し替えられる

**インタフェース**: `nablarch.core.db.cache.ResultSetCache`

**クラス**:
- `nablarch.core.db.cache.statement.CacheableStatementFactory`: キャッシュ可能なSqlPStatementを生成するStatementFactory実装クラス
- `nablarch.core.db.cache.statement.CacheableSqlPStatement`: キャッシュ可能なSqlPStatement実装クラス
- `nablarch.core.db.cache.ResultSetCacheKey`: キャッシュのキーを表すクラス（SQL ID, パラメータ, 開始位置, 最大件数）

## クエリ結果キャッシュ実装クラスの登録

**クラス**: `nablarch.core.db.cache.InMemoryResultSetCache`

コンポーネント定義ファイルに登録する。

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| cacheSize | | キャッシュ上限件数 |
| systemTimeProvider | | システム時刻プロバイダ |

```xml
<component name="resultSetCache" class="nablarch.core.db.cache.InMemoryResultSetCache">
  <property name="cacheSize" value="100"/>
  <property name="systemTimeProvider" ref="systemTimeProvider"/>
</component>
```

## StatementFactory実装クラスの差し替え

`ConnectionFactorySupport`サブクラスの`statementFactory`プロパティに`CacheableStatementFactory`を設定する。

**クラス**: `nablarch.core.db.cache.CacheableStatementFactory`

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| expirationSetting | | 有効期限設定 |
| resultSetCache | | キャッシュ実装 |

```xml
<component name="connectionFactory"
           class="nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource">
  <property name="dataSource" ref="dataSource" />
  <property name="statementFactory" ref="cacheableStatementFactory" />
</component>

<component name="cacheableStatementFactory"
           class="nablarch.core.db.cache.CacheableStatementFactory">
  <property name="expirationSetting" ref="expirationSetting"/>
  <property name="resultSetCache" ref="resultSetCache"/>
</component>
```

## SQL ID毎のキャッシュ設定

**クラス**: `nablarch.core.cache.expirable.BasicExpirationSetting`

SQL ID毎に有効期限を設定する。

有効期限の単位:

| 単位表記 | 意味 |
|---|---|
| ms | ミリ秒 |
| sec | 秒 |
| min | 分 |
| h | 時 |

```xml
<component class="nablarch.core.cache.expirable.BasicExpirationSetting"
           name="expirationSetting">
  <property name="expiration">
    <map>
      <entry key="please.change.me.tutorial.ss11AA.W11AA01Action#SELECT" value="100ms"/>
      <entry key="please.change.me.tutorial.ss11AA.W11AA02Action#SELECT" value="30sec"/>
      <entry key="please.change.me.tutorial.ss11AA.W11AA03Action#SELECT" value="10min"/>
      <entry key="please.change.me.tutorial.ss11AA.W11AA04Action#SELECT" value="1h"/>
    </map>
  </property>
</component>
```

> **注意**: サブシステム毎に有効期限設定を分割する場合は、`expirationList`プロパティにリスト形式で各サブシステムの`map`コンポーネントを参照させる。

```xml
<component class="nablarch.core.cache.expirable.BasicExpirationSetting"
           name="expirationSetting">
  <property name="expirationList">
    <list>
      <component-ref name="expireSettingSS11AA"/>
      <component-ref name="expireSettingSS11BB"/>
    </list>
  </property>
</component>

<!-- サブシステムSS11AAの設定（別ファイル） -->
<map name="expireSettingSS11AA">
  <entry key="please.change.me.tutorial.ss11AA.W11AA01Action#SELECT" value="100ms"/>
</map>

<!-- サブシステムSS11BBの設定（別ファイル） -->
<map name="expireSettingSS11BB">
  <entry key="please.change.me.tutorial.ss11BB.W11BB01Action#SELECT" value="1h"/>
</map>
```

<details>
<summary>keywords</summary>

キャッシュ機能, SQLクエリキャッシュ, 同一クエリ判定, CacheableStatementFactory, CacheableSqlPStatement, ResultSetCacheKey, ResultSetCache, キャッシュクリア, DBアクセス省略, InMemoryResultSetCache, BasicExpirationSetting, BasicDbConnectionFactoryForDataSource, nablarch.core.db.cache.InMemoryResultSetCache, nablarch.core.db.cache.CacheableStatementFactory, nablarch.core.cache.expirable.BasicExpirationSetting, nablarch.core.db.connection.BasicDbConnectionFactoryForDataSource, cacheSize, systemTimeProvider, statementFactory, expirationSetting, resultSetCache, expirationList, クエリ結果キャッシュ設定, キャッシュ有効期限, SQL IDキャッシュ, StatementFactory差し替え

</details>

## 有効期限

- キャッシュの有効期限を設定できる（期限なしの場合、古いデータを参照し続ける可能性がある）
- SQL ID毎にキャッシュ要否・有効期限を設定できる

## 特定のエントリを削除する方法

システムリポジトリからキャッシュインスタンスを取得し、キーを指定して削除する。

```java
// リポジトリからキャッシュのインスタンスを取得する。
ResultSetCache cache = SystemRepository.get("resultSetCache");

// キャッシュキーを組み立てる。
ResultSetCacheKey key
        = new ResultSetCacheKeyBuilder("please.change.me.tutorial.ss11AA.W11AA01Action#SELECT")
                       .addParam("name", "yamada")
                       .addParam("address", "tokyo")
                       .build();

// キャッシュから該当するエントリを削除する。
cache.remove(key);
```

## 全エントリをクリアする方法

システムリポジトリからキャッシュインスタンスを取得し、全エントリを削除するメソッドを呼び出す。

```java
ResultSetCache cache = SystemRepository.get("resultSetCache");
cache.clear();
```

> **注意**: 全エントリ削除機能はクラス単体テストの前後での使用を想定している（あるテストでキャッシュされた値が別のテストで使用されないようにするため）。

<details>
<summary>keywords</summary>

有効期限, キャッシュ有効期限, SQL ID毎, キャッシュ設定, ResultSetCache, ResultSetCacheKeyBuilder, ResultSetCacheKey, SystemRepository, cache.remove, cache.clear, キャッシュクリア, キャッシュエントリ削除, 単体テストキャッシュ初期化

</details>

## キャッシュ保存先

- キャッシュ保存先を切り替えられる（キャッシュ実装クラスの差し替えにより実現）
- 保存先候補: JVMヒープ、KVS等（基本実装ではJVMヒープを使用）

- ロガー名: `RS_CACHE`
- ログレベル: DEBUG

| イベント | ログ出力フォーマット |
|---|---|
| キャッシュにヒットした場合 | `cache hit: key=[<SQL ID>], current=[<システム日時>]` |
| キャッシュにヒットしなかった場合 | `cache not hit: key=[<SQL ID>]` |
| キャッシュ有効期限切れが検知された場合 | `cache entry expired: key=[<SQL ID>], expire=[<有効期限>], current=[<システム日時>]` |
| キャッシュに値が設定された場合 | `cache entry added: key=[<SQL ID>], expire=[<有効期限>]` |
| キャッシュに対して削除要求が発生した場合 | `cache entry removed: key=[<SQL ID>]` |
| キャッシュ全クリア要求が発生した場合 | `cache cleared.` |
| LRUアルゴリズムにより古いエントリが削除された場合 | `the eldest entry removed: key=[<SQL ID>]` |

<details>
<summary>keywords</summary>

キャッシュ保存先, JVMヒープ, KVS, キャッシュ実装差し替え, RS_CACHE, InMemoryResultSetCache, nablarch.core.db.cache.InMemoryResultSetCache, キャッシュログ, cache hit, cache not hit, cache entry expired, cache entry added, cache cleared, the eldest entry removed

</details>

## その他の要件

- キャッシュ対象外のSQL実行性能に影響を与えない
- アプリケーションプログラマがキャッシュ機構を意識せずプログラミングできる

基本実装でのログ出力イベント:
1. キャッシュヒット時
2. キャッシュミス時
3. キャッシュ有効期限切れ検知時
4. キャッシュに値が設定された時
5. キャッシュに対して削除要求が発生した時
6. キャッシュ全クリア要求が発生した時
7. LRUアルゴリズムにより古いエントリが削除された時

## キャッシュ上限件数とヒープサイズ

`nablarch.core.db.cache.InMemoryResultSetCache`はメモリ（JVMヒープ）上にキャッシュを保持する。設定したキャッシュ上限件数を格納できる十分なヒープサイズを確保し、性能試験等で問題がないことを確認すること。ヒープサイズが不足した場合は`OutOfMemoryError`が発生するため、ヒープサイズおよび上限件数の見直しを行う。

## ログによる分析

`nablarch.core.db.cache.InMemoryResultSetCache`クラスのログ出力から各種イベントの情報を確認できる（ログ出力フォーマットの詳細はログ出力セクションを参照）。キャッシュミスが多い場合の対処:

- キャッシュ上限件数を増やす
- 許容できる範囲内でキャッシュ有効期限を伸ばす

<details>
<summary>keywords</summary>

ログ出力, キャッシュヒット, キャッシュミス, LRU, パフォーマンスチューニング, ログイベント, InMemoryResultSetCache, nablarch.core.db.cache.InMemoryResultSetCache, OutOfMemoryError, キャッシュチューニング, ヒープサイズ, キャッシュ上限件数, 性能試験

</details>

## 基本実装

- キャッシュ記憶領域はJVMヒープ上
- キャッシュ保存上限件数を指定可能。LRUアルゴリズムでヒープ逼迫を防止
- キャッシュは同一アプリケーション内で共有（アプリケーション・サーバを跨る共有はされない）
- 有効期限切れ判定は遅延評価（キャッシュ取得時に判定）

**クラス**: `nablarch.core.db.cache.InMemoryResultSetCache`

## BLOB、CLOB型はキャッシュできない

> **警告**: BLOB型、CLOB型を含むクエリを本機能の対象としてはならない。

SELECTでBLOB型・CLOB型カラムを取得した場合、実際のデータではなくLOBロケータが取得される。LOBロケータの有効期間は`java.sql.ResultSet`や`java.sql.Connection`がクローズされるまでであり（RDBMS実装依存）、それより生存期間が長いキャッシュにはBLOB・CLOB型を含めることができない。

## APサーバを冗長化する場合の注意点

`nablarch.core.db.cache.InMemoryResultSetCache`はJVMヒープ上にキャッシュを保持するため、サーバをまたいでキャッシュを共有することはできない。APサーバを冗長化した環境では各APサーバが別のキャッシュを持つため、ロードバランサをラウンドロビンで使用した場合、リクエスト毎にキャッシュの値が前回リクエスト時と変わる可能性がある。

> **注意**: 現状、この問題を回避する手段は提供されていない。

<details>
<summary>keywords</summary>

基本実装, JVMヒープ, LRUアルゴリズム, LRUMap, キャッシュ上限, 遅延評価, InMemoryResultSetCache, BLOB, CLOB, LOBロケータ, APサーバ冗長化, キャッシュ制約, ラウンドロビン, キャッシュ共有不可

</details>

## 未実装・未検討

未実装:
- KVSを使用するキャッシュ実装
- ソフト参照を使用したキャッシュ実装

未検討:
- キャッシュ有効期限判定のリアルタイム実施（デーモンスレッド）（上限件数設定により遅延評価でも肥大化しないため、現状は遅延評価で対応）

<details>
<summary>keywords</summary>

未実装, KVSキャッシュ, ソフト参照, デーモンスレッド, 未検討

</details>

## 構成

StatementFactory実装クラスの差し替えにより本機能を実現する。

- キャッシュ対象SQLの場合: キャッシュ機能付きSqlPStatement（`CacheableSqlPStatement`）を生成
- キャッシュ対象でない場合: 基本実装（`BasicSqlPStatement`）を生成

**インタフェース**: `nablarch.core.db.cache.ResultSetCache` — クエリ結果を保持するキャッシュインタフェース

<details>
<summary>keywords</summary>

構成, StatementFactory, CacheableStatementFactory, CacheableSqlPStatement, BasicSqlPStatement, ResultSetCache

</details>

## 全体図

**クラス**:
- `nablarch.core.db.cache.statement.CacheableStatementFactory`: キャッシュ可能なSqlPStatementを生成するStatementFactory実装クラス
- `nablarch.core.db.cache.statement.CacheableSqlPStatement`: キャッシュ可能なSqlPStatement実装クラス
- `nablarch.core.db.cache.InMemoryResultSetCache`: メモリ上にキャッシュを持つResultSetCache実装クラス（:ref:`有効期限付きキャッシュ`参照）
- `nablarch.core.db.cache.ResultSetCacheKey`: キャッシュのキーを表すクラス（SQL ID, パラメータ, 開始位置, 最大件数）

<details>
<summary>keywords</summary>

全体図, クラス図, CacheableStatementFactory, CacheableSqlPStatement, InMemoryResultSetCache, ResultSetCacheKey

</details>

## 有効期限付きキャッシュ

**インタフェース**:
- `nablarch.core.cache.expirable.ExpirableCache`: 有効期限付きキャッシュのインタフェース
- `nablarch.core.cache.expirable.ExpirableCacheListener`: イベント発生時にコールバックされるリスナーインタフェース

**クラス**:
- `nablarch.core.cache.expirable.InMemoryExpirableCache`: キャッシュをメモリ上に保持する有効期限付きキャッシュ実装クラス
- `nablarch.core.db.cache.InMemoryResultSetCache`: メモリ上にキャッシュを持つResultSetCache実装クラス。各イベント発生時にログ出力
- `nablarch.core.util.map.LRUMap`: LRUアルゴリズムを持つ件数上限付きMap実装クラス

<details>
<summary>keywords</summary>

有効期限付きキャッシュ, ExpirableCache, ExpirableCacheListener, InMemoryExpirableCache, InMemoryResultSetCache, LRUMap

</details>

## キャッシュしたSqlResultSetの保護

キャッシュから取得されたSqlResultSetが変更された場合にキャッシュが変更されることを防ぐため、専用のSqlResultSetサブクラスに値のコピーを行う。

以下のオブジェクトは変更可能なため、取得要求時に値をコピーして返却:
- `java.util.Date`
- `java.sql.Timestamp`
- `byte[]`

**クラス**:
- `nablarch.core.db.cache.statement.MutableGuardingSqlResultSet`: 変更可能なプロパティが書き換えられることを防止するSqlResultSetサブクラス
- `nablarch.core.db.cache.statement.MutableGuardingSqlResultSet.MutableGuardingSqlRow`: 変更可能なプロパティが書き換えられることを防止するSqlRowサブクラス

<details>
<summary>keywords</summary>

MutableGuardingSqlResultSet, MutableGuardingSqlRow, SqlResultSet保護, Date, Timestamp, byte[], コピー

</details>

## SqlPStatementの生成

キャッシュ対象のSQL IDが指定された場合:
- `CacheableStatementFactory`がキャッシュ機能付きの`CacheableSqlPStatement`を生成

キャッシュ対象でないSQL IDが指定された場合:
- `CacheableStatementFactory`が基本実装`BasicSqlPStatement`を生成

<details>
<summary>keywords</summary>

SqlPStatement生成, キャッシュ対象SQL, CacheableStatementFactory, CacheableSqlPStatement, BasicSqlPStatement, StatementFactory

</details>

## キャッシュへのアクセス

キャッシュにヒットしない場合:
1. 指定SQLの検索結果をキャッシュから取得
2. キャッシュに存在しないのでDBアクセスを行う
3. 有効期限を算出し、検索結果をキャッシュに格納

キャッシュにヒットする場合:
1. 指定SQLの検索結果をキャッシュから取得
2. キャッシュに存在するのでそのまま検索結果を返却

キャッシュにヒットするが有効期限切れの場合:
1. 指定SQLの検索結果をキャッシュから取得
2. キャッシュに存在するが有効期限切れのためキャッシュから削除
3. キャッシュに存在しないのでDBアクセスを行う
4. 有効期限を算出し、検索結果をキャッシュに格納

<details>
<summary>keywords</summary>

キャッシュアクセス, キャッシュヒット, キャッシュミス, 有効期限切れ, DBアクセス, キャッシュ格納

</details>

## 概要・特徴

SQLクエリ結果のキャッシュ機能の概要:
- SQL IDとパラメータが等価である参照系クエリに対してキャッシュした結果を返却（DBアクセスが発生しない）
- 適用想定クエリ: トレンド把握クエリ（最新値不要）、更新タイミングが予め分かっているクエリ（例: 夜間バッチ更新データ）
- RDBMSのクエリキャッシュと異なり、アプリケーションおよびクエリの特性を考慮した柔軟なキャッシュ管理が可能

> **警告**: 本機能はDBアクセス高速化のためではない。DBアクセス高速化を目的とした使用禁止（クエリ・DBのチューニングで対処すること）。

> **警告**: データベースが更新されてもキャッシュの値は変更されない。最新データが必要なクエリには絶対に使用禁止。更新タイミングが完全にコントロール可能な場合のみ使用すること。**本機能を適用するかどうかの判断はアーキテクトが行い、開発者が個別に判断しないようにすること。**

特徴:
- SQL ID毎にキャッシュ要否を設定できる
- SQL ID毎にキャッシュ有効期限を設定できる
- アプリケーションプログラマがキャッシュ機構を意識せずにプログラミングできる

<details>
<summary>keywords</summary>

概要, SQLクエリキャッシュ, 警告, 適用条件, アーキテクト, キャッシュ適用判断, 特徴

</details>
