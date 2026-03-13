# マスタデータ復旧機能

**公式ドキュメント**: [マスタデータ復旧機能](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/04_MasterDataRestore.html)

## 概要

マスタメンテナンス機能等のテストでは、マスタデータを変更しないと実施できないテストケースが存在する（例: 存在するはずのデータが存在しなかった場合の異常系テストでは、マスタデータからレコードを削除する必要がある）。

テスト中にマスタデータを変更した場合、それ以降のテストクラスのテストでは、マスタデータが意図しない状態になっているためにテストが失敗することがある。

このようなマスタデータ変更による意図しないテスト失敗を防止するため、自動テスト中にマスタデータが更新された場合、そのテストメソッドが終了した時点でマスタデータを元の状態に復旧する機能を提供する。

<details>
<summary>keywords</summary>

マスタデータ復旧, マスタメンテナンス, テスト失敗防止, 意図しないテスト失敗, 自動復旧

</details>

## 特徴

- テストの実行順序に依存せずに、常に正しい状態のマスタデータでテストできる。
- マスタデータ復旧は自動で行われるので、各テストクラスで復旧処理、復旧用データを用意する必要がない。
- バックアップ用スキーマからテーブル毎に一括で復旧するので、1件ずつINSERTする場合に比べて高速に復旧できる。

<details>
<summary>keywords</summary>

テスト実行順序, 自動復旧, バックアップスキーマ, 高速復旧, 復旧処理不要

</details>

## 必要となるスキーマ

本機能を使用するにあたり、以下の2つのスキーマが必要となる。

| スキーマ | 説明 |
|---|---|
| 自動テスト用スキーマ | 自動テストに使用するスキーマ。 |
| バックアップ用スキーマ | 復旧に使用するためのマスタデータを保存しておくためのスキーマ。 |

<details>
<summary>keywords</summary>

自動テスト用スキーマ, バックアップ用スキーマ, スキーマ構成, 事前準備, 2つのスキーマ

</details>

## 動作イメージ

自動テストフレームワークはコンポーネント設定ファイルより、監視対象テーブル名一覧を取得する。テスト実行中、自動テストフレームワークはSQLログを監視することにより、監視対象テーブルを変更するSQL文が発行されたかどうかを検出する。

監視対象テーブルを変更するSQL文が発行された場合、テストメソッド終了後に変更があったテーブルを復旧する。テーブルを復旧する際、いったんテーブル内のレコードを全件削除する。その後、バックアップ用スキーマのテーブルからレコードを全件挿入する。

<details>
<summary>keywords</summary>

SQLログ監視, 監視対象テーブル, 復旧メカニズム, 全件削除・挿入, テストメソッド終了後

</details>

## バックアップ用スキーマの作成、データ投入

バックアップ用スキーマに自動テスト用スキーマと同じテーブルを作成し、復旧用データを投入する。

> **補足**: バックアップ用スキーマには全テーブルを作成する必要はない。復旧対象テーブルのみ存在すればよい（復旧対象外テーブルがあっても問題ない）。

<details>
<summary>keywords</summary>

マスタデータ復旧, バックアップスキーマ作成, テストデータ投入, 復旧対象テーブル

</details>

## 外部キーが設定されたテーブルを使用する場合について

デフォルトの動作: JDBCの機能で親子関係を取得・構築し、削除処理は子テーブルから、挿入処理は親テーブルから順に行う。

テーブル数が膨大なプロジェクトでは、JDBCによる親子関係構築処理でslow test問題が発生する場合がある。

記述順（:ref:`MasterDataRestore-configuration` 参照）でのテーブル削除・挿入処理を行う場合は、環境設定ファイルに以下を追加する:

```jproperties
nablarch.suppress-table-sort=true
```

<details>
<summary>keywords</summary>

外部キー, 親子関係, slow test, nablarch.suppress-table-sort, テーブルソート無効化

</details>

## コンポーネント設定ファイルに監視対象テーブルを記載

**クラス**: `nablarch.test.core.db.MasterDataRestorer`

| 設定項目名 | 説明 | デフォルト値 |
|---|---|---|
| backupSchema | マスタデータ復旧用スキーマ名を記載する。 | なし |
| tablesTobeWatched | 監視対象とするテーブル名をリスト形式で列挙する。 | なし |
| testEventListeners | テストイベントリスナーの一覧。`nablarch.test.core.db.MasterDataRestorer` を登録するとテストメソッド終了時にマスタデータが復旧される。 | なし |

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

MasterDataRestorer, nablarch.test.core.db.MasterDataRestorer, backupSchema, tablesTobeWatched, testEventListeners, 監視対象テーブル設定

</details>

## ログ出力設定

SQLログを監視してマスタデータへの変更を検出するため、SQLログのデバッグレベル以上での出力が必要。

**app-log.properties**: `sqlLogFormatter.className` に本機能提供クラスを指定する。

```
sqlLogFormatter.className=nablarch.test.core.db.MasterDataRestorer$SqlLogWatchingFormatter
```

**log.properties**: SQLログをDEBUGレベル以上で出力するよう設定する。

```
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

SQLログ設定, MasterDataRestorer$SqlLogWatchingFormatter, NopLogWriter, nablarch.test.core.log.NopLogWriter, sqlLogFormatter, デバッグログ設定

</details>
