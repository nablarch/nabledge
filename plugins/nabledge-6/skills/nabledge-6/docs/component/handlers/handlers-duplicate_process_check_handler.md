# プロセス多重起動防止ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/duplicate_process_check_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DuplicateProcessCheckHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/BasicDuplicateProcessChecker.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DuplicateProcessChecker.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DuplicateProcessCheckHandler`

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, nablarch.fw.handler.DuplicateProcessCheckHandler, プロセス多重起動防止ハンドラ クラス名

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-batch</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-batch, com.nablarch.framework, Maven依存関係, モジュール依存関係

</details>

## 制約

:ref:`thread_context_handler` よりも後ろに設定すること。本ハンドラはスレッドコンテキスト上のリクエストIDを元にプロセス多重起動チェックを行うため。

<details>
<summary>keywords</summary>

thread_context_handler, スレッドコンテキスト変数管理ハンドラ, ハンドラ順序, 設定順序制約, リクエストID

</details>

## 多重起動防止チェックを行うための設定

同一のバッチプロセスを同時に複数実行した場合、**後に実行されたプロセスを異常終了させる**。

同一バッチプロセスの識別にスレッド変数上のリクエストIDを使用する。同一バッチアクションでもリクエストIDが異なる場合は、異なるバッチプロセスとして扱われる。

> **重要**: 原則JP1などのジョブスケジューラ側で制御すること。ジョブスケジューラ側で制御できない場合のみ、本ハンドラを適用してアプリケーションレイヤーで多重起動を防止する。

処理フロー:
1. 多重起動チェック（起動中フラグを起動中に変更）
2. 起動中フラグを未起動（初期化）に変更

`DuplicateProcessCheckHandler` に `BasicDuplicateProcessChecker` を設定する。`BasicDuplicateProcessChecker` は初期化が必要なクラスのため、初期化対象リスト（initializer）に追加すること。

```xml
<!-- 多重起動防止チェッククラス -->
<component name="duplicateProcessChecker" class="nablarch.fw.handler.BasicDuplicateProcessChecker">
  <property name="dbTransactionManager" ref="transaction" />
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="processIdentifierColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
</component>

<!-- プロセス多重起動防止ハンドラ -->
<component name="duplicateProcessCheckHandler"
    class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <property name="duplicateProcessChecker" ref="duplicateProcessChecker" />
  <!-- 終了コード(任意) -->
  <property name="exitCode" value="10" />
</component>

<!-- BasicDuplicateProcessCheckerを初期化対象リストに追加 -->
<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="duplicateProcessChecker" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

BasicDuplicateProcessChecker, nablarch.fw.handler.BasicDuplicateProcessChecker, DuplicateProcessCheckHandler, dbTransactionManager, tableName, processIdentifierColumnName, processActiveFlgColumnName, exitCode, initializeList, 多重起動防止設定, リクエストID, 起動中フラグ, BasicApplicationInitializer, 異常終了, 多重起動 異常終了

</details>

## 多重起動防止チェック処理をカスタマイズする

`DuplicateProcessChecker` の実装クラスを作成することでカスタマイズ可能。実装クラスは :ref:`duplicate_process_check_handler-configuration` の設定方法に従い、本ハンドラの `duplicateProcessChecker` プロパティに設定して使用する。

<details>
<summary>keywords</summary>

DuplicateProcessChecker, nablarch.fw.handler.DuplicateProcessChecker, 多重起動防止チェックカスタマイズ, カスタム実装

</details>
