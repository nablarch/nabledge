# バッチの処理対象件数をログに出力する方法はありますか？

## バッチの処理対象件数取得とログ出力

## DBをインプットとするバッチの場合

**クラス**: `nablarch.core.db.support.DbAccessSupport`

`countByParameterizedSql` メソッドで処理対象レコード数を取得する。件数取得は `createReader` 内で行う。NablarchはSELECT文をCOUNT取得用のSQL文に書き換えて件数を返す。

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

    // 条件なしの場合
    int count = countByParameterizedSql("GET_DELETE_USER_LIST");
}
```

## ファイルをインプットとするバッチの場合

本処理の前に行うファイルレイアウト構成精査時に、ファイルレコード数・データレコード数をカウントして取得する。

## ログ出力方法

バッチアクションの親クラスが提供する `writeLog` メソッドを使用する。

<details>
<summary>keywords</summary>

DbAccessSupport, countByParameterizedSql, writeLog, createReader, DataReader, SqlRow, ExecutionContext, バッチ処理対象件数取得, レコード数ログ出力, データベース入力バッチ, ファイル入力バッチ

</details>
