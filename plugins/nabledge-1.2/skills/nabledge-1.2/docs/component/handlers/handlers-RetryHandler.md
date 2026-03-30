# リトライ制御ハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RetryHandler`

データベースアクセス時のデッドロックなど、単純リトライでリカバリ可能なエラーに対して自動リトライ制御を行うハンドラ。

`Retryable` インターフェースを実装した実行時例外をリトライ可能なエラーとみなし、後続ハンドラを再実行する。リトライ上限判定は `RetryContext` インターフェースの実装クラスに委譲。

デフォルト実装:
- `CountingRetryContext`: リトライ回数に対する上限
- `TimeRetryContext`: 初回実行からの経過時間に対する上限

**関連ハンドラ**

| ハンドラ | 内容 |
|---|---|
| [ProcessResidentHandler](handlers-ProcessResidentHandler.md) | 後続ハンドラからの例外をリトライ可能例外にラップして再送出。RetryHandlerがプロセス継続/中止を判断する。 |
| [DbConnectionManagementHandler](handlers-DbConnectionManagementHandler.md), [MessagingContextHandler](handlers-MessagingContextHandler.md) | DB/メッセージングキューへの接続エラー時にリトライ可能例外を送出。これらのハンドラをRetryHandlerの**後続**に配置しないと再接続が行われない。 |

<details>
<summary>keywords</summary>

RetryHandler, nablarch.fw.handler.RetryHandler, Retryable, RetryContext, CountingRetryContext, TimeRetryContext, ProcessResidentHandler, DbConnectionManagementHandler, MessagingContextHandler, リトライ制御, 自動リトライ, デッドロック

</details>

## ハンドラ処理フロー

**[往路処理]**
1. ハンドラキューのシャローコピー（スナップショット）を保存し、`RetryContext` インスタンスを生成する。
2. 後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**
3. 結果をリターンして終了する。

**[例外処理]**
- **2a. リトライ処理**: `Retryable` を実装する実行時例外を捕捉し、かつリトライ上限未達の場合:
  1. ワーニングログを出力する。
  2. （初回のみ）リトライ処理開始時刻を設定する。
  3. リトライ回数を1増加させる。
  4. リトライ間隔（msec）待機する。
  5. ハンドラキューをスナップショットの内容に戻す。
  6. 後続ハンドラを再実行する（2. に戻る）。
- **2b. リトライ上限到達**: `Retryable` を実装する実行時例外を捕捉し、かつリトライ上限に達した場合、ワーニングログを出力し `ProcessAbnormalEnd` を送出する。実行中のプロセスは強制停止される。
- **2c. リトライ対象外例外**: `Retryable` を実装していない実行時例外を捕捉した場合、再送出して終了する。

<details>
<summary>keywords</summary>

Retryable, RetryContext, ProcessAbnormalEnd, リトライ処理フロー, リトライ上限, プロセス強制停止, ハンドラキュースナップショット, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

**RetryHandler 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryContextFactory | RetryContextFactor | ○ | | リトライコンテキスト生成 |
| retryLimitExceededFailureCode | TransactionFactory | | | リトライ上限エラー時障害コード |
| retryLimitExceededExitCode | int | | 180 | リトライ上限エラー時終了コード |

**CountingRetryContextFactory 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔（msec） |
| retryCount | int | | 0 | リトライ上限回数 |

**TimeRetryContextFactory 設定項目**

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| retryIntervals | long | | 0 | リトライ間隔（msec） |
| retryTime | int | | 0 | リトライ上限時間 |

`CountingRetryContextFactory` を使用する例:

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

`TimeRetryContextFactory` を使用する例:

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

CountingRetryContextFactory, TimeRetryContextFactory, RetryContextFactory, retryContextFactory, retryIntervals, retryCount, retryTime, maxRetryTime, retryLimitExceededExitCode, retryLimitExceededFailureCode, リトライ回数上限, リトライ時間上限, リトライ間隔設定

</details>
