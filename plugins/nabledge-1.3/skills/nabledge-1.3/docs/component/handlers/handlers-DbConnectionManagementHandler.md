# データベース接続管理ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

後続ハンドラの処理で必要となるデータベース接続オブジェクトを、スレッドローカル上で管理するハンドラ。

本ハンドラを複数ハンドラキューに配置することで、1スレッドに複数のDB接続を割り当てることができる。1スレッド内で複数のトランザクションを制御する場合などに使用する。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | このハンドラの後続に配置することで、このハンドラが管理するDB接続をトランザクションに参加させることができる |

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, nablarch.common.handler.DbConnectionManagementHandler, TransactionManagementHandler, データベース接続管理, スレッドローカル, 複数DB接続, 複数トランザクション制御

</details>

## ハンドラ処理フロー

**[往路処理]**

1. DBコネクションファクトリを用いてDB接続を取得する
2. 取得したDB接続をスレッドローカル変数上のMapに登録する（キー名はスレッドローカル登録名）
   - **2a（DB接続重複登録エラー）**: スレッドローカル上に同一登録名で他のDB接続が既に設定されている場合は、実行時例外を送出して終了する
3. 後続ハンドラに処理を委譲し、結果を取得する

**[復路処理]**

4. 取得したDB接続を開放する（コネクションプールに返却）。スレッドローカル上のDB接続への参照も除去する
5. 取得した処理結果をリターンして終了する

**[例外処理]**

- **3a（後続ハンドラの処理でエラー）**: 本ハンドラおよび後続ハンドラ内で例外が発生した場合は、終端処理（手順4）を行った上で例外を再送出する
- **4a（終端処理中のエラー）**: 終端処理中にエラーが発生した場合、そのまま再送出する。ただし後続ハンドラの処理中に例外が発生していた場合は、再送出の前にWARNINGレベルのログで出力する

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, 往路処理, 復路処理, 例外処理, DB接続獲得, コネクションプール返却, スレッドローカル登録, DB接続重複登録エラー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| connectionFactory | nablarch.core.db.connection.ConnectionFactory | ○ | | DBコネクションファクトリ |
| connectionName | String | | transaction | スレッドローカル登録名。複数コネクション利用時に指定。省略時は"transaction" |

**基本設定**（デフォルト接続名を使用する場合）:

デフォルトの設定では、トランザクションが暗黙的に使用する接続名に対して接続オブジェクトを登録する。接続名を明示的に指定する場合は、属性`dbConnectionName`にその値を設定する。

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
</component>
```

**複数のDB接続を利用する場合**（本ハンドラを複数使用し、connectionNameで識別）:

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
  <property name="connectionName" value="secondDbTransaction"/>
</component>
```

<details>
<summary>keywords</summary>

connectionFactory, connectionName, dbConnectionName, ConnectionFactory, nablarch.core.db.connection.ConnectionFactory, DBコネクションファクトリ設定, スレッドローカル登録名, 複数接続設定, secondDbTransaction, transaction

</details>
