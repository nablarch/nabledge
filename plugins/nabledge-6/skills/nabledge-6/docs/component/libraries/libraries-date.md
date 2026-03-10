# 日付管理

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/date.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BasicSystemTimeProvider.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/SystemTimeUtil.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BasicBusinessDateProvider.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BusinessDateUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/SystemTimeProvider.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/date/BusinessDateProvider.html)

## 機能概要

コンポーネント定義で指定するクラスを差し替えることで、アプリケーションで使用するシステム日時(OS日時)と業務日付の取得方法を切り替えられる。テストなどで一時的に切り替えたい場合に利用する。

- システム日時を切り替える方法については「拡張例 > システム日時の切り替え」を参照。
- 業務日付を切り替える方法については「拡張例 > 業務日付の切り替え」を参照。

<details>
<summary>keywords</summary>

システム日時切り替え, 業務日付切り替え, テスト用日時変更, コンポーネント差し替え

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

nablarch-core, nablarch-common-jdbc, 日付管理モジュール, Maven依存関係

</details>

## システム日時の管理機能を使うための設定

**クラス**: `nablarch.core.date.BasicSystemTimeProvider`

コンポーネント名には **systemTimeProvider** と指定する。

```xml
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
```

<details>
<summary>keywords</summary>

BasicSystemTimeProvider, systemTimeProvider, システム日時設定, コンポーネント定義

</details>

## システム日時を取得する

**クラス**: `nablarch.core.date.SystemTimeUtil`

システム日時の取得は `SystemTimeUtil` を使用する。

<details>
<summary>keywords</summary>

SystemTimeUtil, システム日時取得

</details>

## 業務日付管理機能を使うための設定

**クラス**: `nablarch.core.date.BasicBusinessDateProvider`

コンポーネント名には **businessDateProvider** と指定する。初期化が必要なため、初期化対象のリストに設定すること。

業務日付はデータベースで複数管理する。テーブルレイアウト:

| カラム | 説明 |
|---|---|
| 区分(PK) | 業務日付を識別する値（文字列型） |
| 日付 | 業務日付（文字列型、yyyyMMdd形式） |

```xml
<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider">
  <property name="tableName" value="BUSINESS_DATE" />
  <property name="segmentColumnName" value="SEGMENT"/>
  <property name="dateColumnName" value="BIZ_DATE"/>
  <property name="defaultSegment" value="00"/>
  <property name="transactionManager" ref="transactionManager" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <!-- 他のコンポーネントは省略 -->
      <component-ref name="businessDateProvider" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, businessDateProvider, tableName, segmentColumnName, dateColumnName, defaultSegment, transactionManager, BasicApplicationInitializer, initializeList, 業務日付設定, 業務日付テーブル

</details>

## 業務日付を取得する

**クラス**: `nablarch.core.date.BusinessDateUtil`

業務日付の取得は `BusinessDateUtil` を使用する。

<details>
<summary>keywords</summary>

BusinessDateUtil, 業務日付取得

</details>

## 業務日付を任意の日付に上書く

バッチ処理の障害再実行時など、再実行するプロセスのみ任意の日付を業務日付として実行できる。`repository-overwrite_environment_configuration` を使用してシステムプロパティで指定する。

> **補足**: ウェブアプリケーションのように全機能が1プロセス内で実行される場合は、単純にデータベースで管理されている日付を変更すればよい。

システムプロパティ形式: `BasicBusinessDateProvider.<区分>=日付`（日付はyyyyMMdd形式）

例: 区分`batch`の日付を`20160317`に設定する場合: `-DBasicBusinessDateProvider.batch=20160317`

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, 業務日付上書き, repository-overwrite_environment_configuration, システムプロパティ, バッチ再実行

</details>

## 業務日付を更新する

**クラス**: `nablarch.core.date.BasicBusinessDateProvider`

`SystemRepository` からプロバイダを取得し、`setDate` メソッドで更新する。

```java
// システムリポジトリからBasicBusinessDateProviderを取得する
BusinessDateProvider provider = SystemRepository.get("businessDateProvider");

// setDateメソッドを呼び出し、更新する
provider.setDate(segment, date);
```

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, SystemRepository, setDate, 業務日付更新

</details>

## 拡張例

## システム日時の切り替え

ユニットテストなどでシステム日時を切り替える手順:

1. `SystemTimeProvider` (`nablarch.core.date.SystemTimeProvider`) を実装したクラスを作成する。
2. 「システム日時の管理機能を使うための設定」に従い設定する。

## 業務日付の切り替え

ユニットテストなどで業務日付を切り替える手順:

1. `BusinessDateProvider` (`nablarch.core.date.BusinessDateProvider`) を実装したクラスを作成する。
2. 「業務日付管理機能を使うための設定」に従い設定する。

<details>
<summary>keywords</summary>

SystemTimeProvider, BusinessDateProvider, システム日時切り替え, 業務日付切り替え, ユニットテスト

</details>
