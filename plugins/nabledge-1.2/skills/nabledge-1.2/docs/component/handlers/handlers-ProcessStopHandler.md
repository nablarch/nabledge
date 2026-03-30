# プロセス停止制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.ProcessStopHandler`

[ProcessResidentHandler](handlers-ProcessResidentHandler.md) などのループ制御ハンドラの後続に配置することで、DBのフラグ変更によりループを中断しプロセスを正常終了させる。

> **警告**: 本ハンドラは処理停止フラグの初期化を行わない。停止フラグでプロセスを停止した後、再度同じプロセスを実行する場合は停止フラグをクリアする必要がある。

**関連するハンドラ**

| ハンドラ | 配置要件 |
|---|---|
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラより前に配置必須（スレッドコンテキストのリクエストID属性を使用するため） |
| [LoopHandler](handlers-LoopHandler.md) | [../architectural_pattern/batch_single_shot](../../processing-pattern/nablarch-batch/nablarch-batch-batch_single_shot.md) 実行中に停止させる場合、[LoopHandler](handlers-LoopHandler.md) の後続に配置 |
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | [../architectural_pattern/batch_resident](../../processing-pattern/nablarch-batch/nablarch-batch-batch_resident.md) では [ProcessResidentHandler](handlers-ProcessResidentHandler.md) の後続に配置。停止時終了コード: 0（正常終了） |
| [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では [RequestThreadLoopHandler](handlers-RequestThreadLoopHandler.md) の後続に配置。停止時終了コード: 0（正常終了） |

**テーブル構成（リクエスト管理テーブル）**

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| 処理停止フラグ | CHAR(1) | "0": 通常、"1": 停止 |

<details>
<summary>keywords</summary>

ProcessStopHandler, ProcessResidentHandler, ThreadContextHandler, LoopHandler, RequestThreadLoopHandler, プロセス停止制御, ループ制御, 停止フラグ, バッチ常駐処理, リクエスト管理テーブル

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(停止フラグ確認処理のスキップ)** 総実行回数が停止フラグ確認間隔の倍数でない場合、後続ハンドラに処理を委譲して終了。
2. **(停止フラグ確認)** 総実行回数が停止フラグ確認間隔の倍数の場合、リクエストテーブルにクエリを発行: `リクエストID = (スレッドコンテキストのリクエストID属性値) AND 処理停止フラグ = '1'`
   - **2a. (プロセス停止)** 結果セットが空でない場合、`ProcessStopHandler.ProcessStop` を送出してループを中断。未コミットの例外は全てロールバックされ、運用ログ出力後プロセス停止。
3. **(後続ハンドラへの処理移譲)** 結果セットが空の場合、後続ハンドラに処理を委譲。

**[復路処理]**

4. **(正常終了)** 3. で取得した処理結果をリターンして終了。

**[例外処理]**

- **3a. (後続ハンドラ処理中のエラー)** 後続ハンドラ処理中にエラーが発生した場合はそのまま再送出して終了。

<details>
<summary>keywords</summary>

ProcessStopHandler.ProcessStop, 停止フラグ確認, ハンドラ処理フロー, プロセス停止, ロールバック, checkInterval

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| checkInterval | int | | 1（毎回） | 停止フラグ確認間隔 |
| tableName | String | ○ | | リクエストテーブル名 |
| requestIdColumnName | String | ○ | | リクエストIDカラム名 |
| processHaltColumnName | String | ○ | | 処理停止フラグカラム名 |
| dbTransactionManager | SimpleDbTransactionManager | ○ | | DBトランザクションマネージャ |
| exitCode | Integer | | 1 | プロセス停止時終了コード |

**基本設定**

```xml
<component name="processStopHandler" class="nablarch.fw.handler.ProcessStopHandler">
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意の設定項目も含めた例**

```xml
<component name="processStopHandler" class="nablarch.fw.handler.ProcessStopHandler">
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

checkInterval, tableName, requestIdColumnName, processHaltColumnName, dbTransactionManager, exitCode, SimpleDbTransactionManager, 設定項目, 停止フラグ確認間隔

</details>
