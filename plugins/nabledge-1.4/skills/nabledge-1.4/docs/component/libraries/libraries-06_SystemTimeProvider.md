# 日付の管理機能

## クラス図

![システム日時クラス図](../../../knowledge/component/libraries/assets/libraries-06_SystemTimeProvider/Date_SystemTime_ClassDiagram.jpg)

**インタフェース**: `nablarch.core.date.SystemTimeProvider`
システム日時を取得するインタフェース。実装クラスを追加することでシステム日時の取得方法を切り替えられる。

**クラス**:

| クラス名 | 概要 |
|---|---|
| `nablarch.core.date.BasicSystemTimeProvider` | `SystemTimeProvider`の基本実装クラス。JVMの稼働マシンのシステム日時（`new java.util.Date()`）を取得する。 |
| `nablarch.core.date.SystemTimeUtil` | システム日時を取得するクラス。アプリケーションではこのクラスからシステム日時を取得する。 |

<details>
<summary>keywords</summary>

SystemTimeProvider, BasicSystemTimeProvider, SystemTimeUtil, nablarch.core.date.SystemTimeProvider, nablarch.core.date.BasicSystemTimeProvider, nablarch.core.date.SystemTimeUtil, システム日時取得, システム日時機能, クラス図

</details>

## SystemTimeUtilで提供される機能では不足している場合の対応方法

`SystemTimeUtil`で機能が不足する場合は、プロジェクト固有のシステム日時取得クラスを作成し`SystemTimeUtil`に処理を委譲する。

> **注意**: このクラスはプロジェクトのアーキテクトが実装するものであり、アプリケーションプログラマが実装するものではない。

```java
public class SampleSystemTimeUtil {
    public static Date getDate() {
        return SystemTimeUtil.getDate();
    }

    public static Time getTime() {
        return new Time(SystemTimeUtil.getDate().getTime());
    }
}
```

<details>
<summary>keywords</summary>

SystemTimeUtil, SampleSystemTimeUtil, システム日時取得拡張, プロジェクト固有実装

</details>

## クラス図

![業務日付クラス図](../../../knowledge/component/libraries/assets/libraries-06_SystemTimeProvider/Date_BusinessDate_ClassDiagram.jpg)

**インタフェース**: `nablarch.core.date.BusinessDateProvider`
業務日付を取得・設定するインタフェース。実装クラスを追加することで業務日付の取得方法の切り替え・設定ができる。

**クラス**:

| クラス名 | 概要 |
|---|---|
| `nablarch.core.date.BasicBusinessDateProvider` | `BusinessDateProvider`の基本実装クラス。データベースから業務日付を取得・設定する。 |
| `nablarch.core.date.BusinessDateUtil` | 業務日付を取得するクラス。アプリケーションではこのクラスから業務日付を取得する。 |

<details>
<summary>keywords</summary>

BusinessDateProvider, BasicBusinessDateProvider, BusinessDateUtil, nablarch.core.date.BusinessDateProvider, nablarch.core.date.BasicBusinessDateProvider, nablarch.core.date.BusinessDateUtil, 業務日付取得, 業務日付機能, クラス図

</details>

## テーブル定義

`BasicBusinessDateProvider`を使用する場合、以下のテーブルを用意する。テーブル名・カラム名は設定（:ref:`date_BusinessConfiguration`参照）で任意の名称が使用できる。

**業務日付テーブル**:

| 定義 | Javaの型 | 制約 | 備考 |
|---|---|---|---|
| 区分 | `java.lang.String` | プライマリキー | |
| 日付 | `java.lang.String` | | 値はyyyyMMdd形式であること |

![テーブル定義例](../../../knowledge/component/libraries/assets/libraries-06_SystemTimeProvider/Date_BusinessDate_EntityDiagram.jpg)

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, 業務日付テーブル, テーブル定義, 区分, yyyyMMdd

</details>

## 複数の業務日付の設定

業務日付ごとに区分を与えることで複数の業務日付を管理する。基本実装クラスでは区分で業務日付テーブルを検索し、対応する日付を返す。区分の割り振りは重複しないこと以外に制限はない。

区分を指定せずに業務日付を取得した場合は、設定ファイル（:ref:`date_BusinessConfiguration`参照）で設定したデフォルト区分が使用される。

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, 複数業務日付, 区分, defaultSegment, 業務日付管理

</details>

## 設定ファイル

```xml
<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider">
    <property name="tableName" value="BUSINESS_DATE" />
    <property name="segmentColumnName" value="SEGMENT"/>
    <property name="dateColumnName" value="BIZ_DATE"/>
    <property name="defaultSegment" value="00"/>
    <property name="cacheEnabled" value="true" />
    <property name="dbTransactionName" value="transaction" />
    <property name="transactionManager" ref="transactionManager" />
</component>
```

`component`の設定:

| 属性値 | 必須 | 設定値 |
|---|---|---|
| name | ○ | `businessDateProvider` |
| class | ○ | 使用する`BusinessDateProvider`実装クラス |

