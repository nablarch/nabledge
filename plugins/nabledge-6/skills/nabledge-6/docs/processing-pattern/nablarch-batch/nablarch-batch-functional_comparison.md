# Jakarta Batchに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/functional_comparison.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/job/DuplicateJobRunningCheckListener.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/jakarta/batch/api/chunk/ItemReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html)

## Jakarta Batchに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較

凡例: ◎ = Jakarta Batch仕様で定義, ○ = 提供あり, △ = 一部提供あり, × = 提供なし, — = 対象外

| 機能 | Jakarta Batchに準拠 | Nablarchバッチ |
|---|---|---|
| 起動時に任意のパラメータを設定できる | ◎ [1] | ○ :ref:`解説書へ <main-option_parameter>` |
| 同一バッチアプリケーションの同時実行を防止できる | ○ `DuplicateJobRunningCheckListener` | ○ :ref:`解説書へ <duplicate_process_check_handler>` |
| 実行中のバッチアプリケーションを外部から安全に停止できる | ◎ [1] | ○ :ref:`解説書へ <process_stop_handler>` |
| 1回の実行で処理する最大の件数を指定できる | × [2] | ○ :ref:`解説書へ <data_read_handler-max_count>` |
| 一定件数単位のコミットができる | ◎ [1] | ○ :ref:`解説書へ <loop_handler-commit_interval>` |
| 障害発生ポイントから再実行できる | ◎ [1] | △ [3] |
| 業務処理を複数スレッドで並列実行できる | ◎ [1] | ○ :ref:`解説書へ <multi_thread_execution_handler>` |
| 特定の例外を無視して処理を継続できる（ロールバック後に処理を継続できる） | ◎ [1] | × [4] |
| 特定の例外発生時に処理をリトライできる | ◎ [1] | △ [5] |
| バッチアプリケーションの結果を元に次に実行する処理を切り替えられる | ◎ [1] | × [6] |
| 入力データソースを一定間隔で監視しバッチを実行出来る | × [7] | ○ :ref:`解説書へ <nablarch_batch-resident_batch>` |

[1] ◎の箇所は、Jakarta Batchで規定されている仕様に従う。詳細は [Jakarta Batch仕様](https://jakarta.ee/specifications/batch/) を参照。

[2] `ItemReader` の実装クラスに、1回の実行で読み込む最大件数を指定できるプロパティを持たせるなどで対応可能。

[3] `ResumeDataReader` を使用することで障害発生ポイントからの再実行が可能。ただし、この機能はファイルを入力としている場合にのみ使用できる。それ以外のデータを入力とする場合には、アプリケーション側で設計及び実装が必要。

[4] 特定例外を無視して処理を継続したい場合は、ハンドラを追加して対応すること。

[5] :ref:`retry_handler` でリトライ可能例外の場合にリトライできるが、Jakarta Batchのように例外が発生したデータの単純なリトライはできない。:ref:`retry_handler` では、リトライ対象の例外を柔軟に指定できない。:ref:`retry_handler` で要件を満たすことができない（例外が発生したデータの単純なリトライや柔軟に例外を指定したい）場合は、ハンドラを追加して対応すること。

[6] ジョブスケジューラなどで対応すること。例えば、終了コードを元に次に実行するジョブを切り替える等の対応が必要。

[7] Jakarta Batchに準拠したバッチアプリケーションでは、一定間隔で入力データソースを監視するようなバッチ処理は実現できない。このようなバッチアプリケーションが必要となった場合は、:ref:`Nablarchバッチアプリケーションの常駐バッチ <nablarch_batch-resident_batch>` を使用して実現すること。

<details>
<summary>keywords</summary>

DuplicateJobRunningCheckListener, ItemReader, ResumeDataReader, Jakarta Batchとの機能比較, バッチアプリケーション比較, リトライ処理, 障害復旧・再実行, 並列実行, 常駐バッチ, コミット制御, 例外ハンドリング, 同時実行防止, プロセス停止

</details>
