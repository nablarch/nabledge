# 日付の管理機能

## 概要

業務日付とシステム日時（OS日時）の管理・取得機能を提供する。日付ユーティリティも提供する。

<details>
<summary>keywords</summary>

日付管理, システム日時, 業務日付, 日付ユーティリティ, OS日時

</details>

## 特徴

- 業務日付・システム日時の取得方法は切り替え可能（実装クラスを追加することで要件に応じた取得方法に変更可能）。
- 複数の業務日付を設定可能（例：オンラインとバッチで別の業務日付を使用）。各業務日付ごとに個別の更新タイミングを指定可能。

<details>
<summary>keywords</summary>

拡張性, 業務日付切り替え, 複数業務日付, SystemTimeProvider, BusinessDateProvider

</details>

## 要求

**実装済み機能:**
- システム日付を取得できる
- 業務日付を取得できる
- 業務日付を複数管理できる
- 業務日付を任意の日付に上書きできる（バッチ処理の障害時再実行時、再実行プロセスのみ過去日付を業務日付として実行可能）
- 業務日付をメンテナンスできる

<details>
<summary>keywords</summary>

システム日付取得, 業務日付取得, 業務日付上書き, 業務日付メンテナンス, 複数業務日付管理

</details>

## システム日時機能

システム日時とはOS日時（サーバ日時）のこと。業務日付と異なり、営業日/非営業日の概念を持たない。

**インタフェース**: `nablarch.core.date.SystemTimeProvider`
システム日時を取得するインタフェース。実装クラスを追加することでシステム日時の取得方法を切り替え可能。

**クラス**:
- `nablarch.core.date.BasicSystemTimeProvider`: SystemTimeProviderの基本実装。JVMのシステム日時（`new java.util.Date()`）を取得する。
- `nablarch.core.date.SystemTimeUtil`: アプリケーションからシステム日時を取得するクラス。

**SystemTimeUtilで不足する場合:** プロジェクト固有のシステム日時取得クラスを追加する（アーキテクトが実装）。SystemTimeUtilの機能はSystemTimeUtilに委譲し、固有機能を追加する。

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

SystemTimeProvider, BasicSystemTimeProvider, SystemTimeUtil, SampleSystemTimeUtil, システム日時取得, OS日時, nablarch.core.date.SystemTimeProvider, nablarch.core.date.SystemTimeUtil, nablarch.core.date.BasicSystemTimeProvider

</details>

## 業務日付機能

本章では業務日付機能について説明する。

**インタフェース**: `nablarch.core.date.BusinessDateProvider`
業務日付を取得・設定するインタフェース。実装クラスを追加することで取得方法の切り替えと設定が可能。

**クラス**:
- `nablarch.core.date.BasicBusinessDateProvider`: BusinessDateProviderの基本実装。DBから業務日付を取得・設定する。
- `nablarch.core.date.BusinessDateUtil`: アプリケーションから業務日付を取得するクラス。

<details>
<summary>keywords</summary>

BusinessDateProvider, BasicBusinessDateProvider, BusinessDateUtil, 業務日付取得, 業務日付設定, nablarch.core.date.BusinessDateProvider, nablarch.core.date.BasicBusinessDateProvider, nablarch.core.date.BusinessDateUtil

</details>

## 業務日付テーブル定義

BasicBusinessDateProviderを使用する場合、以下のデータベーステーブルを用意する。テーブル名・カラム名は任意（設定で指定）。

| 定義 | Javaの型 | 制約 | 備考 |
|---|---|---|---|
| 区分 | java.lang.String | プライマリキー | |
| 日付 | java.lang.String | | 値はyyyyMMdd形式 |

<details>
<summary>keywords</summary>

業務日付テーブル, tableName, segmentColumnName, dateColumnName, 区分, 日付カラム, yyyyMMdd, BasicBusinessDateProvider

</details>

## 複数の業務日付の設定

区分（プライマリキー）ごとに業務日付を管理することで複数の業務日付を管理する。区分の割り振り方は重複しないこと以外に制限なし。

区分を省略して業務日付を取得した場合は、設定ファイルの`defaultSegment`で設定した区分が使用される。

<details>
<summary>keywords</summary>

複数業務日付, 区分, defaultSegment, 業務日付管理

</details>

## 設定ファイル（BasicBusinessDateProvider）

設定ファイルの記述方法を説明する。

**設定例**:

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

`component`の`name`属性には`"businessDateProvider"`を設定する（必須）。

