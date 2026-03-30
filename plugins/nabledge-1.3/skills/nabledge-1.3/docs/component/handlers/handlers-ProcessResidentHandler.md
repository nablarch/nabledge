# プロセス常駐化ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessResidentHandler`

後続のハンドラキューの内容を一定間隔毎に繰り返し実行するハンドラ。特定のデータソース上の入力データを定期的に監視してバッチ処理を行う、常駐起動型のバッチ処理で用いられる。

> **注意**: 本ハンドラは :doc:`/architectural_pattern/batch_resident_thread_sync` 専用。それ以外の基盤構成では使用不可。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ProcessStopHandler](handlers-ProcessStopHandler.md) | 本ハンドラを組み込んだハンドラキューは、シグナル送信以外の手段で外部から停止できない。外部コマンドによる正常終了には、本ハンドラの後続に [ProcessStopHandler](handlers-ProcessStopHandler.md) を設定すること。 |
| [RetryHandler](handlers-RetryHandler.md) | 実行時例外を捕捉した場合、リトライ可能例外でラップして再送出する。[RetryHandler](handlers-RetryHandler.md) を本ハンドラの上位に配置すること。 |

<details>
<summary>keywords</summary>

ProcessResidentHandler, nablarch.fw.handler.ProcessResidentHandler, ProcessStopHandler, RetryHandler, 常駐起動型バッチ処理, ハンドラキュー繰り返し実行, 定期監視バッチ

</details>

## ハンドラ処理フロー

**[往路での処理]**

1. ハンドラ開始時点でのハンドラキューのスナップショット（シャローコピー）を作成する。
2. 実行コンテキスト上のハンドラキューを 1. のスナップショット状態に復旧する。
3. 後続のハンドラを実行し、結果を取得する。

**[復路での処理]**

4. データ監視時間から後続ハンドラの実行時間を差し引いた時間を待機する。
5. 2. 以降の処理を繰り返す（ループ継続）。

**[例外処理]**

- **3a. 閉局エラー（`nablarch.fw.Result.ServiceUnavailable`）**: 何もせず 4.→5. の処理を行う（ループ継続）。
- **3b. プロセス正常停止（`nablarch.fw.handler.ProcessStopHandler.ProcessStop`）**: ループを中断し、直近の処理結果オブジェクトを返して終了。
- **3c. プロセス異常停止（`nablarch.fw.ProcessAbnormalEnd`）**: ループを中断し、捕捉した例外を再送出して終了。
- **3d. 実行時例外**: 障害ログに出力後、`RetryableException` でラップして送出し終了。
- **3e. エラー（`java.lang.Error`）**: 捕捉したエラーをそのまま再送出して終了。

<details>
<summary>keywords</summary>

nablarch.fw.Result.ServiceUnavailable, nablarch.fw.handler.ProcessStopHandler.ProcessStop, nablarch.fw.ProcessAbnormalEnd, RetryableException, java.lang.Error, ループ制御, プロセス正常停止, プロセス異常停止, 閉局エラー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| dataWatchInterval | int | | 1000 | データ監視間隔（msec） |
| normalEndExceptions | List\<Class\> | | [ProcessStop.class] | プロセスを正常停止させる例外 |
| abnormalEndExceptions | List\<Class\> | | [ProcessAbnormalEnd.class] | プロセスを異常終了させる例外 |

> **補足**: `dataWatchInterval` は常駐プロセスごとに異なる値を設定・運用変更することが想定されるため、埋め込みパラメータとして定義することを強く推奨する。

```xml
<component class="nablarch.fw.handler.ProcessResidentHandler">
  <property name="dataWatchInterval" value="${data-watch-interval}" />
</component>
```

> **注意**: プロセス正常停止・異常停止の対象例外クラスは設定で変更可能だが、特段の理由がない限りデフォルト設定を使用すること。

<details>
<summary>keywords</summary>

dataWatchInterval, normalEndExceptions, abnormalEndExceptions, ProcessStop, ProcessAbnormalEnd, データ監視間隔, プロセス停止例外設定, 常駐化ハンドラ設定

</details>
