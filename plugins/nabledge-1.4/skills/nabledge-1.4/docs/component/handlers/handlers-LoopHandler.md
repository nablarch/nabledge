# トランザクションループ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.LoopHandler`

データリーダ上に処理対象データが存在する間、後続ハンドラを繰り返し実行し、一定件数ごとにトランザクションをコミットする。

> **警告**: 複数業務処理の一括コミットを許容しているため、業務アクションハンドラが正常終了しても、後続レコードの処理でエラーが発生した場合にロールバックされる可能性がある。

[TransactionManagementHandler](handlers-TransactionManagementHandler.md) および [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) とは排他利用。

**関連ハンドラ**

| ハンドラ | 内容 |
|---|---|
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md) | 上位に配置することで、本ハンドラが管理するトランザクションにDB接続を参加させることができる。 |

**コールバックイベント** (`TransactionManagementHandler.Callback` を実装したハンドラが受け取る)

1. 業務処理正常終了時: `TransactionManagementHandler.Callback<TData>#transactionNormalEnd(TData data, ExecutionContext context): void`

   > **警告**: このコールバックはレコード1件の業務処理が正常終了した場合に呼ばれるが、[TransactionManagementHandler](handlers-TransactionManagementHandler.md) とは異なり、この時点ではトランザクションのコミットが確定していない。コミット単位を任意に設定できることに起因する制約。

2. トランザクションロールバック直後: `TransactionManagementHandler.Callback<TData>#transactionAbnormalEnd(TData data, ExecutionContext context): void`

<details>
<summary>keywords</summary>

nablarch.fw.handler.LoopHandler, LoopHandler, TransactionManagementHandler.Callback, transactionNormalEnd, transactionAbnormalEnd, ExecutionContext, RequestThreadLoopHandler, DbConnectionManagementHandler, トランザクション制御, ループ制御, バッチ処理スループット, コミット間隔, コールバックイベント

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(トランザクション取得と開始)**: 設定されたトランザクションファクトリからトランザクションオブジェクトを取得・開始し、スレッドローカル変数に格納する。
2. **(ループ開始前の初期化)**: (1) ハンドラキューのシャローコピー作成 (2) 未コミット件数を0に初期化 (3) コミット実施予告フラグ (`nablarch_LoopHandler_is_about_to_commit`) をfalseで初期化
3. **(ループ開始)**: ハンドラキューをループ開始前の状態に戻す。
4. **(後続ハンドラの実行)**

**[復路処理]**

5. **(正常終了)**: 未コミット件数を1増加。`TransactionManagementHandler.Callback` を実装したハンドラに `transactionNormalEnd` コールバックを呼び出す。
5a. **(データリーダ終端の場合)**: 処理結果が `nablarch.fw.DataReader.NoMoreRecord` の場合、コールバックをスキップ。
6. **(コミット判定)**: 未コミット件数がコミット間隔と一致したらトランザクションをコミット。
6a. **(コミット実施予告フラグ設定)**: 未コミット件数がコミット間隔より1少ない場合、`nablarch_LoopHandler_is_about_to_commit` フラグをtrueに設定。
7. **(ループ継続)**: データリーダが終端でなければ3.以降を再実行。
7a. **(ループ終端)**: データリーダが終端の場合、残未コミット処理をコミットし処理結果をリターン。

**[例外処理]**

5b. **(例外制御)**: 後続ハンドラから未捕捉例外が送出された場合、トランザクションをロールバック（未コミット処理も含む）し、`transactionAbnormalEnd` コールバックを呼び出し、例外を再送出してループを終了。

<details>
<summary>keywords</summary>

nablarch.fw.DataReader.NoMoreRecord, nablarch_LoopHandler_is_about_to_commit, transactionNormalEnd, transactionAbnormalEnd, コミット実施予告フラグ, ループ処理フロー, コミット判定, ロールバック, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| commitInterval | int | | 1 | コミット間隔回数 |
| transactionFactory | TransactionFactory | ○ | | トランザクション取得機能 |
| transactionName | String | | "transaction" | 使用DBコネクション名 |

> **補足**: コミット間隔は運用状況に応じて変更される可能性があるため、埋め込みパラメータとして定義することを推奨。

```xml
<component class="nablarch.fw.handler.LoopHandler">
  <property name="commitInterval" value="${commitInterval}" />
  <property name="transactionFactory" ref="transactionFactory" />
</component>
```

<details>
<summary>keywords</summary>

commitInterval, transactionFactory, transactionName, TransactionFactory, コミット間隔設定, DIコンテナ設定

</details>
