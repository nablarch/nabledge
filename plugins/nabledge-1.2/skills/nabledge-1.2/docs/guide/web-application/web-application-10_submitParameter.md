# 一覧表示から個別の情報を扱う画面への遷移

## 本項で説明する内容

## 編集するファイル

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC03Action.java](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC03Action.java) | Action | 一覧から送られてきたパラメータを元に検索を行う。検索結果をリクエストに格納、更新画面への遷移を行う。 |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0101.jsp) | View | 検索結果の一覧表示および個別の情報のサブミットを行う。 |
| [W11AC0301.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0301.jsp) | View | 更新画面に検索結果を初期値として表示する。 |

![画面遷移図](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/screenTransition.png)

<details>
<summary>keywords</summary>

W11AC03Action, W11AC0101.jsp, W11AC0301.jsp, DbAccessSupport, 一覧画面からパラメータ送信, 画面遷移

</details>

## 作成手順

## View(JSP)の作成

リンク毎に異なるパラメータを送るには、`<n:submitLink>` タグ内に `<n:param>` タグを指定する。

- a) `<n:submitLink>` 開始タグと `</n:submit>` 終了タグでリンクを作成する
- b) `n:submit` タグの内容として `<n:param>` タグを記述する

![W11AC0101 画面イメージ](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0101.png)

## 更新画面初期表示までの実装

処理フロー:

1. 送られてきたパラメータの取得
2. パラメータをキーとした検索
3. 検索結果をリクエストスコープに格納
4. 更新画面の初期表示

**クラス**: `W11AC03Action`, `DbAccessSupport`, `W11AC03Form`, `CM311AC1Component`, `SqlResultSet`
**アノテーション**: `@OnError`

```java
public class W11AC03Action extends DbAccessSupport {
    @OnError(type = ApplicationException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
    public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC03Form> userSearchFormContext =
            ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
        if (!userSearchFormContext.isValid()) {
            // hidden暗号化を行っていれば発生しないエラー
            throw new ApplicationException(userSearchFormContext.getMessages());
        }
        String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();

        CM311AC1Component comp = new CM311AC1Component();
        SqlResultSet sysAcct = comp.selectSystemAccount(userId);
        SqlResultSet users = comp.selectUsers(userId);
        SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
        SqlResultSet ugroup = comp.selectUgroup(userId);

        ctx.setRequestScopedVar("W11AC03", getWindowScopeObject(sysAcct, users, permissionUnit, ugroup));
        return new HttpResponse("/ss11AC/W11AC0301.jsp");
    }

    // 【説明】検索結果を設定したFormを返すメソッド
    private W11AC03Form getWindowScopeObject(SqlResultSet sysAcct, SqlResultSet users,
            SqlResultSet permissionUnit, SqlResultSet ugroup) {
        W11AC03Form userForm = new W11AC03Form();

        // ～中略～

        return userForm;
    }
}
```

<details>
<summary>keywords</summary>

n:submitLink, n:submit, n:param, W11AC03Action, W11AC03Form, DbAccessSupport, ValidationUtil, ValidationContext, ApplicationException, SqlResultSet, CM311AC1Component, @OnError, HttpResponse, HttpRequest, ExecutionContext, getWindowScopeObject, パラメータ送信リンク, 更新画面初期表示, リクエストスコープ設定, hidden暗号化

</details>
