# 登録画面初期表示の作成

## 登録画面初期表示の作成

## JSP実装

:download:`create.jsp <../downloads/client_create/create.jsp>`

`/src/main/webapp/WEB-INF/view/client/create.jsp`:

```jsp
<n:form>
    <div class="row m-3">
        <label class="col-md-2 col-form-label fs-5">顧客名</label>
        <!-- フォーム作成前なので、name属性には仮の値を指定する -->
        <div class="col-md-10 form-group">
            <n:text name="tmp" cssClass="form-control form-control-lg"/>
        </div>
    </div>
    <div class="row m-3">
        <label class="col-md-2 col-form-label fs-5">業種</label>
        <!-- フォーム作成前なので、name属性には仮の値を指定する -->
        <div class="col-md-10 form-group">
            <n:select
                    listName="industries"
                    elementValueProperty="industryCode"
                    elementLabelProperty="industryName"
                    name="tmp"
                    withNoneOption="true"
                    cssClass="form-select form-select-lg"/>
        </div>
    </div>
    <div class="button-nav">
        <!-- 登録内容確認画面は作成前なので、uri属性には仮の値を指定する -->
        <n:button uri="tmp" cssClass="btn btn-lg btn-success">登録</n:button>
    </div>
</n:form>
```

- `name="tmp"` および `uri="tmp"` はフォームや遷移先画面が未作成の段階での仮の値
- :ref:`tag` を使用してテキスト入力フォーム・プルダウンを作成する（:ref:`tag-input_form` 参照）
- :ref:`tag-select_tag` の `listName` 属性に、リクエストスコープに登録する業種リストの名称を指定してプルダウンに表示する（:ref:`tag-selection` 参照）

## 業務アクション実装

業務アクションメソッドのシグネチャ要件（満たさない場合は404エラー）：

```java
public HttpResponse methodName(HttpRequest request, ExecutionContext context)
```

| パラメータ | 説明 |
|---|---|
| request | フレームワークから受け渡されるリクエストオブジェクト |
| context | フレームワークから受け渡される実行コンテキスト |
| 戻り値 | 遷移先を設定したレスポンスオブジェクト |

実装例（`ClientAction.java`）：

```java
public HttpResponse input(HttpRequest request, ExecutionContext context) {
    EntityList<Industry> industries = UniversalDao.findAll(Industry.class);
    context.setRequestScopedVar("industries", industries);
    return new HttpResponse("/WEB-INF/view/client/create.jsp");
}
```

- :ref:`universal_dao` を使用してデータベースから業種情報を全件取得する
- 取得した業種リストをリクエストスコープに登録してJSPへ値を受け渡す

## URLマッピング (routes.xml)

マッピング処理はOSSライブラリの `http_request_router` ([外部サイト](https://github.com/kawasima/http-request-router)) を使用して行う。

```xml
<routes>
  <get path="/action/client" to="Client#input"/>
</routes>
```

routes.xmlは上から評価されるため、このマッピングは他の設定より前に記述する。

> **補足**: routes.xmlの指定方法は、[ライブラリのREADMEドキュメント(外部サイト)](https://github.com/kawasima/http-request-router/blob/master/README.ja.md) を参照。

## ヘッダメニューへのリンク追加

`/src/main/webapp/WEB-INF/view/common/menu.jsp`:

```jsp
<ul class="navbar-nav me-auto">
  <li class="nav-item px-2">
    <n:a href="/action/client" cssClass="nav-link">顧客登録</n:a>
  </li>
</ul>
```

- :ref:`tag` の :ref:`tag-a_tag` を使用してリンクを作成する
