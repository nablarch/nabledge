# マスタデータ復旧機能

## 概要

マスタメンテナンス機能等のテストでマスタデータを変更した場合に、テストメソッド終了後に自動でマスタデータを元の状態に復旧する機能。テスト実行中にマスタデータが更新されると、テストメソッド終了時点で自動的に復旧が実行される。

<details>
<summary>keywords</summary>

マスタデータ復旧機能, 自動テスト, テストメソッド終了後復旧, マスタデータ自動復旧

</details>

## 特徴

- テストの実行順序に依存せずに、常に正しい状態のマスタデータでテストできる。
- マスタデータ復旧は自動で行われるので、各テストクラスで復旧処理・復旧用データを用意する必要がない。
- バックアップスキーマからテーブル毎に一括で復旧するので、1件ずつINSERTする場合に比べて高速に復旧できる。

<details>
<summary>keywords</summary>

マスタデータ復旧, バックアップスキーマ, テスト実行順序非依存, 高速復旧, 一括復旧

</details>

## 動作イメージ

1. コンポーネント設定ファイルより監視対象テーブル名一覧を取得する。
2. テスト実行中、SQLログを監視し、監視対象テーブルを変更するSQL文が発行されたかを検出する。
3. 監視対象テーブルを変更するSQL文が発行された場合、テストメソッド終了後に変更があったテーブルを復旧する。
4. 復旧処理: テーブル内のレコードを全件削除後、バックアップ用スキーマのテーブルからレコードを全件挿入する。

<details>
<summary>keywords</summary>

SQLログ監視, 監視対象テーブル, 変更検出, バックアップからの復旧, 全件削除, 全件挿入

</details>

## 環境構築: バックアップ用スキーマの作成・データ投入

マスタデータ復旧用スキーマを作成し、自動テスト用スキーマと同じテーブルを作成して復旧用データを投入する。

> **注意**: 復旧対象テーブルのみ作成すればよい（全テーブルの作成は不要。復旧対象以外のテーブルが存在しても問題ない）。

<details>
<summary>keywords</summary>

バックアップスキーマ作成, データ投入, マスタデータ復旧用スキーマ, 自動テスト用スキーマ

</details>

## 環境構築: コンポーネント設定ファイルへの設定

自動テスト用のコンポーネント設定ファイルに、監視対象テーブルを列挙する。

**クラス**: `nablarch.test.core.db.MasterDataRestorer`

| プロパティ名 | 説明 | デフォルト値 |
|---|---|---|
| backupSchema | マスタデータ復旧用スキーマ名 | なし |
| tablesTobeWatched | 監視対象テーブル名をリスト形式で列挙する | なし |
| testEventListeners | テストイベントリスナー一覧。`nablarch.test.core.db.MasterDataRestorer`を登録するとテストメソッド終了時にマスタデータが復旧される | なし |

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

MasterDataRestorer, nablarch.test.core.db.MasterDataRestorer, backupSchema, tablesTobeWatched, testEventListeners, バックアップスキーマ設定, コンポーネント設定, 監視対象テーブル設定

</details>

## 環境構築: ログ出力設定

本機能はSQLログを監視してマスタデータへの変更を検出するため、以下のログ出力設定が必要。

**app-log.properties**: `sqlLogFormatter.className` に本機能の提供クラスを指定する。

```
sqlLogFormatter.className=nablarch.test.core.db.MasterDataRestorer$SqlLogWatchingFormatter
```

**log.properties**: SQLログをDEBUGレベル以上で出力する設定が必要。以下の例ではSQLログを標準出力に表示させないよう専用のロガー（何もしないロガー）を設定している。

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

SqlLogWatchingFormatter, nablarch.test.core.db.MasterDataRestorer$SqlLogWatchingFormatter, NopLogWriter, nablarch.test.core.log.NopLogWriter, sqlLogFormatter, BasicLoggerFactory, nablarch.core.log.basic.BasicLoggerFactory, StandardOutputLogWriter, nablarch.core.log.basic.StandardOutputLogWriter, ログ出力設定, app-log.properties, log.properties

</details>
