# アーキテクチャ概要

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/cdi/StepScoped.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/step/NablarchStepListenerExecutor.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/chunk/NablarchItemWriteListenerExecutor.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/job/JobProgressLogListener.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/job/DuplicateJobRunningCheckListener.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/step/StepProgressLogListener.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/step/DbConnectionManagementListener.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/step/StepTransactionManagementListener.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/chunk/ChunkProgressLogListener.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/chunk/ItemWriteTransactionManagementListener.html)

## バッチアプリケーションの構成

Jakarta Batch(JSR352)準拠のバッチアプリケーション実装として、[jBeret](https://jberet.gitbooks.io/jberet-user-guide/content/)の使用を推奨する（ドキュメントが豊富、Maven Centralから取得可能）。[jBatch](https://github.com/WASdev/standards.jsr352.jbatch)も選択可能。

> **重要**: JobContextおよびStepContextの一時領域（`TransientUserData`）はグローバル領域への値保持と同義であるため、アプリケーション側で使用してはならない。StepContextの一時領域は`StepScoped`がステップ内の値共有に使用しているため、アプリケーション側では使用不可。

> **補足**: :ref:`jsr352_batch`のアーキテクチャは:ref:`nablarch_architecture`とは異なり、横断的処理（ログ出力・トランザクション制御等）はハンドラではなくJakarta Batchのリスナーで実現する。リスナーは既定のタイミングで起動されるため、ハンドラのような入力値フィルタ処理や変換処理は行えない。

<details>
<summary>keywords</summary>

jBeret, jBatch, Jakarta Batch, JSR352, TransientUserData, StepScoped, nablarch.fw.batch.ee.cdi.StepScoped, バッチ実装選択, リスナーアーキテクチャ, JobContext, StepContext

</details>

## バッチの種類

| バッチ種別 | 使用場面 | 例 |
|---|---|---|
| Batchlet | タスク指向の処理 | 外部システムからのファイル取得、SQL1つで処理が完結する処理 |
| Chunk | 入力データソース（ファイル・DB等）からレコードを読み込み業務処理を実行する処理 | — |

<details>
<summary>keywords</summary>

Batchlet, Chunk, バッチ種別選択, タスク指向, ItemReader, ItemProcessor, ItemWriter, ファイル取得, レコード処理

</details>

## Batchlet処理の流れ

Batchletタイプのバッチアプリケーションの処理の流れ：

1. `NablarchStepListenerExecutor`がBatchletステップ実行前コールバックとして呼び出される
2. Batchletステップ実行前のリスナーを順次実行
3. Batchletが実行される
4. Batchletで業務ロジックを実行（責務配置は:ref:`jsr352-batchlet_design`参照）
5. `NablarchStepListenerExecutor`がBatchletステップ実行後コールバックとして呼び出される
6. Batchletステップ実行後のリスナーをNo.2の逆順で実行

<details>
<summary>keywords</summary>

NablarchStepListenerExecutor, nablarch.fw.batch.ee.listener.step.NablarchStepListenerExecutor, Batchlet処理フロー, Batchlet

</details>

## Chunk処理の流れ

Chunkタイプのバッチアプリケーションの処理の流れ：

1. `NablarchStepListenerExecutor`がChunkステップ実行前コールバックとして呼び出される
2. Chunkステップ実行前のリスナーを順次実行
3. `ItemReader`が実行され、入力データソースからデータを読み込む
4. `ItemProcessor`が実行される
5. `ItemProcessor`は`Form`や`Entity`を使って業務ロジックを実行する（DBへのデータ書き込み・更新はここでは実施しない）
6. `NablarchItemWriteListenerExecutor`が`ItemWriter`実行前コールバックとして呼び出される
7. `ItemWriter`実行前のリスナーを順次実行
8. `ItemWriter`が実行され、テーブルへの登録（更新・削除）やファイル出力などの結果反映処理を行う
9. `NablarchItemWriteListenerExecutor`が`ItemWriter`実行後コールバックとして呼び出される
10. `ItemWriter`実行後のリスナーをNo.7の逆順で実行
11. `NablarchStepListenerExecutor`がChunkステップ実行後コールバックとして呼び出される
12. Chunkステップ実行後のリスナーをNo.2の逆順で実行

※No.3〜10は入力データソースのデータが終わるまで繰り返し実行される。Chunkの責務配置は:ref:`jsr352-chunk_design`参照。

<details>
<summary>keywords</summary>

NablarchStepListenerExecutor, NablarchItemWriteListenerExecutor, nablarch.fw.batch.ee.listener.step.NablarchStepListenerExecutor, nablarch.fw.batch.ee.listener.chunk.NablarchItemWriteListenerExecutor, Chunk処理フロー, ItemReader, ItemProcessor, ItemWriter, Form, Entity

</details>

## 例外発生時の処理の流れ

> **重要**: バッチ実行中の例外はNablarchでは捕捉せず、Jakarta Batchの実装側で例外ハンドリングを行う。:ref:`web_application`や:ref:`nablarch_batch`等の他基盤とは異なる振る舞い。Jakarta BatchはNablarchがコンポーネントを提供するのみで実行制御はJakarta Batch実装が担うため、例外制御をNablarchとJakarta Batchで分散させると設計が複雑化するためこの方針を採用。

例外発生時のバッチステータス（batch status・exit status）やリトライ・継続有無の動作はJSR352仕様およびジョブ定義に従う。Javaプロセスからのリターンコードは:ref:`jsr352-failure_monitoring`参照。

Jakarta Batch実装で補足された例外のログはJakarta Batch実装により出力される。ログの設定（フォーマットや出力先などの設定）は、Jakarta Batch実装が使用しているロギングフレームワークのマニュアルなどを参照して行うこと。アプリケーションのエラーログをJakarta Batchと同一ログファイルに出力したい場合は:ref:`log_adaptor`でロギングフレームワークを統一する。

<details>
<summary>keywords</summary>

例外ハンドリング, batch status, exit status, Jakarta Batch例外処理, log_adaptor, jsr352-failure_monitoring, ログ設定, ロギングフレームワーク

</details>

## バッチアプリケーションで使用するリスナー

**ジョブレベルリスナー**（ジョブ起動・終了直前にコールバック）:

- `JobProgressLogListener`: ジョブの起動・終了ログを出力
- `DuplicateJobRunningCheckListener`: 同一ジョブの多重起動防止

**ステップレベルリスナー**（ステップ実行前後にコールバック）:

- `StepProgressLogListener`: ステップの開始・終了ログを出力
- `DbConnectionManagementListener`: データベースへ接続
- `StepTransactionManagementListener`: トランザクションを制御

**ItemWriterレベルリスナー**（`ItemWriter`実行前後にコールバック）:

- `ChunkProgressLogListener`: Chunkの進捗ログを出力（**非推奨**。代わりに:ref:`jsr352-progress_log`を使用すること）
- `ItemWriteTransactionManagementListener`: トランザクションを制御

> **補足**: JSR352では複数リスナーを設定した場合の実行順は保証されない。Nablarchでは各レベルに実行順を保証するexecutorリスナーのみを設定し、このexecutorが:ref:`repository`からリスナーリストを取得して定義順に実行することで順序を保証する。定義方法は:ref:`jsr352-listener_definition`参照。

<details>
<summary>keywords</summary>

JobProgressLogListener, DuplicateJobRunningCheckListener, StepProgressLogListener, DbConnectionManagementListener, StepTransactionManagementListener, ChunkProgressLogListener, ItemWriteTransactionManagementListener, ジョブレベルリスナー, ステップレベルリスナー, ItemWriterレベルリスナー, リスナー実行順保証, 多重起動防止

</details>

## 最小のリスナー構成

プロジェクト要件を満たせない場合はリスナーを追加して対応すること。

**ジョブレベルの最小リスナー構成**

| No. | リスナー | ジョブ起動直前の処理 | ジョブ終了直前の処理 |
|---|---|---|---|
| 1 | `JobProgressLogListener` | 起動するジョブ名をログ出力 | ジョブ名称とバッチステータスをログ出力 |

**ステップレベルの最小リスナー構成**

| No. | リスナー | ステップ実行前の処理 | ステップ実行後の処理 |
|---|---|---|---|
| 1 | `StepProgressLogListener` | 実行するステップ名称をログ出力 | ステップ名称とステップステータスをログ出力 |
| 2 | `DbConnectionManagementListener` | DB接続を取得 | DB接続を解放 |
| 3 | `StepTransactionManagementListener` | トランザクションを開始 | トランザクションを終了（commit or rollback） |

**`ItemWriter`レベルの最小リスナー構成**

| No. | リスナー | `ItemWriter`実行前の処理 | `ItemWriter`実行後の処理 |
|---|---|---|---|
| 1 | `ItemWriteTransactionManagementListener` | — | トランザクションを終了（commit or rollback） |

※`ItemWriter`レベルのリスナーで行うトランザクション制御は、ステップレベルで開始されたトランザクションに対して行う。

<details>
<summary>keywords</summary>

最小リスナー構成, JobProgressLogListener, StepProgressLogListener, DbConnectionManagementListener, StepTransactionManagementListener, ItemWriteTransactionManagementListener, DB接続管理, トランザクション制御

</details>

## リスナーの指定方法

リスナーリスト定義の手順：

1. ジョブ定義XMLにリスナーの実行順を保証するリスナーを設定する
2. コンポーネント設定ファイルにリスナーリストを設定する

**ジョブ定義ファイルへの設定**

```xml
<job id="chunk-integration-test" xmlns="https://jakarta.ee/xml/ns/jakartaee" version="2.0">
  <listeners>
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>
  <step id="myStep">
    <listeners>
      <listener ref="nablarchStepListenerExecutor" />
      <listener ref="nablarchItemWriteListenerExecutor" />
    </listeners>
    <chunk item-count="10">
      <reader ref="stringReader">
        <properties>
          <property name="max" value="25" />
        </properties>
      </reader>
      <processor ref="createEntityProcessor" />
      <writer ref="batchOutputWriter" />
    </chunk>
  </step>
</job>
```

**コンポーネント設定ファイルへの設定**

```xml
<!-- ジョブレベルのリスナーリスト（コンポーネント名: jobListeners） -->
<list name="jobListeners">
  <component class="nablarch.fw.batch.ee.listener.job.JobProgressLogListener" />
  <component class="nablarch.fw.batch.ee.listener.job.DuplicateJobRunningCheckListener">
    <property name="duplicateProcessChecker" ref="duplicateProcessChecker" />
  </component>
</list>

<!-- ステップレベルのリスナーリスト（コンポーネント名: stepListeners） -->
<list name="stepListeners">
  <component class="nablarch.fw.batch.ee.listener.step.StepProgressLogListener" />
  <component class="nablarch.fw.batch.ee.listener.step.DbConnectionManagementListener">
    <property name="dbConnectionManagementHandler">
      <component class="nablarch.common.handler.DbConnectionManagementHandler" />
    </property>
  </component>
  <component class="nablarch.fw.batch.ee.listener.step.StepTransactionManagementListener" />
</list>

<!-- ItemWriterレベルのリスナーリスト（コンポーネント名: itemWriteListeners） -->
<list name="itemWriteListeners">
  <component class="nablarch.fw.batch.ee.listener.chunk.ChunkProgressLogListener" />
  <component class="nablarch.fw.batch.ee.listener.chunk.ItemWriteTransactionManagementListener" />
</list>

<!-- ジョブ固有のジョブレベルリスナーリスト上書き例 -->
<list name="sample-job.jobListeners">
  <component class="nablarch.fw.batch.ee.listener.job.JobProgressLogListener" />
</list>

<!-- ジョブ・ステップ固有のステップレベルリスナーリスト上書き例 -->
<list name="sample-job.sample-step.stepListeners">
  <component class="nablarch.fw.batch.ee.listener.step.StepProgressLogListener" />
</list>
```

**ポイント**

- デフォルトのジョブレベルリスナーリストのコンポーネント名: `jobListeners`
- デフォルトのステップレベルリスナーリストのコンポーネント名: `stepListeners`
- デフォルトのItemWriterレベルリスナーリストのコンポーネント名: `itemWriteListeners`
- デフォルトリスナーリストを上書きする場合: コンポーネント名を「ジョブ名称 + "." + 上書き対象のコンポーネント名」とする（例: `sample-job.jobListeners`）
- 特定のステップで上書きする場合: コンポーネント名を「ジョブ名称 + "." + ステップ名称 + "." + 上書き対象のコンポーネント名」とする（例: `sample-job.sample-step.stepListeners`）
- 特定のステップで上書き可能なリスナーリストはステップレベルとItemWriterレベルのみ

<details>
<summary>keywords</summary>

jobListeners, stepListeners, itemWriteListeners, リスナー定義, ジョブ定義XML, コンポーネント設定, リスナーリスト上書き, nablarchJobListenerExecutor, nablarchStepListenerExecutor, nablarchItemWriteListenerExecutor, DbConnectionManagementHandler, nablarch.common.handler.DbConnectionManagementHandler

</details>
