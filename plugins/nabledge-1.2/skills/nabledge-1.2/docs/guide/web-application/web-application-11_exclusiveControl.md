# 排他制御

## 作成クラス一覧

楽観ロックを使用した排他制御で作成するクラス:

| クラス | ステレオタイプ | 説明 |
|---|---|---|
| ExclusiveCtrlSystemAccountContext.java | — | 排他制御補助クラス。排他制御実行に必要な情報を保持する |
| W11AC03Action.java | Action | 排他制御補助クラスを使用し、更新処理時に排他制御を行う |

<details>
<summary>keywords</summary>

ExclusiveCtrlSystemAccountContext, W11AC03Action, 排他制御, 楽観ロック

</details>

## 作成手順: 概要

本書で作成する排他制御の仕様:

- 楽観ロック
- 排他制御のバージョン番号として、SYSTEM_ACCOUNTテーブルの **VERSION** カラムの値を使用する

<details>
<summary>keywords</summary>

楽観ロック, 排他制御, バージョン番号, SYSTEM_ACCOUNT, VERSION

</details>

## 主キークラス(ExclusiveCtrlSystemAccountContext)の作成

主キークラス作成手順:

1. `ExclusiveControlContext` を継承
2. 排他制御用テーブルの主キーを列挙型で定義
3. 主キーの値を引数にとるコンストラクタを定義
4. 排他制御に関するテーブルの情報を設定:
   - `setTableName` — テーブル名
   - `setVersionColumnName` — バージョン番号カラム名
   - `setPrimaryKeyColumnNames` — 主キーカラム名一覧
   - `appendCondition` — 行特定条件

テーブル定義:
```sql
CREATE TABLE SYSTEM_ACCOUNT (
    USER_ID CHAR(10) NOT NULL,
    VERSION NUMBER(10,0) DEFAULT 1 NOT NULL
);
ALTER TABLE SYSTEM_ACCOUNT ADD(PRIMARY KEY (USER_ID) USING INDEX);
```

実装例:
```java
public class ExclusiveCtrlSystemAccountContext extends ExclusiveControlContext {
    private enum PK { USER_ID }
    public ExclusiveCtrlSystemAccountContext(String userId) {
        setTableName("SYSTEM_ACCOUNT");
        setVersionColumnName("VERSION");
        setPrimaryKeyColumnNames(PK.values());
        appendCondition(PK.USER_ID, userId);
    }
}
```

<details>
<summary>keywords</summary>

ExclusiveCtrlSystemAccountContext, ExclusiveControlContext, setTableName, setVersionColumnName, setPrimaryKeyColumnNames, appendCondition, 排他制御, バージョン番号

</details>

## Actionの作成

更新取引の排他処理では `HttpExclusiveControlUtil` を使用する。各フェーズで以下のメソッドを呼び出す:

| 呼び出しタイミング | メソッド | 動作 |
|---|---|---|
| 更新画面初期表示 | `prepareVersion(ctx, context)` | バージョン番号をDBから取得し主キークラスに設定 |
| 更新確認処理 | `checkVersions(req, ctx)` | バージョンチェック（不一致→`OptimisticLockException`） |
| DB更新処理 | `updateVersionsWithCheck(req)` | バージョンチェック＋更新（不一致→`OptimisticLockException`） |

`OptimisticLockException` 発生時の遷移先は `@OnError` / `@OnErrors` で指定する。

```java
// 更新画面初期表示: バージョン番号取得
HttpExclusiveControlUtil.prepareVersion(ctx, new ExclusiveCtrlSystemAccountContext(userId));
```

```java
// 更新確認処理: バージョンチェック
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0301.jsp")
})
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.checkVersions(req, ctx);
    ...
}
```

```java
// DB更新処理: バージョンチェック＋更新
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0303")
})
@OnDoubleSubmission(path = "forward://RW11AC0303", statusCode = 400)
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.updateVersionsWithCheck(req);
    ...
}
```

<details>
<summary>keywords</summary>

HttpExclusiveControlUtil, OptimisticLockException, ApplicationException, @OnError, @OnErrors, @OnDoubleSubmission, prepareVersion, checkVersions, updateVersionsWithCheck, W11AC03Action, 楽観ロック, バージョン番号

</details>
