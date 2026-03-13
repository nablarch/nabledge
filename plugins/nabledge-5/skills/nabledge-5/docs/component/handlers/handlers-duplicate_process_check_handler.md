# プロセス多重起動防止ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/duplicate_process_check_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DuplicateProcessCheckHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/BasicDuplicateProcessChecker.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/DuplicateProcessChecker.html)

## ハンドラクラス名

同一バッチプロセスが同時に複数起動された場合に、後から起動されたプロセスを異常終了させるハンドラ。同一プロセスの識別にはスレッドコンテキスト上のリクエストIDを使用する。同一バッチアクションでも、リクエストIDが異なる場合は別プロセスとして扱われる。

> **重要**: 原則JP1などのジョブスケジューラ側で多重起動を制御すること。ジョブスケジューラ側で制御できない場合に限り、本ハンドラをアプリケーションレイヤーの制御として使用する。

処理フロー:
1. プロセスの多重起動チェック（起動中フラグを「起動中」に変更）
2. 起動中フラグを「未起動」に初期化

**クラス名**: `nablarch.fw.handler.DuplicateProcessCheckHandler`

<details>
<summary>keywords</summary>

DuplicateProcessCheckHandler, nablarch.fw.handler.DuplicateProcessCheckHandler, プロセス多重起動防止, バッチプロセス重複実行防止, 起動中フラグ, リクエストID

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

nablarch-fw-batch, com.nablarch.framework, モジュール依存

</details>

## 制約

[thread_context_handler](handlers-thread_context_handler.md) より後ろに設定すること。本ハンドラはスレッドコンテキスト上のリクエストIDを使用して多重起動チェックを行うため、スレッドコンテキスト変数管理ハンドラが先に実行されている必要がある。

<details>
<summary>keywords</summary>

スレッドコンテキスト変数管理ハンドラ, thread_context_handler, ハンドラ設定順序, リクエストID, 多重起動チェック順序

</details>

## 多重起動防止チェックを行うための設定

`BasicDuplicateProcessChecker` を多重起動防止チェッククラスとして使用する。`BasicDuplicateProcessChecker` は初期化が必要なため、初期化対象リストへの追加が必要。

```xml
<component name="duplicateProcessChecker" class="nablarch.fw.handler.BasicDuplicateProcessChecker">
  <!-- データベースへアクセスするためのトランザクション設定 -->
  <property name="dbTransactionManager" ref="transaction" />
  <!-- チェックで使用するテーブルの定義情報 -->
  <property name="tableName" value="BATCH_REQUEST" />
  <property name="processIdentifierColumnName" value="REQUEST_ID" />
  <property name="processActiveFlgColumnName" value="PROCESS_ACTIVE_FLG" />
</component>

<component name="duplicateProcessCheckHandler"
    class="nablarch.fw.handler.DuplicateProcessCheckHandler">
  <property name="duplicateProcessChecker" ref="duplicateProcessChecker" />
  <!-- 終了コードを設定する（任意） -->
  <property name="exitCode" value="10" />
</component>

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

BasicDuplicateProcessChecker, duplicateProcessChecker, tableName, processIdentifierColumnName, processActiveFlgColumnName, dbTransactionManager, exitCode, 多重起動防止設定, BATCH_REQUEST, BasicApplicationInitializer

</details>

## 多重起動防止チェック処理をカスタマイズする

`DuplicateProcessChecker` の実装クラスを作成することでカスタマイズ可能。実装したクラスは [duplicate_process_check_handler-configuration](#s3) の設定方法に従い、本ハンドラの `duplicateProcessChecker` プロパティに設定して使用する。

<details>
<summary>keywords</summary>

DuplicateProcessChecker, nablarch.fw.handler.DuplicateProcessChecker, 多重起動防止カスタマイズ, インターフェース実装

</details>
