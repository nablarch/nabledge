# ユーザに権限があるかを簡単に確認する方法はありますか？

> **question:**
> 画面打鍵時に403エラー(権限なしエラー)が返却されます。
> ユーザに対して権限がないために、403となっていることはわかるのですが、
> 権限関連のテーブルが多く、そのユーザに与えられている権限を調べるのが大変です。

> ユーザに与えられている権限を簡単に調べる方法はありますか？

> **answer:**
> 以下のSQLで権限有無の確認ができます。
> 各プロジェクトのテーブル定義に合わせてテーブル名及びカラム名を変更して実行してください。
> また、必要に応じてユーザ名を条件に付加してください。

> ```sql
> SELECT
>     SA.USER_ID                    USER_ID ,
>     SA.LOGIN_ID                   LOGIN_ID,
>     G.UGROUP_ID                   UGROUP_ID,
>     G.UGROUP_NAME                 UGROUP_NAME,
>     PU.PERMISSION_UNIT_ID         PERMISSION_UNIT_ID,
>     PU.PERMISSION_UNIT_NAME       PERMISSION_UNIT_NAME,
>     PUR.REQUEST_ID                REQUEST_ID
> FROM
>     SYSTEM_ACCOUNT SA                       -- システムアカウント
>     INNER JOIN UGROUP_SYSTEM_ACCOUNT GSA    -- グループシステムアカウント
>         ON SA.USER_ID = GSA.USER_ID
>     INNER JOIN UGROUP G                     -- ユーザグループ
>         ON GSA.UGROUP_ID = G.UGROUP_ID
>     INNER JOIN UGROUP_AUTHORITY GA          -- グループ権限
>         ON G.UGROUP_ID = GA.UGROUP_ID
>     INNER JOIN PERMISSION_UNIT PU           -- 認可単位
>         ON GA.PERMISSION_UNIT_ID = PU.PERMISSION_UNIT_ID
>     INNER JOIN PERMISSION_UNIT_REQUEST PUR  -- 認可単位リクエスト
>         ON PU.PERMISSION_UNIT_ID = PUR.PERMISSION_UNIT_ID
> ```

> 権限関連のテーブル詳細は、以下のドキュメントを参照してください。

> * >   **[Nablarch Application Framework解説書]** -> **[NAF共通コンポーネント]** -> **[認可]** -> **[テーブル定義]**
