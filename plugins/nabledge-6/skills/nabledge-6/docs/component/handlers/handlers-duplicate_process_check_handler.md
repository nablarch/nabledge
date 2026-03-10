# プロセス多重起動防止ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.DuplicateProcessCheckHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-batch</artifactId>
</dependency>
```

## 制約

:ref:`thread_context_handler` よりも後ろに設定すること。本ハンドラはスレッドコンテキスト上のリクエストIDを元にプロセス多重起動チェックを行うため。

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

## 多重起動防止チェック処理をカスタマイズする

`DuplicateProcessChecker` の実装クラスを作成することでカスタマイズ可能。実装クラスは :ref:`duplicate_process_check_handler-configuration` の設定方法に従い、本ハンドラの `duplicateProcessChecker` プロパティに設定して使用する。
