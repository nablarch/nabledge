# 登録画面初期表示の作成

**公式ドキュメント**: [登録画面初期表示の作成](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/getting_started/client_create/client_create1.html)

## 登録画面初期表示の作成

### JSP実装

:ref:`tag` を使用してフォームを作成する。

- `n:text`: テキスト入力フォーム（:ref:`tag-input_form` 参照）
- `n:select`: プルダウン。`listName` 属性にリクエストスコープの業種リスト名を指定（:ref:`tag-selection` 参照）

```jsp
<n:form>
    <n:text name="tmp" cssClass="form-control input-text"/>
    <n:select
            listName="industries"
            elementValueProperty="industryCode"
            elementLabelProperty="industryName"
            name="tmp"
            withNoneOption="true"
            cssClass="btn dropdown-toggle"/>
    <n:button uri="tmp" cssClass="btn btn-raised btn-success">登録</n:button>
</n:form>
```

### 業務アクションメソッド

業務アクションメソッドのシグネチャが以下を満たさない場合、**404エラーが発生する**:

```java
public HttpResponse methodName(HttpRequest request, ExecutionContext context)
```

プルダウン用データは [universal_dao](../../component/libraries/libraries-universal_dao.md) で全件取得し、リクエストスコープに登録してJSPに渡す:

```java
public HttpResponse input(HttpRequest request, ExecutionContext context) {
    EntityList<Industry> industries = UniversalDao.findAll(Industry.class);
    context.setRequestScopedVar("industries", industries);
    return new HttpResponse("/WEB-INF/view/client/create.jsp");
}
```

### URLマッピング（routes.xml）

`http_request_router` でURLと業務アクションをマッピングする。

> **補足**: routes.xmlは上から評価されるため、他のマッピングより前に設定する。

```xml
<routes>
  <get path="/action/client" to="Client#input"/>
</routes>
```

### メニューリンク

`/src/main/webapp/WEB-INF/view/common/menu.jsp` に [tag-a_tag](../../component/libraries/libraries-tag_reference.md) を使用してリンクを追加する:

```jsp
<ul class="nav navbar-nav">
  <!-- その他のリンクは省略 -->
  <li>
    <n:a href="/action/client">顧客登録</n:a>
  </li>
</ul>
```

<details>
<summary>keywords</summary>

HttpResponse, HttpRequest, ExecutionContext, EntityList, UniversalDao, Industry, ClientAction, 登録画面初期表示, プルダウン実装, URLマッピング, 業務アクション, リクエストスコープ, routes.xml, n:select, n:text, n:form

</details>
