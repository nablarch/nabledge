# Nablarchアンチパターン

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/repository.html#repository) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/NoInputDataBatchAction.html) [3](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/architecture.html#jsr352-batch-type)

## Webアプリケーション

### コンポーネントライフサイクルの誤解によるマルチスレッドバグ

> **警告**: Nablarchのシステムリポジトリで管理されるコンポーネントのライフサイクルは`singleton`。デフォルトを`prototype`または`request`と誤解してコンポーネントの状態を書き換えると、同じコンポーネントを使用する他のスレッド・リクエストに影響を与えるマルチスレッドバグが発生する。

- 通常の業務アプリケーションコードでは、システムリポジトリからコンポーネントを取得するケースは多くない
- 初期化処理以外でコンポーネントの状態を書き換えてはならない
- コンポーネントの状態を書き換えるコードを見かけたら、このバグの可能性を疑うこと

<details>
<summary>keywords</summary>

コンポーネントライフサイクル, シングルトン, マルチスレッドバグ, システムリポジトリ, DIコンテナ, singleton, prototype, request

</details>

## Nablarchバッチ

### N+1問題

> **警告**: `createReader`のSQLで取得したN件に対し、`handle`メソッド内で再度SELECTを発行するとN+1問題が発生し、深刻な性能劣化を引き起こす。100件処理なら101回、10000件なら10001回のSQLが発行される。

**回避策**: `createReader`のSQLでJOINし、1回のSQLで必要なデータを全て取得する。`handle`メソッド内でSQLを発行する必要がなくなる。

**NG例（createReader）:**
```sql
SELECT 売上ID, 売上日 FROM 売上 WHERE 売上日 = ?
```

**NG例（handle内で追加SELECT）:**
```sql
SELECT 売上明細ID, 金額 FROM 売上明細 WHERE 売上ID = ?
```

**OK例（JOINで1回に集約）:**
```sql
SELECT 売上.売上ID, 売上.売上日, 売上明細.売上明細ID, 売上明細.金額
FROM 売上
INNER JOIN 売上明細 ON 売上.売上ID = 売上明細.売上ID
WHERE 売上.売上日 = ?
```

### フレームワーク制御下にないループ処理

> **警告**: `handle`メソッド内で自前のSELECT＋ループ処理を行うと、フレームワークによるコミットが実行されない。更新件数が増えるとトランザクションログを逼迫する。[`NoInputDataBatchAction`](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/NoInputDataBatchAction.html)を使って上記のようなループ処理をするのは典型的な誤り。

**NG例:**
```java
public Result handle(ExecutionContext context) {
   SqlResultSet sqlResultSet = search("SEARCH");
   for (SqlRow row : sqlResultSet) {
       // 更新処理
   }
}
```

> **警告**: トランザクションログ逼迫の回避策として、ループの一定回数毎に自前でコミットを実行するトランザクション制御を実装するケースも見られるが、これはフレームワークで行っている処理を独自に再実装することになるため、品質・生産性を低下させる要因となる。

**解決法**: `handle`内で発行しているSQLを`createReader`で行い、フレームワーク管理のループ処理を使用する。

<details>
<summary>keywords</summary>

N+1問題, createReader, handleメソッド, NoInputDataBatchAction, ループ処理, トランザクション制御, バッチ性能劣化, 自前コミット制御, 定期コミット, フレームワーク再実装

</details>

## Jakarta Batchに準拠したバッチ

### Batchletの誤用

> **警告**: Chunkで設計・実装すべきバッチをBatchletで実装すると、「フレームワーク制御下にないループ処理」と同様の問題（フレームワークによるコミットが行われずトランザクションログを逼迫）が発生する。

バッチの種類と用途（[参照](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/architecture.html#jsr352-batch-type)）:

| バッチの種類 | 用途 |
|---|---|
| Batchlet | 外部システムからのファイル取得や、SQL1つで処理が完結するような処理 |
| Chunk | ファイルやデータベースなどの入力データソースからレコードを読み込み業務処理を実行するような処理 |

<details>
<summary>keywords</summary>

Batchlet, Chunk, Jakarta Batch, バッチの種類, Batchlet誤用

</details>
