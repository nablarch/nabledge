# バッチの処理対象件数をログに出力する方法はありますか？

## バッチ処理対象件数のログ出力

**クラス**: `nablarch.core.db.support.DbAccessSupport`

### データベースをインプットとする場合

`countByParameterizedSql` メソッドで処理対象レコード数を取得する。件数取得は `createReader` 内で行う。件数取得時には処理対象データを取得するSQL文のSQL_IDを指定する。NablarchはそのSQL文を件数取得用に書き換えて件数を返却する。

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

```java
public DataReader<SqlRow> createReader(ExecutionContext ctx) {
    // オブジェクトを条件とする場合
    SystemAccountEntity condition = new SystemAccountEntity();
    condition.setEffectiveDateTo(ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);

    // Mapを条件とする場合
    Map<String, Object> condition = new HashMap<String, Object>();
    condition.put("effectiveDateTo", ctx.<String>getSessionScopedVar(DATE_DATE_SESSION_KEY));
    int count = countByParameterizedSql("GET_DELETE_USER_LIST", condition);

    // 条件を必要としないSQL文の場合
    int count = countByParameterizedSql("GET_DELETE_USER_LIST");
}
```

### ファイルをインプットとする場合

ファイルのレイアウト構成精査時にファイルレコード数やデータレコード数をカウントすることで、ログ出力対象のレコード数を取得する。

### ログ出力方法

バッチアクションの親クラスが提供する `writeLog` メソッドを使用してログ出力を行う。

<details>
<summary>keywords</summary>

DbAccessSupport, countByParameterizedSql, writeLog, DataReader, SqlRow, createReader, ExecutionContext, バッチ処理対象件数取得, データベース件数取得, ファイルレコード数取得, ログ出力

</details>
