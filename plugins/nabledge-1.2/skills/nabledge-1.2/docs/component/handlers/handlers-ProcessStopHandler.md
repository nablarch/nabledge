## プロセス停止制御ハンドラ

**クラス名:** `nablarch.fw.handler.ProcessStopHandler`

-----

-----

### 概要

本ハンドラは、 [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) のような、ループ制御を行なうハンドラの後続に配置することで、
DB上のフラグ変更によってループを中断させ、プロセスを正常終了させることを可能とするハンドラである。

> **Warning:**
> 本ハンドラでは、処理停止フラグの初期化は行なわない。
> 停止フラグを立ててプロセスを停止させた後、再度同じプロセスを実行する際には、
> 停止フラグをクリアする必要がある。

-----

**ハンドラ処理概要** ( [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) での例)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| スレッドコンテキスト変数設定ハンドラ(メインスレッド) | nablarch.common.handler.ThreadContextHandler_main | Object | Object | 起動引数の内容からリクエストID、ユーザID等のスレッドコンテキスト変数を初期化する。 | - | - |
| プロセス常駐化ハンドラ | nablarch.fw.handler.ProcessResidentHandler | Object | Object | データ監視間隔ごとに後続処理を繰り返し実行する。 | ループを継続する。 | ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。エラーが送出された場合はそのまま再送出する。 |
| 処理停止制御ハンドラ | nablarch.fw.handler.ProcessStopHandler | Object | Object | リクエストテーブル上の処理停止フラグがオンであった場合は、後続の処理は行なわずにプロセス停止例外(ProcessStop)を送出する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラではスレッドコンテキスト上のリクエストID属性を使用するので、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) を本ハンドラより前に配置する必要がある。 |
| [トランザクションループ制御ハンドラ](../../component/handlers/handlers-LoopHandler.md) | [都度起動バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-single-shot.md) を実行中に停止させる場合は、 [トランザクションループ制御ハンドラ](../../component/handlers/handlers-LoopHandler.md) の後続にこのハンドラを配置する。 |
| [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) | [常駐バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident.md) では、 [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) の後続にこのハンドラを配置する。 なお、停止時の終了コードは(0:正常終了)となる。 |
| [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-RequestThreadLoopHandler.md) | [同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、 [リクエストスレッド内ループ制御ハンドラ](../../component/handlers/handlers-RequestThreadLoopHandler.md) の後続にこのハンドラを配置する。 なお、停止時の終了コードは(0:正常終了)となる。 |

**テーブル構成**

以下は、本ハンドラが参照するリクエスト管理テーブルの構造である。

| 論理名 | データ型 | 備考 |
|---|---|---|
| リクエストID | VARCHAR PK | プロセスを特定するためのID |
| 処理停止フラグ | CHAR(1) | "0": 通常、"1": 停止 |

### ハンドラ処理フロー

**[往路処理]**

**1. (停止フラグ確認処理のスキップ)**

本ハンドラの総実行回数が、停止フラグ確認間隔の値の倍数でない場合、
このハンドラでは何もせずに、後続のハンドラに処理を委譲し、その処理結果をリターンして終了する。

**2. (停止フラグ確認)**

本ハンドラの総実行回数が、停止フラグ確認間隔の値の倍数に一致する場合、
リクエストテーブルに以下のクエリを発行し、停止フラグの状態を確認する。

**抽出条件**:

```
リクエストID = (スレッドコンテキストのリクエストID属性値) AND 処理停止フラグ = '1'
```

**2a. (プロセス停止)**

**2.** の結果セットが空ではない場合、後続ハンドラの実行は行なわず、 `ProcessStopHandler.ProcessStop` を送出し終了する。
これにより、ループは中断され、運用ログを出力したのち、プロセスが停止する。また、未コミットの例外は全てロールバックされる。

**3.  (後続ハンドラへの処理移譲)**

**2.** の結果セットが空であった場合、後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**4. (正常終了)**

**3.** で取得した処理結果をリターンして終了する。

**[例外処理]**

**3a. (後続ハンドラ処理中のエラー)**

後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| 停止フラグ確認間隔 | checkInterval | int | 任意指定(デフォルト = 1:毎回) |
| リクエストテーブル名 | tableName | String | 必須指定 |
| リクエストIDカラム名 | requestIdColumnName | String | 必須指定 |
| 処理停止フラグカラム名 | processHaltColumnName | String | 必須指定 |
| DBトランザクションマネージャ | dbTransactionManager | SimpleDbTransactionManager | 必須指定 |
| プロセス停止時終了コード | exitCode | Integer | 任意指定(デフォルト = 1) |

**基本設定**

```xml
<component
  name="processStopHandler"
  class="nablarch.fw.handler.ProcessStopHandler">
  <!-- リクエストテーブル名 -->
  <property name="tableName" value="BATCH_REQUEST" />
  <!-- リクエストIDカラム名 -->
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <!-- 処理停止フラグカラム名 -->
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <!-- DBトランザクションマネージャ -->
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
</component>
```

**任意の設定項目も含めた例**

```xml
<component
  name="processStopHandler"
  class="nablarch.fw.handler.ProcessStopHandler">

  <!-- 停止フラグ確認間隔 -->
  <property name="checkInterval" value="1" />
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />

  <!-- プロセス停止時終了コード -->
  <property name="exitCode" value="50" />
</component>
```
