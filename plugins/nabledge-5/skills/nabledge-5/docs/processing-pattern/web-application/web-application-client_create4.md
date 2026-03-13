# データベースへの登録

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create4.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/OnDoubleSubmission.html)

## データベースへの登録（登録処理・二重サブミット防止・完了画面）

## 登録処理の実装

:ref:`セッションストア <session_store>` からエンティティを取り出し、[universal_dao](../../component/libraries/libraries-universal_dao.md) でDBに登録する。登録後はセッションストアから削除し、完了画面へリダイレクトする（ブラウザの更新ボタンによる多重登録を防ぐため）。

**クラス**: `ClientAction`

```java
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    Client client = SessionUtil.get(context, "client");
    UniversalDao.insert(client);
    SessionUtil.delete(context, "client");
    return new HttpResponse(303, "redirect://complete");
}
```

リダイレクトのステータスコードについては [web_feature_details-status_code](web-application-feature_details.md) を参照。

## 二重サブミット防止

業務アクションとJSPの両方で制御する。

### サーバサイド

`OnDoubleSubmission` を付与する。業務アクションメソッドが二重に実行された場合にエラーページへ遷移する。詳細は :ref:`tag-double_submission` を参照。

**アノテーション**: `@OnDoubleSubmission`

```java
@OnDoubleSubmission
public HttpResponse create(HttpRequest request, ExecutionContext context) {
    // ...
}
```

> **補足**: デフォルトの遷移先画面の設定方法は :ref:`tag-double_submission` を参照。

### クライアントサイド（JSP実装）

[tag-button_tag](../../component/libraries/libraries-tag_reference.md) の `allowDoubleSubmission` 属性に `false` を指定すると、二重サブミット制御のJavaScriptが追加される。ブラウザのJavaScriptが無効な場合を考慮して、サーバサイドでも二重サブミットを制御する必要がある。

「入力へ戻る」ボタンと「確定」ボタンは `<n:forConfirmationPage>` タグで囲み、確認画面でのみ表示されるようにする。

```jsp
<!-- 入力へ戻る、確定ボタンは確認画面でのみ表示 -->
<n:forConfirmationPage>
    <n:button uri="/action/client/back"
              cssClass="btn btn-raised btn-default">入力へ戻る</n:button>
    <!-- allowDoubleSubmission属性にfalseを指定する -->
    <n:button uri="/action/client/create"
              allowDoubleSubmission="false"
              cssClass="btn btn-raised btn-success">確定</n:button>
</n:forConfirmationPage>
```

## 登録完了画面の表示処理

### 業務アクションメソッド

```java
public HttpResponse complete(HttpRequest request, ExecutionContext context) {
    return new HttpResponse("/WEB-INF/view/client/complete.jsp");
}
```

### 登録完了画面のJSP（complete.jsp）

登録完了画面のJSPを新規作成する。`n:include` タグで共通レイアウト（メニュー・ヘッダー・フッター）を組み込み、完了メッセージを表示する。

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<details>
<summary>keywords</summary>

UniversalDao, SessionUtil, OnDoubleSubmission, HttpResponse, allowDoubleSubmission, forConfirmationPage, Client, データベース登録, セッションストア, 二重サブミット防止, リダイレクト, PRGパターン, complete.jsp, 登録完了画面

</details>
