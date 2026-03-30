# トランザクション管理

## 概要

様々なリソース（主にデータベースやメッセージキュー）のトランザクション管理機能を提供する。

Webアプリケーションでは [../../handler/TransactionManagementHandler](../handlers/handlers-TransactionManagementHandler.md) が本機能を使用する。アプリケーションプログラマは本機能を直接使用しない。

<details>
<summary>keywords</summary>

トランザクション管理, TransactionManagementHandler, データベーストランザクション, メッセージキュー

</details>

## 特徴

- **任意のリソースへのトランザクション制御追加**: トランザクション制御部品を追加することで、任意のリソースのトランザクション制御が可能。
- **分散トランザクション機能（未実装）**: Webコンテナのトランザクションマネージャ（ユーザトランザクション）を使用して分散トランザクションを行う機能。設定ファイルへの記述のみで使用可否を制御可能。

<details>
<summary>keywords</summary>

任意リソーストランザクション制御, 分散トランザクション, 未実装機能

</details>

## 要求

**実装済み**:
- RDBMSのトランザクション管理
- アイソレーションレベルの設定
- トランザクション開始時の任意SQL文実行
- トランザクションタイムアウト処理

**未実装**:
- 分散トランザクション対応
- トランザクションのリトライ（デッドロック・ロック要求タイムアウト時）: SQLStateまたはベンダー依存のSQLエラーコードでリトライ対象エラーを設定可能

<details>
<summary>keywords</summary>

RDBMSトランザクション管理, アイソレーションレベル, トランザクションタイムアウト, トランザクションリトライ, 分散トランザクション対応, SQLState, トランザクション開始時SQL実行

</details>

## 構造

**インタフェース**:
- **インタフェース**: `nablarch.core.transaction.TransactionFactory`: Transaction制御オブジェクト（Transaction）を取得するインタフェース
- **インタフェース**: `nablarch.core.transaction.Transaction`: トランザクション制御オブジェクト。新規トランザクション方式追加時はこのインタフェースの実装クラスを追加する必要がある。

**TransactionFactory実装クラス**:
- **クラス**: `nablarch.core.db.transaction.JdbcTransactionFactory`: JdbcTransactionを生成するクラス。トランザクションタイムアウトの設定は本クラスに行う（詳細は :ref:`transactionTimeoutSettings` 参照）。

**Transaction実装クラス**:
- **クラス**: `nablarch.core.db.transaction.JdbcTransaction`: JDBCのトランザクション機能を使用してトランザクション制御を行うクラス。

**その他**:
- **クラス**: `nablarch.core.transaction.TransactionContext`: ThreadLocalにTransactionを保持するクラス。任意の名前（トランザクション名）を付加可能（詳細は :ref:`データベースコネクション名とトランザクション名 <db-connection-name-label>` 参照）。

> **警告**: ThreadLocalでTransactionが管理されるため、アプリケーションのスレッドと同一スレッドでTransactionを設定する必要がある。マルチスレッド環境では各スレッドに対してTransactionを設定する必要がある。

<details>
<summary>keywords</summary>

TransactionFactory, Transaction, JdbcTransactionFactory, JdbcTransaction, TransactionContext, ThreadLocal, トランザクション制御クラス

</details>

## 使用例

データベースに対するトランザクション管理の使用例は [./04_DbAccessSpec](libraries-04_DbAccessSpec.md) を参照。

<details>
<summary>keywords</summary>

データベーストランザクション使用例, DbAccessSpec

</details>
