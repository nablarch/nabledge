# 日付の管理機能

## 概要

業務日付とシステム日時(OS日時)の管理・取得機能を提供する。日付ユーティリティについても説明する。

<details>
<summary>keywords</summary>

日付管理, 業務日付, システム日時, 日付ユーティリティ

</details>

## 特徴

- 業務日付・システム日時の取得方法は、実装クラスの切り替えにより変更可能（高い拡張性）
- 業務日付は複数設定が可能。例：オンラインとバッチで別の業務日付を使用し、各業務日付ごとに更新タイミングを個別指定できる

<details>
<summary>keywords</summary>

拡張性, 業務日付複数設定, 取得方法切り替え, オンラインとバッチで別業務日付

</details>

## 要求

## 実装済み機能

- システム日付の取得
- 業務日付の取得
- 業務日付の複数管理
- 業務日付の任意日付への上書き（バッチ処理の障害復旧時などに、対象プロセスのみ過去日付を業務日付として使用可能）
- 業務日付のメンテナンス

<details>
<summary>keywords</summary>

システム日付取得, 業務日付取得, 業務日付複数管理, 業務日付上書き, 業務日付メンテナンス

</details>

## システム日時機能

システム日時とは、OS日時(サーバ日時)のことを指し、業務日付のように営業日や非営業日の考え方を持たない日時である。

## クラス・インタフェース

**インタフェース**: `nablarch.core.date.SystemTimeProvider`  
システム日時を取得するインタフェース。実装クラスを追加することで取得方法を切り替え可能。

**クラス**: `nablarch.core.date.BasicSystemTimeProvider`  
SystemTimeProviderの基本実装。`new java.util.Date()`でJVMのシステム日時を取得する。

**クラス**: `nablarch.core.date.SystemTimeUtil`  
アプリケーションからシステム日時を取得するクラス。アプリケーションでは本クラスを使用する。

## SystemTimeUtil機能不足時の拡張

SystemTimeUtilで機能不足の場合は、プロジェクト固有クラスを追加し、SystemTimeUtilへ処理移譲するパターンで実装する。

```java
public class SampleSystemTimeUtil {
    public static Date getDate() {
        return SystemTimeUtil.getDate();
    }
    // プロジェクト固有メソッドを追加
    public static Time getTime() {
        return new Time(SystemTimeUtil.getDate().getTime());
    }
}
```

> **注意**: この実装はプロジェクトのアーキテクトが実装すべきもの。アプリケーションプログラマが実装することはない。

<details>
<summary>keywords</summary>

SystemTimeProvider, BasicSystemTimeProvider, SystemTimeUtil, システム日時取得, OS日時, SampleSystemTimeUtil, 営業日, 非営業日, 業務日付との違い

</details>

## 業務日付機能 — クラス・インタフェース・テーブル定義

## クラス・インタフェース

**インタフェース**: `nablarch.core.date.BusinessDateProvider`  
業務日付を取得・設定するインタフェース。実装クラスを追加することで取得方法の切り替えと業務日付の設定が可能。

**クラス**: `nablarch.core.date.BasicBusinessDateProvider`  
BusinessDateProviderの基本実装。DBから業務日付を取得・設定する。

**クラス**: `nablarch.core.date.BusinessDateUtil`  
アプリケーションから業務日付を取得するクラス。アプリケーションでは本クラスを使用する。

## 業務日付テーブル定義（BasicBusinessDateProvider使用時）

テーブル名・カラム名に制約はなく、設定で任意の名称を使用できる。

| カラム | 型 | 制約 | 備考 |
|---|---|---|---|
| 区分 | java.lang.String | PK | |
| 日付 | java.lang.String | | yyyyMMdd形式 |

## 複数業務日付の設定

区分ごとに異なる業務日付を管理する。区分の割り振りは重複しなければ制限なし。区分を省略した場合は設定ファイルのdefaultSegmentが使用される。

<details>
<summary>keywords</summary>

BusinessDateProvider, BasicBusinessDateProvider, BusinessDateUtil, 業務日付テーブル, 区分, 複数業務日付, defaultSegment

</details>

## 業務日付機能 — 設定ファイル

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

