# 日付管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/date.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BasicSystemTimeProvider.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/SystemTimeUtil.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BasicBusinessDateProvider.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BusinessDateUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/SystemTimeProvider.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BusinessDateProvider.html)

## 機能概要

コンポーネント定義で指定するクラスを差し替えるだけで、アプリケーションで使用するシステム日時(OS日時)と業務日付の取得方法を切り替えることができる。テストなどで一時的にシステム日時や業務日付を切り替えたい場合に使用する。

- システム日時の切り替え: [date-system_time_change](#s6)
- 業務日付の切り替え: [date-business_date_change](#s6)

<details>
<summary>keywords</summary>

システム日時切り替え, 業務日付切り替え, 日付管理, テスト用日時差し替え, date-system_time_change, date-business_date_change

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core</artifactId>
</dependency>

<!-- 業務日付管理機能を使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-core, nablarch-common-jdbc, Maven依存関係, 業務日付管理モジュール

</details>

## システム日時設定・取得

### システム日時の管理機能を使うための設定

**クラス**: `nablarch.core.date.BasicSystemTimeProvider`

コンポーネント名には `systemTimeProvider` と指定する。

```xml
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
```

### システム日時を取得する

システム日時の取得は `SystemTimeUtil` を使用する。

<details>
<summary>keywords</summary>

BasicSystemTimeProvider, SystemTimeUtil, systemTimeProvider, システム日時設定, システム日時取得, date-system_time_settings

</details>

## 業務日付設定・取得

### 業務日付管理機能を使うための設定

業務日付はデータベースを使用して複数の業務日付を管理する。テーブルレイアウト:

| カラム | 型 | 説明 |
|---|---|---|
| 区分(PK) | 文字列型 | 業務日付を識別するための値 |
| 日付 | 文字列型 | yyyyMMdd形式 |

**クラス**: `nablarch.core.date.BasicBusinessDateProvider`

コンポーネント名には `businessDateProvider` と指定する。

```xml
<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider">
  <!-- テーブル名 -->
  <property name="tableName" value="BUSINESS_DATE" />
  <!-- 区分のカラム名 -->
  <property name="segmentColumnName" value="SEGMENT"/>
  <!-- 日付のカラム名 -->
  <property name="dateColumnName" value="BIZ_DATE"/>
  <!-- 区分を省略して業務日付を取得した場合に使用される区分 -->
  <property name="defaultSegment" value="00"/>
  <!-- データベースアクセスに使用するトランザクションマネージャ -->
  <property name="transactionManager" ref="transactionManager" />
</component>
```

### 業務日付を取得する

業務日付の取得は `BusinessDateUtil` を使用する。

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, BusinessDateUtil, businessDateProvider, tableName, segmentColumnName, dateColumnName, defaultSegment, transactionManager, 業務日付設定, 業務日付取得, date-business_date_settings

</details>

## 業務日付上書き・更新

### 業務日付を任意の日付に上書く

バッチ処理の障害時再実行時など、特定プロセスのみ任意の業務日付を使用したい場合、[repository-overwrite_environment_configuration](libraries-repository.md) を使用してシステムプロパティで指定する。

システムプロパティ形式: `BasicBusinessDateProvider.<区分>=yyyyMMdd`

例: 区分"batch"を"2016/03/17"に上書きする場合 → `-DBasicBusinessDateProvider.batch=20160317`

> **補足**: ウェブアプリケーションのように全機能が1プロセス内で実行される場合は、DBで管理している日付を直接変更すればよい。

### 業務日付を更新する

`BasicBusinessDateProvider` を使用する。

```java
// システムリポジトリからBasicBusinessDateProviderを取得する
BusinessDateProvider provider = SystemRepository.get("businessDateProvider");

// setDateメソッドを呼び出し、更新する
provider.setDate(segment, date);
```

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, BusinessDateProvider, 業務日付上書き, 業務日付更新, setDate, SystemRepository, repository-overwrite_environment_configuration

</details>

## 拡張例

### システム日時を切り替える

1. `SystemTimeProvider` を実装したクラスを作成する。
2. [date-system_time_settings](#) に従い設定する。

### 業務日付を切り替える

1. `BusinessDateProvider` を実装したクラスを作成する。
2. [date-business_date_settings](#) に従い設定する。

<details>
<summary>keywords</summary>

SystemTimeProvider, BusinessDateProvider, システム日時カスタマイズ, 業務日付カスタマイズ, date-system_time_change, date-business_date_change, date-system_time_settings, date-business_date_settings

</details>
