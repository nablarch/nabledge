# サロゲートキーの採番

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/database/generator.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/BasicDaoContextFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/idgenerator/IdGenerator.html)

## 概要と使用判断

この機能は、[universal_dao](libraries-universal_dao.md) でサロゲートキーを採番（単純な連番を採番）する際に使用する。

[universal_dao](libraries-universal_dao.md) 以外でも使用できるが、以下の理由によりアプリケーション側で対応することを推奨する。

**理由**: サロゲートキーの採番処理は [universal_dao](libraries-universal_dao.md) が行うため、アプリケーション側で直接採番機能を使用する必要がない。それ以外の用途で値を採番する場合には、採番ルールが複雑であったり、採番した値を編集することが想定される。このような場合は単純な連番を採番する本機能を使用できないため、アプリケーション側で設計・実装する必要がある。（本機能でも実現可能だが、設計及び実装（設定）が必要となるため、本機能を使うメリットは無い）

**例: 親キーの中での連番を採番するケース（アプリケーション側実装）**

1. 親キーごとに連番を採番するための専用テーブルを作成する。
2. アプリケーションでは、親のキーが登録されたタイミングで専用テーブルにレコードを登録する。
3. 採番が必要なタイミングで親キーに対応する採番済みの値をインクリメントすることで、親キー内での連番を採番できる。

<details>
<summary>keywords</summary>

universal_dao, サロゲートキー採番, 使用判断, アプリケーション側実装, 親キー連番, 採番推奨外ケース

</details>

## 機能概要

## シーケンス採番
データベース上のシーケンスオブジェクトを使って一意の値を採番できる。次の値を取得するSQL文はダイアレクト機能（[ダイアレクト](libraries-database.md)）を使って構築する。

## テーブル採番
テーブルのレコード単位に現在値を管理し、一意の値を採番できる。

テーブルレイアウト:

| カラム | 説明 |
|---|---|
| 採番識別名(PK) | 採番対象を識別するための値 |
| 現在値 | 現在の値（採番実行時に1加算した値が取得できる） |

> **重要**: 必要なレコードは予めセットアップしておくこと。採番実行時に指定した採番識別名(PK)に対応するレコードが存在しない場合、新規レコードは追加されず異常終了（例外送出）する。

> **重要**: テーブル採番は大量データを処理するバッチ処理でボトルネックとなることが多い。データベースの採番カラムやシーケンスを用いた採番を強く推奨する。DB側の採番カラムおよびシーケンスオブジェクトが使用できない場合のみテーブル採番を使用すること。

<details>
<summary>keywords</summary>

シーケンス採番, テーブル採番, サロゲートキー採番, 一意値生成, SequenceIdGenerator, TableIdGenerator, 採番識別名, バッチ処理ボトルネック

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-idgenerator</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-idgenerator-jdbc</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-common-idgenerator, nablarch-common-idgenerator-jdbc, モジュール依存関係

</details>

## 使用方法

[universal_dao](libraries-universal_dao.md) で使用するには `BasicDaoContextFactory` への設定が必要。

- シーケンス採番を使う場合: `sequenceIdGenerator` に `SequenceIdGenerator` を設定
- テーブル採番を使う場合: `tableIdGenerator` に `TableIdGenerator` を設定（`tableName`、`idColumnName`、`noColumnName` を指定）
- データベース側の自動採番カラムを使う場合: 採番設定不要

> **重要**: テーブル採番は推奨しない。シーケンス採番を使用する場合は `sequenceIdGenerator` のみ設定すれば良い。

```xml
<component name="daoContextFactory" class="nablarch.common.dao.BasicDaoContextFactory">
  <property name="sequenceIdGenerator">
    <component class="nablarch.common.idgenerator.SequenceIdGenerator"/>
  </property>
  <property name="tableIdGenerator">
    <component class="nablarch.common.idgenerator.TableIdGenerator">
      <property name="tableName" value="GENERATOR" />
      <property name="idColumnName" value="ID" />
      <property name="noColumnName" value="NO" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

BasicDaoContextFactory, SequenceIdGenerator, TableIdGenerator, sequenceIdGenerator, tableIdGenerator, ユニバーサルDAO採番設定, 自動採番カラム

</details>

## 拡張例

`IdGenerator` を実装したクラスを作成し、コンポーネント設定ファイルに定義することで、テーブル採番・シーケンス採番の実装を置き換え可能。設定方法は [generator_dao_setting](#s4) に従う。

<details>
<summary>keywords</summary>

IdGenerator, カスタム採番実装, 採番拡張, 採番置き換え

</details>
