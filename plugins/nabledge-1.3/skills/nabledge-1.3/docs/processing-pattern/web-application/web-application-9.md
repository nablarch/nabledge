# ユーザに権限があるかを簡単に確認する方法はありますか？

## ユーザ権限確認SQL

403エラー発生時にユーザの権限有無を確認するSQL。テーブル名・カラム名は各プロジェクトのテーブル定義に合わせて変更すること。必要に応じてユーザ名を条件に追加すること。

```sql
SELECT
    SA.USER_ID                    USER_ID ,
    SA.LOGIN_ID                   LOGIN_ID,
    G.UGROUP_ID                   UGROUP_ID,
    G.UGROUP_NAME                 UGROUP_NAME,
    PU.PERMISSION_UNIT_ID         PERMISSION_UNIT_ID,
    PU.PERMISSION_UNIT_NAME       PERMISSION_UNIT_NAME,
    PUR.REQUEST_ID                REQUEST_ID
FROM
    SYSTEM_ACCOUNT SA                       -- システムアカウント
    INNER JOIN UGROUP_SYSTEM_ACCOUNT GSA    -- グループシステムアカウント
        ON SA.USER_ID = GSA.USER_ID
    INNER JOIN UGROUP G                     -- ユーザグループ
        ON GSA.UGROUP_ID = G.UGROUP_ID
    INNER JOIN UGROUP_AUTHORITY GA          -- グループ権限
        ON G.UGROUP_ID = GA.UGROUP_ID
    INNER JOIN PERMISSION_UNIT PU           -- 認可単位
        ON GA.PERMISSION_UNIT_ID = PU.PERMISSION_UNIT_ID
    INNER JOIN PERMISSION_UNIT_REQUEST PUR  -- 認可単位リクエスト
        ON PU.PERMISSION_UNIT_ID = PUR.PERMISSION_UNIT_ID
```

<details>
<summary>keywords</summary>

権限確認, 403エラー, ユーザ権限, 認可, SYSTEM_ACCOUNT, UGROUP, UGROUP_AUTHORITY, PERMISSION_UNIT, PERMISSION_UNIT_REQUEST, UGROUP_SYSTEM_ACCOUNT

</details>
