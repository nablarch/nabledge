# トランザクションループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.LoopHandler`

データリーダ上に処理対象のデータが存在する間、後続ハンドラの処理を繰り返し実行するとともに、トランザクション制御を行い、一定の繰り返し回数ごとにトランザクションをコミットする。これにより、バッチ処理のスループットを向上させることができる。

トランザクション管理機能とループ制御機能を兼ねているため、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) および [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) とは排他利用。

> **警告**: 業務処理が正常終了しても、後続レコードの処理でエラーが発生した場合にロールバックされる可能性がある（複数業務処理の一括コミットを許容しているため）。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | このハンドラの上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる |

**コールバックイベント**

後続のハンドラが `TransactionManagementHandler.Callback` を実装することで以下のコールバックを受けられる。

1. 業務処理正常終了時: `TransactionManagementHandler.Callback<TData>#transactionNormalEnd(TData data, ExecutionContext context): void`

   > **警告**: このコールバックは1件の業務処理が正常終了した時点で呼ばれるが、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) と異なり、この時点ではトランザクションのコミットが未確定。コミット単位を任意に設定できることに起因する制約。

2. トランザクションロールバック直後: `TransactionManagementHandler.Callback<TData>#transactionAbnormalEnd(TData data, ExecutionContext context): void`

<details>
<summary>keywords</summary>

LoopHandler, nablarch.fw.handler.LoopHandler, TransactionManagementHandler, TransactionManagementHandler.Callback, transactionNormalEnd, transactionAbnormalEnd, トランザクションループ制御, バッチ処理, コミット間隔, 排他利用, RequestThreadLoopHandler, DbConnectionManagementHandler

</details>

## ハンドラ処理フロー

**[往路処理]**

1. トランザクションファクトリからトランザクションオブジェクトを取得・開始し、スレッドローカル変数に格納する。
2. ループ開始前のハンドラキューのシャローコピーを作成し、未コミット件数を0に初期化する。
3. 実行コンテキスト上のハンドラキューの内容をループ開始前の状態に戻す。
4. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

5. 正常終了時: 未コミット件数を1増加。`TransactionManagementHandler.Callback` を実装するハンドラに `transactionNormalEnd` コールバックを呼び出す。
5a. 処理結果が `nablarch.fw.DataReader.NoMoreRecord` だった場合（業務処理呼び出し前にデータリーダが終端）: コールバックなしでスキップ。
6. 未コミット件数が `commitInterval` に一致する場合は、現在のトランザクションをコミットする。
7. データリーダが終端に達していなければ3.以降を再実行（ループ継続）。
7a. データリーダが終端の場合: 未コミット処理をコミットして処理結果をリターンし終了。

**例外処理**

5b. 未捕捉例外発生時: トランザクションをロールバック（未コミット処理も含む）。`TransactionManagementHandler.Callback` を実装するハンドラに `transactionAbnormalEnd` コールバックを呼び出す。例外を再送出しループを終了する。

<details>
<summary>keywords</summary>

LoopHandler, トランザクション制御フロー, ループ処理, DataReader.NoMoreRecord, transactionNormalEnd, transactionAbnormalEnd, コミット判定, 往路処理, 復路処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| commitInterval | int | | 1 | コミット間隔回数 |
| transactionFactory | TransactionFactory | ○ | | トランザクション取得機能 |
| transactionName | String | | "transaction" | 使用DBコネクション名 |

> **補足**: `commitInterval` は運用状況に応じて変更される可能性があるため、埋め込みパラメータとして定義することを推奨。

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="${commitInterval}" />
  <property name="transactionFactory" ref="transactionFactory" />
</component>
```

<details>
<summary>keywords</summary>

commitInterval, transactionFactory, transactionName, TransactionFactory, LoopHandler設定, コミット間隔設定

</details>
