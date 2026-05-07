# JSRに準拠したバッチアプリケーションとNablarchバッチアプリケーションとの機能比較

この章では、以下の機能の比較を示す。

* [JSR352に準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md)
* [Nablarchバッチアプリケーション](../../processing-pattern/nablarch-batch/nablarch-batch-nablarch-batch.md)

機能比較（JSR：JSRの仕様で定義されている　○：提供あり　△：一部提供あり　×：提供なし　－：対象外）

| 機能 | JSR352に準拠 [1] | Nablarchバッチ |
|---|---|---|
| 起動時に任意のパラメータを設定できる | JSR | ○   [解説書へ](../../component/handlers/handlers-main.md#アプリケーション起動に任意のオプションを設定する) |
| 同一バッチアプリケーションの同時実行を防止できる | ○   Javadocへ | ○   [解説書へ](../../component/handlers/handlers-duplicate-process-check-handler.md#プロセス多重起動防止ハンドラ) |
| 実行中のバッチアプリケーションを   外部から安全に停止できる | JSR | ○   [解説書へ](../../component/handlers/handlers-process-stop-handler.md#プロセス停止制御ハンドラ) |
| 1回の実行で処理する最大の件数を指定できる | ×   [2] | ○   [解説書へ](../../component/handlers/handlers-data-read-handler.md#最大処理件数の設定) |
| 一定件数単位のコミットができる | JSR | ○   [解説書へ](../../component/handlers/handlers-loop-handler.md#コミット間隔を指定する) |
| 障害発生ポイントから再実行できる | JSR | △   [3] |
| 業務処理を複数スレッドで並列実行できる | JSR | ○   [解説書へ](../../component/handlers/handlers-multi-thread-execution-handler.md#マルチスレッド実行制御ハンドラ) |
| 特定の例外を無視して処理を継続できる   (ロールバック後に処理を継続できる) | JSR | ×   [4] |
| 特定の例外発生時に処理をリトライできる | JSR | △   [5] |
| バッチアプリケーションの結果を元に   次に実行する処理を切り替えられる | JSR | ×   [6] |
| 入力データソースを一定間隔で監視し   バッチを実行出来る | × [7] | ○   [解説書へ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) |

JSRの箇所は、JSR352で規定されている仕様に従う。
詳細は、 [JSR352(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=352) のSpecificationを参照すること。

ItemReader の実装クラスに、1回の実行で読み込む最大件数を指定できるプロパティを持たせるなどで対応可能。

ResumeDataReader (レジューム機能付き読み込み) を使用することで障害発生ポイントからの再実行が可能。
ただし、この機能はファイルを入力としている場合にのみ使用できる。それ以外のデータを入力とする場合には、アプリケーション側で設計及び実装が必要となる。

特定例外を無視して処理を継続したい場合は、ハンドラを追加して対応すること。

[リトライハンドラ](../../component/handlers/handlers-retry-handler.md#リトライハンドラ) でリトライ可能例外の場合にリトライできるが、JSR352のように例外が発生したデータの単純なリトライはできない。
[リトライハンドラ](../../component/handlers/handlers-retry-handler.md#リトライハンドラ) では、リトライ対象の例外を柔軟に指定できない。

[リトライハンドラ](../../component/handlers/handlers-retry-handler.md#リトライハンドラ) で要件を満たすことができない(例外が発生したデータの単純なリトライや柔軟に例外を指定したい)場合は、ハンドラを追加して対応すること。

ジョブスケジューラなどで対応すること。例えば、終了コードを元に次に実行するジョブを切り替える等の対応が必要になる。

JSR352に準拠したバッチアプリケーションでは、一定間隔で入力データソースを監視するようなバッチ処理は実現できない。
このため、このようなバッチアプリケーションが必要となった場合は、 [Nablarchバッチアプリケーションの常駐バッチ](../../processing-pattern/nablarch-batch/nablarch-batch-architecture.md#アーキテクチャ概要) を使用して実現すること。
