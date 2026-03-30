# 画面初期表示

## 本項で説明する内容

![画面遷移図](../../../knowledge/guide/web-application/assets/web-application-02_basic/screenTransition.png)

| 名称 | ステレオタイプ | 処理内容 |
|---|---|---|
| [CM311AC1Component.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.java) | Component | ユーザ一覧照会画面の検索条件グループ欄ドロップダウンリスト用グループ一覧をDBから取得する。SQLファイル: [CM311AC1Component.sql](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.sql) |
| [W11AC01Action.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC01Action.java) | Action | ComponentのメソッドをCallし、結果をリクエストスコープに格納してJSPへ遷移する。 |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC0101.jsp) | View | ユーザ一覧照会画面を表示する。 |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

CM311AC1Component, W11AC01Action, W11AC0101, Component, Action, View, ステレオタイプ, ユーザ一覧照会, 画面初期表示

</details>

## ビジネスロジック(Component)の作成

**クラス**: `CM311AC1Component`（`DbAccessSupport` を継承）

追加メソッド: `SqlResultSet getUserGroups()`

> **注意**: 複数機能（複数のActionクラス）から共用されるロジックはComponentに実装する。単一のActionクラスからしか呼ばれないロジックはActionクラスに実装すること。

処理フロー:
1. DBコネクション取得
2. プリペアドステートメント作成（SQL ID: `SELECT_ALL_UGROUPS`）
3. 検索実行、結果返却

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

CM311AC1Component, DbAccessSupport, SqlResultSet, SqlPStatement, getUserGroups, getSqlPStatement, SELECT_ALL_UGROUPS, Component作成, DBアクセス

</details>

## Actionのメソッド名命名方法

Actionメソッド名: `"do" + リクエストID`

例: リクエストID `RW11AC0101` → メソッド名 `doRW11AC0101`

URI `/action/△△△/.../×××/□□□` のマッピング:
- `/△△△/.../×××/`: Actionのパッケージ（ss11AA以降）＋Action名（×××）
- `□□□`: リクエストID。呼び出しメソッドは `(HTTPメソッド名 or "do") + □□□`

例:
- URI: `http://localhost:8080/action/ss11AA/W11AA01Action/RW11AA0101`
- クラス: `nablarch.sample.ss11AC.W11AC01Action#doRW11AC0101`

<details>
<summary>keywords</summary>

Actionメソッド命名規則, リクエストID, doRW11AC0101, HTTPメソッド, URIマッピング

</details>

## Actionの作成

**クラス**: `W11AC01Action`

:ref:`actionClassMethodName` に従い、以下のメソッドを追加する。

追加メソッド: `HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx)`

処理フロー:
1. Componentのインスタンス化
2. ビジネスロジック呼び出し
3. 戻り値をリクエストスコープに格納（`ctx.setRequestScopedVar(key, value)`）
4. JSPへ遷移

```java
public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
    CM311AC1Component function = new CM311AC1Component();
    SqlResultSet ugroupList = function.getUserGroups();
    ctx.setRequestScopedVar("ugroupList", ugroupList);
    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

JSP遷移の記述方法:
- JSPへ遷移: `servlet://"JSPのパス"`（省略可能、デフォルト）
- 別のリクエストIDを実行: `forward://"リクエストIDのパス"`

JSPファイルのパス指定:
- 基本的にアプリケーションのWebルートディレクトリからの絶対パスで記述する。
- 国際化対応でWebルート直下に言語フォルダを配置する場合は、言語フォルダからの絶対パスで記述する（`<言語>` 部分はユーザが選択した言語（"ja"や"en"等）が自動設定される）。

<details>
<summary>keywords</summary>

W11AC01Action, HttpRequest, HttpResponse, ExecutionContext, doRW11AC0101, setRequestScopedVar, リクエストスコープ, JSP遷移, servlet, forward

</details>

## View(JSP)の作成

**ファイル**: `W11AC0101.jsp`

JSPの動的部分はフレームワーク提供のカスタムタグ（ネームスペース `n`）を使用する。取得したグループ一覧は `n:select` タグ（ドロップダウンリスト）で使用する。

`SqlResultSet` からの値取得: `ugroupName`（グループ名）、`ugroupId`（グループID）。詳細は [DB/01_DbAccessSpec_Example](web-application-01_DbAccessSpec_Example.md) の [how_to_use_sql_result_set](web-application-01_DbAccessSpec_Example.md) を参照。

外部共通JSPファイル（外部化は必須ではない）:
- `html_header.jsp`: HTMLヘッダ部分
- `app_header.jsp`: 業務アプリケーションヘッダ部分
- `app_error.jsp`: エラーメッセージ表示部分

JavaScriptを画面内に記述する場合は :ref:`using_javascript` を参照すること。

<details>
<summary>keywords</summary>

W11AC0101, n:select, ドロップダウンリスト, カスタムタグ, JSP, html_header.jsp, app_header.jsp, app_error.jsp

</details>
