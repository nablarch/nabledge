# プロセス停止制御ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/process_stop_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/BasicProcessStopHandler.html)

## ハンドラクラス名

**クラス**: `nablarch.fw.handler.BasicProcessStopHandler`

:ref:`process_resident_handler`、:ref:`loop_handler`、:ref:`request_thread_loop_handler` などのループ制御ハンドラの後続に配置することで、ループを中断してプロセス停止要求を示す例外を送出する。

処理の流れ:
1. プロセス停止可否のチェック（プロセス停止フラグが"1"であればプロセス停止対象と判定）
2. プロセス停止処理

> **補足**: 都度起動バッチで、大量データ処理が終わらない場合などに、強制的に処理を停止するために使用する。

> **重要**: 本ハンドラはプロセス停止フラグの初期化を行わない。再度同じプロセスを実行する際には、予めプロセス停止フラグを初期化すること。

<details>
<summary>keywords</summary>

BasicProcessStopHandler, nablarch.fw.handler.BasicProcessStopHandler, プロセス停止制御, ループ中断, プロセス停止フラグ, 都度起動バッチ

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

nablarch-fw-standalone, nablarch-fw-batch, モジュール依存関係

</details>

## 制約

:ref:`thread_context_handler` より後ろに設定すること。本ハンドラはスレッドコンテキスト上のリクエストIDをもとに停止処理を行うため、:ref:`thread_context_handler` より後ろに配置する必要がある。

<details>
<summary>keywords</summary>

ThreadContextHandler, thread_context_handler, スレッドコンテキスト, リクエストID, ハンドラ設定順序

</details>

## プロセス停止制御を行うための設定

- 都度起動バッチで使用する場合、本ハンドラはサブスレッド側に設定する。
- 常駐バッチで使用する場合、本ハンドラはメインスレッド側に設定する。
- 初期化が必要なため、初期化対象のリストに設定する。

| プロパティ名 | 説明 |
|---|---|
| dbTransactionManager | DBアクセス用トランザクション設定 |
| tableName | チェックで使用するテーブル名 |
| requestIdColumnName | リクエストIDカラム名 |
| processHaltColumnName | プロセス停止フラグカラム名 |
| checkInterval | プロセス停止フラグのチェック間隔（任意） |
| exitCode | プロセス停止時の終了コード（任意） |

```xml
<component name="processStopHandler" class="nablarch.fw.handler.BasicProcessStopHandler">
  <property name="dbTransactionManager" ref="simpleDbTransactionManager" />
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="requestIdColumnName" value="REQUEST_ID" />
  <property name="processHaltColumnName" value="PROCESS_HALT_FLG" />
  <property name="checkInterval" value="1" />
  <property name="exitCode" value="50" />
</component>

<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="processStopHandler" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

dbTransactionManager, tableName, requestIdColumnName, processHaltColumnName, checkInterval, exitCode, BasicApplicationInitializer, プロセス停止設定, 都度起動バッチ, 常駐バッチ, サブスレッド, メインスレッド

</details>
