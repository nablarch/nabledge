# トランザクション制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.TransactionManagementHandler`

データベースやメッセージキューなどのトランザクション対応リソースを使用し、後続処理における透過的トランザクションを実現するハンドラ。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる。 |

**コールバック**

後続ハンドラが `TransactionEventCallback` を実装することで、以下のイベント発生時にコールバックを受けることができる。

| インターフェース | メソッド | イベント |
|---|---|---|
| TransactionEventCallback | transactionNormalEnd() | トランザクションコミット直後 |
| TransactionEventCallback | transactionAbnormalEnd() | トランザクションロールバック直後 |

> **注意**: `transactionAbnormalEnd()` は業務トランザクションのロールバック後に個別のトランザクション内で実行される。このトランザクションはコールバック完了後に自動的にコミット/ロールバックされる。

<details>
<summary>keywords</summary>

TransactionManagementHandler, nablarch.common.handler.TransactionManagementHandler, TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, DbConnectionManagementHandler, トランザクション制御, 透過的トランザクション, コールバック, トランザクションイベントリスナ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. トランザクションファクトリを用いてスレッドローカル上のDB接続に対するトランザクションオブジェクトを取得する。
   - **1a.** スレッドローカル登録名に対するDB接続がスレッドローカル上に設定されていない場合、実行時例外を送出して終了。
2. 取得したトランザクションオブジェクトをスレッドローカルのMapに登録する（キー名はスレッドローカル登録名）。
   - **2a.** 同一登録名で既にトランザクションが設定されていた場合、実行時例外を送出して終了。
3. トランザクションを開始し、後続ハンドラに処理を委譲して結果を取得する。

**[復路処理]**

4. 後続ハンドラの処理が正常終了した場合、トランザクションをコミットする。
5. `TransactionEventCallback` を実装している後続ハンドラの `transactionNormalEnd(Object data, ExecutionContext context)` を呼び出す。
6. スレッドローカルからトランザクションを除去し、トランザクションをクローズする。
7. 後続ハンドラの処理結果をリターンして終了。

**[例外処理]**

- **3a, 4a. トランザクションロールバック**: 後続ハンドラ処理中またはコミット時に例外が送出された場合、トランザクションをロールバックし、`TransactionEventCallback#transactionAbnormalEnd(Object data, ExecutionContext context)` を呼び出す。終端処理（6.）実行後、元例外を再送出。
- **3b. コミット対象エラー**: 後続ハンドラ処理中に送出された実行時例外が**コミット対象例外クラスリスト**に含まれていた場合、ロールバックを行わず、コミット（4.）・コールバック（5.）・終端処理（6.）を実行し、送出された例外を再送出して終了。

<details>
<summary>keywords</summary>

TransactionManagementHandler, TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, スレッドローカル登録名, コミット対象例外クラスリスト, トランザクション開始, トランザクションコミット, トランザクションロールバック, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | nablarch.core.transaction.TransactionFactory | ○ | | トランザクションファクトリ |
| transactionName | String | | transaction | カレントスレッドで使用するトランザクションを識別する文字列。複数トランザクション使用時に指定する。トランザクションとDBコネクションの登録名は一致させる必要がある。 |
| transactionCommitExceptions | List\<String\> | | | このハンドラで捕捉してもそのままコミットする実行時例外クラスの完全修飾名リスト。 |

> **重要**: `transactionName` と DbConnectionManagementHandler の `connectionName` は同一の値を設定する必要がある。

**基本設定**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="transactionFactory"/>
</component>
```

**複数トランザクション使用時（接続名を明示指定）**

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

**特定の例外発生時にロールバックせずコミットする設定**

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

transactionFactory, transactionName, transactionCommitExceptions, TransactionFactory, nablarch.core.transaction.TransactionFactory, トランザクションファクトリ設定, コミット対象例外クラスリスト, 複数トランザクション, connectionName

</details>
