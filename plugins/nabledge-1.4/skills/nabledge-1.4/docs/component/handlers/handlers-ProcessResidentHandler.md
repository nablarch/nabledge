# プロセス常駐化ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、常駐起動型のバッチ処理で用いられる。

> **注意**: 本ハンドラは :doc:`/architectural_pattern/batch_resident_thread_sync` 専用のハンドラである。それ以外の基盤構成を選択した場合、本ハンドラを使用することはできない。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ProcessStopHandler](handlers-ProcessStopHandler.md) | 本ハンドラを組み込んだハンドラキューは、シグナル送信以外の手段で外部から停止させることができなくなる。外部コマンドなどによって正常終了させるには、ProcessStopHandlerを本ハンドラの後続に設定する必要がある。 |
| [RetryHandler](handlers-RetryHandler.md) | 後続ハンドラ実行中に実行時例外を捕捉した場合、リトライ可能例外でラップして再送出し、バッチプロセスの継続制御をRetryHandlerで行う。RetryHandlerを本ハンドラの上位に配置する必要がある。 |

<details>
<summary>keywords</summary>

ProcessResidentHandler, nablarch.fw.handler.ProcessResidentHandler, プロセス常駐化ハンドラ, 常駐起動型バッチ処理, データ監視, ProcessStopHandler, RetryHandler

</details>

## ハンドラ処理フロー

**[往路での処理]**

1. (ハンドラキューのコピー) 本ハンドラ開始時点でのハンドラキューのスナップショット（シャローコピー）を作成する。
2. (ループ開始) 実行コンテキスト上のハンドラキューの内容を、1.で作成したスナップショットの状態に復旧する。
3. (後続ハンドラの実行) 後続のハンドラを実行し、その結果を取得する。

**[復路での処理]**

4. (実行待機) 本ハンドラに設定されたデータ監視時間から、後続ハンドラの実行時間を差し引いた時間を待機する。
5. (正常終了→ループ継続) 2.以降の処理を繰り返す。

**[例外処理]**

- 3a. (閉局エラー→ループ継続) `nablarch.fw.Result.ServiceUnavailable` が送出された場合は、何もせずに4.5.の処理を行う。
- 3b. (プロセス正常停止) `nablarch.fw.handler.ProcessStopHandler.ProcessStop` が送出された場合は、ループを中断し、直近の処理結果オブジェクトをリターンして終了する。
- 3c. (プロセス異常停止) `nablarch.fw.ProcessAbnormalEnd` が送出された場合は、ループを中断し、捕捉した例外を再送出して終了する。
- 3d. (実行時例外→リトライ) その他の実行時例外が送出された場合は、障害ログに出力した上で、`RetryableException` でラップして送出し終了する。
- 3e. (エラー終了) `java.lang.Error` が送出された場合は、捕捉したエラーをそのまま再送出して終了する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, ループ処理, 例外処理, 閉局エラー, プロセス停止, RetryableException, nablarch.fw.Result.ServiceUnavailable, nablarch.fw.ProcessAbnormalEnd, ProcessStop, java.lang.Error

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dataWatchInterval | int | | 1000 | データ監視間隔 (msec) |
| normalEndExceptions | List\<Class\> | | [ProcessStop.class] | プロセスを正常停止させる例外 |
| abnormalEndExceptions | List\<Class\> | | [ProcessAbnormalEnd.class] | プロセスを異常終了させる例外 |

データ監視間隔は常駐プロセスごとに異なる値を設定したり、運用状況に応じて変更することが想定されるため、埋め込みパラメータとして定義することを強く推奨する。

```xml
<component class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="dataWatchInterval" value="${data-watch-interval}" />
</component>
```

> **注意**: プロセス正常停止・異常停止の対象となる例外クラスは設定で追加・変更可能だが、特段の理由が無い限りデフォルト設定を使用すること。

<details>
<summary>keywords</summary>

dataWatchInterval, normalEndExceptions, abnormalEndExceptions, データ監視間隔, 設定項目, 埋め込みパラメータ

</details>
