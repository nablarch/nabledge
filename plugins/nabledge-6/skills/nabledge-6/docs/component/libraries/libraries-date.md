# 日付管理

**目次**

* 機能概要

  * システム日時(OS日時)と業務日付の切り替えができる
* モジュール一覧
* 使用方法

  * システム日時の管理機能を使うための設定
  * システム日時を取得する
  * 業務日付管理機能を使うための設定
  * 業務日付を取得する
  * 業務日付を任意の日付に上書く
  * 業務日付を更新する
* 拡張例

  * システム日時を切り替える
  * 業務日付を切り替える

アプリケーションで使用するシステム日時(OS日時)と業務日付を一元的に管理する機能を提供する。

## 機能概要

### システム日時(OS日時)と業務日付の切り替えができる

この機能では、コンポーネント定義で指定されたクラスを使用して、システム日時(OS日時)や業務日付を取得する。
そのため、コンポーネント定義で指定するクラスを差し替えるだけで、
アプリケーションで使用するシステム日時(OS日時)と業務日付の取得方法を切り替えることができる。
この切り替えは、テストなどで一時的にシステム日時(OS日時)や業務日付を切り替えたい場合に使用できる。

* [システム日時を切り替える](../../component/libraries/libraries-date.md#date-system-time-change)
* [業務日付を切り替える](../../component/libraries/libraries-date.md#date-business-date-change)

## モジュール一覧

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

### システム日時の管理機能を使うための設定

システム日時の管理機能を使うためには、
BasicSystemTimeProvider の設定をコンポーネント定義に追加する。
コンポーネント名には **systemTimeProvider** と指定する。

```xml
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
```

### システム日時を取得する

システム日時の取得は、 SystemTimeUtil を使用する。

### 業務日付管理機能を使うための設定

業務日付管理機能では、データベースを使用して複数の業務日付を管理する。
テーブルのレイアウトは以下となる。

| 区分(PK) | 業務日付を識別するための値。文字列型 |
|---|---|
| 日付 | 業務日付。文字列型で値はyyyyMMdd形式 |

業務日付管理機能を使うためには、
BasicBusinessDateProvider の設定をコンポーネント定義に追加する。
コンポーネント名には **businessDateProvider** と指定する。

また初期化が必要なので、初期化対象のリストに設定すること。

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

### 業務日付を取得する

業務日付の取得は、 BusinessDateUtil を使用する。

### 業務日付を任意の日付に上書く

バッチ処理で障害時の再実行時に、過去日付をバッチ実行時の業務日付としたい場合がある。
このような場合に、再実行するプロセスのみ任意の日付を業務日付として実行できる。

> **Tip:**
> ウェブアプリケーションのように、全ての機能が１プロセス内で実行される場合は、
> 単純にデータベースで管理されている日付を変更すればよい。

業務日付の上書きは、 [システムプロパティを使って環境依存値を上書きする](../../component/libraries/libraries-repository.md#repository-overwrite-environment-configuration) を使用して行う。
システムプロパティとして、以下の形式で指定する。

システムプロパティの形式
BasicBusinessDateProvider.<区分>=日付

※日付はyyyyMMdd形式
システムプロパティの例
区分が"batch"の日付を"2016/03/17"に上書きしたい場合

-DBasicBusinessDateProvider.batch=20160317

### 業務日付を更新する

業務日付の更新は、 BasicBusinessDateProvider を使用して行う。

```java
// システムリポジトリからBasicBusinessDateProviderを取得する
BusinessDateProvider provider = SystemRepository.get("businessDateProvider");

// setDateメソッドを呼び出し、更新する
provider.setDate(segment, date);
```

## 拡張例

### システム日時を切り替える

ユニットテストの実行時など、システム日時を切り替えたい場合は、以下の手順で行う。

1. SystemTimeProvider を実装したクラスを作成する。
2. [システム日時の管理機能を使うための設定](../../component/libraries/libraries-date.md#date-system-time-settings) に従い設定する。

### 業務日付を切り替える

ユニットテストの実行時など、業務日付を切り替えたい場合は、以下の手順で行う。

1. BusinessDateProvider を実装したクラスを作成する。
2. [業務日付管理機能を使うための設定](../../component/libraries/libraries-date.md#date-business-date-settings) に従い設定する。
