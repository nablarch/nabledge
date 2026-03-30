# マルチスレッド実行制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.MultiThreadExecutionHandler`

サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行する。処理結果は各サブスレッドの実行結果を集約した `Result.MultiStatus` となる。

**コールバック**

後続ハンドラで以下の抽象クラス／インターフェースを継承／実装することで、本ハンドラ実行中にコールバックを受けられる。

| 抽象クラス／インターフェース | メソッド | イベント |
|---|---|---|
| `BatchActionBase` | initialize | マルチスレッド実行開始前に一度だけ呼ばれる |
| `BatchActionBase` | error | サブスレッドのいずれかが異常終了（未捕捉の実行時例外またはエラー）した場合に一度だけ呼ばれる |
| `BatchActionBase` | terminate | サブスレッド上の処理完了後に一度だけ呼ばれる（異常終了時はerror後に呼ばれる） |
| `DataReaderFactory` | createReader | 実行コンテキスト上にデータリーダが設定されていない場合、`BatchActionBase#initialize()` の呼び出し直後に一度だけ呼ばれる |

**関連するハンドラ**: `BatchAction` — バッチアクションのコールバックを利用して初期処理・終了処理を実装している

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, nablarch.fw.MultiThreadExecutionHandler, Result.MultiStatus, BatchActionBase, BatchAction, DataReaderFactory, initialize, error, terminate, createReader, マルチスレッド実行, 並行実行, コールバック, サブスレッド

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 並行実行スレッド数をスレッドコンテキストの属性値として登録する（後続処理でシングルスレッド専用機能の実行可否判定に使用）
2. `BatchActionBase#initialize(Object data, ExecutionContext context)` を呼び出す
3. `ExecutionContext` からデータリーダを取得する。データリーダが未設定の場合はデータリーダファクトリを使用して作成する
   - **3a.** データリーダもデータリーダファクトリも未設定の場合、`IllegalStateException` を送出する
4. 各サブスレッド用に実行コンテキストをコピーする

   | 属性名 | データ型 | コピーされる内容 |
   |---|---|---|
   | ハンドラキュー | `List<Handler>` | 現在のListのシャローコピー（各ハンドラはスレッドセーフに作成する必要がある） |
   | リクエストコンテキスト | `Map<String, Object>` | 新規Mapを作成（メインスレッド側の変数はサブスレッドに引き継がれない） |
   | セッションコンテキスト | `Map<String, Object>` | 現在のMapをそのまま設定（各サブスレッドで単一Mapを共有） |
   | データリーダ | `DataReader` | 現在のデータリーダをそのまま設定 |
   | データリーダファクトリ | `DataReaderFactory` | 現在のファクトリをそのまま設定 |

5. サブスレッドを作成・実行する。各サブスレッドはコピーされた実行コンテキストのハンドラキューに処理を委譲し、メインスレッドは全サブスレッドの終了を待機する

**[復路処理]**

6. `BatchActionBase#terminate(Object data, ExecutionContext context)` を呼び出す
7. 各サブスレッドの処理結果を `Result.MultiStatus` に追加してリターンする

**[例外処理]**

サブスレッドが異常終了（未捕捉の実行時例外またはエラー）した場合:

1. `BatchActionBase#error(Throwable e, ExecutionContext context)` を呼び出す
2. 実行中の全サブスレッドに割り込み要求を行い、全スレッドが完了するか**スレッド停止タイムアウト**を経過するまで待機する
3. `BatchActionBase#terminate` を呼び出した上で起因例外を再送出する

<details>
<summary>keywords</summary>

ExecutionContext, IllegalStateException, Handler, DataReader, DataReaderFactory, BatchActionBase, Result.MultiStatus, ハンドラ処理フロー, 実行コンテキストコピー, スレッドセーフ, サブスレッド実行, 往路処理, 復路処理, 例外処理

</details>

## 設定項目

| プロパティ名 | 型 | デフォルト値 | 説明 |
|---|---|---|---|
| concurrentNumber | int | 1 | 並行実行スレッド数 |
| terminationTimeout | int | 600（秒） | スレッド停止のタイムアウト秒数 |

並行実行スレッド数は運用時に変更する可能性が高いため、埋め込みパラメータとして定義することを推奨する。

```xml
<component class="nablarch.fw.handler.MultiThreadExecutionHandler">
  <property name="concurrentNumber" value="${threadCount}" />
</component>
```

<details>
<summary>keywords</summary>

concurrentNumber, terminationTimeout, 並行実行スレッド数, スレッド停止タイムアウト, MultiThreadExecutionHandler設定, nablarch.fw.handler.MultiThreadExecutionHandler

</details>
