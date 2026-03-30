# マルチスレッド実行制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.MultiThreadExecutionHandler`

サブスレッドを作成し、ハンドラキュー上の後続ハンドラの処理を各サブスレッド上で並行実行する。処理結果は各サブスレッドの実行結果を集約した `Result.MultiStatus` となる。

**コールバック**

後続ハンドラで以下の抽象クラス／インターフェースを継承／実装することでコールバックを受けられる：

| 抽象クラス／インターフェース | メソッド | イベント |
|---|---|---|
| `BatchActionBase` | initialize | マルチスレッド実行開始前に一度だけ呼ばれる |
| `BatchActionBase` | error | サブスレッドのいずれかが異常終了した場合に一度だけ呼ばれる |
| `BatchActionBase` | terminate | サブスレッド上の処理完了後に一度だけ呼ばれる（異常終了時は error 後に呼ばれる） |
| `DataReaderFactory` | createReader | 実行コンテキスト上にデータリーダが未設定の場合、`BatchActionBase#initialize()` 呼び出し直後に一度だけ呼ばれる |

**関連するハンドラ**

- [BatchAction](handlers-BatchAction.md): バッチアクションでは本ハンドラのコールバックを利用してバッチの初期処理・終了処理を実装している

<details>
<summary>keywords</summary>

MultiThreadExecutionHandler, nablarch.fw.MultiThreadExecutionHandler, BatchActionBase, DataReaderFactory, Result.MultiStatus, マルチスレッド実行, サブスレッド並行実行, コールバック

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 並行実行スレッド数をスレッドコンテキストに登録する。後続処理でシングルスレッド環境でしか利用できない機能の実行可否を判定する際に参照される。
2. `BatchActionBase` を継承しているハンドラに対して `BatchActionBase#initialize(Object data, ExecutionContext context)` コールバックを呼び出す。
3. サブスレッドで使用するデータリーダを実行コンテキスト（`ExecutionContext`）から取得する。データリーダが未設定の場合はデータリーダファクトリを使用して作成する。
   - データリーダ・データリーダファクトリともに未設定の場合、`IllegalStateException` を送出する。
4. 各サブスレッド用の実行コンテキストを現在の実行コンテキストをもとに作成する。各属性のコピー方式：

| 属性名 | データ型 | コピーされる内容 |
|---|---|---|
| ハンドラキュー | List\<Handler\> | 現在のListのシャローコピー。各ハンドラはスレッドセーフに作成される必要がある |
| リクエストコンテキスト | Map\<String, Object\> | 新規Mapを作成。メインスレッド側の変数はサブスレッドに引き継がれない |
| セッションコンテキスト | Map\<String, Object\> | 現在のセッションスコープのMapをそのまま設定。各サブスレッドは単一のMapを共有する |
| データリーダ | `DataReader` | 現在のデータリーダをそのまま設定 |
| データリーダファクトリ | `DataReaderFactory` | 現在のファクトリをそのまま設定 |

5. サブスレッドを作成し実行する。各サブスレッドはコピーした実行コンテキスト中のハンドラキューに処理を委譲する。メインスレッドは全サブスレッドが終了するまで待機する。

**[復路処理]**

6. `BatchActionBase` を継承しているハンドラに対して `BatchActionBase#terminate(Object data, ExecutionContext context)` コールバックを呼び出す。
7. 各サブスレッドの処理結果を `Result.MultiStatus` に追加してリターンする。

**[例外処理]**

サブスレッドのいずれかが異常終了（未捕捉の実行時例外またはエラーを送出）した場合：
1. `BatchActionBase#error(Throwable e, ExecutionContext context)` コールバックを呼び出す。
2. 現在実行中の全サブスレッドに割り込み要求を行い、全サブスレッドが完了するか**スレッド停止タイムアウト**を経過するまで待機する。
3. `BatchActionBase#terminate` コールバックを呼び出した上で、起因例外を再送出する。

<details>
<summary>keywords</summary>

ExecutionContext, IllegalStateException, DataReader, DataReaderFactory, Handler, BatchActionBase, ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, スレッドコンテキスト, 実行コンテキストのコピー

</details>

## 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 並行実行スレッド数 | concurrentNumber | int | デフォルト値は1 |
| スレッド停止のタイムアウト秒数 | terminationTimeout | int | デフォルト値は600(秒) |

並行実行スレッド数は運用時に値を変更する可能性が高いため、埋め込みパラメータとして定義することを推奨する。

```xml
<component class="nablarch.fw.handler.MultiThreadExecutionHandler">
  <property name="concurrentNumber" value="${threadCount}" />
</component>
```

<details>
<summary>keywords</summary>

concurrentNumber, terminationTimeout, 並行実行スレッド数, スレッド停止タイムアウト, nablarch.fw.handler.MultiThreadExecutionHandler

</details>
