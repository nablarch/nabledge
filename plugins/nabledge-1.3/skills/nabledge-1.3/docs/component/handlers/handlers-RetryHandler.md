# リトライ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RetryHandler`

[RetryHandler](handlers-RetryHandler.md) はデータベースアクセス時のデッドロックのように、単純リトライによってリカバリ可能なエラーに対して自動リトライ制御を行うハンドラ。

`Retryable` インターフェースを実装した実行時例外をリトライ可能エラーとみなし、後続ハンドラを再実行する。リトライ上限の判定処理は `RetryContext` インターフェースの実装クラスとして外部化されている。

デフォルト実装:
- `CountingRetryContext`: リトライ回数に対する上限を設定する
- `TimeRetryContext`: 初回実行時からの経過時間に対する上限を設定する

**関連ハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | 後続ハンドラから例外が送出された場合、その例外をリトライ可能例外にラップして再送出し、[RetryHandler](handlers-RetryHandler.md) 側でプロセス継続/中止の判断を行う |
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md), [MessagingContextHandler](handlers-MessagingContextHandler.md) | DB/メッセージングキューへの接続エラー発生時にリトライ可能例外を送出する。これらのハンドラを [RetryHandler](handlers-RetryHandler.md) の後続に配置しないと再接続が行われない |

<details>
<summary>keywords</summary>

RetryHandler, nablarch.fw.handler.RetryHandler, Retryable, RetryContext, CountingRetryContext, TimeRetryContext, ProcessResidentHandler, DbConnectionManagementHandler, MessagingContextHandler, リトライ制御, デッドロック, 自動リトライ, プロセス継続

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 実行コンテキスト上のハンドラキューについてシャローコピー（スナップショット）を作成し、`RetryContext` インスタンスを生成する
2. 後続ハンドラに処理を委譲し、その結果を取得する

**[復路処理]**

3. 2. の結果をリターンして終了する

**[例外処理]**

**2a. リトライ処理**: `Retryable` を実装する実行時例外を捕捉し、`RetryContext` によるリトライ上限判定で上限未達の場合、以下を実行する:
1. ワーニングレベルのログを出力する
2. (初回のみ) リトライ処理開始時刻を設定する
3. リトライ回数を1増加させる
4. リトライ間隔(msec)待機する
5. ハンドラキューの内容を1. で作成したスナップショットの内容に戻す
6. `destroyReader=true` の場合、実行コンテキスト上のデータリーダを破棄する（DBを入力とするデータリーダはリトライ時のDB再接続により使用不可となるため、破棄して後続ハンドラで再生成させる）
7. 後続ハンドラを再実行する（2. に戻る）

**2b. リトライ上限到達**: `Retryable` を実装する実行時例外を捕捉し、かつリトライ上限に達していた場合、ワーニングログを出力し `ProcessAbnormalEnd` を送出する。実行中のプロセスは強制停止される。

**2c. リトライ対象外例外**: `Retryable` を実装していない実行時例外を捕捉した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

RetryHandler, Retryable, RetryContext, ProcessAbnormalEnd, リトライ処理フロー, ハンドラキュースナップショット, データリーダ破棄, リトライ上限, destroyReader

</details>

## 設定項目・拡張ポイント

**RetryHandler 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryContextFactory | RetryContextFactor | ○ | | リトライコンテキスト生成 |
| retryLimitExceededFailureCode | TransactionFactory | | | リトライ上限エラー時障害コード |
| retryLimitExceededExitCode | int | | 180 | リトライ上限エラー時終了コード |
| destroyReader | boolean | | false | trueの場合、リトライ時に実行コンテキスト上のデータリーダを破棄する |

**CountingRetryContextFactory 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔 (msec) |
| retryCount | int | | 0 | リトライ上限回数 |

**TimeRetryContextFactory 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔 (msec) |
| retryTime | int | | 0 | リトライ上限時間 |

CountingRetryContextFactory を使用する例:

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

TimeRetryContextFactory を使用する例:

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

retryContextFactory, retryLimitExceededFailureCode, retryLimitExceededExitCode, destroyReader, CountingRetryContextFactory, nablarch.fw.handler.retry.CountingRetryContextFactory, TimeRetryContextFactory, nablarch.fw.handler.retry.TimeRetryContextFactory, retryIntervals, retryCount, retryTime, maxRetryTime, リトライ設定, リトライ上限回数, リトライ上限時間

</details>
