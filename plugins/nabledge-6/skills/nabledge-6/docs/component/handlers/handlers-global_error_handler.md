# グローバルエラーハンドラ

## ハンドラクラス名

後続ハンドラで発生した未捕捉の例外及びエラーを捕捉し、ログ出力及び結果を返すハンドラ。

**クラス名**: `GlobalErrorHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

## 制約

- できるだけハンドラキューの先頭に配置すること。このハンドラより手前のハンドラで例外が発生した場合は、ウェブアプリケーションサーバやJVMにより例外処理が行われる。
- スレッドコンテキストの情報をログに出力したい場合は、:ref:`thread_context_clear_handler` より後に配置すること。

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

## グローバルエラーハンドラでは要件を満たせない場合

このハンドラは設定などで実装を切り替えることができない。要件を満たせない場合は、プロジェクト固有のエラー処理用ハンドラを作成して対応すること（例：ログレベルを細かく切り替えたい場合など）。
