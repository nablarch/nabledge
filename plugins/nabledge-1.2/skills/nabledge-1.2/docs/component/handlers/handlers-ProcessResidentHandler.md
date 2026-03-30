# プロセス常駐化ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、常駐起動型のバッチ処理で用いられる。

> **注意**: [ProcessResidentHandler](handlers-ProcessResidentHandler.md) はメインスレッド上でのループ制御、[RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) は各サブスレッド上でのループ制御を行う。例外制御のポリシーなどの面で挙動が大きく異なるため、共用はできない。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ProcessStopHandler](handlers-ProcessStopHandler.md) | 本ハンドラを組み込んだハンドラキューは、シグナル送信以外の手段で外部から停止させることができなくなる。外部コマンドなどによって正常終了させるには、[ProcessStopHandler](handlers-ProcessStopHandler.md) を本ハンドラの後続に設定する必要がある。 |
| [RetryHandler](handlers-RetryHandler.md) | 後続ハンドラの実行時例外をリトライ可能例外でラップして再送出するため、[RetryHandler](handlers-RetryHandler.md) を本ハンドラの上位に配置する必要がある。 |

<details>
<summary>keywords</summary>

ProcessResidentHandler, nablarch.fw.handler.ProcessResidentHandler, RequestThreadLoopHandler, ProcessStopHandler, RetryHandler, 常駐起動型バッチ処理, ループ制御, 定期実行

</details>

## ハンドラ処理フロー

**往路での処理**

1. ハンドラキューのスナップショット（シャローコピー）を作成する。
2. 実行コンテキスト上のハンドラキューを1.で作成したスナップショットの状態に復旧する。
3. 後続のハンドラを実行し、結果を取得する。

**復路での処理**

4. データ監視時間から後続ハンドラの実行時間を差し引いた時間を待機する。
5. 正常終了→2.以降を繰り返す（ループ継続）。

**例外処理**

- **3a. 閉局エラー（ServiceUnavailable）**: 何もせずに4.・5.の処理を行う（ループ継続）。
- **3b. プロセス正常停止（ProcessStop）**: ループを中断し、直近の処理結果オブジェクトをリターンして終了する。
- **3c. プロセス異常停止（ProcessAbnormalEnd）**: ループを中断し、捕捉した例外を再送出して終了する。
- **3d. 実行時例外**: 障害ログに出力した上で、RetryableExceptionでラップして送出する。
- **3e. エラー（java.lang.Error）**: 捕捉したエラーをそのまま再送出して終了する。

<details>
<summary>keywords</summary>

ProcessResidentHandler, ServiceUnavailable, ProcessStop, ProcessAbnormalEnd, RetryableException, nablarch.fw.Result.ServiceUnavailable, nablarch.fw.handler.ProcessStopHandler.ProcessStop, nablarch.fw.ProcessAbnormalEnd, ループ継続, プロセス停止

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dataWatchInterval | int | | 1000 | データ監視間隔（msec） |
| normalEndExceptions | List\<Class\> | | [ProcessStop.class] | プロセスを正常停止させる例外 |
| abnormalEndExceptions | List\<Class\> | | [ProcessAbnormalEnd.class] | プロセスを異常終了させる例外 |

> **注意**: データ監視間隔は常駐プロセスごとに異なる値を設定・変更することが想定されるため、埋め込みパラメータとして定義することを強く推奨する。

```xml
<component class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="dataWatchInterval" value="${data-watch-interval}" />
</component>
```

> **注意**: プロセス正常停止・異常停止の対象例外クラスは設定により変更可能だが、特段の理由がない限りはデフォルト設定を使用すること。

<details>
<summary>keywords</summary>

dataWatchInterval, normalEndExceptions, abnormalEndExceptions, ProcessStop, ProcessAbnormalEnd, データ監視間隔, 埋め込みパラメータ, 設定項目

</details>
