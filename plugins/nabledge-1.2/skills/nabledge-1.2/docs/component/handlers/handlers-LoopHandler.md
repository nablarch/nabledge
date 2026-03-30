# トランザクションループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.LoopHandler`

データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行するとともに、トランザクション制御を行ない、一定の繰り返し回数ごとにトランザクションをコミットする。コミット間隔でスループット調整可能。

本ハンドラの機能はトランザクション管理機能とループ制御機能を兼ねているため、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) および [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) とは排他利用である。

> **警告**: 複数の業務処理の一括コミットを許容しているため、後続レコードの処理でエラーが発生することによりロールバックされる可能性がある。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる。 |

**コールバックイベント**

後続のハンドラが `TransactionManagementHandler.Callback` を実装することで、以下のイベント発生時にコールバックを受けることができる。

1. 業務処理正常終了時:

   `TransactionManagementHandler.Callback<TData>#transactionNormalEnd(TData data, ExecutionContext context): void`

   > **警告**: このコールバックは、レコード一件に対する業務処理が正常終了した場合に呼ばれるが、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) とは異なり、この時点ではまだトランザクションのコミットが確定していない。コミット単位を任意に設定できることに起因する制約である。

2. トランザクションロールバック直後:

   `TransactionManagementHandler.Callback<TData>#transactionAbnormalEnd(TData data, ExecutionContext context): void`

<details>
<summary>keywords</summary>

LoopHandler, nablarch.fw.handler.LoopHandler, TransactionManagementHandler, RequestThreadLoopHandler, DbConnectionManagementHandler, TransactionManagementHandler.Callback, ExecutionContext, transactionNormalEnd, transactionAbnormalEnd, トランザクションループ制御, バッチ処理, 排他利用, コールバック

</details>

## ハンドラ処理フロー

**[往路処理]**

1. トランザクション取得と開始: 設定されたトランザクションファクトリからトランザクションオブジェクトを取得し、トランザクションを開始する。取得したトランザクションオブジェクトをスレッドローカル変数に格納する。
2. ループ開始前の初期化処理: ハンドラキューのシャローコピーを作成する。未コミット件数を0に初期化する。
3. ループ開始: 実行コンテキスト上のハンドラキューの内容を2.で作成したループ開始前の状態に戻す。
4. 後続ハンドラの実行: ハンドラキュー上の後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

5. 1件分の処理が正常終了: 未コミット件数を1件増加させる。`TransactionManagementHandler.Callback` を実装しているハンドラに対して `transactionNormalEnd` コールバックを呼び出す。
   - 5a. データリーダが終端に達していた場合（`nablarch.fw.DataReader.NoMoreRecord`）: コールバックをスキップする。
6. コミット判定: 未コミット件数がコミット間隔に一致する場合は、現在のトランザクションをコミットする。
7. ループ継続: データリーダが終端に達していなければ、3.以降の処理を再度実行する。
   - 7a. ループ終端: データリーダが終端に達していた場合は、未コミット処理をコミットした上で、4.の処理結果をリターンして終了する。

**例外処理**

- 5b. 後続ハンドラから未捕捉の例外が送出された場合: トランザクションをロールバックする（未コミットの処理も含む）。`TransactionManagementHandler.Callback` を実装しているハンドラに対して `transactionAbnormalEnd` コールバックを呼び出す。例外を再送出し、ループを終了する。

<details>
<summary>keywords</summary>

LoopHandler, nablarch.fw.DataReader.NoMoreRecord, NoMoreRecord, TransactionManagementHandler.Callback, ExecutionContext, ハンドラ処理フロー, ループ制御, コミット判定, ロールバック, transactionNormalEnd, transactionAbnormalEnd

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| commitInterval | int | | 1 | コミット間隔回数 |
| transactionFactory | TransactionFactory | ○ | | トランザクション取得機能 |
| transactionName | String | | "transaction" | 使用DBコネクション名 |

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="${commitInterval}" />
  <property name="transactionFactory" ref="transactionFactory" />
</component>
```

> **補足**: コミット間隔は運用状況等に応じて変更される可能性があるので、埋め込みパラメータとして定義しておくことを推奨する。

<details>
<summary>keywords</summary>

commitInterval, transactionFactory, transactionName, 設定項目, コミット間隔, TransactionFactory

</details>
