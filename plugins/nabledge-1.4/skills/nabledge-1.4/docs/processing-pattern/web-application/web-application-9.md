# ユーザに権限があるかを簡単に確認する方法はありますか？

## ユーザ権限確認SQL

403エラー（権限なし）発生時に、ユーザの権限有無を確認するSQL。各プロジェクトのテーブル定義に合わせてテーブル名およびカラム名を変更して実行すること。必要に応じてユーザ名を条件に付加すること。

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

403エラー, 権限確認, 認可, SYSTEM_ACCOUNT, UGROUP, PERMISSION_UNIT, PERMISSION_UNIT_REQUEST, UGROUP_AUTHORITY, 権限なしエラー, ユーザ権限調査, UGROUP_SYSTEM_ACCOUNT

</details>
