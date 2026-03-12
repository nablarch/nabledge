# グローバルエラーハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/global_error_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/GlobalErrorHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceError.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/InternalError.html)

## ハンドラクラス名

後続ハンドラで発生した未捕捉の例外及びエラーを捕捉し、ログ出力及び結果を返すハンドラ。

**クラス名**: `GlobalErrorHandler`

<details>
<summary>keywords</summary>

GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, グローバルエラーハンドラ, 未捕捉例外, エラー捕捉, ログ出力

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw, com.nablarch.framework, Mavenモジュール, 依存関係

</details>

## 制約

- できるだけハンドラキューの先頭に配置すること。このハンドラより手前のハンドラで例外が発生した場合は、ウェブアプリケーションサーバやJVMにより例外処理が行われる。
- スレッドコンテキストの情報をログに出力したい場合は、[thread_context_clear_handler](handlers-thread_context_clear_handler.md) より後に配置すること。

<details>
<summary>keywords</summary>

ハンドラキュー配置順, 先頭配置, thread_context_clear_handler, スレッドコンテキスト, ログ出力

</details>

## 例外及びエラーに応じた処理内容

**例外に応じた処理内容**:

| 例外クラス | 処理内容 |
|---|---|
| `ServiceError` (サブクラス含む) | `ServiceError#writeLog` を呼び出しログ出力（ログレベルはServiceError実装クラスにより異なる）。処理結果として `ServiceError` を返却。 |
| `Result.Error` (サブクラス含む) | FATALレベルのログ出力後、処理結果として `Result.Error` を返却。 |
| 上記以外の例外クラス | FATALレベルのログ出力後、捕捉した例外を原因とする `InternalError` を生成して処理結果として返却。 |

**エラーに応じた処理内容**:

| エラークラス | 処理内容 |
|---|---|
| `ThreadDeath` (サブクラス含む) | INFOレベルのログ出力後、捕捉したエラーをリスロー。 |
| `StackOverflowError` (サブクラス含む) | FATALレベルのログ出力後、捕捉したエラーを原因とする `InternalError` を生成して処理結果として返却。 |
| `OutOfMemoryError` (サブクラス含む) | FATALレベルのログ出力失敗の可能性があるため、ログ出力前に標準エラー出力にOutOfMemoryError発生を出力する。FATALレベルのログ出力後、捕捉したエラーを原因とする `InternalError` を生成して処理結果として返却。 |
| `VirtualMachineError` (StackOverflowError・OutOfMemoryError以外のサブクラス) | FATALレベルのログ出力後、捕捉したエラーをリスロー。 |
| 上記以外のエラークラス | FATALレベルのログ出力後、捕捉したエラーを原因とする `InternalError` を生成して処理結果として返却。 |

<details>
<summary>keywords</summary>

ServiceError, nablarch.fw.results.ServiceError, Result.Error, nablarch.fw.Result.Error, InternalError, nablarch.fw.results.InternalError, ThreadDeath, StackOverflowError, OutOfMemoryError, VirtualMachineError, 例外処理, エラー処理, FATALレベル, リスロー, InternalError生成

</details>

## グローバルエラーハンドラでは要件を満たせない場合

このハンドラは設定などで実装を切り替えることができない。要件を満たせない場合は、プロジェクト固有のエラー処理用ハンドラを作成して対応すること（例：ログレベルを細かく切り替えたい場合など）。

<details>
<summary>keywords</summary>

カスタムハンドラ, プロジェクト固有ハンドラ, ログレベル切り替え, 実装切り替え不可

</details>
