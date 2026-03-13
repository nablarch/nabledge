# プロセス停止制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/process_stop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/BasicProcessStopHandler.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.BasicProcessStopHandler`

本ハンドラは、以下のようなループ制御を行うハンドラの後続に配置することで、ループを中断してプロセス停止要求を示す例外を送出する機能を提供する。

- `process_resident_handler`
- `loop_handler`
- `request_thread_loop_handler`

> **補足**: 都度起動バッチで大量データ処理が終わらない場合などに、強制的に処理を停止するために使用する。

> **重要**: プロセス停止フラグの初期化は行わない。再度同じプロセスを実行する際には、予めプロセス停止フラグを初期化すること。

プロセス停止フラグが"1"であればプロセス停止対象と判定する。

<details>
<summary>keywords</summary>

BasicProcessStopHandler, nablarch.fw.handler.BasicProcessStopHandler, プロセス停止制御, プロセス停止フラグ, 強制停止, 都度起動バッチ, ループ制御, process_resident_handler, loop_handler, request_thread_loop_handler, ハンドラ配置, 後続

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>

<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-batch</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, nablarch-fw-batch, モジュール依存関係, com.nablarch.framework

</details>

## 制約

- `thread_context_handler` より後ろに設定すること。本ハンドラはスレッドコンテキスト上のリクエストIDをもとに停止処理を行うため。

<details>
<summary>keywords</summary>

thread_context_handler, スレッドコンテキスト, リクエストID, 設定順序, ハンドラ配置順

</details>

## プロセス停止制御を行うための設定

- 都度起動バッチで使用する場合、本ハンドラはサブスレッド側に設定する。
- 常駐バッチで使用する場合、本ハンドラはメインスレッド側に設定する。

```xml
<component name="processStopHandler" class="nablarch.fw.handler.BasicProcessStopHandler">
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="checkInterval" value="1" />
  <property name="exitCode" value="50" />
</component>
```

`checkInterval`（プロセス停止フラグのチェック間隔）、`exitCode`（プロセス停止時の終了コード）は任意設定。

<details>
<summary>keywords</summary>

BasicProcessStopHandler, dbTransactionManager, tableName, requestIdColumnName, processHaltColumnName, checkInterval, exitCode, 都度起動バッチ, 常駐バッチ, サブスレッド, メインスレッド

</details>
