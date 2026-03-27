# リトライ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RetryHandler`

デッドロックのような単純リトライでリカバリ可能なエラーについて、自動リトライ制御を行うハンドラ。`Retryable` インターフェースを実装した実行時例外をリトライ可能なエラーとみなし、後続ハンドラの再実行を行う。リトライ上限判定は `RetryContext` インターフェースの実装クラスとして外部化されている。

デフォルト実装:
- `CountingRetryContext`: リトライ回数に対する上限を設定
- `TimeRetryContext`: 初回実行時からの経過時間に対する上限を設定

## 関連ハンドラ

| ハンドラ | 内容 |
|---|---|
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | 後続ハンドラから例外が送出された場合、リトライ可能例外にラップして再送出し、[RetryHandler](handlers-RetryHandler.md) 側でプロセス継続/中止の判断を行う |
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md), [MessagingContextHandler](handlers-MessagingContextHandler.md) | DBやメッセージングキューへの接続エラー発生時にリトライ可能例外を送出する。これらのハンドラを [RetryHandler](handlers-RetryHandler.md) の後続に配置しないと再接続が行われない |

<details>
<summary>keywords</summary>

RetryHandler, nablarch.fw.handler.RetryHandler, Retryable, RetryContext, CountingRetryContext, TimeRetryContext, ProcessResidentHandler, DbConnectionManagementHandler, MessagingContextHandler, リトライ制御, デッドロック, 自動リトライ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. ハンドラキューのスナップショット（シャローコピー）を保存し、`RetryContext` のインスタンスを生成する
2. 後続ハンドラに処理を委譲し、結果を取得する

**[復路処理]**

3. 正常終了: 結果をリターンして終了する

**[例外処理]**

**2a. リトライ処理**: `Retryable` を実装する実行時例外を捕捉し、リトライ上限未達の場合:
1. ワーニングレベルのログを出力する
2. （初回のみ）リトライ処理開始時刻を設定する
3. リトライ回数を1増加させる
4. リトライ間隔 (msec) 待機する
5. ハンドラキューの内容をスナップショットに戻す
6. `destroyReader` が `true` の場合、実行コンテキスト上のデータリーダを破棄する
7. 後続ハンドラの処理を再実行する（2. に戻る）

> **注意**: データベースを入力とするデータリーダを使用している場合、リトライ時のデータベース再接続によりデータリーダが使用しているデータベース接続が使用不可となる。このため、`destroyReader=true` を設定してリトライ時に使用不可となったデータリーダを破棄し、新しいデータベース接続でデータリーダを再生成させること（再生成は後続ハンドラが行う）。

**2b. リトライ上限到達**: `Retryable` を実装する実行時例外を捕捉し、リトライ上限に達していた場合、ワーニングログを出力し `ProcessAbnormalEnd` を送出してプロセスを強制停止する。

**2c. リトライ対象外例外の捕捉**: `Retryable` を実装していない実行時例外を捕捉した場合、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

RetryContext, Retryable, ProcessAbnormalEnd, destroyReader, リトライ処理フロー, ハンドラキュースナップショット, リトライ上限, データリーダ破棄

</details>

## 設定項目・拡張ポイント

## RetryHandler 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryContextFactory | RetryContextFactor | ○ | | リトライコンテキスト生成 |
| retryLimitExceededFailureCode | TransactionFactory | | | リトライ上限エラー時障害コード |
| retryLimitExceededExitCode | int | | 180 | リトライ上限エラー時終了コード |
| destroyReader | boolean | | false | trueの場合、リトライ時に実行コンテキスト上のデータリーダを破棄する |

## CountingRetryContextFactory 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔 (msec) |
| retryCount | int | | 0 | リトライ上限回数 |

CountingRetryContextFactory使用例:

```xml
<component name="retryHandler" class="nablarch.fw.handler.RetryHandler">
  <property name="retryContextFactory">
    <component class="nablarch.fw.handler.retry.CountingRetryContextFactory">
      <property name="retryCount" value="3" />
      <property name="retryIntervals" value="5000" />
    </component>
  </property>
</component>
```

## TimeRetryContextFactory 設定項目

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔 (msec) |
| retryTime | long | | 0 | リトライ上限時間 (msec) |
| maxRetryTime | long | | 900000 | 最長リトライ時間 (msec)。ハンドラ構成によっては、処理が正常終了し続ける間、リトライ制御を行う側まで制御が戻ってこないケースが存在する。このような場合に、リトライが成功したか否かをリトライ制御を行う側が判断するために設けられている。リトライ経過時間がこの値を超えている場合はリトライ成功と判断する |

TimeRetryContextFactory使用例:

```xml
<component name="retryHandler" class="nablarch.fw.handler.RetryHandler">
  <property name="retryContextFactory">
    <component class="nablarch.fw.handler.retry.TimeRetryContextFactory">
      <property name="maxRetryTime" value="35000" />
      <property name="retryTime" value="30000" />
      <property name="retryIntervals" value="5000" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

retryContextFactory, retryLimitExceededFailureCode, retryLimitExceededExitCode, destroyReader, CountingRetryContextFactory, nablarch.fw.handler.retry.CountingRetryContextFactory, TimeRetryContextFactory, nablarch.fw.handler.retry.TimeRetryContextFactory, retryIntervals, retryCount, retryTime, maxRetryTime, リトライ設定

</details>
