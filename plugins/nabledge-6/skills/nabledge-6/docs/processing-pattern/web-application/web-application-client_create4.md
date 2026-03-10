# データベースへの登録

## データベースへの登録

### 登録処理の実装

セッションストアから顧客エンティティを取得し、:ref:`universal_dao` でDBに登録する。登録後はセッションから削除し、303リダイレクトで完了画面へ遷移する（ブラウザ更新ボタンによる多重登録防止）。リダイレクトのステータスコードは :ref:`web_feature_details-status_code` を参照。

```java
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    Client client = SessionUtil.get(context, "client");
    UniversalDao.insert(client);
    SessionUtil.delete(context, "client");
    return new HttpResponse(303, "redirect://complete");
}
```

### 二重サブミット防止

**アノテーション**: `@OnDoubleSubmission`

業務アクションメソッドに `@OnDoubleSubmission` を付与すると、業務アクションメソッドが二重に実行された場合にエラーページへ遷移する（:ref:`tag-double_submission` 参照）。JavaScriptが無効な場合を考慮し、サーバサイドでも制御する。

> **補足**: Exampleアプリケーションでは二重サブミット時のデフォルト遷移先画面を設定している。指定方法は :ref:`tag-double_submission` を参照。

```java
@OnDoubleSubmission
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    // ...
}
```

JSPでは、入力へ戻るボタンと確定ボタンを `<n:forConfirmationPage>` タグで囲んで確認画面でのみ表示する。:ref:`tag-button_tag` の `allowDoubleSubmission` 属性に `false` を指定することで、二重サブミットを制御するJavaScriptが追加される。

```jsp
<n:forConfirmationPage>
    <n:button uri="/action/client/back"
              cssClass="btn btn-lg btn-light">入力へ戻る</n:button>
    <n:button uri="/action/client/create"
              allowDoubleSubmission="false"
              cssClass="btn btn-lg btn-success">確定</n:button>
</n:forConfirmationPage>
```

### 登録完了画面の表示処理

登録完了画面の表示処理を業務アクションメソッドとして実装し、完了画面のJSPへフォワードする。

```java
public HttpResponse complete(HttpRequest request, ExecutionContext context) {
    return new HttpResponse("/WEB-INF/view/client/complete.jsp");
}
```

登録完了画面のJSP（`/src/main/webapp/WEB-INF/view/client/complete.jsp`）は以下のように実装する。taglib宣言（`c`、`n`）、`session="false"` ディレクティブ、`n:include` による共通部品（menu、header、footer）の組み込みパターンを使用する。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html>
    <head>
        <title>顧客登録完了画面</title>
    </head>
    <body>
        <n:include path="/WEB-INF/view/common/menu.jsp" />
        <n:include path="/WEB-INF/view/common/header.jsp" />
        <div class="container-fluid mainContents">
            <section class="row">
                <div class="title-nav">
                    <span class="page-title">顧客登録完了画面</span>
                </div>
                <div class="message-area message-info">
                    顧客の登録が完了しました。
                </div>
            </section>
        </div>
        <n:include path="/WEB-INF/view/common/footer.jsp" />
    </body>
</html>
```
