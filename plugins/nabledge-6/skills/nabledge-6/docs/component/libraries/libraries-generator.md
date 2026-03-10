# サロゲートキーの採番

## 機能概要

:ref:`universal_dao` でサロゲートキーを採番する際に使用する機能。:ref:`universal_dao` 以外での使用は推奨しない。

**理由**: 採番処理はuniversal_daoが行うためアプリケーション側で直接採番機能を使用する必要がない。複雑な採番ルールや値の編集が必要な場合は本機能を使用できないため、アプリケーション側で設計・実装する必要がある。(本機能でも実現可能だが、設計及び実装(設定)が必要となるため、本機能を使うメリットは無い)

例えば、親キーの中での連番を採番するケースでは、以下の手順にて値を採番できる。

1. 親キーの毎に連番を採番するための専用テーブルを作成する。
2. アプリケーションでは、親のキーが登録されたタイミングで専用テーブルにレコードを登録する。
3. 採番が必要なタイミングで親キーに対応する採番済みの値をインクリメントすることで、親キー内での連番を採番できる。

## シーケンスを使った採番

データベース上に作成されたシーケンスオブジェクトを使って一意の値を採番できる。シーケンスの次の値取得SQL文は:ref:`ダイアレクト <database-dialect>` を使用して構築する。

## テーブルを使った採番

テーブルのレコード単位に現在値を管理し、一意の値を採番できる。

**テーブルレイアウト:**

| カラム | 説明 |
|---|---|
| 採番識別名 (PK) | 採番対象を識別するための値 |
| 現在値 | 現在の値（採番実行時に1加算した値が取得される） |

> **重要**: 必要なレコードは予めセットアップしておくこと。採番実行時に指定した採番識別名(PK)に対応するレコードが存在しない場合、新規レコードを追加するのではなく例外を送出する。

> **重要**: テーブル採番は大量データを処理するバッチ処理でボトルネックになることが多い。データベース側の採番カラムやシーケンスを使うことを強く推奨する。データベース機能として採番カラム・シーケンスが使用できない場合のみ、テーブル採番を使用すること。

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

## 使用方法

:ref:`universal_dao` で本機能を使用するには、`BasicDaoContextFactory` への設定が必要。

- テーブル採番は推奨しない。シーケンス採番を使用する場合は `sequenceIdGenerator` プロパティを設定する。
- データベース側の自動採番カラムを使う場合は採番設定自体が不要。

```xml
<!-- テーブル採番モジュールの設定 -->
<component name="tableIdGenerator" class="nablarch.common.idgenerator.TableIdGenerator">
  <property name="tableName" value="GENERATOR" />
  <property name="idColumnName" value="ID" />
  <property name="noColumnName" value="NO" />
</component>

<component name="daoContextFactory" class="nablarch.common.dao.BasicDaoContextFactory">
  <!-- シーケンス採番の設定 -->
  <property name="sequenceIdGenerator">
    <component class="nablarch.common.idgenerator.SequenceIdGenerator"/>
  </property>

  <!-- テーブル採番の設定 -->
  <property name="tableIdGenerator" ref="tableIdGenerator" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <!-- TableIdGeneratorは初期化が必要 -->
      <component-ref name="tableIdGenerator" />
    </list>
  </property>
</component>
```

## 拡張例

テーブルやシーケンスを使った採番の実装を置き換えるには、`IdGenerator` を実装したクラスを作成する。作成したクラスは :ref:`generator_dao_setting` に従いコンポーネント設定ファイルに定義することで使用可能となる。
