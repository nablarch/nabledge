# 画面初期表示

## 

- 画面上のリンクやボタンを押下後、ビジネスロジックを実行して次の画面へ遷移するまでの処理
- 基本的なデータベースアクセス処理

<details>
<summary>keywords</summary>

画面初期表示, 画面遷移, ビジネスロジック実行, データベースアクセス, リンク・ボタン押下処理

</details>

## 本項で説明する内容

作成するソースコード:

| 名称 | ステレオタイプ | 処理内容 |
|---|---|---|
| [CM311AC1Component.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.java) | Component | ユーザ一覧照会画面の検索条件グループ欄ドロップダウンリスト用グループ一覧をDBから取得する。SQLファイル: [CM311AC1Component.sql](../../../knowledge/guide/web-application/assets/web-application-02_basic/CM311AC1Component.sql) |
| [W11AC01Action.java](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC01Action.java) | Action | ComponentのメソッドをCallし、結果をリクエストスコープに格納してJSPへ遷移させる |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-02_basic/W11AC0101.jsp) | View | ユーザ一覧照会画面を表示する |

ステレオタイプについては :ref:`stereoType` を参照。

<details>
<summary>keywords</summary>

CM311AC1Component, W11AC01Action, W11AC0101.jsp, Component, Action, View, ステレオタイプ, 作成内容

</details>

## 

**クラス**: `CM311AC1Component` extends `DbAccessSupport`

追加メソッド: `SqlResultSet getUserGroups()`

> **注意**: 複数の機能（複数のActionクラス）から共用するロジックはComponentで実装する。1つのActionクラスからしか呼ばれないロジックはそのActionクラスに実装すること。

**SQL** (CM311AC1Component.sql):
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

**Java実装**:
```java
class CM311AC1Component extends DbAccessSupport {
    SqlResultSet getUserGroups() {
        SqlPStatement statement = getSqlPStatement("SELECT_ALL_UGROUPS");
        return statement.retrieve();
    }
}
```

処理手順:
1. `getSqlPStatement("SELECT_ALL_UGROUPS")` でプリペアドステートメントを作成（`DbAccessSupport` のヘルパーメソッドを使用）
2. `statement.retrieve()` で検索実行し結果を返す

<details>
<summary>keywords</summary>

CM311AC1Component, DbAccessSupport, SqlResultSet, getUserGroups, getSqlPStatement, retrieve, SELECT_ALL_UGROUPS, SqlPStatement, Component作成, DBアクセス

</details>

## Actionのメソッド名命名方法

Actionのメソッド名: `"do" + リクエストID`

例: リクエストID `RW11AC0101` → メソッド名 `doRW11AC0101`

URIとActionクラス/メソッドの対応:
- URI: `http://サーバアドレス/action/△△△/・・・/×××/□□□`
- `/△△△/・・・/×××/` 部分 → Actionのパッケージ名（ss11AA以降）＋Action名
- `□□□` 部分 → リクエストID。実際に呼ばれるメソッドは `(HTTPメソッド名もしくは"do") + □□□`

例:
- URI: `http://localhost:8080/action/ss11AA/W11AA01Action/RW11AA0101`
- クラス/メソッド: `nablarch.sample.ss11AC.W11AC01Action#doRW11AC0101`

<details>
<summary>keywords</summary>

Actionメソッド名, リクエストID, do＋リクエストID, HTTPメソッド名, URI対応, メソッド名命名規則

</details>

## Actionの作成

`W11AC01Action` クラスを作成し、:ref:`actionClassMethodName` に従ってメソッドを追加する。

追加するメソッド: `HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx)`

処理手順:
1. Componentのインスタンス化
2. ビジネスロジックの呼び出し
3. ビジネスロジックの戻り値をリクエストスコープに格納
4. /ss11AC/W11AC0101.jspへ遷移

**クラス**: `W11AC01Action`

```java
public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
    CM311AC1Component function = new CM311AC1Component();
    SqlResultSet ugroupList = function.getUserGroups();
    ctx.setRequestScopedVar("ugroupList", ugroupList);
    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

`ctx.setRequestScopedVar(キー名, オブジェクト)`: 第1引数のキー名でJSPからオブジェクトを取得できる。

> **注意**: `HttpResponse` のパス指定方法:
> - `servlet://JSPのパス` → JSPへ遷移（デフォルト。`servlet://` を省略してパスのみ記述も可）
> - `forward://リクエストIDのパス` → 別リクエストIDを実行

JSPファイルのパスは基本的にwebルートからの絶対パス。言語ごとにJSPを切り替える場合は言語フォルダからの絶対パスで記述する（例: `<webルート>/<言語>/ss11AC/W11AC0101.jsp`。`<言語>` にはユーザ選択言語が自動設定される）。

> **注意**: 通常のプロジェクトではプロジェクトが決めた国際化の方針に従いJSPファイルを配置すること。

<details>
<summary>keywords</summary>

W11AC01Action, HttpResponse, doRW11AC0101, HttpRequest, ExecutionContext, Action作成, ビジネスロジック呼び出し, setRequestScopedVar, servlet://, forward://, JSPパス, リクエストスコープ, CM311AC1Component

</details>

## 

**ファイル**: `W11AC0101.jsp`

JSPの動的部分はフレームワーク提供のカスタムタグライブラリおよびサンプルタグファイルを使用する:
- カスタムタグライブラリのネームスペース: `n`
- タグファイルのネームスペース: タグファイルの配置ディレクトリ名

> **注意**: サンプルタグファイル（template, button, column, field, link, tab, table）はNablarch導入プロジェクトのアーキテクトの判断で変更される場合がある。導入プロジェクトではアーキテクトより提供されるガイドに従いJSPを作成すること。

グループ一覧のドロップダウン表示には `field:pulldown` タグファイルを使用する。

検索結果（ugroupList）からは `ugroupName` および `ugroupId` という名前で値を取得する（[DB/01_DbAccessSpec_Example](web-application-01_DbAccessSpec_Example.md) の [how_to_use_sql_result_set](web-application-01_DbAccessSpec_Example.md) 参照）。

<details>
<summary>keywords</summary>

W11AC0101.jsp, field:pulldown, カスタムタグ, JSP作成, タグファイル, ネームスペース, ugroupList, SqlResultSet, ugroupName, ugroupId

</details>

## 次に読むもの

- [データベースアクセス処理の詳細](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.html)
- [データベースアクセス処理の実例](./DB/01_DbAccessSpec_Example.html)
- [Actionのメソッド名とURIの関係](../../../fw/reference/handler/HttpMethodBinding.html#http-dispatch)
- [カスタムタグの使用方法](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)
- [言語ごとのJSP/静的ファイル切り替え](../../../fw/reference/01_SystemConstitution/02_I18N.html)

<details>
<summary>keywords</summary>

データベースアクセス, HttpMethodBinding, カスタムタグ, 国際化, JSP切り替え, DbAccessSpec

</details>
