## トランザクション制御ハンドラ

**クラス名:** `nablarch.common.handler.TransactionManagementHandler`

-----

-----

### 概要

データベースやメッセージキューなどのトランザクションに対応したリソースを使用し、
後続処理における透過的トランザクションを実現するハンドラ。

トランザクション機能の詳細については、
[トランザクション管理](../../component/libraries/libraries-03-TransactionManager.md) 機能の項を参照すること。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| トランザクション制御ハンドラ | nablarch.fw.common.handler.TransactionManagementHandler | Object | Object | 業務トランザクションの開始 | トランザクションをコミットする。 | トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションに DB接続を参加させることができる。 |

**コールバック**

本ハンドラではトランザクションに関連した以下のイベントリスナを定義している。
後続のハンドラで実装することにより、本ハンドラ実行中にコールバックを受けることができる。

| インターフェース | メソッド | イベント |
|---|---|---|
| [TransactionEventCallback](../../javadoc/nablarch/fw/TransactionEventCallback.html) | transactionNormalEnd() | トランザクションコミット直後に呼ばれる。 |
|  | transactionAbnormalEnd() | トランザクションロールバック直後に呼ばれる。 |

なお、 **transactionAbnormalEnd()** は業務トランザクションのロールバック後に実行されるため、
個別のトランザクション内で実行される。また、このトランザクションはコールバック完了後
自動的にコミット/ロールバックされる。

### ハンドラ処理フロー

**[往路処理]**

**1. (トランザクションオブジェクトの獲得)**

このハンドラに設定されている **トランザクションファクトリ** を用いて、
スレッドローカル上のDB接続に対するトランザクションを作成する。

**1a. (DB接続未設定エラー)**

本ハンドラに設定された **スレッドローカル登録名** に対するDB接続がスレッドローカル上に設定されていなかった場合は
実行時例外を送出して終了する。

**2. (スレッドローカルへの登録)**

**1.** で取得したトランザクションオブジェクトを、スレッドローカル変数上のMapに登録する。
キー名は、本ハンドラに設定された **スレッドローカル登録名** を使用する。

**2a. (トランザクション重複登録エラー)**

スレッドローカル上に同一の登録名で既にトランザクションが設定されていた場合は、実行時例外を送出して終了する。

**3. (トランザクション開始とハンドラキューの実行)**

トランンザクションを開始し、ハンドラキュー上の後続ハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**4. (トランザクションコミット)**

後続ハンドラの処理が正常終了した場合、トランザクションをコミットする。

**5. (コールバックの呼び出し)**

後続ハンドラの内、 **TransactionEventCallback** を実装しているものについて、
以下のコールバックメソッドを呼び出す。:

```
TransactionEventCallback#transactionNormalEnd(Object data, ExecutionContext context): void
```

**6. (終端処理)**

スレッドローカルからトランザクションを除去した上で、トランザクションをクローズする。

**7. (正常終了)**

**3.** で取得した後続ハンドラの処理結果をリターンし終了する。

**[例外処理]**

**3a, 4a.(トランザクションロールバック)**

後続ハンドラの処理中およびトランザクションのコミット時に例外が送出された場合は、トランザクションをロールバックし、
以下のコールバックメソッドを呼び出す。:

```
TransactionEventCallback#transactionAbnormalEnd(Object data, ExecutionContext context): void
```

**6.** の終端処理を実行後、元例外を再送出して終了する。

**3b. (コミット対象エラー)**

後続ハンドラの処理中に送出された実行時例外が本ハンドラに設定された **コミット対象例外クラスリスト** に含まれていた場合は、
**3a.** のロールバック処理は行わず、かわりに **4.** 、 **5.** 、 **6.** の各処理を実行し、送出された例外を再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| トランザクションファクトリ | transactionFactory | nablarch.core.transaction .TransactionFactory | (必須指定) |
| スレッドローカル登録名 | transactionName | String | (任意指定) カレントスレッドで使用するトランザクションを識別する 文字列。 複数のトランザクションを利用する場合に指定する。 またトランザクションとDBコネクションの登録名は一致させる 必要がある。 省略した場合は既定の接続名("transaction")使用する。 |
| コミット対象例外クラスリスト | transactionCommitExceptioins | List<String> | (任意指定) このハンドラで捕捉してもそのままコミットする実行時例外 のリスト。クラスの完全修飾名のリストを設定する。 |

**トランザクションファクトリ** の設定方法については
[トランザクション管理](../../component/libraries/libraries-03-TransactionManager.md)
を参照すること。

**基本設定**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <!-- トランザクションファクトリ -->
  <property name="transactionFactory" ref="transactionFactory"/>
</component>
```

デフォルトの設定では、トランザクションが暗黙的に使用する接続名
に対して接続オブジェクトを登録する。
接続名を明示的に指定する場合は、属性dbConnectionNameにその値を設定する。

```xml
<!-- DB接続管理ハンドラ -->
<component class="nablarch.common.handler.DbConnectionManagementHandler">
  <!-- DBコネクションファクトリ -->
  <property name="connectionFactory" ref="connectionFactory"/>
  <!-- DBコネクション登録名 -->
  <property name="connectionName" value="subTran"/>
</component>

<!-- トランザクション制御ハンドラ -->
<component class="nablarch.common.handler.TransactionManagementHandler">
  <!-- トランザクションファクトリ -->
  <property name="transactionFactory" ref="transactionFactory"/>
  <!-- トランザクション登録名(DBコネクションの登録名にあわせる) -->
  <property name="transactionName" value="subTran"/>
</component>
```

**特定の例外が発生した場合はロールバックせずにそのままコミットする**

```xml
<component class="nablarch.common.handler.TransactionManagementHandler">
  <!-- トランザクションファクトリ -->
  <property name="transactionFactory" ref="transactionFactory"/>
  <!-- トランザクションをコミットする例外 -->
  <property name="transactionCommitExceptions">
  <list>
    <value>example.TransactionCommitException</value>
    <value>example.TransactionCommitException2</value>
  </list>
  </property>
</component>
```