**BasicBusinessDateProviderのプロパティ**:

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | 業務日付テーブルの物理名 |
| segmentColumnName | ○ | 区分カラムの物理名 |
| dateColumnName | ○ | 日付カラムの物理名 |
| defaultSegment | ○ | 区分省略時に使用する区分 |
| cacheEnabled | | キャッシュ有無。省略時はキャッシュあり。無効にする場合のみ`false`を設定。バッチ処理では有効化を推奨（無効だと業務日付取得のたびDBアクセスが発生し性能劣化の原因になる）。キャッシュ有効時は最初の取得時に全業務日付データをスレッドコンテキストにキャッシュし、ThreadContextHandlerによってクリアされる。 |
| dbTransactionName | | トランザクション名。業務アプリケーションと同一DB接続を使用するため、業務アプリと同じトランザクション名を設定する。省略可否は下記のコードで判断する。 |
| transactionManager | ○ | トランザクションマネージャ |

**dbTransactionNameの設定判断**:

```java
// 以下のコードでコネクションが取得できる場合は、本プロパティへの設定は省略可能
AppDbConnection con = DbConnectionContext.getConnection();

// 以下のコードでコネクションを取得する必要がある場合は、
// 本プロパティには、getConnectionへ設定している引数("appTransactionName")を設定する。
AppDbConnection con = DbConnectionContext.getConnection("appTransactionName");
```

<details>
<summary>keywords</summary>

date_BusinessConfiguration, businessDateProvider, tableName, segmentColumnName, dateColumnName, defaultSegment, cacheEnabled, dbTransactionName, transactionManager, DbConnectionContext, getConnection, 設定ファイル, BasicBusinessDateProvider

</details>

## 日付の上書き機能

DBで管理される日付をプロセス単位で上書き可能。主にバッチ処理の障害復旧時（障害発生時の日付で再実行したい場合）に使用。画面処理（全機能が1プロセス内）ではDBの値を直接変更すること。

Javaの「-D」オプションで上書き日付を指定する:
- キー: `BasicBusinessDateProvider.{区分}`
- 値: 上書きしたい日付

```bash
java -DBasicBusinessDateProvider.00=20110710 Main
```

リポジトリに日付が登録されている区分はリポジトリの値が使用され、登録されていない区分はDBの値が使用される。

```java
// 20110710が取得される（リポジトリに登録なし → DBの値）
getDate("00");

// 20110708が取得される（リポジトリに登録あり → リポジトリの値）
getDate("01");
```

<details>
<summary>keywords</summary>

日付の上書き, BasicBusinessDateProvider, -D, 起動パラメータ, 障害復旧, バッチ再実行, プロセス単位

</details>

## 業務日付のメンテナンス

`BusinessDateUtil`は`setDate`を意図的に提供しない（アプリケーションプログラマが使えないようにするため）。業務日付のメンテナンスはアーキテクトが実装するクラスから`setDate`メソッドで行う。

```java
// リポジトリから業務日付を操作するクラスを取得する
BusinessDateProvider bdp = (BasicBusinessDateProvider) SystemRepository.getObject("businessDateProvider");

// 更新対象の区分値、更新する値を入力し、更新実行
bdp.setDate(segment, date);
```

<details>
<summary>keywords</summary>

setDate, 業務日付メンテナンス, BusinessDateProvider, SystemRepository, businessDateProvider

</details>

## BusinessDateUtilで不足する場合

BusinessDateUtilで提供される機能に不足がある場合には、プロジェクト固有の業務日付取得クラスを追加する（アーキテクトが実装）。BusinessDateUtilの機能はBusinessDateUtilに委譲し、固有機能を追加する。

```java
public class SampleBusinessDateUtil {
    public static String getDate() {
        // BusinessDateUtilで実装されている機能については、BusinessDateUtilに処理を移譲する。
        return BusinessDateUtil.getDate();
    }

    // プロジェクト固有の実装を行う。

    public static String getBeforeDate() {
        // 業務日付の前日を取得する処理
    }
}
```

<details>
<summary>keywords</summary>

SampleBusinessDateUtil, BusinessDateUtil, プロジェクト固有, 業務日付拡張

</details>

## 日付ユーティリティ

システム日時・業務日付に関係しない日付関連機能を日付ユーティリティとして提供する。詳細は [date-util-spec](libraries-99_Utility.md) を参照。

<details>
<summary>keywords</summary>

日付ユーティリティ, date-util-spec, 日付関連機能

</details>
