# 排他制御

## 本項で説明する内容

作成するソースコード:

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| `ExclusiveCtrlSystemAccountContext.java` | — | 排他制御用の補助クラス。排他制御の実行に必要な情報を保持する。 |
| `W11AC03Action.java` | Action | 排他制御補助クラスを使用し、更新処理時に排他制御を行う。 |

<details>
<summary>keywords</summary>

ExclusiveCtrlSystemAccountContext, W11AC03Action, 排他制御, 楽観ロック, 更新処理

</details>

## 概要

本書で作成する排他制御の仕様:

- 楽観ロックを使用する。
- 排他制御のバージョン番号として、SYSTEM_ACCOUNTテーブルの **VERSION** 項目の値を使用する。

<details>
<summary>keywords</summary>

排他制御, 楽観ロック, バージョン番号, VERSION

</details>

## 主キークラス(ExclusiveCtrlSystemAccountContext)の作成

主キークラスを作成する手順:

1. Nablarchの提供する `ExclusiveControlContext` クラスを継承する。
2. 排他制御用テーブルの主キーを列挙型（`PK`）で定義する。
3. 主キーの値を引数にとるコンストラクタを定義する。
4. コンストラクタ内で `setTableName()`、`setVersionColumnName()`、`setPrimaryKeyColumnNames()`、`appendCondition()` を呼び出す。

SYSTEM_ACCOUNTテーブル定義:

```sql
CREATE TABLE SYSTEM_ACCOUNT
(
    USER_ID  CHAR(10) NOT NULL,
    VERSION  NUMBER(10,0) DEFAULT 1 NOT NULL
);
ALTER TABLE SYSTEM_ACCOUNT
    ADD(PRIMARY KEY (USER_ID) USING INDEX);
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

ExclusiveControlContext, ExclusiveCtrlSystemAccountContext, 排他制御, 楽観ロック, バージョン番号, setTableName, setVersionColumnName, setPrimaryKeyColumnNames, appendCondition

</details>

## Actionの作成

更新取引の排他処理では `HttpExclusiveControlUtil` クラスを使用して次の処理を行う:

1. 主キークラスのインスタンスを生成する。
2. 生成した主キークラスを指定してバージョン番号を取得する（更新画面初期表示時）。
3. バージョン番号をチェックする（更新確認処理時）。
4. バージョン番号のチェックおよび更新を行う（DB更新処理時）。

**バージョン番号の取得（更新画面初期表示時）**:

主キークラスのインスタンスを生成し、バージョン番号を取得する。取得したバージョン番号は主キークラスに設定される。

```java
HttpExclusiveControlUtil.prepareVersion(ctx, new ExclusiveCtrlSystemAccountContext(userId));
```

**バージョン番号のチェック（更新確認処理時）**:

バージョン番号は `HttpRequest` から取得する。バージョンが異なる場合、`OptimisticLockException` がスローされる。`@OnErrors` / `@OnError(type = OptimisticLockException.class, ...)` で排他制御エラー時の遷移先を指定する。

```java
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0301.jsp")
})
public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.checkVersions(req, ctx);
    // ...
}
```

**バージョン番号のチェックおよび更新（DB更新処理時）**:

バージョンが同じ場合にバージョン番号を更新する。バージョンが異なる場合、`OptimisticLockException` がスローされる。

```java
@OnErrors({
    @OnError(type = OptimisticLockException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102"),
    @OnError(type = ApplicationException.class, path = "forward://RW11AC0303")
})
public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
    HttpExclusiveControlUtil.updateVersionsWithCheck(req);
    // ...
}
```

<details>
<summary>keywords</summary>

HttpExclusiveControlUtil, OptimisticLockException, @OnError, @OnErrors, 排他制御, バージョン番号, prepareVersion, checkVersions, updateVersionsWithCheck

</details>

## 次に読むもの

- [排他制御機能について詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/08_ExclusiveControl.html)

<details>
<summary>keywords</summary>

排他制御機能, ExclusiveControl

</details>
