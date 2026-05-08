## リトライ制御ハンドラ

**クラス名:** `nablarch.fw.handler.RetryHandler`

-----

-----

### 概要

[リトライ制御ハンドラ](../../component/handlers/handlers-RetryHandler.md) はデータベースアクセス時のデッドロックのように、
単純リトライによってリカバリ可能なエラーについて、自動的なリトライ制御を行うハンドラである。

本ハンドラでは、 [Retryable](../../javadoc/nablarch/fw/handler/retry/Retryable.html) インターフェースを実装した実行時例外を
リトライ可能なエラーなとみなし、後続ハンドラの再実行を行う。
なお、リトライ上限の判定に関する処理は、 [RetryContext](../../javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) インターフェースの実装クラスとして外部化されている。
デフォルトでは以下の実装が提供されている。

* [CountingRetryContext](../../javadoc/nablarch/fw/handler/retry/CountingRetryContext.html)

  リトライ回数に対する上限を設定する。
* [TimeRetryContext](../../javadoc/nablarch/fw/handler/retry/TimeRetryContext.html)

  初回実行時からの経過時間に対する上限を設定する。

**ハンドラ処理概要** ([常駐バッチ実行制御基盤（スレッド同期型）](../../processing-pattern/nablarch-batch/nablarch-batch-batch-resident-thread-sync.md) での構成)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| リトライ制御ハンドラ | nablarch.fw.handler.RetryHandler | Object | Object | - | - | リトライ可能な実行時例外を捕捉し、かつリトライ上限に達していなければ後続のハンドラを再実行する。 |
| プロセス常駐化ハンドラ | nablarch.fw.handler.ProcessResidentHandler | Object | Object | データ監視間隔ごとに後続処理を繰り返し実行する。 | ループを継続する。 | ログ出力を行い、実行時例外が送出された場合はリトライ可能例外にラップして送出する。エラーが送出された場合はそのまま再送出する。 |
| データベース接続管理ハンドラ | nablarch.common.handler.DbConnectionManagementHandler | Object | Object | 業務処理用ＤＢ接続を取得し、スレッドローカル上に保持する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 | 業務処理用ＤＢ接続を開放（プールに返却）する。 |
| メッセージングコンテキスト管理ハンドラ | nablarch.fw.messaging.handler.MessagingContextHandler | Object | Object | メッセージングコンテキスト(MQ接続)を取得し、スレッドローカルに保持する。 | メッセージングコンテキストを開放する。（プールに戻す） | メッセージングコンテキストを開放する。（プールに戻す） |

-----

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) | [プロセス常駐化ハンドラ](../../component/handlers/handlers-ProcessResidentHandler.md) では後続ハンドラから例外が送出された場合、 その例外をリトライ可能例外にラップして再送出し、 [リトライ制御ハンドラ](../../component/handlers/handlers-RetryHandler.md) 側 でプロセス継続/中止の判断を行う。 |
| * [データベース接続管理ハンドラ](../../component/handlers/handlers-DbConnectionManagementHandler.md) * [メッセージングコンテキスト管理ハンドラ](../../component/handlers/handlers-MessagingContextHandler.md) | 本フレームワークでは、DBやメッセージングキューへの接続エラーが発生 した場合にリトライ可能例外を送出する。 そのため、これらのハンドラを [リトライ制御ハンドラ](../../component/handlers/handlers-RetryHandler.md) の 後続に配置しないと再接続が行われない。 |

### ハンドラ処理フロー

本ハンドラの処理の流れは以下のとおりである。

**[往路処理]**

**1. (ハンドラキューのスナップショットを保存)**

実行コンテキスト上のハンドラキューについて、シャローコピーを作成する。
また、以降の処理で使用する [RetryContext](../../javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) のインスタンスを生成する。

**2. (後続ハンドラの実行)**

ハンドラキュー上の後続のハンドラに処理を委譲し、その結果を取得する。

**[復路処理]**

**3. (正常終了)**

**2.** の結果をリターンして終了する。

**[例外処理]**

**2a. (リトライ処理)**

後続ハンドラの実行中に [Retryable](../../javadoc/nablarch/fw/handler/retry/Retryable.html) を実装する実行時例外を捕捉した場合、
[RetryContext](../../javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) によるリトライ上限判定を行い、上限に達していない場合は、
以下の処理を実行する。

1. ワーニングレベルのログを出力する。
2. (初回のみ) リトライ処理開始時刻を設定する。
3. リトライ回数を1増加させる。
4. リトライ間隔(msec)待機する。
5. ハンドラキューの内容を **1.** で作成したスナップショットの内容に戻す。
6. データリーダの破棄設定がオン(true)の場合、実行コンテキスト上に設定されたデータリーダを破棄する。

  データベースを入力とするデータリーダを使用している場合、リトライ時のデータベース再接続によりデータリーダが使用しているデータベース接続が使用不可となる。
  このため、リトライ時に使用不可となったデータリーダを破棄し、新しいデータベース接続を使用してデータリーダを再生成する。

  ※データリーダの再生成は、後続のハンドラにより行われる。
7. 後続ハンドラの処理を再実行する。(**2.** に戻る。)

**2b. (リトライ上限到達)**

後続ハンドラ実行中に [Retryable](../../javadoc/nablarch/fw/handler/retry/Retryable.html) を実装する実行時例外を捕捉し、
かつリトライ上限に達していた場合は、ワーニングログを出力し、 [ProcessAbnormalEnd](../../javadoc/nablarch/fw/launcher/ProcessAbnormalEnd.html) を送出する。
これにより、実行中のプロセスは強制停止される。

**2c. (リトライ対象外例外の捕捉)**

[Retryable](../../javadoc/nablarch/fw/handler/retry/Retryable.html) を実装していない実行時例外を捕捉した場合は、それを再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおりである。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リトライコンテキスト生成 | retryContextFactory | RetryContextFactor | 必須設定 |
| リトライ上限エラー時障害コード | retryLimitExceededFailureCode | TransactionFactory | 任意指定 |
| リトライ上限エラー時終了コード | retryLimitExceededExitCode | int | 任意指定(デフォルト="180") |
| リトライ時のデータリーダ破棄フラグ | destroyReader | boolean | 任意設定(デフォルト="false")  trueが設定された場合、 リトライ時に実行コンテキスト上に 設定されたデータリーダを破棄する。 |

リトライ上限の判定ロジックは、 [RetryContext](../../javadoc/nablarch/fw/handler/RetryHandler.RetryContext.html) インターフェースの実装系によって提供される。
フレームワークに同梱されている実装クラスの設定項目は以下のとおり。

CountingRetryContextFactory の設定項目

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リトライ間隔 (msec) | retryIntervals | long | 任意設定(デフォルト="0") |
| リトライ上限回数 | retryCount | int | 任意指定(デフォルト="0") |

TimeRetryContextFactory の設定項目

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| リトライ間隔 (msec) | retryIntervals | long | 任意設定(デフォルト="0") |
| リトライ上限時間 | retryTime | int | 任意指定(デフォルト="0") |

以下はリポジトリ設定ファイルの記述例である。

CountingRetryContextFactory を使用する例。

```xml
<!-- リトライハンドラ -->
<component name="retryHandler" class="nablarch.fw.handler.RetryHandler">
  <property name="retryContextFactory">
    <component class="nablarch.fw.handler.retry.CountingRetryContextFactory">
      <property name="retryCount" value="3" />
      <property name="retryIntervals" value="5000" />
    </component>
  </property>
</component>
```

TimeRetryContextFactory を使用する例。

```xml
<!-- リトライハンドラ -->
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
