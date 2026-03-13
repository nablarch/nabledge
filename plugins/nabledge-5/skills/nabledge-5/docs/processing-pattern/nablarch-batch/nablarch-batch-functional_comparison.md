# JSRに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/functional_comparison.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/batch/ee/listener/job/DuplicateJobRunningCheckListener.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/batch/api/chunk/ItemReader.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/reader/ResumeDataReader.html)

## JSR352に準拠したバッチとNablarchバッチの機能比較表

凡例: JSR = JSRの仕様で定義されている、○ = 提供あり、△ = 一部提供あり、× = 提供なし、－ = 対象外

| 機能 | JSR352に準拠 | Nablarchバッチ |
|---|---|---|
| 起動時に任意のパラメータを設定できる | JSR | ○ [解説書へ](../../component/handlers/handlers-main.md) |
| 同一バッチアプリケーションの同時実行を防止できる | ○ `DuplicateJobRunningCheckListener` | ○ [解説書へ](../../component/handlers/handlers-duplicate_process_check_handler.md) |
| 実行中のバッチアプリケーションを外部から安全に停止できる | JSR | ○ [解説書へ](../../component/handlers/handlers-process_stop_handler.md) |
| 1回の実行で処理する最大の件数を指定できる | × [1] | ○ [解説書へ](../../component/handlers/handlers-data_read_handler.md) |
| 一定件数単位のコミットができる | JSR | ○ [解説書へ](../../component/handlers/handlers-loop_handler.md) |
| 障害発生ポイントから再実行できる | JSR | △ [2] |
| 業務処理を複数スレッドで並列実行できる | JSR | ○ [解説書へ](../../component/handlers/handlers-multi_thread_execution_handler.md) |
| 特定の例外を無視して処理を継続できる（ロールバック後に処理を継続できる） | JSR | × [3] |
| 特定の例外発生時に処理をリトライできる | JSR | △ [4] |
| バッチアプリケーションの結果を元に次に実行する処理を切り替えられる | JSR | × [5] |
| 入力データソースを一定間隔で監視しバッチを実行できる | × [6] | ○ [解説書へ](nablarch-batch-architecture.md) |

[1] `ItemReader` の実装クラスに1回の実行で読み込む最大件数を指定できるプロパティを持たせることで対応可能。

[2] `ResumeDataReader` を使用することで障害発生ポイントからの再実行が可能。ただし、ファイルを入力としている場合にのみ使用できる。それ以外のデータを入力とする場合には、アプリケーション側で設計・実装が必要。

[3] 特定例外を無視して処理を継続したい場合は、ハンドラを追加して対応すること。

[4] [retry_handler](../../component/handlers/handlers-retry_handler.md) でリトライ可能例外の場合にリトライできるが、JSR352のように例外が発生したデータの単純なリトライはできない。また [retry_handler](../../component/handlers/handlers-retry_handler.md) ではリトライ対象の例外を柔軟に指定できない。要件を満たせない場合（例外が発生したデータの単純なリトライや柔軟な例外指定が必要な場合）は、ハンドラを追加して対応すること。

[5] ジョブスケジューラで対応すること（例：終了コードを元に次に実行するジョブを切り替える）。

[6] JSR352に準拠したバッチアプリケーションでは、一定間隔で入力データソースを監視するバッチ処理は実現できない。このようなバッチアプリケーションが必要な場合は [nablarch_batch-resident_batch](nablarch-batch-architecture.md) を使用すること。

JSR352の仕様詳細は [JSR352(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=352) のSpecificationを参照。

<details>
<summary>keywords</summary>

JSR352, Nablarchバッチ, 機能比較, DuplicateJobRunningCheckListener, ResumeDataReader, ItemReader, 同時実行防止, 常駐バッチ, マルチスレッド実行, リトライ処理, 障害発生ポイント再実行, 最大件数指定

</details>
