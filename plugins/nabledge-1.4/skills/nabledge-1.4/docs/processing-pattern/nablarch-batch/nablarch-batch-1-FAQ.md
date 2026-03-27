# バッチの処理対象件数をログに出力する方法はありますか？

## バッチ処理対象件数の取得とログ出力

## バッチ処理対象件数の取得とログ出力

### データベースをインプットとするバッチ

`nablarch.core.db.support.DbAccessSupport` が提供する `countByParameterizedSql` を使用して処理対象レコード数を取得する。件数取得は `createReader` 内で実施する。

処理対象データを取得するSQL文のSQL_IDを指定すると、NablarchがそのSQL文を件数取得用に書き換えてレコード数を返す。

**SQL例**:
```sql
GET_DELETE_USER_LIST =
SELECT
    USER_ID
FROM
    SYSTEM_ACCOUNT
WHERE
    EFFECTIVE_DATE_TO <= :effectiveDateTo
ORDER BY
    USER_ID
```

**実装パターン**:

1. オブジェクトを条件とする場合:
```java
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    SystemAccountEntity condition = new SystemAccountEntity();
    condition.setEffectiveDateTo(ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);
}
```

2. Mapを条件とする場合:
```java
Map<String, Object> condition = new HashMap<String, Object>();
condition.put("effectiveDateTo", ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);
```

3. 条件を必要としない場合:
```java
int count = countByParameterizedSql("GET_DELETE_USER_LIST");
```

> **注意**: 引数なしの `countByParameterizedSql` を使用する場合は、可変条件を持たないSQL文のSQL_IDを指定すること。上記例では便宜上 `GET_DELETE_USER_LIST` を使い回しているが、本来は可変の条件がないSQL文のSQL_IDを指定する。

### ファイルをインプットとするバッチ

本処理前のファイルレイアウト構成精査時に、ファイルレコード数とデータレコード数をカウントして取得する。

### ログ出力

バッチアクションの親クラスが提供する `writeLog` メソッドを使用してログ出力を行う。

<details>
<summary>keywords</summary>

DbAccessSupport, countByParameterizedSql, createReader, writeLog, DataReader, SqlRow, ExecutionContext, バッチ件数取得, 処理対象レコード数, ログ出力, データベース入力バッチ, ファイル入力バッチ

</details>
