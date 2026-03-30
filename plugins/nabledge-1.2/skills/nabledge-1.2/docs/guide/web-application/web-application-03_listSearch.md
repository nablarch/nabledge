# 一覧検索

**公式ドキュメント**: [一覧検索]()

## 本項で説明する内容

## 本項で説明する内容

作成対象ファイル:

| ファイル | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC01Action.java](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC01Action.java) | Action | ユーザ一覧照会の検索条件に一致する情報をDBから取得し、結果をリクエストスコープに格納してJSPに遷移 |
| [W11AC0101.jsp](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC0101.jsp) | View | ユーザ一覧照会画面に検索結果を表示 |

SQLファイル: [W11AC01Action.sql](../../../knowledge/guide/web-application/assets/web-application-03_listSearch/W11AC01Action.sql)

ステレオタイプ: :ref:`stereoType` を参照。

**クラス**: `W11AC01Action`（`DbAccessSupport` を継承）

**SQL (`W11AC01Action.sql`)**:

```sql
SELECT_USER_BY_CONDITION = 
SELECT
  SA.LOGIN_ID, SA.USER_ID, SA.USER_ID_LOCKED,
  USR.KANJI_NAME, USR.KANA_NAME, USR.MAIL_ADDRESS,
  USR.EXTENSION_NUMBER_BUILDING, USR.EXTENSION_NUMBER_PERSONAL,
  UGRP.UGROUP_ID, UGRP.UGROUP_NAME
FROM USERS USR
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
    (1 SA.LOGIN_ID)
    (2 SA.LOGIN_ID DESC)
    (3 USR.KANJI_NAME, SA.LOGIN_ID)
    (4 USR.KANJI_NAME DESC, SA.LOGIN_ID)
    (5 USR.KANA_NAME, SA.LOGIN_ID)
    (6 USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

**Java (`W11AC01Action.java`)**:

```java
public class W11AC01Action extends DbAccessSupport {
    private SqlResultSet selectByCondition(W11AC01SearchForm condition) {
        return search("SELECT_USER_BY_CONDITION", condition);
    }
}
```

- `$if (field) {condition}`: conditionオブジェクトの該当フィールドがnullでも空文字でもない場合のみ、`{}`内を検索条件に組み込む
- `LIKE :%field%`: LIKE検索時のエスケープ処理および`%`付加のJavaコードは不要
- `$sort (sortId)`: `sortId`の値に応じてORDER BY句を動的に変更

> **注意**: [03_field](#s3) を明示的に使用する場合、`getParameterizedSqlStatement`の第2引数と`statement.retrieve`の引数に同じインスタンスを渡すこと。異なるインスタンスを渡すと意図した条件で検索が行われない。

明示使用時の実装例:

```java
ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
        "SELECT_USER_BY_CONDITION", condition);
return statement.retrieve(condition);
```

<details>
<summary>keywords</summary>

W11AC01Action, W11AC0101.jsp, W11AC01Action.sql, 一覧検索, ユーザ一覧照会, DbAccessSupport, SqlResultSet, ParameterizedSqlPStatement, W11AC01SearchForm, 動的SQL構築, LIKE検索, 動的ORDER BY, 条件可変SQL

</details>

## 作成手順

## 検索条件を保持するForm(SearchForm)の作成

- Formクラスには、画面から入力する値や精査処理（単項目精査・項目間精査）を実装する
- **`ListSearchInfo`** クラスを継承することで、ページングや検索結果の並び替えを容易に実現できる

**クラス**: `W11AC01Action`  
**アノテーション**: `@OnError`

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    ValidationContext<W11AC01SearchForm> searchConditionCtx =
        ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
    if (!searchConditionCtx.isValid()) {
        throw new ApplicationException(searchConditionCtx.getMessages());
    }
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

<details>
<summary>keywords</summary>

ListSearchInfo, SearchForm, W11AC01SearchForm, ページング, 並び替え, 検索条件フォーム, W11AC01Action, HttpRequest, HttpResponse, ExecutionContext, ValidationContext, TooManyResultException, @OnError, 検索実行, ApplicationException, ValidationUtil, MessageUtil, MessageLevel

</details>

## Formクラスの作成

## Formクラスの作成

`ListSearchInfo` を継承した場合、使用する機能によって実装を追加する必要がある。

- `setPageNumber` のオーバーライドが必要。`@NumberRange` で想定するページ範囲を設定する
- `setSortId` のオーバーライドが必要。検索結果の並び替えで使用する
- 精査対象プロパティ（`getSearchConditionProps()` の戻り値）に `ListSearchInfo` のプロパティ（pageNumber、sortId）も含める

```java
public class W11AC01SearchForm extends ListSearchInfo {
    private String loginId;
    private String kanjiName;
    private String kanaName;
    private String ugroupId;
    private String userIdLocked;

    public W11AC01SearchForm(Map<String, Object> params) {
        loginId = (String) params.get("loginId");
        kanjiName = (String) params.get("kanjiName");
        kanaName = (String) params.get("kanaName");
        ugroupId = (String) params.get("ugroupId");
        userIdLocked = (String) params.get("userIdLocked");
        setPageNumber((Integer) params.get("pageNumber"));
        setSortId((String) params.get("sortId"));
    }

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

