# アーキテクチャ概要

**目次**

* バッチアプリケーションの構成
* バッチの種類
* バッチアプリケーションの処理の流れ

  * Batchlet
  * Chunk
  * 例外(エラー含む)発生時の処理の流れ

    * 例外発生時のバッチの状態
    * ログ出力
* バッチアプリケーションで使用するリスナー
* 最小のリスナー構成
* リスナーの指定方法

## バッチアプリケーションの構成

<a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> に準拠したバッチアプリケーションを実行するためには、 <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> の実装が必要となる。
実装は、主に以下の2つから選択することになるが、ドキュメントが豊富であること及びMaven Centralからライブラリを取得出来る手軽さから [jBeret(外部サイト、英語)](https://jberet.gitbooks.io/jberet-user-guide/content/) の使用を推奨する。

* [jBeret(外部サイト、英語)](https://jberet.gitbooks.io/jberet-user-guide/content/)
* [参照実装のjBatch(外部サイト、英語)](https://github.com/WASdev/standards.jsr352.jbatch)

以下に構成を示す。

![jsr352-configuration-diagram.png](../../../knowledge/assets/jakarta-batch-architecture/jsr352-configuration-diagram.png)

> **Important:**
> JobContext及びStepContextの一時領域( `TransientUserData` )を使用することは
> グローバル領域に値を保持することと同義となるため、アプリケーション側で使用してはならない。

> なお、StepContextの一時領域については、 StepScoped でステップ内で値を共有をするために使用しているため、
> アプリケーション側ではStepContextの一時領域は使用できない。

> **Tip:**
> [JSR352に準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md#jsr352に準拠したバッチアプリケーション)のアーキテクチャは、 <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> で定められた構成に準拠しているため、
> Nablarchアプリケーションフレームワークの [アーキテクチャ](../../about/about-nablarch/about-nablarch-architecture.md#アーキテクチャ) に記載されているような、
> ハンドラを用いたアーキテクチャとは異なっている。

> [JSR352に準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md#jsr352に準拠したバッチアプリケーション) では、ハンドラで行われるような横断的な処理（ログ出力やトランザクション制御等）は、
> <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> で規定されているリスナーを用いることで実現されている。

> ただし、リスナーは既定のタイミングで起動されるものであり、入力、出力に対して直接処理を行うものではない点がハンドラとは異なっている。
> このためリスナーでは、ハンドラで実現されているような入力値のフィルタ処理や変換処理などを行うことはできない。

## バッチの種類

<a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> では、バッチの実装方法として Batchlet と Chunk の2種類の方法がある。
どちらのタイプを使用するのが適切かは、以下を参照しバッチごとに判断すること。

Batchlet

タスク指向の場合にBatchletタイプのバッチを実装する。

例えば、外部システムからのファイル取得や、SQL1つで処理が完結するような処理が該当する。

Chunk

ファイルやデータベースなどの入力データソースからレコードを読み込み業務処理を実行する場合にChunkタイプのバッチを実装する。

## バッチアプリケーションの処理の流れ

### Batchlet

Batchletタイプのバッチアプリケーションの処理の流れを以下に示す。

![batchlet-flow.png](../../../knowledge/assets/jakarta-batch-architecture/batchlet-flow.png)

1. JSR352のBatch RuntimeからBatchletステップ実行前のコールバック処理として NablarchStepListenerExecutor が呼び出される。
2. Batchletステップ実行前のリスナーを順次実行する。
3. JSR352のBatch Runtimeから Batchlet が実行される。
4. Batchlet では業務ロジックを実行する。(Batchletの責務配置は、 [Batchletの責務配置](../../processing-pattern/jakarta-batch/jakarta-batch-application-design.md#batchletステップの場合) を参照)
5. JSR352のBatch RuntimeからBatchletステップ実行後のコールバック処理として NablarchStepListenerExecutor が呼び出される。
6. Batchletステップ実行後のリスナーを順次実行する。(No2とは逆順に実行する)

### Chunk

Chunkタイプのバッチアプリケーションの処理の流れを以下に示す。

![chunk-flow.png](../../../knowledge/assets/jakarta-batch-architecture/chunk-flow.png)

1. JSR352のBatch RuntimeからChunkステップ実行前のコールバック処理として NablarchStepListenerExecutor が呼び出される。
2. Chunkステップ実行前のリスナーを順次実行する。
3. JSR352のBatch RuntimeからChunkステップの ItemReader が実行される。 
  
  ItemReader では、入力データソースからデータを読み込む。
4. JSR352のBatch RuntimeからChunkステップの ItemProcessor が実行される。 
5. ItemProcessor は、 Form や Entity を使って業務ロジックを実行する。 
  
  ※データーベースに対するデータの書き込みや更新はここでは実施しない。
6. JSR352のBatch Runtimeから ItemWriter 実行前のコールバック処理として NablarchItemWriteListenerExecutor が呼び出される。
7. ItemWriter 実行前のリスナーを順次実行する。
8. JSR352のBatch RuntimeからChunkステップの ItemWriter が実行される。 
  
  ItemWriter では、テーブルへの登録(更新、削除)やファイル出力処理などの結果反映処理を行う。
9. JSR352のBatch Runtimeから ItemWriter 実行後のコールバック処理として NablarchItemWriteListenerExecutor が呼び出される。
10. ItemWriter 実行後のリスナーを順次実行する。(No7とは逆順で実行する)
11. JSR352のBatch RuntimeからChunkステップ実行後のコールバック処理として NablarchStepListenerExecutor が呼び出される。
12. Chunkステップ実行後のリスナーを順次実行する。(No2とは逆順に実行する)

※No3からNo10は、入力データソースのデータが終わるまで繰り返し実行される。

Chunkステップの責務配置については、 [Chunkの責務配置](../../processing-pattern/jakarta-batch/jakarta-batch-application-design.md#chunkステップの場合) を参照

### 例外(エラー含む)発生時の処理の流れ

バッチ実行中に例外が発生した場合、Nablarchでは例外の捕捉は行わずJSR352の実装側で例外ハンドリングを行う方針としている。
これは、JSR352に準拠したバッチアプリケーション特有の振る舞いであり、他の基盤( [Webアプリケーション](../../processing-pattern/web-application/web-application-web.md#ウェブアプリケーション編) や [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md#nablarchバッチアプリケーション) など)とは異なる振る舞いである点に注意すること。

> **Tip:**
> JSR352に準拠したバッチアプリケーションがこのようなアーキテクチャを採用した理由は以下の通り。

> JSR352に準拠したバッチアプリケーションは、JSR352上でNablarchを使用するためのコンポーネントのみの提供であり、実行制御自体はJSR352実装によって行われる。
> このため、Nablarchにより全ての例外を捕捉し処理を行うことは不可能であり、例外制御がNablarchとJSR352で分散することで設計などが複雑化するのを防ぐためこのような方針としている。

#### 例外発生時のバッチの状態

上述したように、例外発生時の制御は全てJSR352の実装が行う。
このため、例外発生時のバッチの状態(batch statusやexit status)については、 <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> の仕様を参照すること。
また、例外の種類に応じたリトライや継続有無などもジョブ定義に従った動作となる。ジョブ定義の詳細は、 <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> の仕様を参照すること。

例外発生後のJavaプロセスから戻されるリターンコードについては、 [障害監視](../../processing-pattern/jakarta-batch/jakarta-batch-operation-policy.md#障害監視) を参照。

#### ログ出力

JSR352の実装で補足された例外の情報は、JSR352の実装によりログ出力される。
ログの設定(フォーマットや出力先などの設定)は、JSR352実装が使用しているロギングフレームワークのマニュアルなどを参照して行うこと。

なお、アプリケーションで明示的に出力するエラーログ等をJSR352と同じログファイルに出力したい場合には、
[logアダプタ](../../component/adapters/adapters-log-adaptor.md#logアダプタ) を使用してJSR352の実装とロギングフレームワークを統一することで対応できる。

## バッチアプリケーションで使用するリスナー

<a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> に準拠したバッチアプリケーションでは、 <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> の仕様で定められているリスナーを使用してNablarchのハンドラ相当のことを実現する。

標準では、以下のリスナーを提供してる。

ジョブレベルリスナー

ジョブの起動及び終了直前にコールバックされるリスナー

* ジョブの起動、終了ログを出力するリスナー
* 同一ジョブの多重起動防止リスナー

ステップレベルリスナー

ステップの実行前及び実行後にコールバックされるリスナー

* ステップの開始、終了ログを出力するリスナー
* データベースへ接続するリスナー
* トランザクションを制御するリスナー

ItemWriterレベルのリスナー

ItemWriter の実行前及び実行後にコールバックされるリスナー

* Chunkの進捗ログを出力するリスナー(非推奨)
  ([進捗ログで出力される内容](../../processing-pattern/jakarta-batch/jakarta-batch-progress-log.md#進捗ログで出力される内容) を使用して進捗ログを出力すること)
* トランザクションを制御するリスナー

> **Tip:**
> <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> で規定されているリスナーは、複数設定した場合の実行順を保証しないことが仕様上明記されている。
> このため、Nablarchでは以下の点に対応することで、リスナーを指定した順で実行出来るよう対応している。

> * >   各レベルのリスナーには、リスナーの実行順を保証するリスナーのみを設定する
> * >   リスナーの実行順を保証するリスナーは、 [システムリポジトリ](../../component/libraries/libraries-repository.md#システムリポジトリ) からリスナーリストを取得し、定義順にリスナーを実行する。

> 実際のリスナーの定義方法は、 [リスナーの指定方法](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md#リスナーの指定方法) を参照。

## 最小のリスナー構成

最小のリスナー構成を以下に示す。この構成でプロジェクト要件を満たすことができない場合は、リスナーの追加などにより対応すること。

ジョブレベルの最小リスナー構成

| No. | リスナー | ジョブ起動直前の処理 | ジョブ終了直前の処理 |
|---|---|---|---|
| 1 | ジョブの起動、終了ログを出力するリスナー | 起動するジョブ名をログに出力する。 | ジョブ名称とバッチステータスをログに出力する。 |

ステップレベルの最小リスナー構成

| No. | リスナー | ステップ実行前の処理 | ステップ実行後の処理 |
|---|---|---|---|
| 1 | ステップの開始、終了ログを出力するリスナー | 実行するステップ名称をログに出力する。 | ステップ名称とステップステータスをログに出力する。 |
| 2 | データベースへ接続するリスナー | DB接続を取得する。 | DB接続を解放する。 |
| 3 | トランザクションを制御するリスナー | トランザクションを開始する。 | トランザクションを終了(commit or rollback)する。 |

ItemWriter レベルの最小リスナー構成

| No. | リスナー | ItemWriter 実行前の処理 | ItemWriter 実行後の処理 |
|---|---|---|---|
| 1 | トランザクションを制御するリスナー [1] |  | トランザクションを終了(commit or rollback)する。 |

ItemWriter レベルのリスナーで行うトランザクション制御は、ステップレベルで開始されたトランザクションに対して行う。

## リスナーの指定方法

各レベルに対してリスナーリストを定義する方法について説明する。

リスナーリストを定義するには、以下の手順が必要になる。

1. <a href="https://jcp.org/en/jsr/detail?id=352" target="_blank">JSR352(外部サイト、英語)</a> で規定されているジョブ定義を表すxmlファイルに、リスナーの実行順を保証するリスナーを設定する。
2. コンポーネント設定ファイルにリスナーリストの設定をする。

ジョブ定義ファイルへの設定

```xml
<job id="chunk-integration-test" xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="1.0">
  <listeners>
    <!-- ジョブレベルのリスナー -->
    <listener ref="nablarchJobListenerExecutor" />
  </listeners>

  <step id="myStep">
    <listeners>
      <!-- ステップレベルのリスナー -->
      <listener ref="nablarchStepListenerExecutor" />
      <!-- ItemWriterレベルのリスナー -->
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

コンポーネント設定ファイルへの設定

```xml
<!-- デフォルトのジョブレベルのリスナーリスト -->
<list name="jobListeners">
  <component class="nablarch.fw.batch.ee.listener.job.JobProgressLogListener" />
  <component class="nablarch.fw.batch.ee.listener.job.DuplicateJobRunningCheckListener">
    <property name="duplicateProcessChecker" ref="duplicateProcessChecker" />
  </component>
</list>

<!-- デフォルトのステップレベルのリスナーリスト -->
<list name="stepListeners">
  <component class="nablarch.fw.batch.ee.listener.step.StepProgressLogListener" />
  <component class="nablarch.fw.batch.ee.listener.step.DbConnectionManagementListener">
    <property name="dbConnectionManagementHandler">
      <component class="nablarch.common.handler.DbConnectionManagementHandler" />
    </property>
  </component>
  <component class="nablarch.fw.batch.ee.listener.step.StepTransactionManagementListener" />
</list>

<!-- デフォルトのItemWriterレベルのリスナーリスト -->
<list name="itemWriteListeners">
  <component
      class="nablarch.fw.batch.ee.listener.chunk.ChunkProgressLogListener" />
  <component
      class="nablarch.fw.batch.ee.listener.chunk.ItemWriteTransactionManagementListener" />
</list>

<!-- デフォルトのジョブレベルのリスナーリストの上書き -->
<list name="sample-job.jobListeners">
  <component class="nablarch.fw.batch.ee.listener.job.JobProgressLogListener" />
</list>

<!-- デフォルトのステップレベルのリスナーリストの上書き -->
<!-- 本設定は「sample-step」ステップの実行時に適用される -->
<list name="sample-job.sample-step.stepListeners">
  <component class="nablarch.fw.batch.ee.listener.step.StepProgressLogListener" />
</list>
```

ポイント

* デフォルトのジョブレベルのリスナーリストのコンポーネント名は、 `jobListeners` とする。
* デフォルトのステップレベルのリスナーリストのコンポーネント名は、 `stepListeners` とする。
* デフォルトのItemWriterレベルのリスナーリストのコンポーネント名は、 `itemWriteListeners` とする。
* デフォルトのリスナーリスト定義を上書きする場合は、コンポーネント名を「ジョブ名称 + "." + 上書き対象のコンポーネント名」とする。 
  
  例えば、「sample-job」でジョブレベルの定義を上書きする場合は、コンポーネント名を `sample-job.jobListeners` としてリスナーリストを定義する。
* 特定のステップでデフォルトのリスナーリスト定義を上書きする場合は、コンポーネント名を「ジョブ名称 + "." + ステップ名称 + "." + 上書き対象のコンポーネント名」とする。 
  
  例えば、「sample-job」で定義されている「sample-step」で、デフォルトのステップレベルのリスナーリスト定義を上書きする場合は、コンポーネント名を `sample-job.sample-step.stepListeners` としてリスナーリストを定義する。
* 特定のステップで上書き出来るリスナーリストは、ステップレベルとItemWriterレベルのリスナーリストのみである。
