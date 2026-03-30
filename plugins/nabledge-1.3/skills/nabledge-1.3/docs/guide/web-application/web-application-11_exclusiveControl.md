# 排他制御

## 本項で説明する内容

| クラス | ステレオタイプ | 処理内容 |
|---|---|---|
| [ExclusiveCtrlSystemAccountContext.java](../../../knowledge/guide/web-application/assets/web-application-11_exclusiveControl/ExclusiveCtrlSystemAccountContext.java) | — | 排他制御用の補助クラス。排他制御の実行に必要な情報を保持する |
| [W11AC03Action.java](../../../knowledge/guide/web-application/assets/web-application-11_exclusiveControl/W11AC03Action.java) | Action | 排他制御補助クラスを使用し、更新処理時に排他制御を行う |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

ExclusiveCtrlSystemAccountContext, W11AC03Action, 排他制御, 作成クラス一覧

</details>

## 作成手順

## 概要

- 楽観ロック方式を使用
- バージョン番号: `SYSTEM_ACCOUNT.VERSION`（`NUMBER(10,0) DEFAULT 1 NOT NULL`）

## 主キークラスの作成（ExclusiveCtrlSystemAccountContext）

**クラス**: `ExclusiveControlContext`（継承元）

作成ルール:
1. `ExclusiveControlContext` を継承
2. 主キーカラムを `private enum PK` で定義
3. コンストラクタで以下を設定:
   - `setTableName("テーブル名")` — バージョン番号を保持するテーブル名
   - `setVersionColumnName("VERSION")` — バージョン番号のカラム名
   - `setPrimaryKeyColumnNames(PK.values())` — 主キーのカラム名（列挙型から設定）
   - `appendCondition(PK.カラム名, 値)` — 排他制御対象行の絞り込み条件

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

## Actionの排他制御実装

**クラス**: `HttpExclusiveControlUtil`

3フェーズで排他制御を実装する:

1. **バージョン番号の取得**（更新画面初期表示時）: `HttpExclusiveControlUtil.prepareVersion(ctx, new ExclusiveCtrlSystemAccountContext(userId))` — バージョン番号を取得して主キークラスに設定する
2. **バージョン番号のチェック**（更新確認処理時）: `HttpExclusiveControlUtil.checkVersions(req, ctx)` — バージョン番号をHttpRequestから取得してチェック。不一致時は `OptimisticLockException` をスロー
3. **バージョン番号のチェックと更新**（データベース更新処理時）: `HttpExclusiveControlUtil.updateVersionsWithCheck(req)` — バージョン一致時に更新、不一致時は `OptimisticLockException` をスロー

**アノテーション**: `@OnError`, `@OnErrors`

排他制御エラー時の遷移先は `@OnError(type = OptimisticLockException.class, path = "...")` で指定する。

バージョン番号の取得（更新画面初期表示時）の実装例:

```java
@OnError(type = ApplicationException.class,
         path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC03Form> userSearchFormContext =
        ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");

    String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();

    HttpExclusiveControlUtil.prepareVersion(ctx, new ExclusiveCtrlSystemAccountContext(userId));

    return new HttpResponse("/ss11AC/W11AC0301.jsp");
}
```

バージョン番号のチェック（更新確認処理時）の実装例:

```java
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0301.jsp")
})
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.checkVersions(req, ctx);
    return new HttpResponse("/ss11AC/W11AC0302.jsp");
}
```

バージョン番号のチェックおよび更新（データベース更新処理時）の実装例:

```java
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0303")
})
@OnDoubleSubmission(path = "forward://RW11AC0303", statusCode = 400)
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.updateVersionsWithCheck(req);
    return new HttpResponse("/ss11AC/W11AC0303.jsp");
}
```

<details>
<summary>keywords</summary>

ExclusiveCtrlSystemAccountContext, ExclusiveControlContext, HttpExclusiveControlUtil, OptimisticLockException, ApplicationException, @OnError, @OnErrors, @OnDoubleSubmission, prepareVersion, checkVersions, updateVersionsWithCheck, W11AC03Action, 排他制御, 楽観ロック, バージョン番号

</details>
