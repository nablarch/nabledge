# 採番機能

## 概要

採番機能はアプリケーションで使用するID（例：取引明細ID等）を採番するための汎用的な機能。

- リポジトリに登録して使用する。初期化処理は :ref:`repository` が実行する。
- 各プロジェクトのアーキテクトが作成する採番機能において使用されることを想定しており、単体では使用しない。アプリケーションプログラマは本機能を直接使用しない。

<details>
<summary>keywords</summary>

採番機能, ID採番, リポジトリ初期化, アーキテクト, 採番対象ID

</details>

## 特徴

## 採番方法の選択

採番方法を採番単位（取引IDや売上明細ID等）で指定できるため、抜け番を許容するIDと許容しないIDで採番方法を切り替え可能。各データベースベンダー提供の採番機能（Oracleのシーケンスオブジェクト等）を使用する場合は、設定ファイルの変更のみで切り替え可能。

## フォーマット機能

各プロジェクトで独自のフォーマットを自由に追加・拡張可能。

<details>
<summary>keywords</summary>

採番方法選択, 抜け番, フォーマット, DBベンダー切り替え, 採番単位

</details>

## 要求

### 実装済み

- 連番（抜け番なし）の採番。連番＝業務処理コミット時に採番値が確定し抜け番が発生しないID。
- 高速採番（抜け番が発生する可能性あり、連番には非対応）: テーブルを使用して採番するが、ロック待機を最小限に抑え高速採番可能。
- 採番付加機能: フォーマット指定可能（採番IDの桁数揃え）。

### 未実装

- テーブル採番のサイクリック指定
- DBベンダー固有機能を使用した高速採番（Oracleシーケンス、DB2シーケンス）
- HILOアルゴリズム（一部をメモリ上で採番し、より高速採番）
- 採番付加機能: 業務日付付加、システム日付付加、採番値初期化

<details>
<summary>keywords</summary>

連番, 高速採番, HILOアルゴリズム, LpadFormatter, 実装済み機能, 未実装機能, フォーマット, サイクリック

</details>

## 構造

### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.common.idgenerator.IdGenerator` | IDを採番するインタフェース。プロジェクト独自の採番実装が必要な場合は本インタフェースを実装する。 |
| `nablarch.common.idgenerator.IdFormatter` | 採番したIDをフォーマットするインタフェース。プロジェクト独自のフォーマットが必要な場合は本インタフェースを実装する。 |

### IdGeneratorの実装クラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.idgenerator.TableIdGenerator` | テーブル（採番用テーブル）を使用して、抜け番を発生させずに採番するクラス。アプリケーションと同一のトランザクションで採番処理を行い、業務処理の確定順に採番可能。 |
| `nablarch.common.idgenerator.FastTableIdGenerator` | テーブル（採番用テーブル）を使用して高速に採番するクラス。アプリケーションとは異なるトランザクションで採番処理を行い即時コミット。ロック待機時間を最小限に抑える。テーブル採番部分はTableIdGeneratorに委譲する。 |

> **警告**: `TableIdGenerator`は業務トランザクションと同一のトランザクションが使用されるため、業務処理確定まで採番用テーブルのロックが保持される。他の処理が同一IDを採番しようとするとロック解放待ちとなり性能劣化の原因となる。業務的に抜け番が許容されるIDの場合は`FastTableIdGenerator`や`SequenceIdGeneratorSupport`の使用を強く推奨する。特にDB2やSQLServerではロックエスカレーション（ロックの範囲がレコードからページやテーブルに拡大）が発生し、性能劣化がより顕著となる可能性があるため注意が必要。

### IdFormatterの実装クラス

| クラス名 | 概要 |
|---|---|
| `nablarch.common.idgenerator.formatter.LpadFormatter` | 採番IDの桁数を揃えるフォーマッタークラス。指定桁数になるまで、指定文字を先頭に付加する。 |

<details>
<summary>keywords</summary>

IdGenerator, IdFormatter, TableIdGenerator, FastTableIdGenerator, LpadFormatter, nablarch.common.idgenerator.IdGenerator, nablarch.common.idgenerator.IdFormatter, nablarch.common.idgenerator.TableIdGenerator, nablarch.common.idgenerator.FastTableIdGenerator, nablarch.common.idgenerator.formatter.LpadFormatter, 採番インタフェース, ロックエスカレーション, SequenceIdGeneratorSupport

</details>

## 採番テーブルの構造とシーケンス図

### 採番テーブルの構造

| カラム | 型（Oracleの場合） | 備考 |
|---|---|---|
| ID | CHAR(4) | 採番対象を識別するためのID（採番対象ID）を格納するカラム |
| NO | NUMBER(10) | 採番対象IDの中で採番された値の最大値を保持するカラム |

