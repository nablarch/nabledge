# リトライハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/retry_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/Retryable.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/CountingRetryContext.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/TimeRetryContext.html)

## ハンドラクラス名

デッドロックのような単純リトライでリカバリ可能なエラーを自動リトライ制御するハンドラ。`Retryable` を実装した実行時例外をリトライ可能とみなし、後続ハンドラを再実行する。リトライ上限の判定は `RetryContext` の実装クラスとして外部化されており、以下のデフォルト実装が提供されている。

- `リトライ回数による上限設定`
- `経過時間による上限設定`

処理内容:
1. リトライ対象例外発生時のリトライ処理
2. リトライ上限到達時の例外送出処理

**クラス**: `nablarch.fw.handler.RetryHandler`

<details>
<summary>keywords</summary>

RetryHandler, Retryable, RetryContext, CountingRetryContext, TimeRetryContext, nablarch.fw.handler.RetryHandler, リトライハンドラ, 自動リトライ, デッドロックリカバリ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係

</details>

## 制約

> **警告**: リトライ対象例外を送出するハンドラは、本ハンドラより後ろに設定すること。本ハンドラより手前でリトライ対象の例外を送出しても、単に例外として処理される。

<details>
<summary>keywords</summary>

ハンドラ設定順序, リトライ対象例外, 制約

</details>

## リトライの上限を設定する

本ハンドラを使用する際には必ずリトライ上限の設定が必要。上限設定は以下の2種類から選択:

- `リトライ回数による上限設定`
- `経過時間による上限設定`

プロジェクト要件にマッチしない場合は、プロジェクト側で実装を追加すること。

リトライ回数による上限設定の例:

```xml
<component name="retryHandler" class="nablarch.fw.handler.RetryHandler">
  <property name="retryContextFactory">
    <component class="nablarch.fw.handler.retry.CountingRetryContextFactory">
      <property name="retryCount" value="3" />        <!-- 最大3回リトライ -->
      <property name="retryIntervals" value="5000" /> <!-- リトライまで5秒待機 -->
    </component>
  </property>
</component>
```

> **補足**: 上限値は想定する最大復旧時間+αを設定すること。例: アクティブ/スタンバイDBの切り替えに最大5分かかる場合は7分等を上限に設定。複数の例外をリトライする場合は、最も復旧に時間がかかるものをベースに上限値を設定すること。

<details>
<summary>keywords</summary>

CountingRetryContextFactory, CountingRetryContext, retryContextFactory, TimeRetryContext, retryCount, retryIntervals, リトライ上限設定, 回数制限, 経過時間制限

</details>
