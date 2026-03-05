# 日付管理

## 機能概要

アプリケーションで使用するシステム日時(OS日時)と業務日付を一元的に管理する機能を提供する。

**システム日時(OS日時)と業務日付の切り替え**

コンポーネント定義で指定されたクラスを使用してシステム日時(OS日時)や業務日付を取得する。コンポーネント定義でクラスを差し替えるだけで、取得方法を切り替えることができる。テストなどで一時的に日時を切り替えたい場合に使用する。

参照: :ref:`date-system_time_change`, :ref:`date-business_date_change`

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

## 使用方法

**システム日時の管理機能を使うための設定**

`BasicSystemTimeProvider` をコンポーネント定義に追加する。コンポーネント名は `systemTimeProvider` と指定する。

```xml
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
```

**システム日時を取得する**

**クラス**: `SystemTimeUtil`

**業務日付管理機能を使うための設定**

データベースを使用して複数の業務日付を管理する。テーブルレイアウト:

| カラム | 説明 |
|---|---|
| 区分(PK) | 業務日付を識別するための値。文字列型 |
| 日付 | 業務日付。文字列型、yyyyMMdd形式 |

`BasicBusinessDateProvider` をコンポーネント定義に追加する。コンポーネント名は `businessDateProvider` と指定する。初期化が必要なので、初期化対象のリストに設定すること。

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
      <component-ref name="businessDateProvider" />
    </list>
  </property>
</component>
```

**業務日付を取得する**

**クラス**: `BusinessDateUtil`

**業務日付を任意の日付に上書く**

バッチ処理で障害時の再実行時に、過去日付をバッチ実行時の業務日付としたい場合、再実行するプロセスのみ任意の日付を業務日付として実行できる。

> **補足**: ウェブアプリケーションのように全ての機能が1プロセス内で実行される場合は、単純にデータベースで管理されている日付を変更すればよい。

:ref:`repository-overwrite_environment_configuration` を使用してシステムプロパティで指定する。

システムプロパティの形式:
```
BasicBusinessDateProvider.<区分>=日付
```
※日付はyyyyMMdd形式

例: 区分が"batch"の日付を"2016/03/17"に上書き
```
-DBasicBusinessDateProvider.batch=20160317
```

**業務日付を更新する**

`BasicBusinessDateProvider` の `setDate` メソッドを使用する。

```java
BusinessDateProvider provider = SystemRepository.get("businessDateProvider");
provider.setDate(segment, date);
```

## 拡張例

**システム日時を切り替える**

ユニットテストの実行時など、システム日時を切り替えたい場合:

1. `SystemTimeProvider` を実装したクラスを作成する。
2. :ref:`date-system_time_settings` に従い設定する。

**業務日付を切り替える**

ユニットテストの実行時など、業務日付を切り替えたい場合:

1. `BusinessDateProvider` を実装したクラスを作成する。
2. :ref:`date-business_date_settings` に従い設定する。
