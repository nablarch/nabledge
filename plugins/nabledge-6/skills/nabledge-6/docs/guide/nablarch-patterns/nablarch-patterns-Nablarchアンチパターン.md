# Nablarchアンチパターン

## Webアプリケーション

### コンポーネントライフサイクルの誤解によるマルチスレッドバグ

> **重要**: Nablarchのシステムリポジトリで管理されるコンポーネントのライフサイクルは`singleton`。`prototype`や`request`と誤解してコンポーネントの状態を書き換えると、同じコンポーネントを使用する他のスレッド・リクエストに影響を与えるマルチスレッドバグが発生する。

- 通常の業務アプリケーションコードでシステムリポジトリからコンポーネントを取得する必要はほとんどない（システム基盤部品の作成は別）。
- `singleton`のため、初期化処理以外でコンポーネントの状態を書き換えてはいけない。
- コンポーネントの状態を書き換えるコードがあれば、このライフサイクル誤解によるバグを疑うこと。

## Nablarchバッチ

> **注意**: 誤った構造のバッチは業務要件を満たせることもあるが、件数が増えた時に性能劣化や異常終了を起こす恐れがある。少ない件数でテストする単体テスト工程では気づくことができず、大量のデータでテストできるプロジェクト終盤まで発覚しない恐れがある。

### N+1問題

**問題**: `handle`メソッド内で入力データをもとに再度SELECTを発行することで発生。処理対象件数Nに対しN+1件のSQLが実行される（例: 100件 → 101件、10000件 → 10001件）。

**回避策**: `createReader`のSQLにJOINを使い、1回のSQLで必要なデータをすべて取得する。

NG例（`createReader`でSELECT後、`handle`内で再度SELECT）:

```sql
-- createReader
SELECT 売上ID, 売上日 FROM 売上 WHERE 売上日 = ?
-- handle内
SELECT 売上明細ID, 金額 FROM 売上明細 WHERE 売上ID = ?
```

OK例（JOINで1回のSQLにまとめる）:

```sql
SELECT 売上.売上ID, 売上.売上日, 売上明細.売上明細ID, 売上明細.金額
FROM 売上
INNER JOIN 売上明細 ON 売上.売上ID = 売上明細.売上ID
WHERE 売上.売上日 = ?
```

### フレームワーク制御下にないループ処理

**問題**: `handle`メソッド内で自前のループ処理を行うと、フレームワークによる一定間隔のコミットが行われず、更新件数が増えるとトランザクションログを逼迫する。

> **重要**: [`NoInputDataBatchAction`](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/action/NoInputDataBatchAction.html)を使って`handle`内でループ処理するのは典型的な誤り。

NG例:

```java
public Result handle(ExecutionContext context) {
   SqlResultSet sqlResultSet = search("SEARCH");
   for (SqlRow row : sqlResultSet) {
       // 更新処理
   }
}
```

ループ内に自前でコミットを実装するのも、フレームワークの処理の再実装となり品質・生産性を低下させる。

### 解決法

`handle`内で発行しているSQLを`createReader`で行うようにし、フレームワーク管理のループ処理で実現する。

## Jakarta Batchに準拠したバッチ

### Batchletの誤用

Chunkで設計・実装すべきバッチをBatchletで実装すると、「フレームワーク制御下にないループ処理」と同様の問題（コミット未実行によるトランザクションログ逼迫）が発生する。

[バッチの種類](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/batch/jsr352/architecture.html#jsr352-batch-type)に従い適切に使い分けること:

| バッチの種類 | 用途 |
|---|---|
| Batchlet | 外部システムからのファイル取得や、SQL1つで処理が完結するような処理 |
| Chunk | ファイルやDBなどの入力データソースからレコードを読み込み業務処理を実行するような処理 |