コンポーネントの `name` は `"businessDateProvider"` とすること。

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| tableName | ○ | | 業務日付テーブルの物理名 |
| segmentColumnName | ○ | | 区分カラムの物理名 |
| dateColumnName | ○ | | 日付カラムの物理名 |
| defaultSegment | ○ | | 区分省略時のデフォルト区分 |
| cacheEnabled | | true | 業務日付テーブルのデータをキャッシュするか否か |
| dbTransactionName | | | データベーストランザクション名 |
| transactionManager | ○ | | トランザクションマネージャ |

**cacheEnabled**:
- デフォルトはキャッシュあり（省略時true）。キャッシュを無効にする場合のみ`false`を設定
- キャッシュ有効時: 初回呼び出し時に全業務日付をスレッドコンテキスト（[thread-context-label](libraries-thread_context.md)）にキャッシュし、:ref:`Threadcontexthandler` によりクリア
- バッチ処理など大量データを繰り返し処理する場合、キャッシュ無効化は業務日付取得のたびにDBアクセスが発生し性能劣化の一因となるため、**キャッシュ有効化を推奨**

**dbTransactionName**:
- デフォルトトランザクション（`DbConnectionContext.getConnection()`でコネクション取得可能）を使用する場合は省略可
- `DbConnectionContext.getConnection("appTransactionName")`のように引数を指定してコネクションを取得する場合は、その引数（トランザクション名）を設定する

<details>
<summary>keywords</summary>

cacheEnabled, tableName, segmentColumnName, dateColumnName, dbTransactionName, transactionManager, Threadcontexthandler, thread-context-label, AppDbConnection, DbConnectionContext, BasicBusinessDateProvider設定

</details>

## 業務日付機能 — 上書き・メンテナンス・拡張

## 日付の上書き機能

プロセス単位に業務日付を上書きする機能。主にバッチ処理の障害復旧時（現在日付でなく障害発生時の日付で再実行）に使用。画面処理では不要（DBの日付を直接変更すればよい）。

JVM起動時の`-D`オプションで上書きする:

| キー | 値 |
|---|---|
| `BasicBusinessDateProvider.{区分}` | 上書きしたい日付 |

```bash
java -DBasicBusinessDateProvider.00=20110710 Main
```

リポジトリに日付が登録されている区分はリポジトリの値が使用され、登録されていない区分はDBの値が使用される。

```java
// 20110710が取得される。（リポジトリに登録なし → DBの値）
getDate("00");

// 20110708が取得される。（リポジトリに登録あり → リポジトリの値）
getDate("01");
```

## 業務日付のメンテナンス

`setDate(segment, date)`メソッドで更新する。BusinessDateUtilはsetDateを提供しない（アプリケーションプログラマが直接使用できないようにするため）。

```java
BusinessDateProvider bdp = (BasicBusinessDateProvider) SystemRepository.getObject("businessDateProvider");
bdp.setDate(segment, date);
```

> **注意**: この実装はプロジェクトのアーキテクトが実装すべきもの。アプリケーションプログラマが実装することはない。

## BusinessDateUtil機能不足時の拡張

BusinessDateUtilで機能不足の場合は、プロジェクト固有クラスを追加し、BusinessDateUtilへ処理移譲するパターンで実装する。

```java
public class SampleBusinessDateUtil {
    public static String getDate() {
        return BusinessDateUtil.getDate();
    }
    // プロジェクト固有メソッドを追加
    public static String getBeforeDate() {
        // 業務日付の前日を取得する処理
    }
}
```

> **注意**: この実装はプロジェクトのアーキテクトが実装すべきもの。アプリケーションプログラマが実装することはない。

<details>
<summary>keywords</summary>

業務日付上書き, setDate, 業務日付メンテナンス, SampleBusinessDateUtil, BasicBusinessDateProvider上書き, -Dオプション, 障害復旧

</details>

## 日付ユーティリティ

システム日時や業務日付に関係しない日付機能を日付ユーティリティとして提供する。詳細は [date-util-spec](libraries-99_Utility.md) 参照。

<details>
<summary>keywords</summary>

日付ユーティリティ, date-util-spec

</details>
