# データベース接続管理ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

後続ハンドラの処理で必要となるデータベース接続オブジェクトを、スレッドローカル上で管理するハンドラ。

本ハンドラを複数ハンドラキューに配置することで、1スレッドに複数のDB接続を割り当てることができる。1スレッド内で複数のトランザクションを制御する場合に使用する。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | このハンドラの後続に配置することで、このハンドラが管理するDB接続をトランザクションに参加させることができる。 |

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, nablarch.common.handler.DbConnectionManagementHandler, TransactionManagementHandler, データベース接続管理, スレッドローカル, DB接続, 複数トランザクション

</details>

## ハンドラ処理フロー

**[往路処理]**

1. DBコネクションファクトリを用いてDB接続を取得する。
2. 取得したDB接続をスレッドローカル変数上のMapに登録する。キー名はスレッドローカル登録名の値を使用する。
   - 2a. スレッドローカル上に同一の登録名で他のDB接続が既に設定されていた場合は、実行時例外を送出して終了する。
3. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

4. DB接続を開放する（コネクションプールに返却）。スレッドローカル上のDB接続への参照も除去する。
5. 処理結果をリターンして終了する。

**[例外処理]**

- 3a. 本ハンドラおよび後続ハンドラ内で例外が発生した場合は、終端処理（4.）を行った上で例外を再送出する。
- 4a. 終端処理中にエラーが発生した場合、そのまま再送出する。後続ハンドラ処理中に例外が発生していた場合は、再送出の前にWARNINGレベルのログを出力する。

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, 往路処理, 復路処理, 例外処理, DB接続取得, スレッドローカル登録, コネクションプール返却

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| connectionFactory | nablarch.core.db.connection.ConnectionFactory | ○ | | DBコネクションファクトリ |
| connectionName | String | | transaction | スレッドローカル登録名。複数のコネクションを利用する場合に指定する。省略時は"transaction"が使用される。 |

DBコネクションファクトリの設定方法については、[../02_FunctionDemandSpecifications/01_Core/04/04_Statement](../libraries/libraries-04_Statement.md) を参照すること。

**基本設定**

デフォルトの設定では、トランザクションが暗黙的に使用する接続名に対して接続オブジェクトを登録する。接続名を明示的に指定する場合は、属性`dbConnectionName`にその値を設定する。

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
</component>
```

**複数のDB接続を利用する場合**

本ハンドラを複数使用することでDB接続を複数使用可能。それぞれの接続はスレッドローカル登録名で識別される。

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
  <property name="connectionName" value="secondDbTransaction"/>
</component>
```

<details>
<summary>keywords</summary>

connectionFactory, connectionName, dbConnectionName, DbConnectionManagementHandler, DBコネクションファクトリ, スレッドローカル登録名, 複数DB接続, secondDbTransaction

</details>