> **注意**: テーブル名やカラム名は各プロジェクトの規約にしたがい命名する。リポジトリ機能を使用して任意の名前を設定できる。

### シーケンス図

**抜け番を出さない採番**:
![抜け番なし採番シーケンス図](../../../knowledge/component/libraries/assets/libraries-06_IdGenerator/IdGenerator_SequenceDiagram1.jpg)

**抜け番を出す可能性のある採番**:
![抜け番あり採番シーケンス図](../../../knowledge/component/libraries/assets/libraries-06_IdGenerator/IdGenerator_SequenceDiagram2.jpg)

<details>
<summary>keywords</summary>

採番テーブル, TableIdGenerator, FastTableIdGenerator, シーケンス図, 抜け番なし, 抜け番あり, 採番対象ID, ID_GENERATE

</details>

## 使用例

**テーブルデータ例**:

| ID | NO | 補足説明 |
|---|---|---|
| 1101 | 0 | サンプルID用レコード |
| 1102 | 10 | サンプルID2用レコード |

**採番クラスの実装例（プロジェクトのアーキテクトが作成）**:

```java
public class SampleGenerator {
    public static String generateSampleId() {
        IdGenerator generator = (IdGenerator) SystemRepository.getObject("tableIdGenerator");
        return generator.generateId("1101", null); // 1が返却される
    }
    public static String generateSampleId2() {
        IdGenerator generator = (IdGenerator) SystemRepository.getObject("fastTableIdGenerator");
        return generator.generateId("1102", new LpadFormatter(10, '0')); // 0000000011が返却される
    }
}
```

<details>
<summary>keywords</summary>

IdGenerator, LpadFormatter, generateId, SystemRepository, tableIdGenerator, fastTableIdGenerator, SampleGenerator, 採番クラス実装例

</details>

## 設定ファイルの定義

**設定ファイル例**:

```xml
<!-- 連番採番（抜け番なし） -->
<component name="tableIdGenerator" class="nablarch.common.idgenerator.TableIdGenerator">
    <property name="tableName" value="ID_GENERATE" />
    <property name="idColumnName" value="ID"/>
    <property name="noColumnName" value="NO"/>
</component>
<!-- 高速採番（抜け番あり） -->
<component name="fastTableIdGenerator" class="nablarch.common.idgenerator.FastTableIdGenerator">
    <property name="tableName" value="ID_GENERATE" />
    <property name="idColumnName" value="ID"/>
    <property name="noColumnName" value="NO"/>
    <property name="dbTransactionManager">
        <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
            <property name="dbTransactionName" value="generator"/>
        </component>
    </property>
</component>
<!-- 初期化設定 -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="TableIdGenerator"/>
            <component-ref name="FastTableIdGenerator"/>
        </list>
    </property>
</component>
```

### TableIdGeneratorのプロパティ

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | 採番テーブルのテーブル物理名 |
| idColumnName | ○ | 採番テーブルのIDカラムの物理名 |
| noColumnName | ○ | 採番テーブルのNOカラムの物理名 |
| dbTransactionName | | データベースコネクション名。ビジネスロジックで無名のDB接続を使用する場合は設定不要。 |

> **警告**: `dbTransactionName`を設定する場合は、必ずアプリケーションで使用するデータベースコネクション名と同一の値を設定すること。

### FastTableIdGeneratorのプロパティ

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | 採番テーブルのテーブル物理名 |
| idColumnName | ○ | 採番テーブルのIDカラムの物理名 |
| noColumnName | ○ | 採番テーブルのNOカラムの物理名 |
| dbTransactionManager | ○ | `nablarch.core.db.transaction.SimpleDbTransactionManager`を設定する |

### SimpleDbTransactionManagerのプロパティ（採番機能関連のみ）

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| dbTransactionName | | データベーストランザクション名。未設定の場合は`nablarch.common.idgenerator.FastTableIdGenerator`が自動設定される。 |

> **警告**: `dbTransactionName`を設定する場合は、ビジネスロジックで使用するトランザクション名と異なる値を設定すること。同一名を指定した場合、トランザクション開始時に例外が発生する。

テーブル採番クラスは初期化処理が必要なため、リポジトリ機能の初期化機能（`BasicApplicationInitializer`）を使用して初期化すること。

<details>
<summary>keywords</summary>

SimpleDbTransactionManager, BasicApplicationInitializer, tableName, idColumnName, noColumnName, dbTransactionName, dbTransactionManager, 設定ファイル, トランザクション制御, nablarch.core.db.transaction.SimpleDbTransactionManager, nablarch.core.repository.initialization.BasicApplicationInitializer

</details>
