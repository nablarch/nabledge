# 一覧表示から個別の情報を扱う画面への遷移

## 

一覧表示から個別の情報を扱う画面へ遷移する際に、各行のキー情報（ユーザIDなど）をパラメータとして送信する実装パターン。一覧の更新リンクをクリックすると、その行のキー情報をサブミットして更新画面へ遷移する。

<details>
<summary>keywords</summary>

一覧表示から個別情報画面への遷移, パラメータ送信, 画面遷移, リンクサブミット

</details>

## 本項で説明する内容

本項では、検索結果などの一覧表示されているリンクごとに異なる情報をパラメータとして送る方法を説明する。具体的には、`column:link`タグと`<n:param>`タグを組み合わせて、一覧の各行に対応するキー情報（ユーザIDなど）をリンクのサブミット時に送信する実装方法を扱う。

<details>
<summary>keywords</summary>

一覧リンクごとに異なるパラメータ, 検索結果パラメータ送信

</details>

## 

本項で作成するのは一覧画面から更新画面への遷移部分（画面遷移図の赤丸部分）。

![画面遷移図](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/screenTransition.png)

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC03Action.java](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC03Action.java) | Action | 一覧から送られてきたパラメータを元に検索を行う。検索結果をリクエストに格納、更新画面への遷移を行う。|
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0101.jsp) / [W11AC0301.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0301.jsp) | View | W11AC0101.jspは検索結果の一覧表示および個別の情報のサブミットを行う。W11AC0301.jspは更新画面に検索結果を初期値として表示する。|

ステレオタイプ: :ref:`stereoType` 参照

<details>
<summary>keywords</summary>

作成内容, W11AC03Action, W11AC0101.jsp, W11AC0301.jsp, Action, View, 画面遷移図

</details>

## 作成手順

## 概要

一覧に表示された*更新*リンクをクリックすると、そのユーザのキー情報（ユーザID）をサブミットする。

リンク毎に異なるパラメータを送りたい場合、サブミット用のリンクを表すカスタムタグの内容にパラメータを表すカスタムタグを指定すればよい。

<details>
<summary>keywords</summary>

View(JSP)の作成, 概要, ユーザID, キー情報, カスタムタグ, column:link, n:param

</details>

## 画面イメージ

W11AC0101.jspの画面イメージ。検索結果の一覧と各行の更新リンクが表示される。

![W11AC0101.jsp 画面イメージ](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0101.png)

<details>
<summary>keywords</summary>

画面イメージ, W11AC0101, 検索結果一覧

</details>

## パラメータをサブミットするリンクの作成方法

パラメータをサブミットするリンクの作成方法:
1. サンプル提供の`column:link`タグでリンクを作成する。
2. `column:link`タグの内容として、`<n:param>`タグを記述する。

W11AC0101.jspの実装例: [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0101.jsp)

<details>
<summary>keywords</summary>

パラメータ付きリンク作成, column:link, n:param, カスタムタグ, W11AC0101.jsp

</details>

## 

## 更新画面初期表示までの実装

以下の順で処理を行う:
1. 送られてきたパラメータの取得
2. パラメータをキーとした検索
3. 検索結果をリクエストスコープに格納
4. 更新画面の初期表示

```java
public class W11AC03Action extends DbAccessSupport {

    @OnError(type = ApplicationException.class,
             path = "forward:///action/ss11AC/W11AC01Action/RW11AC0102")
    public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
        
        // パラメータの取得
        ValidationContext<W11AC03Form> userSearchFormContext =
            ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");

        // hidden暗号化を行っていれば発生しないエラー
        userSearchFormContext.abortIfInvalid();
        String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();

        // パラメータをキーとして検索
        CM311AC1Component comp = new CM311AC1Component();
        SqlResultSet sysAcct = comp.selectSystemAccount(userId);
        SqlResultSet users = comp.selectUsers(userId);
        SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
        SqlResultSet ugroup = comp.selectUgroup(userId);
        
        // 検索結果をリクエストスコープに設定
        ctx.setRequestScopedVar("W11AC03", getWindowScopeObject(sysAcct, users, permissionUnit, ugroup));
        
        return new HttpResponse("/ss11AC/W11AC0301.jsp");
    }
}
```

W11AC0301.jspの実装例: [W11AC0301.jsp](../../../knowledge/guide/web-application/assets/web-application-10_submitParameter/W11AC0301.jsp)

<details>
<summary>keywords</summary>

更新画面初期表示, ValidationUtil, validateAndConvertRequest, W11AC03Form, DbAccessSupport, HttpResponse, setRequestScopedVar, SqlResultSet, @OnError, ApplicationException, CM311AC1Component, ExecutionContext, HttpRequest, ValidationContext

</details>

## 次に読むもの

- [データベースアクセス処理を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.html)
- [データベースアクセス処理の実例を知りたい時](./DB/01_DbAccessSpec_Example.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

データベースアクセス, カスタムタグ, 次に読むもの

</details>
