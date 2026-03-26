# プロセス停止制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessStopHandler`

[ProcessResidentHandler](handlers-ProcessResidentHandler.md) などループ制御ハンドラの後続に配置し、DBのフラグ変更によってループを中断させ、プロセスを正常終了させるハンドラ。

> **警告**: 本ハンドラは処理停止フラグの初期化を行わない。停止フラグを立ててプロセスを停止させた後、再度同じプロセスを実行する際には停止フラグをクリアする必要がある。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキスト上のリクエストID属性を使用するため、本ハンドラより前に配置する必要がある |
| [LoopHandler](handlers-LoopHandler.md) | [../architectural_pattern/batch_single_shot](../../processing-pattern/nablarch-batch/nablarch-batch-batch_single_shot.md) 実行中に停止させる場合は後続に配置 |
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) では後続に配置。停止時の終了コードは0（正常終了） |
| [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では後続に配置。停止時の終了コードは0（正常終了） |

**リクエスト管理テーブル構造**

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| 処理停止フラグ | CHAR(1) | "0": 通常、"1": 停止 |

<details>
<summary>keywords</summary>

ProcessStopHandler, nablarch.fw.handler.ProcessStopHandler, ProcessResidentHandler, ThreadContextHandler, LoopHandler, RequestThreadLoopHandler, ループ中断, プロセス停止, DBフラグ制御, 処理停止フラグ, リクエスト管理テーブル

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(停止フラグ確認のスキップ)** 総実行回数が停止フラグ確認間隔の倍数でない場合、後続ハンドラに処理委譲してリターン
2. **(停止フラグ確認)** 総実行回数が確認間隔の倍数の場合、リクエストテーブルに以下の条件でクエリ発行: `リクエストID = (スレッドコンテキストのリクエストID属性値) AND 処理停止フラグ = '1'`
   - **2a.** 結果セットが空でない場合、後続ハンドラを実行せず `ProcessStopHandler.ProcessStop` を送出。ループ中断、運用ログ出力後にプロセス停止。未コミットの例外はすべてロールバック
3. **(後続ハンドラへの処理移譲)** 結果セットが空の場合、後続ハンドラに処理委譲して結果を取得

**[復路処理]**

4. **(正常終了)** 3. で取得した処理結果をリターンして終了

**[例外処理]**

- **3a.** 後続ハンドラ処理中のエラーはそのまま再送出

<details>
<summary>keywords</summary>

ProcessStopHandler.ProcessStop, ハンドラ処理フロー, 停止フラグ確認, ロールバック, プロセス停止制御, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| checkInterval | int | | 1 | 停止フラグ確認間隔 |
| tableName | String | ○ | | リクエストテーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| processHaltColumnName | String | ○ | | 処理停止フラグカラム名 |
| dbTransactionManager | SimpleDbTransactionManager | ○ | | DBトランザクションマネージャ |
| exitCode | int | | 1 | プロセス停止時終了コード |

**基本設定**

```xml
<component
  name="processStopHandler"
  class="nablarch.fw.handler.ProcessStopHandler">
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意設定項目も含む例**

```xml
<component
  name="processStopHandler"
  class="nablarch.fw.handler.ProcessStopHandler">
  <property name="checkInterval" value="1" />
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
  <property name="exitCode" value="50" />
</component>
```

<details>
<summary>keywords</summary>

checkInterval, tableName, requestIdColumnName, processHaltColumnName, dbTransactionManager, exitCode, SimpleDbTransactionManager, 設定項目, DBトランザクション, 停止フラグ確認間隔

</details>
