# プロセス停止制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessStopHandler`

DB上の処理停止フラグ変更によってループを中断させ、プロセスを正常終了させるハンドラ。[ProcessResidentHandler](handlers-ProcessResidentHandler.md) などのループ制御ハンドラの後続に配置する。

> **警告**: 処理停止フラグの初期化は行なわない。停止フラグを立ててプロセスを停止させた後、再度同じプロセスを実行する際には停止フラグをクリアする必要がある。

**関連するハンドラ**

| ハンドラ | 配置ルール |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | スレッドコンテキストのリクエストID属性を使用するため、本ハンドラより前に配置する必要がある |
| [LoopHandler](handlers-LoopHandler.md) | [../architectural_pattern/batch_single_shot](../../processing-pattern/nablarch-batch/nablarch-batch-batch_single_shot.md) 実行中に停止させる場合、[LoopHandler](handlers-LoopHandler.md) の後続に配置する |
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | [../architectural_pattern/batch_resident_thread_sync](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident_thread_sync.md) では [ProcessResidentHandler](handlers-ProcessResidentHandler.md) の後続に配置する。停止時の終了コードは 0（正常終了） |
| [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) の後続に配置する。停止時の終了コードは 0（正常終了） |

**テーブル構成（リクエスト管理テーブル）**

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| 処理停止フラグ | CHAR(1) | "0": 通常、"1": 停止 |

<details>
<summary>keywords</summary>

ProcessStopHandler, nablarch.fw.handler.ProcessStopHandler, ProcessResidentHandler, ThreadContextHandler, LoopHandler, RequestThreadLoopHandler, プロセス停止制御, 処理停止フラグ, ループ中断, リクエスト管理テーブル

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(停止フラグ確認のスキップ)**: 総実行回数が停止フラグ確認間隔の倍数でない場合、後続ハンドラに処理を委譲し、その結果をリターンして終了する。
2. **(停止フラグ確認)**: 総実行回数が確認間隔の倍数に一致する場合、以下の条件でリクエストテーブルを検索する。
   - 抽出条件: `リクエストID = (スレッドコンテキストのリクエストID属性値) AND 処理停止フラグ = '1'`
   - **2a. (プロセス停止)**: 結果セットが空でない場合、後続ハンドラを実行せず `ProcessStopHandler.ProcessStop` を送出してプロセスを停止する。ループが中断され、運用ログ出力後にプロセスが停止する。未コミットの処理はすべてロールバックされる。
3. **(後続ハンドラへの処理移譲)**: 結果セットが空の場合、後続ハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

4. **(正常終了)**: 3. で取得した処理結果をリターンして終了する。

**[例外処理]**

- **3a. (後続ハンドラ処理中のエラー)**: 後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

ProcessStopHandler.ProcessStop, 停止フラグ確認, プロセス停止フロー, ロールバック, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| checkInterval | int | | 1 | 停止フラグ確認間隔 |
| tableName | String | ○ | | リクエストテーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| processHaltColumnName | String | ○ | | 処理停止フラグカラム名 |
| dbTransactionManager | SimpleDbTransactionManager | ○ | | DBトランザクションマネージャ |
| exitCode | Integer | | 1 | プロセス停止時終了コード |

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

**任意の設定項目も含めた例**

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

checkInterval, tableName, requestIdColumnName, processHaltColumnName, dbTransactionManager, exitCode, SimpleDbTransactionManager, 設定項目, XML設定

</details>
