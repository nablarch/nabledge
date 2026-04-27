# 採番機能

## 概要

アプリケーションで使用するID(例えば取引明細ID等)を採番するための汎用的な機能を提供する。

本機能は、リポジトリに登録して使用する。
このため、本機能に必要な初期化処理は [リポジトリ](../../component/libraries/libraries-02-Repository.md#repository) が実行する。

また、本機能は各プロジェクトでアーキテクトが作成する採番機能において使用されることを想定しており、単体で使用することはない。
このため、アプリケーションプログラマは、本機能を直接使用することはない。

> **Note:**
> 本章で登場するデータベースに関する記述の詳細は、下記ドキュメントを参照すること。

> * >   [データベースアクセス(検索、更新、登録、削除)機能](../../component/libraries/libraries-04-DbAccessSpec.md)
> * >   [データベースコネクション名とトランザクション名](../../component/libraries/libraries-04-TransactionConnectionName.md)

## 特徴

### 採番方法を選択可能

採番方法を採番単位(取引IDや、売上明細ID等の単位)で指定できるため、抜け番を許容するIDと許容しないIDで採番方法を切り替える事が可能となっている。
また、各データベースベンダーによって提供されている採番機能(Oracleのシーケンスオブジェクト等)を使用したい場合は、設定ファイルの変更のみで切り替え可能となっている。

### 採番した値をフォーマット出来る機能

各プロジェクトで独自のフォーマットを自由に追加、拡張することが可能となっている。

## 要求

### 実装済み

* 連番(抜け番を出さない) [1] を採番できる。
* 高速な採番処理を選択できる。

  高速に採番する機能は、抜け番が発生する可能性があり、連番 [1] には対応していない。

  * テーブルを使用して採番を行うが、ロック待機を最小限に抑え高速に採番できる。
* 採番付加機能

  * フォーマットを指定できる。

    * 採番したIDの桁数を揃えることができる。

連番とは、業務処理が確定(コミット)したタイミングで採番したIDが確定し抜け番が発生しないIDのことを指す。

### 未実装機能

* テーブル採番を使用した場合に、サイクリック指定できる。
* データベースベンダー固有の機能を使用して高速に採番できる。

  * Oracleシーケンスを使用して採番できる。
  * DB2シーケンスを使用して採番できる。
* より高速な採番処理を選択できる。

  * テーブルを使用して採番を行うが、一部をメモリ上で採番し、より高速に採番できる。(HILOアルゴリズム)
* 採番付加機能

  * 採番したIDの先頭に業務日付を付加できる。
  * 採番したIDの先頭にシステム日付を付加できる。
  * 採番した値を初期化できる。

## 構造

### クラス図

![IdGenerator_ClassDiagram.jpg](../../../knowledge/assets/libraries-06-IdGenerator/IdGenerator_ClassDiagram.jpg)

### 各クラスの責務

#### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.common.idgenerator.IdGenerator | IDを採番するインタフェース。  各プロジェクトで独自の採番実装が必要となった場合には、本インタフェースを実装することにより実現可能となっている。 |
| nablarch.common.idgenerator.IdFormatter | 採番したIDをフォーマットするインタフェース。  各プロジェクトで独自のフォーマットを行う必要がある場合は、本インタフェースを実装することにより実現可能となっている。 |

#### クラス定義

a) nablarch.common.idgenerator.IdGeneratorの実装クラス
| クラス名 | 概要 |
|---|---|
| テーブルを使用した採番クラス |  |
| nablarch.common.idgenerator.TableIdGenerator | テーブル(採番用テーブル)を使用して、抜け番を発生させずに採番を行うクラス。  本クラスは、アプリケーションと同一のトランザクションを使用して採番処理を行う。 これにより業務処理と同じタイミングで採番された値が確定されるため、抜け番の発生を防止する事ができる。 また、業務処理の確定順に採番を行うことができる。  > **Warning:** > 業務トランザクションと同一のトランザクションが使用されるため、業務処理のトランザクションが確定するまで、 > 採番用テーブルのロックが保持された状態となる。 > ロックが保持されている状態で、他の処理が同一のIDを採番しようとすると、ロック解放待ちとなるため性能劣化の原因になる。  > このため、業務的に抜け番が許容されるIDの場合には、抜け番の可能性がある採番(FastTableIdGeneratorやSequenceIdGeneratorSupport) > を使用することを強く推奨する。  > 特にDB2やSQLServerを使用した場合は、ロックエスカレーション(ロックの範囲がレコードではなく、ページやテーブルへと拡大すること)が発生し、 > ロック待機がより広範囲に広がり、性能劣化がより顕著となる可能性があるため注意が必要である。 |
| nablarch.common.idgenerator.FastTableIdGenerator | テーブル(採番用テーブル)を使用して、高速に採番を行うクラス。  本クラスは、アプリケーションとは異なるトランザクションを使用して採番処理を行い、即時にコミット処理を行う。 このため、ロック待機時間を最小限に抑えることができ、高速に採番処理を行うことができる。  本クラスは、テーブルを使用した採番部分はTableIdGeneratorに委譲して行い、トランザクション制御のみを実装している。 |
b) nablarch.common.idgenerator.IdFormatterの実装クラス
| クラス名 | 概要 |
|---|---|
| nablarch.common.idgenerator.formatter.LpadFormatter | 採番されたIDの桁数を揃えるフォーマッタークラス。  指定された桁数になるまで、指定された文字を先頭に付加する。 |

## テーブルを使用した採番機能

本章では、テーブルを使用した採番機能についての説明を行う。

### 採番テーブルの構造

採番テーブルの構造例