    private static final String[] SEARCH_COND_PROPS =
        new String[] {"loginId", "kanjiName", "kanaName", "ugroupId", "userIdLocked", "pageNumber", "sortId"};

    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }

    @ValidateFor("search")
    public static void validateForSearch(ValidationContext<W11AC01SearchForm> context) {
        ValidationUtil.validate(context, SEARCH_COND_PROPS);
        if (!context.isValid()) { return; }
        String loginId = (String) context.getConvertedValue("loginId");
        String kanjiName = (String) context.getConvertedValue("kanjiName");
        String kanaName = (String) context.getConvertedValue("kanaName");
        String ugroupId = (String) context.getConvertedValue("ugroupId");
        String userIdLocked = (String) context.getConvertedValue("userIdLocked");
        if (!isValidSearchCondition(loginId, kanjiName, kanaName, ugroupId, userIdLocked)) {
            context.addMessage("MSG00006");
        }
    }
}
```

検索結果はリスト-マップ（検索結果の1レコードを表すMapを要素とするList）で取得できるが、検索結果一覧表示用のカスタムタグを使用しているためJSP内でループ処理を行わない。詳細は :ref:`custom_tag_paging` 参照。

> **警告**: 値の出力には `n:write` タグを使用すること。EL式はサニタイジング処理を行わないため、EL式で直接出力しないこと。

<details>
<summary>keywords</summary>

ListSearchInfo, W11AC01SearchForm, @PropertyName, @Required, @NumberRange, @Digits, @ValidateFor, ValidationContext, ValidationUtil, setPageNumber, setSortId, getSearchConditionProps, SEARCH_COND_PROPS, リスト-マップ, カスタムタグ, n:writeタグ, XSS防止, ループ処理, 検索結果一覧表示, サニタイジング, W11AC0101.jsp

</details>

## Javaオブジェクトのフィールドの値をバインド変数に設定する機能

## Javaオブジェクトのフィールドの値をバインド変数に設定する機能

> **注意**: ビジネスロジックが他の処理では使用しない場合、ComponentクラスではなくActionクラスに作成する。

`SqlPStatement` の代わりに `ParameterizedSqlPStatement` を使用することで、Javaオブジェクトのフィールド値をバインド変数に一括設定できる。

手順:
1. プリペアドステートメント取得に `DbAccessSupport#getParameterizedSqlStatement` を使用（`ParameterizedSqlPStatement` を取得）
2. SQLのバインド変数は `?` ではなく `:フィールド名` で指定
3. `ParameterizedSqlPStatement#retrieve` の引数にJavaオブジェクトを渡すと、`:フィールド名` に対応するフィールドの値が自動設定される

- [データベースアクセス処理を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.html)
- [データベースアクセス処理の実例を知りたい時](./DB/01_DbAccessSpec_Example.html)
- [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)

<details>
<summary>keywords</summary>

ParameterizedSqlPStatement, SqlPStatement, DbAccessSupport, getParameterizedSqlStatement, retrieve, バインド変数, フィールド名バインド, データベースアクセス, カスタムタグ, 一覧表示

</details>

## 条件が可変のSQL文を組み立てる機能

## 条件が可変のSQL文を組み立てる機能

フィールドの値がnullまたは空文字("")の場合は検索条件から除外し、nullでも空文字でもない場合のみ検索条件に組み込む。

SQL構文: `$if (フィールド名) { 検索条件 }`

```sql
-- loginIdフィールドの値がnullまたは空文字でない場合のみ、WHERE句に組み込まれる
WHERE $if (loginId) {LOGIN_ID = :loginId}
```

- 条件に組み込むかの判断: `DbAccessSupport#getParameterizedSqlStatement` 実行時に渡すオブジェクトのフィールド値による
- `:loginId` に設定される実際の値: `ParameterizedSqlPStatement#retrieve` 実行時に渡すオブジェクトの loginId フィールドの値

<details>
<summary>keywords</summary>

$if, 可変条件, 動的WHERE句, null判定, 空文字判定, 検索条件除外

</details>

## LIKE検索を簡易的に実装できる機能

## LIKE検索を簡易的に実装できる機能

- LIKE条件に設定する文字列のエスケープ処理を実装する必要がない
- Javaコードで条件に `%` を付加する必要がない（`%` はSQL文に記述する）

中間一致検索のSQL構文: `LIKE :%フィールド名%`

```sql
-- kanjiNameフィールドの値で中間一致検索（Javaでのエスケープ処理や%付加は不要）
WHERE USR.KANJI_NAME LIKE :%kanjiName%
```

<details>
<summary>keywords</summary>

LIKE検索, 中間一致, エスケープ不要, :%fieldName%, 部分一致検索

</details>

## ORDER BY句を動的に変更する機能

## ORDER BY句を動的に変更する機能

SQL構文: `$sort (フィールド名) { (値 ORDER BY条件) ... }`

フィールドの値に対応するORDER BY条件が自動的に組み込まれる。

```sql
-- sortIdフィールドの値でORDER BY句を切り替える（例: sortId=2の場合、SA.LOGIN_ID DESC が指定される）
$sort (sortId) {
    (1 SA.LOGIN_ID)
    (2 SA.LOGIN_ID DESC)
    (3 USR.KANJI_NAME, SA.LOGIN_ID)
    (4 USR.KANJI_NAME DESC, SA.LOGIN_ID)
    (5 USR.KANA_NAME, SA.LOGIN_ID)
    (6 USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

<details>
<summary>keywords</summary>

$sort, ORDER BY, 動的ソート, sortId, 並び替え切り替え

</details>
