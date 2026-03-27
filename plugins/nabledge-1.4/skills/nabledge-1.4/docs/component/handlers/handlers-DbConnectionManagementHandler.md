# データベース接続管理ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.DbConnectionManagementHandler`

後続ハンドラの処理で必要となるデータベース接続オブジェクトをスレッドローカル上で管理するハンドラ。複数のハンドラキューに配置することで、1スレッドに複数のDB接続を割り当て可能（複数トランザクション制御に利用）。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [TransactionManagementHandler](handlers-TransactionManagementHandler.md) | 後続に配置することで、このハンドラが管理するDB接続をトランザクションに参加させることができる |

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, nablarch.common.handler.DbConnectionManagementHandler, TransactionManagementHandler, データベース接続管理, スレッドローカル, DB接続管理, 複数トランザクション制御

</details>

## ハンドラ処理フロー

**[往路処理]**

1. DB接続の獲得: DBコネクションファクトリを用いてDB接続を取得
2. スレッドローカルへの登録: 取得したDB接続をスレッドローカル変数のMapに登録（キー名はスレッドローカル登録名）
   - 2a. 同一登録名で他のDB接続が既に設定されていた場合、実行時例外を送出して終了
3. 後続ハンドラに処理委譲

**[復路処理]**

4. 終端処理: DB接続を開放してコネクションプールに返却、スレッドローカルの参照も除去
5. 処理結果をリターン

**[例外処理]**

- 3a. 本ハンドラまたは後続ハンドラで例外発生時: 終端処理後に例外を再送出
- 4a. 終端処理中のエラー: そのまま再送出。ただし後続ハンドラで既に例外が発生していた場合は、WARNINGレベルのログを出力してから再送出

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, DB接続獲得, スレッドローカル登録, DB接続重複登録エラー, コネクションプール, 終端処理, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| connectionFactory | nablarch.core.db.connection.ConnectionFactory | ○ | | DBコネクションファクトリ |
| connectionName | String | | "transaction" | スレッドローカル登録名。複数のDB接続を利用する場合に指定 |

**基本設定**:

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
</component>
```

**複数のDB接続を利用する場合**（各接続をスレッドローカル登録名で識別）:

```xml
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
  <property name="connectionName" value="secondDbTransaction"/>
</component>
```

<details>
<summary>keywords</summary>

DbConnectionManagementHandler, connectionFactory, connectionName, nablarch.core.db.connection.ConnectionFactory, DBコネクションファクトリ, スレッドローカル登録名, 複数DB接続

</details>
