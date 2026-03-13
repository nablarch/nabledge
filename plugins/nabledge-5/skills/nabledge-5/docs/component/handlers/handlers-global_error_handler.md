# グローバルエラーハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/global_error_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/GlobalErrorHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/ServiceError.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/results/InternalError.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/ThreadDeath.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/StackOverflowError.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/OutOfMemoryError.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/java/lang/VirtualMachineError.html)

## ハンドラクラス名

後続ハンドラで発生した未捕捉の例外及びエラーを捕捉し、ログ出力及び結果を返すハンドラ。

**クラス名**: `nablarch.fw.handler.GlobalErrorHandler`

<details>
<summary>keywords</summary>

GlobalErrorHandler, nablarch.fw.handler.GlobalErrorHandler, グローバルエラーハンドラ, 未捕捉例外処理, エラーハンドラ

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

nablarch-fw, com.nablarch.framework, モジュール依存関係

</details>

## 制約

- できるだけハンドラキューの先頭に配置すること。このハンドラより手前で例外が発生した場合は、ウェブアプリケーションサーバやJVMにより例外処理が行われる。
- スレッドコンテキストの情報をログに出力したい場合は、 [thread_context_clear_handler](handlers-thread_context_clear_handler.md) より後に配置すること。

<details>
<summary>keywords</summary>

ハンドラキュー配置順序, thread_context_clear_handler, スレッドコンテキスト, ハンドラキュー先頭配置

</details>

## 例外及びエラーに応じた処理内容

## 例外に応じた処理内容

| 例外クラス | 処理内容 |
|---|---|
| `ServiceError` (サブクラス含む) | `ServiceError#writeLog` を呼び出しログ出力。ログレベルはServiceErrorの実装クラスにより異なる。処理結果としてServiceErrorを返却。 |
| `Result.Error` (サブクラス含む) | FATALレベルのログ出力後、Result.Errorを返却。 |
| 上記以外の例外クラス | FATALレベルのログ出力後、捕捉した例外を原因に持つ `InternalError` を生成し返却。 |

## エラーに応じた処理内容

| エラークラス | 処理内容 |
|---|---|
| `ThreadDeath` (サブクラス含む) | INFOレベルのログ出力後、捕捉したエラーをリスロー。 |
| `StackOverflowError` (サブクラス含む) | FATALレベルのログ出力後、捕捉したエラーを原因に持つ `InternalError` を生成し返却。 |
| `OutOfMemoryError` (サブクラス含む) | FATALレベルのログ出力（失敗する可能性があるため、ログ出力前に標準エラー出力にOutOfMemoryError発生を出力）後、捕捉したエラーを原因に持つ `InternalError` を生成し返却。 |
| `VirtualMachineError` (サブクラス含む。StackOverflowError・OutOfMemoryError除く) | FATALレベルのログ出力後、捕捉したエラーをリスロー。 |
| 上記以外のエラークラス | FATALレベルのログ出力後、捕捉したエラーを原因に持つ `InternalError` を生成し返却。 |

<details>
<summary>keywords</summary>

ServiceError, nablarch.fw.results.ServiceError, Result.Error, nablarch.fw.Result.Error, InternalError, nablarch.fw.results.InternalError, ThreadDeath, StackOverflowError, OutOfMemoryError, VirtualMachineError, 例外処理, FATALログ, リスロー

</details>

## グローバルエラーハンドラでは要件を満たせない場合

このハンドラは設定などで実装を切り替えることができない。要件を満たせない場合（例：ログレベルを細かく切り替えたい場合）は、プロジェクト固有のエラー処理用ハンドラを作成すること。

<details>
<summary>keywords</summary>

カスタムエラーハンドラ, プロジェクト固有ハンドラ, ログレベルカスタマイズ, エラー処理ハンドラ作成

</details>
