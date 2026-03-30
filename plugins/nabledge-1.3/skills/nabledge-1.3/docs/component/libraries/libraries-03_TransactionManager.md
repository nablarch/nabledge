# トランザクション管理

## 概要

DBやメッセージキューなど各種リソースのトランザクション管理機能。Webアプリケーションでは [../../handler/TransactionManagementHandler](../handlers/handlers-TransactionManagementHandler.md) が本機能を使用する。アプリケーションプログラマが直接本機能を使用することはない。

<details>
<summary>keywords</summary>

トランザクション管理, TransactionManagementHandler, Webアプリケーション, アプリケーションプログラマ不使用

</details>

## 特徴

- トランザクション制御部品を追加することで、任意のリソースに対するトランザクション制御が可能。
- 分散トランザクション機能（Webコンテナが提供するユーザトランザクション機能を使用）は**未実装**。設定ファイルの記述のみで使用可否を切り替える設計だが実装されていない。

<details>
<summary>keywords</summary>

分散トランザクション, トランザクション制御部品, 未実装機能, 任意リソーストランザクション制御

</details>

## 要求

**実装済み**:
- RDBMSのトランザクション管理
- アイソレーションレベルの設定
- トランザクション開始時の任意SQL実行
- トランザクションタイムアウト処理

**未実装**:
- 分散トランザクション対応
- トランザクションのリトライ（デッドロック/ロック要求タイムアウト発生時の自動リトライ）。リトライ対象エラーはSQLStateまたはベンダー依存のSQLエラーコードで設定可能。

<details>
<summary>keywords</summary>

RDBMSトランザクション管理, アイソレーションレベル, トランザクションタイムアウト, 分散トランザクション, デッドロックリトライ, SQLState, 任意SQL実行, トランザクション開始時SQL

</details>

## 構造

**インタフェース**:

- **`nablarch.core.transaction.TransactionFactory`**: Transaction制御オブジェクト(Transaction)を取得するインタフェース
- **`nablarch.core.transaction.Transaction`**: トランザクション制御オブジェクト。新たなトランザクション方式を追加する場合はこのインタフェースの実装クラスを追加する

**TransactionFactory実装クラス**:

- **`nablarch.core.db.transaction.JdbcTransactionFactory`**: JdbcTransactionを生成するクラス。トランザクションタイムアウト設定はこのクラスで行う（:ref:`transactionTimeoutSettings` 参照）

**Transaction実装クラス**:

- **`nablarch.core.db.transaction.JdbcTransaction`**: JDBCトランザクション機能を使用してトランザクション制御を行うクラス

**その他のクラス**:

- **`nablarch.core.transaction.TransactionContext`**: ThreadLocalにTransactionを保持するクラス。任意の名前（トランザクション名）を付加可能（:ref:`データベースコネクション名とトランザクション名 <db-connection-name-label>` 参照）

> **警告**: ThreadLocalでTransactionが管理されるため、アプリケーションのスレッドと同一スレッドでTransactionを設定すること。マルチスレッド環境では各スレッドに対してTransactionを設定する必要がある。

<details>
<summary>keywords</summary>

TransactionFactory, Transaction, JdbcTransactionFactory, JdbcTransaction, TransactionContext, ThreadLocal, トランザクション名, クラス構造

</details>

## 使用例

データベーストランザクション管理の使用例は [./04_DbAccessSpec](libraries-04_DbAccessSpec.md) を参照。

<details>
<summary>keywords</summary>

データベーストランザクション管理, 使用例, DbAccessSpec

</details>