`nablarch.core.date.BasicBusinessDateProvider`のプロパティ:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | 業務日付テーブルのテーブル物理名 |
| segmentColumnName | ○ | 区分カラムの物理名 |
| dateColumnName | ○ | 日付カラムの物理名 |
| defaultSegment | ○ | 区分省略時に使用されるデフォルト区分 |
| cacheEnabled | | 業務日付テーブルのデータをキャッシュするか否か。デフォルトはキャッシュあり（省略時は`true`）。キャッシュを有効にすることを推奨する。無効にするとアクセスのたびにDBアクセスが発生し性能劣化の原因となる（特にバッチ処理）。キャッシュは初回取得時にスレッドコンテキスト（[thread-context-label](libraries-thread_context.md)参照）に全件保存され、:ref:`Threadcontexthandler`によってクリアされる。 |
| dbTransactionName | | トランザクション名。デフォルトのトランザクション名（`DbConnectionContext.getConnection()`）を使用する場合は省略可能。`DbConnectionContext.getConnection("appTransactionName")`のように引数を指定する場合はその引数値を設定する。 |
| transactionManager | ○ | 業務日付をDBから取得する際に使用するトランザクションマネージャ |

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, tableName, segmentColumnName, dateColumnName, defaultSegment, cacheEnabled, dbTransactionName, transactionManager, DbConnectionContext, 業務日付設定

</details>

## 日付の上書き機能

[date_table](#s4)で管理されている日付をプロセス単位で上書きする機能。主にバッチ処理の障害復旧時（障害発生時の日付を業務日付として再実行したい場合）に使用する。

> **注意**: 画面処理では全機能が1プロセス内で実行されるため、本機能ではなくデータベース上の日付を直接変更すること。

Javaの`-D`オプションを使用して:ref:`repository`に上書き日付を登録する。

| キー | 値 |
|---|---|
| `BasicBusinessDateProvider.{区分}` | 上書きしたい日付 |

例：区分`00`の日付を`20110710`に上書き:
```bash
java -DBasicBusinessDateProvider.00=20110710 Main
```

リポジトリに登録されていない区分はデータベースの値が、登録されている区分はリポジトリの値が優先される。

```java
// 20110710が取得される（リポジトリ未登録、DB値を使用）
getDate("00");

// 20110708が取得される（リポジトリ登録値が優先）
getDate("01");
```

<details>
<summary>keywords</summary>

BasicBusinessDateProvider, 業務日付上書き, 日付上書き, 障害復旧, バッチ処理

</details>

## 業務日付のメンテナンス

業務日付のメンテナンスは`setDate`メソッドで行う。

> **注意**: このクラスはプロジェクトのアーキテクトが実装するものであり、アプリケーションプログラマが実装するものではない。`BusinessDateUtil`が`setDate`を提供しないのも、アプリケーションプログラマが使用できないようにするためである。

```java
// リポジトリから業務日付を操作するクラスを取得する
BusinessDateProvider bdp = (BasicBusinessDateProvider) SystemRepository.getObject("businessDateProvider");

// 更新対象の区分値、更新する値を入力し、更新実行
bdp.setDate(segment, date);
```

<details>
<summary>keywords</summary>

BusinessDateProvider, BasicBusinessDateProvider, SystemRepository, setDate, 業務日付メンテナンス

</details>

## BusinessDateUtilで提供される機能では不足している場合の対応方法

`BusinessDateUtil`で機能が不足する場合は、プロジェクト固有の業務日付取得クラスを作成し`BusinessDateUtil`に処理を委譲する。

> **注意**: このクラスはプロジェクトのアーキテクトが実装するものであり、アプリケーションプログラマが実装するものではない。

```java
public class SampleBusinessDateUtil {
    public static String getDate() {
        return BusinessDateUtil.getDate();
    }

    public static String getBeforeDate() {
        // 業務日付の前日を取得する処理
    }
}
```

<details>
<summary>keywords</summary>

BusinessDateUtil, SampleBusinessDateUtil, 業務日付取得拡張, プロジェクト固有実装

</details>

## 概要・特徴・要求

業務日付とシステム日時（OS日時）の管理・取得機能を提供する。

**システム日時**: OS日時（サーバ日時）のことであり、業務日付のような営業日・非営業日の概念を持たない。

**業務日付の特徴**:
- 複数の業務日付を管理可能（例：オンラインとバッチで別の業務日付を使用）
- 業務日付ごとに個別の更新タイミングを指定可能
- 取得方法を実装クラスで切り替え可能

**実装済み機能**:
- システム日付の取得
- 業務日付の取得
- 複数業務日付の管理
- 業務日付の任意日付への上書き（バッチ障害時の再実行など、プロセスごとに日付を変更可能）
- 業務日付のメンテナンス

<details>
<summary>keywords</summary>

日付管理機能, 業務日付, システム日時, 概要, 特徴, 要求

</details>

## 日付ユーティリティ

システム日時や業務日付に関係しない日付関連機能を日付ユーティリティとして提供する。詳細は[date-util-spec](libraries-99_Utility.md)を参照すること。

<details>
<summary>keywords</summary>

日付ユーティリティ, date-util-spec

</details>
