# マスタデータ復旧機能

**公式ドキュメント**: [マスタデータ復旧機能](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/04_MasterDataRestore.html)

## 概要

自動テスト中にマスタデータが更新された場合、そのテストメソッドが終了した時点でマスタデータを元の状態に復旧する機能。

マスタメンテナンス機能等のテストでは、マスタデータを変更しないと実施できない異常系テストケース（例: 存在するはずのデータが存在しなかった場合のテスト）が存在し、マスタレコードの削除が必要になる場合がある。テスト中にマスタデータを変更した場合、それ以降のテストクラスではマスタデータが意図しない状態になりテストが失敗することがある。本機能はこのような意図しないテスト失敗を防止するために提供される。

<details>
<summary>keywords</summary>

マスタデータ復旧, マスタデータ変更, テスト失敗防止, テストメソッド終了, 異常系テスト

</details>

## 特徴

本機能には以下の特徴がある。

- テストの実行順序に依存せずに、常に正しい状態のマスタデータでテストできる。
- マスタデータ復旧は自動で行われるので、各テストクラスで復旧処理・復旧用データを用意する必要がない。
- バックアップ用スキーマからテーブル毎に一括で復旧するので、1件ずつINSERTする場合に比べて高速に復旧できる。

<details>
<summary>keywords</summary>

テスト実行順序, 自動復旧, 高速復旧, バックアップスキーマ, 一括復旧

</details>

## 必要となるスキーマ

本機能を使用するにあたり、以下の**2つのスキーマ**が必要となる。

| スキーマ | 説明 |
|---|---|
| 自動テスト用スキーマ | 自動テストに使用するスキーマ。 |
| バックアップ用スキーマ | 復旧に使用するためのマスタデータを保存しておくためのスキーマ。 |

<details>
<summary>keywords</summary>

自動テスト用スキーマ, バックアップ用スキーマ, 必要スキーマ, 2つのスキーマ

</details>

## 動作イメージ

自動テストフレームワークはコンポーネント設定ファイルより監視対象テーブル名一覧を取得する。テスト実行中、SQLログを監視することにより監視対象テーブルを変更するSQL文が発行されたかどうかを検出する。

監視対象テーブルを変更するSQL文が発行された場合、テストメソッド終了後に変更があったテーブルを復旧する。復旧の手順は以下のとおり：

1. テーブル内のレコードを全件削除する。
2. バックアップ用スキーマのテーブルからレコードを全件挿入する。

<details>
<summary>keywords</summary>

監視対象テーブル, SQLログ監視, 全件削除, 全件挿入, 復旧メカニズム, コンポーネント設定ファイル

</details>

## バックアップ用スキーマの作成、データ投入

バックアップ用スキーマに自動テスト用スキーマと同じテーブルを作成し、復旧用データを投入する。

> **補足**: 復旧用スキーマに全テーブルを作成する必要はない。復旧対象とするテーブルのみ存在すればよい（復旧対象外のテーブルがあっても問題ない）。

<details>
<summary>keywords</summary>

バックアップスキーマ作成, マスタデータ復旧, データ投入, 復旧対象テーブル

</details>

## 外部キーが設定されたテーブルを使用する場合について

外部キーが設定されたテーブルを復旧する場合、デフォルトではJDBCの機能で親子関係を取得・構築し、削除処理は子テーブルから、挿入処理は親テーブルから順に行う。

テーブル数が膨大なプロジェクトでは、JDBC機能による親子関係構築処理が原因でslow test問題が発生する場合がある。この場合、記述順（:ref:`MasterDataRestore-configuration` 参照）を元にテーブルの削除・挿入処理を行う機能を使用する。

記述順での復旧を有効にするには、環境設定ファイルに以下を追加する：

```jproperties
nablarch.suppress-table-sort=true
```

<details>
<summary>keywords</summary>

外部キー, slow test, テーブル削除挿入順序, 親子関係, nablarch.suppress-table-sort

</details>

## コンポーネント設定ファイルに監視対象テーブルを記載

自動テスト用コンポーネント設定ファイルに監視対象テーブルを列挙する。

**クラス名**: `nablarch.test.core.db.MasterDataRestorer`

| プロパティ名 | 説明 | デフォルト値 |
|---|---|---|
| backupSchema | マスタデータ復旧用スキーマ名 | なし |
| tablesTobeWatched | 監視対象テーブル名のリスト | なし |
| testEventListeners | テストイベントリスナーの一覧。`nablarch.test.core.db.MasterDataRestorer`を登録することでテストメソッド終了時にマスタデータが復旧される。 | なし |

```xml
<component name="masterDataRestorer"
           class="nablarch.test.core.db.MasterDataRestorer">
  <property name="backupSchema" value="nablarch_test_master"/>
  <property name="tablesTobeWatched">
    <list>
      <value>MESSAGE</value>
      <value>ID_GENERATE</value>
      <value>BUSINESS_DATE</value>
      <value>PERMISSION_UNIT</value>
      <value>REQUEST</value>
      <value>PERMISSION_UNIT_REQUEST</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

MasterDataRestorer, nablarch.test.core.db.MasterDataRestorer, backupSchema, tablesTobeWatched, testEventListeners, 監視対象テーブル, コンポーネント設定

</details>

## ログ出力設定

本機能はSQLログを監視してマスタデータへの変更を検出するため、SQLログ出力の設定が必要。

**app-log.properties** — `sqlLogFormatter`のクラス名に本機能の提供クラスを指定する：

```none
sqlLogFormatter.className=nablarch.test.core.db.MasterDataRestorer$SqlLogWatchingFormatter
```

**log.properties** — SQLログをDEBUGレベル以上で出力する設定をする。以下の例では、SQLログを標準出力に表示させないよう専用のロガー（何もしないロガー: `NopLogWriter`）を設定している：

```none
loggerFactory.className=nablarch.core.log.basic.BasicLoggerFactory
writerNames=stdout,nop
writer.stdout.className=nablarch.core.log.basic.StandardOutputLogWriter
writer.nop.className=nablarch.test.core.log.NopLogWriter
availableLoggersNamesOrder=sql,root
loggers.root.nameRegex=.*
loggers.root.level=DEBUG
loggers.root.writerNames=stdout
loggers.sql.nameRegex=SQL
loggers.sql.level=DEBUG
loggers.sql.writerNames=nop
```

<details>
<summary>keywords</summary>

MasterDataRestorer$SqlLogWatchingFormatter, nablarch.test.core.db.MasterDataRestorer$SqlLogWatchingFormatter, NopLogWriter, nablarch.test.core.log.NopLogWriter, BasicLoggerFactory, nablarch.core.log.basic.BasicLoggerFactory, StandardOutputLogWriter, nablarch.core.log.basic.StandardOutputLogWriter, SQLログ, app-log.properties, log.properties

</details>
