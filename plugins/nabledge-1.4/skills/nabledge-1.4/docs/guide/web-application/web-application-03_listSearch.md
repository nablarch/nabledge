# 一覧検索

## 本項で説明する内容

作成するファイル:

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC01Action.java](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC01Action.java) | Action | 検索条件に一致する情報をDBから取得し、リクエストスコープに格納してJSPに遷移。SQLファイル: [W11AC01Action.sql](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC01Action.sql) |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC0101.jsp) | View | ユーザ一覧照会画面に検索結果を表示 |

**クラス**: `W11AC01Action` extends `DbAccessSupport`

条件が可変なSQL文、LIKE検索（自動エスケープ）、動的ORDER BYを組み合わせた一覧検索の実装例。

### SQL定義 (W11AC01Action.sql)

- `$if (field) {条件}`: `search` 実行時に渡されたオブジェクトにフィールドが存在し、nullでも空文字でもなければWHERE句に組み込まれる
- LIKE検索: `LIKE :%field%` 記法。エスケープ処理は不要（フレームワークが自動処理）
- `$sort (sortId) {(key ORDER句)...}`: `sortId` フィールドの値に応じたORDER BY句を動的に組み込む

```sql
SELECT_USER_BY_CONDITION =
SELECT
  SA.LOGIN_ID, SA.USER_ID, SA.USER_ID_LOCKED,
  USR.KANJI_NAME, USR.KANA_NAME, USR.MAIL_ADDRESS,
  USR.EXTENSION_NUMBER_BUILDING, USR.EXTENSION_NUMBER_PERSONAL,
  UGRP.UGROUP_ID, UGRP.UGROUP_NAME
FROM
    USERS USR
INNER JOIN UGROUP_SYSTEM_ACCOUNT USA ON USR.USER_ID = USA.USER_ID
INNER JOIN SYSTEM_ACCOUNT SA ON USR.USER_ID = SA.USER_ID
INNER JOIN UGROUP UGRP ON UGRP.UGROUP_ID = USA.UGROUP_ID
WHERE
    $if (loginId) {SA.LOGIN_ID = :loginId}
    AND $if (kanjiName) {USR.KANJI_NAME LIKE :%kanjiName%}
    AND $if (kanaName) {USR.KANA_NAME  LIKE :%kanaName%}
    AND $if (ugroupId) {UGRP.UGROUP_ID = :ugroupId}
    AND $if (userIdLocked) {SA.USER_ID_LOCKED = :userIdLocked}
$sort (sortId) {
    (loginId_asc    SA.LOGIN_ID)
    (loginId_desc   SA.LOGIN_ID DESC)
    (kanjiName_asc  USR.KANJI_NAME, SA.LOGIN_ID)
    (kanjiName_desc USR.KANJI_NAME DESC, SA.LOGIN_ID)
    (kanaName_asc   USR.KANA_NAME, SA.LOGIN_ID)
    (kanaName_desc  USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

### Java実装 (W11AC01Action.java)

`search()` 使用時：

```java
private SqlResultSet selectByCondition(W11AC01SearchForm condition) {
    return search("SELECT_USER_BY_CONDITION", condition);
}
```

LIKE検索のエスケープや `%` 付加のJavaコードは不要。

### getParameterizedSqlStatement を使う場合

> **注意**: `getParameterizedSqlStatement` の第2引数（condition）と `retrieve` の引数には、必ず**同じインスタンス**を渡すこと。異なるインスタンスを渡すと、意図した条件で検索が行われない。

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
        "SELECT_USER_BY_CONDITION", condition);
return statement.retrieve(condition);
```

<details>
<summary>keywords</summary>

W11AC01Action, W11AC0101, 一覧検索, 検索結果表示, ActionとViewの構成, DbAccessSupport, SqlResultSet, W11AC01SearchForm, ParameterizedSqlPStatement, 条件可変SQL, LIKE検索, 動的ORDER BY, $if条件, $sort

</details>

## 作成手順

**検索条件Form作成のポイント**: `ListSearchInfo`クラスを継承することでページングや検索結果の並び替えを容易に実現できる。

**ビジネスロジック作成のポイント**: 本処理で使用するビジネスロジックは他の処理では使用しないため、ComponentクラスではなくActionクラスに作成する。

