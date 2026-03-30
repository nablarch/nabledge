# トランザクション制御ハンドラ

## 概要

**クラス名**: `nablarch.common.handler.TransactionManagementHandler`

DB/メッセージキューなどのトランザクションに対応したリソースを使用し、後続処理における透過的トランザクションを実現するハンドラ。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる |

**コールバック**

`TransactionEventCallback` インターフェースを後続ハンドラで実装することで、トランザクションイベント時にコールバックを受けることができる。

| メソッド | イベント |
|---|---|
| transactionNormalEnd() | トランザクションコミット直後に呼ばれる |
| transactionAbnormalEnd() | トランザクションロールバック直後に呼ばれる |

> **注意**: `transactionAbnormalEnd()` は業務トランザクションのロールバック後に個別のトランザクション内で実行される。このトランザクションはコールバック完了後自動的にコミット/ロールバックされる。

<details>
<summary>keywords</summary>

TransactionManagementHandler, nablarch.common.handler.TransactionManagementHandler, DbConnectionManagementHandler, TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, トランザクション制御, 透過的トランザクション, コールバック

</details>

## ハンドラ処理フロー

**[往路処理]**

1. トランザクションオブジェクトの獲得: `transactionFactory` を用いてスレッドローカル上のDB接続に対するトランザクションを作成する。
   - 1a. DB接続未設定エラー: スレッドローカル登録名に対するDB接続がスレッドローカル上に未設定の場合は実行時例外を送出して終了する。
2. スレッドローカルへの登録: 取得したトランザクションオブジェクトをスレッドローカル変数上のMapに登録する（キー名=スレッドローカル登録名）。
   - 2a. トランザクション重複登録エラー: 同一登録名でトランザクションが既に存在する場合は実行時例外を送出して終了する。
3. トランザクション開始とハンドラキューの実行: トランザクションを開始し、後続ハンドラに処理を委譲する。

**[復路処理]**

4. トランザクションコミット: 後続ハンドラが正常終了した場合、トランザクションをコミットする。
5. コールバックの呼び出し: `TransactionEventCallback` を実装しているハンドラに対して `transactionNormalEnd(Object data, ExecutionContext context)` を呼び出す。
6. 終端処理: スレッドローカルからトランザクションを除去し、トランザクションをクローズする。
7. 正常終了: 後続ハンドラの処理結果をリターンする。

**[例外処理]**

- 3a, 4a. トランザクションロールバック: 後続ハンドラ処理中またはトランザクションコミット時に例外が送出された場合、トランザクションをロールバックし `transactionAbnormalEnd(Object data, ExecutionContext context)` を呼び出す。終端処理後、元例外を再送出する。
- 3b. コミット対象エラー: 後続ハンドラの実行時例外が `コミット対象例外クラスリスト` に含まれる場合は、ロールバックせずコミット処理（4.→5.→6.）を実行し、送出された例外を再送出する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, トランザクションコミット, トランザクションロールバック, TransactionEventCallback, transactionNormalEnd, transactionAbnormalEnd, 往路処理, 復路処理, 例外処理, コミット対象例外

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| transactionFactory | nablarch.core.transaction.TransactionFactory | ○ | | トランザクションファクトリ |
| transactionName | String | | transaction | トランザクション識別名。複数トランザクション利用時に指定。DBコネクションの登録名と一致させる必要がある。 |
| transactionCommitExceptions | List\<String\> | | | ロールバックせずコミットする実行時例外クラスの完全修飾名リスト |

**基本設定**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <property name="transactionFactory" ref="transactionFactory"/>
</component>
```

デフォルトの設定では、トランザクションが暗黙的に使用する接続名に対して接続オブジェクトを登録する。接続名を明示的に指定する場合は、属性 `dbConnectionName` にその値を設定する。

**複数トランザクション設定（登録名を明示する場合）**

`connectionName` と `transactionName` は一致させる必要がある。

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

**特定の例外が発生した場合にコミットする設定**

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

transactionFactory, transactionName, transactionCommitExceptions, nablarch.core.transaction.TransactionFactory, 設定項目, トランザクション登録名, コミット対象例外クラスリスト, connectionName, dbConnectionName

</details>
