# 画面初期表示

## 本項で説明する内容

| クラス/ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [CM311AC1Component.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.java) | Component | ユーザ一覧照会画面のグループ欄ドロップダウン用グループ一覧をDBから取得。SQLファイル: [CM311AC1Component.sql](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.sql) |
| [W11AC01Action.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC01Action.java) | Action | ComponentメソッドをCallし、結果をリクエストスコープに格納してJSPへ遷移。 |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC0101.jsp) | View | ユーザ一覧照会画面を表示。 |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

CM311AC1Component, W11AC01Action, W11AC0101.jsp, Component, Action, View, ステレオタイプ, 画面初期表示, ビジネスロジック

</details>

## ビジネスロジック(Component)の作成

**クラス**: `CM311AC1Component`（`DbAccessSupport`を継承）

**メソッド**: `SqlResultSet getUserGroups()`

> **注意**: 複数のActionから共用するロジックはComponentに実装する。1つのActionクラスからしか使われないロジックは、そのActionクラスに実装すること。

処理内容:
1. `DbAccessSupport`のヘルパーメソッドでプリペアドステートメントを作成
2. 検索を実行して結果を返す

**SQL** (`CM311AC1Component.sql`):
```sql
SELECT_ALL_UGROUPS=
SELECT
    UGROUP_ID,
    UGROUP_NAME
FROM
    UGROUP
ORDER BY
    UGROUP_ID
```

**実装例**:
```java
class CM311AC1Component extends DbAccessSupport {
    SqlResultSet getUserGroups() {
        SqlPStatement statement = getSqlPStatement("SELECT_ALL_UGROUPS");
        return statement.retrieve();
    }
}
```

<details>
<summary>keywords</summary>

CM311AC1Component, DbAccessSupport, SqlResultSet, SqlPStatement, getUserGroups, ビジネスロジック, Component, プリペアドステートメント, データベースアクセス

</details>

## ビジネスロジックを呼び出す処理(Action)の作成

**クラス**: `W11AC01Action`

**Actionメソッド名の命名規則**: `"do" + リクエストID`
- 例: リクエストID `RW11AC0101` → メソッド名 `doRW11AC0101`

> **注意**: リクエストURIの構造: `http://{サーバ}/action/{Actionのパッケージ}/{リクエストID}` → `(HTTPメソッド名 or "do") + リクエストID` のメソッドが呼ばれる。

**メソッド**: `public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx)`

処理内容:
1. Componentをインスタンス化: `new CM311AC1Component()`
2. ビジネスロジックを呼び出す: `function.getUserGroups()`
3. 結果をリクエストスコープに格納: `ctx.setRequestScopedVar("ugroupList", ugroupList)`
4. JSPへ遷移: `return new HttpResponse("/ss11AC/W11AC0101.jsp")`

**レスポンス遷移の指定方法**:
- JSPへ遷移: `new HttpResponse("servlet://{JSPパス}")` またはデフォルト（`"servlet://"` を省略可能）
- 別リクエストIDへフォワード: `new HttpResponse("forward://{リクエストIDのパス}")`

**JSPパスの記述方法**:
- 基本的にアプリケーションの web ルートディレクトリからの絶対パスで記述する。
- 言語によって遷移先のJSPファイルを切り替える場合、web ルート直下に言語フォルダを配置し、その言語フォルダ配下にJSPファイルを配置することがある。この場合は**言語フォルダからの絶対パス**で記述する。
- 上記コード例 `/ss11AC/W11AC0101.jsp` は後者のケースで、実際のファイルは `<webルート>/<言語>/ss11AC/W11AC0101.jsp` に配置される。`<言語>` にはユーザが選択した言語（`"ja"` や `"en"` など）が自動的に設定される。
- **実際のプロジェクトでは、このガイドの例に従うのではなく、プロジェクトが決めた国際化の方針に従いJSPファイルを配置すること。**

**実装例**:
```java
public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
    CM311AC1Component function = new CM311AC1Component();
    SqlResultSet ugroupList = function.getUserGroups();
    ctx.setRequestScopedVar("ugroupList", ugroupList);
    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

<details>
<summary>keywords</summary>

W11AC01Action, HttpResponse, HttpRequest, ExecutionContext, doRW11AC0101, setRequestScopedVar, Actionメソッド命名規則, リクエストスコープ, JSP遷移, servlet://, forward://, JSPパス, webルート, 言語フォルダ, 国際化

</details>

## View(JSP)の作成

**ファイル**: `W11AC0101.jsp`

**カスタムタグライブラリのネームスペース**:
- フレームワーク提供タグ: `n`（例: `<n:xxx>`）
- タグファイル: タグファイルの配置ディレクトリ名（例: `field:xxx`）

> **注意**: サンプルタグファイル（template, button, column, field, link, tab, table）はアーキテクトの判断により変更される。Nablarch導入プロジェクトでは本ガイドでなくアーキテクト提供ガイドに従いJSPを作成すること。

グループ一覧のドロップダウン表示には **`field:pulldown`** タグを使用する。

検索結果（`ugroupList`）から値を取得する際は `ugroupName`、`ugroupId` というキーを使用する（詳細は [DB/01_DbAccessSpec_Example](web-application-01_DbAccessSpec_Example.md) の [how_to_use_sql_result_set](web-application-01_DbAccessSpec_Example.md) 参照）。

<details>
<summary>keywords</summary>

W11AC0101.jsp, field:pulldown, カスタムタグ, ネームスペース, ドロップダウン, JSP, ugroupList, ugroupName, ugroupId

</details>
