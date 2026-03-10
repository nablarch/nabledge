# リトライハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/retry_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/Retryable.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/CountingRetryContext.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/retry/TimeRetryContext.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.handler.RetryHandler`

データベースアクセス時のデッドロックのように、単純リトライによってリカバリ可能なエラーについて、自動的なリトライを制御するハンドラ。

`Retryable` を実装した実行時例外をリトライ可能なエラーとみなし、後続ハンドラを再実行する。

リトライ上限判定は `RetryContext` の実装クラスとして外部化されており、デフォルトで以下の実装が提供されている：
- `リトライ回数による上限設定`
- `経過時間による上限設定`

<details>
<summary>keywords</summary>

RetryHandler, nablarch.fw.handler.RetryHandler, Retryable, nablarch.fw.handler.retry.Retryable, RetryContext, nablarch.fw.handler.RetryHandler.RetryContext, CountingRetryContext, TimeRetryContext, リトライ制御, デッドロックリカバリ, デッドロック, 単純リトライ, リカバリ可能なエラー

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

nablarch-fw-standalone, スタンドアロンモジュール, モジュール依存

</details>

## 制約

リトライ対象例外を送出するハンドラは、本ハンドラより後ろに設定すること。本ハンドラより手前でリトライ対象の例外を送出しても、単に例外として処理される。

<details>
<summary>keywords</summary>

ハンドラ配置順序, リトライ対象例外, 設定順序制約, 後続ハンドラ

</details>

## リトライの上限を設定する

本ハンドラを使用する際には必ずリトライ上限の設定が必要。上限に達しても処理が成功しない場合は異常終了させる。

上限設定は以下の2種類から選択（プロジェクト要件に合わない場合はプロジェクト側で実装を追加）：
- `リトライ回数による上限設定`
- `経過時間による上限設定`

リトライ回数による上限設定の例：
```xml
<component name="retryHandler" class="nablarch.fw.handler.RetryHandler">
  <property name="retryContextFactory">
    <component class="nablarch.fw.handler.retry.CountingRetryContextFactory">
      <property name="retryCount" value="3" />          <!-- 最大3回リトライを行う -->
      <property name="retryIntervals" value="5000" />   <!-- リトライを実行するまで5秒待機する -->
    </component>
  </property>
</component>
```

> **補足**: 上限値は想定する最大の復旧時間プラスアルファに設定すること。例えば、DB切り替えに最大5分かかる場合は7分等を設定する。複数の例外に対するリトライを実現する場合は、最も復旧まで時間を要するものをベースに上限値を設定すること。

<details>
<summary>keywords</summary>

CountingRetryContext, nablarch.fw.handler.retry.CountingRetryContext, TimeRetryContext, nablarch.fw.handler.retry.TimeRetryContext, CountingRetryContextFactory, nablarch.fw.handler.retry.CountingRetryContextFactory, retryContextFactory, retryCount, retryIntervals, リトライ上限設定, リトライ回数, 経過時間, 復旧時間

</details>
