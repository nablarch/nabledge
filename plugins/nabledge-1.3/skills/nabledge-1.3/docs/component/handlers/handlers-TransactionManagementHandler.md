# トランザクション制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.TransactionManagementHandler`

DB・メッセージキューなどトランザクション対応リソースに対して、後続処理における透過的トランザクションを実現するハンドラ。

**関連ハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる。 |

**コールバック**

後続ハンドラが `TransactionEventCallback` を実装することで、以下のイベント時にコールバックを受け取れる。

| インターフェース | メソッド | イベント |
|---|---|---|
| TransactionEventCallback | transactionNormalEnd() | トランザクションコミット直後 |
| TransactionEventCallback | transactionAbnormalEnd() | トランザクションロールバック直後 |

> **注意**: `transactionAbnormalEnd()` は業務トランザクションのロールバック後に個別のトランザクション内で実行される。このトランザクションはコールバック完了後に自動的にコミット/ロールバックされる。

<details>
<summary>keywords</summary>

TransactionManagementHandler, nablarch.common.handler.TransactionManagementHandler, TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, DbConnectionManagementHandler, トランザクション制御, 透過的トランザクション, コールバック

</details>

## ハンドラ処理フロー

**[往路処理]**

1. トランザクションファクトリを使用してスレッドローカル上のDB接続に対するトランザクションを作成する。
   - 1a. スレッドローカル登録名に対するDB接続がスレッドローカル上に未設定の場合は実行時例外を送出して終了。
2. 取得したトランザクションオブジェクトをスレッドローカル変数上のMapに登録する（キー名はスレッドローカル登録名）。
   - 2a. 同一登録名でトランザクションが既に設定されていた場合は実行時例外を送出して終了。
3. トランザクションを開始し、後続ハンドラに処理を委譲する。

**[復路処理]**

4. 後続ハンドラが正常終了した場合、トランザクションをコミットする。
5. `TransactionEventCallback` を実装した後続ハンドラの以下のコールバックメソッドを呼び出す。
   ```
   TransactionEventCallback#transactionNormalEnd(Object data, ExecutionContext context): void
   ```
6. スレッドローカルからトランザクションを除去し、トランザクションをクローズする。
7. 後続ハンドラの処理結果をリターンして終了。

**[例外処理]**

- 3a/4a. 後続ハンドラ処理中またはコミット時に例外が発生した場合、トランザクションをロールバックし以下のコールバックメソッドを呼び出す。終端処理（6.）後、元例外を再送出して終了。
   ```
   TransactionEventCallback#transactionAbnormalEnd(Object data, ExecutionContext context): void
   ```
- 3b. 発生した実行時例外がコミット対象例外クラスリストに含まれる場合、ロールバックせずにコミット（4.→5.→6.）し、例外を再送出して終了。

<details>
<summary>keywords</summary>

TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, トランザクションコミット, トランザクションロールバック, 往路処理, 復路処理, 例外処理, コミット対象例外クラスリスト

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | nablarch.core.transaction.TransactionFactory | ○ | | トランザクションファクトリ |
| transactionName | String | | transaction | スレッドローカル登録名。複数トランザクション使用時に指定。DBコネクションの登録名と一致させること。 |
| transactionCommitExceptions | List\<String\> | | | ロールバックせずコミットする実行時例外クラスの完全修飾名リスト。 |

**基本設定**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="transactionFactory"/>
</component>
```

デフォルトの設定では、トランザクションが暗黙的に使用する接続名に対して接続オブジェクトを登録する。接続名を明示的に指定する場合は、属性 `dbConnectionName` にその値を設定する。

**複数トランザクション（接続名を明示指定）**

トランザクション登録名（`transactionName`）はDBコネクションの登録名（`connectionName`）と一致させること。

```xml
<!-- DB接続管理ハンドラ -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <property name="connectionFactory" ref="connectionFactory"/>
  <property name="connectionName" value="subTran"/>
</component>

<!-- トランザクション制御ハンドラ -->
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="transactionFactory"/>
  <property name="transactionName" value="subTran"/>
</component>
```

**特定例外発生時にコミットする設定**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="transactionFactory"/>
  <property name="transactionCommitExceptions">
    <list>
      <value>example.TransactionCommitException</value>
      <value>example.TransactionCommitException2</value>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

transactionFactory, transactionName, transactionCommitExceptions, TransactionFactory, トランザクション設定, スレッドローカル登録名, コミット対象例外, connectionName, dbConnectionName

</details>
