# マルチスレッド実行制御ハンドラ

**公式ドキュメント**: [マルチスレッド実行制御ハンドラ](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/MultiThreadExecutionHandler.html)

## 概要

**クラス名**: `nablarch.fw.MultiThreadExecutionHandler`

サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行する。処理結果は各サブスレッドの実行結果を集約した `Result.MultiStatus` として返る。

**コールバック**

後続ハンドラで以下の抽象クラス／インターフェースを継承／実装することでコールバックを受けられる。

| 抽象クラス／インターフェース | メソッド | イベント |
|---|---|---|
| `BatchActionBase` | initialize | マルチスレッド実行開始前に一度だけ呼ばれる |
| `BatchActionBase` | error | サブスレッドのいずれかが異常終了した場合に一度だけ呼ばれる |
| `BatchActionBase` | terminate | サブスレッド上の処理完了後に一度だけ呼ばれる（異常終了時はerror後） |
| `DataReaderFactory` | createReader | 実行コンテキスト上にデータリーダが設定されていなかった場合、`BatchActionBase#initialize()` 呼び出し直後に一度だけ呼ばれる |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [BatchAction](handlers-BatchAction.md) | バッチアクションでは、本ハンドラのコールバックを利用してバッチの初期処理及び終了処理を実装している |

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, BatchActionBase, DataReaderFactory, Result.MultiStatus, マルチスレッド実行, コールバック, 並行実行, バッチアクション, データリーダ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 並行実行スレッド数をスレッドコンテキストの属性値として登録する。後続処理でシングルスレッド環境でしか利用できない機能の実行可否判定に参照される。
2. `BatchActionBase` を継承した後続ハンドラの `BatchActionBase#initialize(Object data, ExecutionContext context)` を呼び出す。
3. `ExecutionContext` からサブスレッドで使用するデータリーダを取得する。データリーダが未設定の場合はデータリーダファクトリで作成する。
   - 3a. `ExecutionContext` にデータリーダもデータリーダファクトリも設定されていない場合、`IllegalStateException` を送出する。
4. 各サブスレッド用に実行コンテキストをコピーする。

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List\<Handler\> | 現在のListのシャローコピー。各ハンドラはスレッドセーフに作成される必要がある |
| リクエストコンテキスト | Map\<String, Object\> | 新規のMapを作成。メインスレッド側の変数はサブスレッドに引き継がれない |
| セッションコンテキスト | Map\<String, Object\> | 現在のセッションスコープのMapをそのまま設定。各サブスレッドが単一のMapを共有する |
| データリーダ | DataReader | 現在のデータリーダをそのまま設定 |
| データリーダファクトリ | DataReaderFactory | 現在のファクトリをそのまま設定 |

5. サブスレッドを作成・実行する。各サブスレッドはコピーした実行コンテキストのハンドラキューに処理を委譲する。メインスレッドは全サブスレッドが終了するまで待機する。

**[復路処理]**

6. `BatchActionBase` を継承した後続ハンドラの `BatchActionBase#terminate(Object data, ExecutionContext context)` を呼び出す。
7. 各サブスレッドの処理結果を `Result.MultiStatus` に追加してリターンする。

**[例外処理]**

5a. サブスレッドのいずれかが異常終了（未捕捉の実行時例外またはエラーを送出）した場合：

1. `BatchActionBase` を継承した後続ハンドラの `BatchActionBase#error(Throwable e, ExecutionContext context)` を呼び出す。
2. 現在実行中の各サブスレッドに割り込み要求を行い、全サブスレッドが完了するかスレッド停止タイムアウトを経過するまで待機する。
3. `BatchActionBase#terminate` のコールバックを呼び出した後、起因例外を再送出する。

<details>
<summary>keywords</summary>

ExecutionContext, DataReader, DataReaderFactory, BatchActionBase, IllegalStateException, Handler, サブスレッド, 実行コンテキストコピー, ハンドラ処理フロー, 異常終了処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | デフォルト値 | 説明 |
|---|---|---|---|
| concurrentNumber | int | 1 | 並行実行スレッド数 |
| terminationTimeout | int | 600 | スレッド停止のタイムアウト秒数 |

並行実行スレッド数は運用時に変更する可能性が高いため、埋め込みパラメータとして定義することを推奨する。

```xml
<component class = "nablarch.fw.handler.MultiThreadExecutionHandler">
  <property name="concurrentNumber" value="${threadCount}" />
</component>
```

<details>
<summary>keywords</summary>

concurrentNumber, terminationTimeout, MultiThreadExecutionHandler, 並行実行スレッド数, スレッド停止タイムアウト

</details>