使用するデータベースアクセス機能:
- [03_field](#s3): Javaオブジェクトのフィールドの値をバインド変数に設定する機能
- :ref:`03_SQL`: 条件が可変のSQL文を組み立てる機能
- [03_like](#s5): LIKE検索を簡易的に実装できる機能
- :ref:`03_orderBy`: ORDER BY句を動的に変更する機能

## リクエストに対応するメソッドの作成

**アノテーション**: `@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")`

```java
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    W11AC01Form form = W11AC01Form.validate(req, "search");

    W11AC01SearchForm condition = searchConditionCtx.createObject();
    ctx.setRequestScopedVar("11AC_W11AC01", condition);

    SqlResultSet searchResult;
    try {
        searchResult = selectByCondition(condition);
    } catch (TooManyResultException e) {
        throw new ApplicationException(
            MessageUtil.createMessage(MessageLevel.ERROR, "MSG00035", e.getMaxResultCount()));
    }

    ctx.setRequestScopedVar("searchResult", searchResult);
    ctx.setRequestScopedVar("resultCount", condition.getResultCount());
    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

- `TooManyResultException` をキャッチし、`ApplicationException` に変換すること
- 検索条件入力チェックは [how_to_validate](web-application-04_validation.md) を参照

## View(JSP)の作成 (W11AC0101.jsp)

- 検索結果はリスト-マップ（1レコードを表す `Map` を要素とする `List`）で取得できる
- 検索結果一覧表示用のカスタムタグを使用するため、JSP内でループ処理は不要
- 一覧表示用カスタムタグの使用方法: :ref:`custom_tag_paging`

<details>
<summary>keywords</summary>

ListSearchInfo, ページング, 検索結果並び替え, ActionクラスとComponentクラスの使い分け, 一覧検索実装, W11AC01Form, W11AC01SearchForm, TooManyResultException, ApplicationException, MessageUtil, MessageLevel, HttpResponse, HttpRequest, ExecutionContext, @OnError, リクエスト処理, 一覧検索結果表示, カスタムタグ, JSP

</details>

## Formクラスの作成

`ListSearchInfo`を継承したFormクラスの実装ポイント:

1. `pageNumber`と`sortId`のセッターをオーバーライドし、バリデーションアノテーションを設定する
2. `SEARCH_CONDITION_PROPS`にListSearchInfoのプロパティ（`pageNumber`、`sortId`）も含める
3. `getSearchConditionProps()`メソッドを追加して`SEARCH_CONDITION_PROPS`を返す
4. 検索条件が少なくとも1つ指定されていることを`isValidSearchCondition()`で確認する

**W11AC01FormBase.java** (`ListSearchInfo`継承):

```java
public abstract class W11AC01FormBase extends ListSearchInfo {
    private String loginId;
    private String kanjiName;
    private String kanaName;
    private String ugroupId;
    private String userIdLocked;

    @PropertyName("開始ページ")
    @Required
    @NumberRange(max = 10, min = 1)
    @Digits(integer = 2)
    public void setPageNumber(Integer pageNumber) {
        super.setPageNumber(pageNumber);
    }

    @PropertyName("ソートID")
    @Required
    public void setSortId(String sortId) {
        super.setSortId(sortId);
    }
}
```

**W11AC01Form.java**:

```java
public class W11AC01Form extends W11AC01FormBase {

    public static W11AC01Form validate(HttpRequest req, String validationName) {
        ValidationContext<W11AC01Form> context = ValidationUtil.validateAndConvertRequest(
                "11AC_W11AC01", W11AC01Form.class, req, validationName);
        context.abortIfInvalid();
        return context.createObject();
    }

    private static final String[] SEARCH_CONDITION_PROPS = {
        "loginId", "kanjiName", "kanaName", "ugroupId", "userIdLocked", "pageNumber", "sortId"
    };

    // 【説明】精査対象プロパティのゲッターを追加
    public String[] getSearchConditionProps() {
        return SEARCH_CONDITION_PROPS;
    }

    @ValidateFor("search")
    public static void validateForSearch(ValidationContext<W11AC01Form> context) {
        ValidationUtil.validate(context, SEARCH_CONDITION_PROPS);
        if (!context.isValid()) return;
        W11AC01Form form = context.createObject();
        if (!form.isValidSearchCondition()) {
            context.addMessage("MSG00006");
        }
    }

    private boolean isValidSearchCondition() {
        return StringUtil.hasValue(
            getLoginId(), getKanjiName(), getKanaName(), getUgroupId(), getUserIdLocked());
    }
}
```

`validate()`メソッドは`ValidationUtil.validateAndConvertRequest`でリクエストを精査・変換し、`context.abortIfInvalid()`で精査エラー時に処理を中断、`context.createObject()`でFormオブジェクトを生成して返す。

- [データベースアクセス処理を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.html)
- [データベースアクセス処理の実例を知りたい時](./DB/01_DbAccessSpec_Example.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

ListSearchInfo, W11AC01FormBase, W11AC01Form, @PropertyName, @Required, @NumberRange, @Digits, @ValidateFor, pageNumber, sortId, 検索条件バリデーション, ValidationUtil, ValidationContext, StringUtil, データベースアクセス, カスタムタグ, 一覧表示, 参照先

</details>

## Javaオブジェクトのフィールドの値をバインド変数に設定する機能

`DbAccessSupport#getParameterizedSqlStatement`で`ParameterizedSqlPStatement`を取得することで、Javaオブジェクトのフィールド値をバインド変数に一括設定できる。

使用手順:
1. `DbAccessSupport#getParameterizedSqlStatement`を使用して`ParameterizedSqlPStatement`を取得する（`SqlPStatement`は使用しない）
2. SQL文のバインド変数は`?`ではなく`:フィールド名`形式で記述する
3. `ParameterizedSqlPStatement#retrieve`の引数にJavaオブジェクトのインスタンスを渡す（`:フィールド名`に対応するフィールドの値が自動設定される）

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, SqlPStatement, DbAccessSupport, getParameterizedSqlStatement, retrieve, バインド変数設定, フィールド値バインド

</details>

## 条件が可変のSQL文を組み立てる機能

指定したフィールドの値がnullまたは空文字の場合は検索条件から除外し、値がある場合のみ検索条件を組み込む機能。`DbAccessSupport#getParameterizedSqlStatement`実行時に引き渡すオブジェクトのフィールド値によって条件の組み込みが判断される。

```sql
WHERE $if (loginId) {LOGIN_ID = :loginId}
```

上記の例では、引き渡すオブジェクトの`loginId`フィールドがnullまたは空文字でない場合のみ`LOGIN_ID = :loginId`が検索条件に組み込まれる。実際に`:loginId`に設定される値は、`ParameterizedSqlPStatement#retrieve`実行時に引き渡すオブジェクトの`loginId`フィールドの値となる。

<details>
<summary>keywords</summary>

$if, 可変条件SQL, 動的WHERE句, nullチェック, 条件付き検索

</details>

## LIKE検索を簡易的に実装できる機能

SQL文に`:%フィールド名%`形式で記述することでLIKE検索を実現できる。エスケープ処理の実装およびJavaコードでの`%`付加が不要。

```sql
WHERE USR.KANJI_NAME LIKE :%kanjiName%
```

上記の例では、`ParameterizedSqlPStatement#retrieve`実行時に引き渡すオブジェクトの`kanjiName`フィールドの値で中間一致検索を行う。エスケープ処理は自動で行われ、`%`をJavaコードで付加する必要はない。

<details>
<summary>keywords</summary>

LIKE検索, 中間一致検索, エスケープ処理, ParameterizedSqlPStatement

</details>

## ORDER BY句を動的に変更する機能

`$sort`構文でORDER BY句を動的に切り替える機能。SQL実行時、指定したフィールドの値に対応するORDER BY条件が自動的に組み込まれる。

```sql
$sort (sortId) {
  (loginId_asc    SA.LOGIN_ID)
  (loginId_desc   SA.LOGIN_ID DESC)
  (kanjiName_asc  USR.KANJI_NAME, SA.LOGIN_ID)
  (kanjiName_desc USR.KANJI_NAME DESC, SA.LOGIN_ID)
  (kanaName_asc   USR.KANA_NAME, SA.LOGIN_ID)
  (kanaName_desc  USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

`$sort (フィールド名) {(値 ORDER BY条件) ...}` 形式で定義する。例えば`sortId = loginId_desc`の場合、`ORDER BY SA.LOGIN_ID DESC`が適用される。

<details>
<summary>keywords</summary>

$sort, ORDER BY動的変更, 並び替え, sortId

</details>