| カラム | 型(Oracleの場合) | 備考 |
|---|---|---|
| ID | CHAR(4) | 採番対象を識別するためのID(採番対象ID)を格納するカラム |
| NO | NUMBER(10) | 採番対象IDの中で採番された値の最大値を保持するカラム |

> **Note:**
> テーブル名やカラム名は、各プロジェクトの規約にしたがい命名することが考えられる。
> このため、リポジトリ機能を使用して任意の名前を設定できるようになっている。

### シーケンス図

#### 抜け番を出さない採番

![IdGenerator_SequenceDiagram1.jpg](../../../knowledge/assets/libraries-06-IdGenerator/IdGenerator_SequenceDiagram1.jpg)

#### 抜け番を出す可能性のある採番

![IdGenerator_SequenceDiagram2.jpg](../../../knowledge/assets/libraries-06-IdGenerator/IdGenerator_SequenceDiagram2.jpg)

### 使用例

#### テーブルデータ例

| ID | NO | 補足説明 |
|---|---|---|
| 1101 | 0 | サンプルID用レコード |
| 1102 | 10 | サンプルID2用レコード |

#### プロジェクト毎の採番クラスの実装例

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class SampleGenerator {

    /**
     * サンプルIDを採番する。<br>
     * @reutrn サンプルID
     */
    public static String generateSampleId() {
        // フォーマットが不要な場合
        IdGenerator generator = (IdGenerator) SystemRepository.getObject("tableIdGenerator");
        return generator.generateId("1101", null);        // 1が返却される。
    }

    /**
     * サンプルID２を採番する。<br>
     * @reutrn サンプルID2(10桁で先頭0埋めされた値)
     */
    public static String generateSampleId2() {
        // フォーマットが必要となる場合
        IdGenerator generator = (IdGenerator) SystemRepository.getObject("fastTableIdGenerator");
        return generator.generateId("1102", new LpadFormatter(10, '0'));    // 0000000011が返却される。
    }
}
```

#### 設定ファイルの定義

```xml
<!--
連番を採番するクラスの設定(抜け番を出さない採番)
-->
<component name="tableIdGenerator" class="nablarch.common.idgenerator.TableIdGenerator">
    <property name="tableName" value="ID_GENERATE" />
    <property name="idColumnName" value="ID"/>
    <property name="noColumnName" value="NO"/>
</component>

<!--
高速に採番を行うクラスの設定(抜け番を出す可能性のある採番)
-->
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

<!--
採番機能の初期化設定
テーブル採番を使用するクラスは、初期化処理が必要となるためリポジトリ機能の初期化機能を使用して初期化を行う。
-->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="TableIdGenerator"/>
            <component-ref name="FastTableIdGenerator"/>
        </list>
    </property>
</component>
```

##### 設定内容詳細

a) 連番を採番するクラスの設定
a)-1. componentの設定
| 属性値 | 設定内容 |
|---|---|
| name(必須) | 任意の値を設定する。 各プロジェクトで作成する採番クラスが、SystemRepositoryから IdGeneratorを取得する際に使用する値となる。 |
| class(必須) | nablarch.common.idgenerator.TableIdGenerator |
a)-2. nablarch.common.idgenerator.TableIdGeneratorの設定
| property名 | 設定内容 |
|---|---|
| tableName(必須) | 採番テーブルのテーブル物理名設定する。 |
| idColumnName(必須) | 採番テーブルのIDカラムの物理名を設定する。 |
| noColumnName(必須) | 採番テーブルのNOカラムの物理名を設定する。 |
| dbTransactionName | データベースコネクション名を設定する。 ビジネスロジックで無名のデータベース接続を使用する場合は、設定不要。  > **Warning:** > 無名のデータベース接続以外を使用する場合(本設定値を記述する場合)は、 > 必ずアプリケーションで使用するデータベース接続と同一のデータベースコネクション名を設定すること。 |

※採番テーブルのレイアウトは、 [採番テーブルの構造](../../component/libraries/libraries-06-IdGenerator.md#id-table-label) を参照。
b) 高速に採番を行うクラスの設定
b)-1. componentの設定
| 属性値 | 設定内容 |
|---|---|
| name(必須) | 任意の値を設定する。 各プロジェクトで作成する採番クラスが、SystemRepositoryから IdGeneratorを取得する際に使用する値となる。 |
| class(必須) | nablarch.common.idgenerator.FastTableIdGenerator |
b)-2. nablarch.common.idgenerator.FastTableIdGeneratorの設定
| property名 | 設定内容 |
|---|---|
| tableName(必須) | 採番テーブルのテーブル物理名設定する。 |
| idColumnName(必須) | 採番テーブルのIDカラムの物理名を設定する。 |
| noColumnName(必須) | 採番テーブルのNOカラムの物理名を設定する。 |
| dbTransactionManager(必須) | nablarch.core.db.transaction.SimpleDbTransactionManagerを設定する。 このクラスを使用して、トランザクション制御を行う。 |

b)-3. nablarch.core.db.transaction.SimpleDbTransactionManagerの設定

SimpleDbTransactionManagerへの設定は、本機能で必要なプロパティのみ記載している。
ここに記載のない設定値は、データベース機能を参照すること。

| property名 | 設定内容 |
|---|---|
| dbTransactionName | データベーストランザクション名を設定する。 本設定値が設定されていない場合は、データベーストランザクション名に、 「nablarch.common.idgenerator.FastTableIdGenerator」を自動で設定し、トランザクション制御を行う。  > **Warning:** > 本設定値を設定する場合には、ビジネスロジックで使用するトランザクション名と異なる値を設定すること。 > ビジネスロジックで使用するトランザクションと同一の名前を指定した場合、トランザクション開始時に例外が発生する。 |
