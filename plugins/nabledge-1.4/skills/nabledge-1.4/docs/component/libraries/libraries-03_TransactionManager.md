# トランザクション管理

## 概要

様々なリソース（データベース、メッセージキューなど）に対するトランザクション管理機能。

本機能はフレームワーク内部から使用される。Webアプリケーションでは [../../handler/TransactionManagementHandler](../handlers/handlers-TransactionManagementHandler.md) が本機能を使用する。アプリケーションプログラマが直接使用することはない。

<details>
<summary>keywords</summary>

トランザクション管理, TransactionManagementHandler, アプリケーションプログラマ直接使用不可

</details>

## 特徴

- トランザクション制御部品を追加することで、任意のリソースへのトランザクション制御を追加可能。
- 分散トランザクション機能（未実装）: Webコンテナが提供するユーザトランザクション機能を使用した分散トランザクション。設定ファイルの記述のみで切り替え可能。

<details>
<summary>keywords</summary>

任意リソースへのトランザクション制御追加, 分散トランザクション, ユーザトランザクション

</details>

## 要求

**実装済み**:
- RDBMSのトランザクション管理
- アイソレーションレベルの設定
- トランザクション開始時の任意SQL文実行
- トランザクションタイムアウト処理

**未実装**:
- 分散トランザクション対応
- トランザクションリトライ（デッドロック・ロックタイムアウト発生時）。リトライ対象エラーはSQLStateまたはベンダー依存SQLエラーコードで設定可能。

<details>
<summary>keywords</summary>

RDBMSトランザクション管理, アイソレーションレベル設定, トランザクションタイムアウト, 分散トランザクション未実装, トランザクションリトライ未実装, SQLState, SQLエラーコード

</details>

## 構造

**インタフェース**:

- **インタフェース**: `nablarch.core.transaction.TransactionFactory` — トランザクション制御オブジェクト（Transaction）を取得するインタフェース。
- **インタフェース**: `nablarch.core.transaction.Transaction` — トランザクション制御オブジェクト。新たなトランザクション方式を追加する場合は、このインタフェースの実装クラスを新たに追加する必要がある。

**クラス**:

- **クラス**: `nablarch.core.db.transaction.JdbcTransactionFactory` — JdbcTransactionを生成するクラス。トランザクションタイムアウトの設定は本クラスに行う。設定詳細は :ref:`transactionTimeoutSettings` を参照。
- **クラス**: `nablarch.core.db.transaction.JdbcTransaction` — JDBCのトランザクション機能を使用してトランザクション制御を行うクラス。
- **クラス**: `nablarch.core.transaction.TransactionContext` — ThreadLocalにTransactionを保持するクラス。任意の名前（トランザクション名）を付加できる。トランザクション名の詳細は :ref:`データベースコネクション名とトランザクション名 <db-connection-name-label>` を参照。

> **警告**: ThreadLocalでTransactionが管理されるため、アプリケーションのスレッドと同一のスレッドでTransactionを設定する必要がある。マルチスレッド環境では各スレッドに対してTransactionを設定する必要があるため注意が必要。

<details>
<summary>keywords</summary>

TransactionFactory, Transaction, JdbcTransactionFactory, JdbcTransaction, TransactionContext, ThreadLocal, トランザクション制御クラス設計, transactionTimeoutSettings, db-connection-name-label

</details>

## 使用例

データベースに対するトランザクション管理の使用例は [./04_DbAccessSpec](libraries-04_DbAccessSpec.md) を参照。

<details>
<summary>keywords</summary>

データベーストランザクション管理使用例, DbAccessSpec

</details>
