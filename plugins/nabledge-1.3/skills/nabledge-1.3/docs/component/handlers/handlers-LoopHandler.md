## トランザクションループ制御ハンドラ

**クラス名:** `nablarch.fw.handler.LoopHandler`

-----

-----

### 概要

本ハンドラは、データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行するとともに、
トランザクション制御を行ない、一定の繰り返し回数ごとにトランザクションをコミットする。
これにより、バッチ処理のスループットを向上させることができる。

本ハンドラの機能はトランザクション管理機能とループ制御機能を兼ねているため
[トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) および [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-RequestThreadLoopHandler.md) とは排他利用である。

> **Warning:**
> 本ハンドラでは、複数の業務処理の一括コミットを許容している。
> このため、業務アクションハンドラ上の処理が正常終了したとしても、後続レコードの処理でエラーが
> 発生することによりロールバックされる可能性がある。

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | - |
| トランザクションループハンドラ | nablarch.fw.handler.LoopHandler | Object | Object | 実行中の業務トランザクションがなければ、新規のトランザクションを開始する。 | コミット間隔毎に業務トランザクションをコミットする。また、データリーダ上に処理対象データが残っていればループを継続する。 | 業務トランザクションをロールバックする。 | 1.コミット完了後 / 2.ロールバック後 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる。 |

**コールバックイベント**

本ハンドラでは [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md) と同様のコールバックを行なう。
後続のハンドラがイベントリスナ **TransactionManagementHandler.Callback** を実装することで、
下記のイベント発生時にコールバックを受けることができる。

1. 業務処理正常終了時

```java
TransactionManagementHandler.Callback<TData>#transactionNormalEnd(TData data, ExecutionContext context): void
```

> **Warning:**
> このコールバックは、レコード一件に対する業務処理が正常終了した場合に呼ばれるが、
> [トランザクション制御ハンドラ](../../component/handlers/handlers-TransactionManagementHandler.md) とは異なり、この時点ではまだ
> トランザクションのコミットが確定していない点に留意すること。

> これは、本ハンドラでは、コミット単位を任意に設定することができることに起因する制約である。

1. トランザクションロールバック直後

```java
TransactionManagementHandler.Callback<TData>#transactionAbnormalEnd(TData data, ExecutionContext context): void
```

### ハンドラ処理フロー

**[往路処理]**

**1. (トランザクションの取得と開始)**

本ハンドラに設定されたトランザクションファクトリからトランザクションオブジェクトを取得し、
トランザクションを開始する。
また、取得したトランザクションオブジェクトをスレッドローカル変数に格納する。

**2. (ループ開始前の初期化処理)**

ループ開始前のハンドラキューのシャローコピーを作成する。
未コミット件数を0に初期化する。

**3. (ループ開始)**

実行コンテキスト上のハンドラキューの内容を **2.** で作成したループ開始前の状態に戻す。

**4. (後続ハンドラの実行)**

ハンドラキュー上の後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**5. (1件分の処理が正常終了)**

後続ハンドラでの処理が正常終了した場合は、未コミット件数を1件増加させる。
また、後続ハンドラのうち、イベントリスナ **TransactionManagementHandler.Callback** を実装しているハンドラに対して
以下のコールバックを呼び出す。:

```
TransactionManagementHandler.Callback<TData>#transactionNormalEnd(TData data, ExecutionContext context): void
```

**5a. (データリーダが終端に達していた場合)**

**4.** の結果が **nablarch.fw.DataReader.NoMoreRecord** であった場合は、
業務処理が呼ばれる前にデータリーダの終端に達しているため、コールバックは呼ばずにスキップする。

**6. (コミット判定)**

現在の未コミット件数が、本ハンドラに設定されたコミット間隔に一致する場合は、現在のトランザクションをコミットする。

**7. (ループ継続)**

実行コンテキスト上のデータリーダの状態を確認し、終端に達していなければ、
**3.** 以降の処理を再度実行する。

**7a. (ループ終端)**

データリーダが終端に達していた場合は、未コミット処理をコミットした上で、
**4.** の処理結果をリターンして終了する。

**例外処理**

**5b. (例外制御)**

**4.** での処理中に、後続ハンドラから未捕捉の例外が送出された場合は、トランザクションをロールバックする。
(未コミットの処理についてもあわせてロールバックされる。)
また、後続ハンドラのうち、イベントリスナ **TransactionManagementHandler.Callback** を実装しているハンドラに対して
以下のコールバックを呼び出す。:

```
TransactionManagementHandler.Callback<TData>#transactionAbnormalEnd(TData data, ExecutionContext context): void
```

例外を再送出し、ループを終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| コミット間隔回数 | commitInterval | int | 任意指定(デフォルト=1) |
| トランザクション取得機能 | transactionFactory | TransactionFactory | 必須指定 |
| 使用DBコネクション名 | transactionName | String | 任意指定(デフォルト="transaction") |

以下はDIリポジトリ設定ファイルへの記述例である。
コミット間隔は運用状況等に応じて変更される可能性があるので、埋め込みパラメータとして定義しておくことを推奨する。

```xml
<!-- トランザクションループ制御ハンドラ -->
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="${commitInterval}" />
  <property name="transactionFactory" ref="transactionFactory" />
</component>
```
