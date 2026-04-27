# 一覧検索

## 本項で説明する内容

### 説明内容

本項では、以下の内容を説明する。

* 条件を指定した一覧検索処理
* 一覧検索結果を表示するJSPの作成方法

### 作成内容

本項で作成するのは、下記画面遷移図の赤丸の部分である。

![screenTransition.png](../../../knowledge/assets/web-application-03-listSearch/screenTransition.png)

編集するソースコードは以下のとおり。

| 名称(右クリック->保存でダウンロード) | ステレオタイプ | 処理内容 |
|---|---|---|
| [W11AC01Action.java](../../../knowledge/assets/web-application-03-listSearch/W11AC01Action.java) | Action | ユーザ一覧照会画面で指定された検索条件に一致する情報を、データベースから取得する。 結果をリクエストスコープに格納し、JSPに遷移させる。  本クラスから使用するSQLファイルは、下記リンク先のファイルを参照すること。 (右クリック->保存でダウンロード)  [W11AC01Action.sql](../../../knowledge/assets/web-application-03-listSearch/W11AC01Action.sql) |
| [W11AC0101.jsp](../../../knowledge/assets/web-application-03-listSearch/W11AC0101.jsp) | View | ユーザ一覧照会画面に検索結果を表示する。 |

ステレオタイプについては [業務コンポーネントの責務配置](../../about/about-nablarch/about-nablarch-01-NablarchOutline.md#stereotype) を参照。

## 作成手順

### 検索条件を保持するForm(SearchForm)の作成

検索条件を保持するFormクラスを新規に作成する。
Formクラスには、画面から入力する値や取引で必要となる精査処理(単項目精査や項目間精査)を実装する。

この時、 **ListSearchInfo** クラスを継承することで、ページングや検索結果の並び替えを容易に実現できる。

> **Note:**
> ListSearchInfoクラスの詳細は、業務機能サンプルの解説書を参照。

> 全体構造:

> ```
> 業務共通機能サンプル実装＞検索結果の一覧表示＞構成
> ```

> 実装例:

> ```
> 業務共通機能サンプル実装＞検索結果の一覧表示＞ListSearchInfoクラス
> ```

> **Note:**
> 本項では、検索条件用のFormを作成する際に特に気をつける点について述べる。
> Form作成時の詳細な手順は [入力内容の精査](../../guide/web-application/web-application-04-validation.md#how-to-validate) を参照。

#### Formクラスの作成

ListSearchInfo を継承した場合、使用する機能によって実装を追加する必要がある。

> **Note:**
> ListSearchInfoを継承した実装の詳細は、業務機能サンプルの解説書を参照。

> ```
> 業務共通機能サンプル実装＞検索結果の一覧表示＞ListSearchInfoクラス
> ```

W11AC01SearchFormクラスを作成し、プロパティの追加および精査処理の実装を行った例を示す。

* W11AC01SearchForm.javaの内容

```java
/**
 * ユーザ検索の検索条件を表すクラス。
 */
public class W11AC01SearchForm extends ListSearchInfo {

    // 【説明】検索条件をプロパティに追加
    /** ログインID */
    private String loginId;

    /** 漢字氏名 */
    private String kanjiName;

    /** カナ氏名 */
    private String kanaName;

    /** グループID */
    private String ugroupId;

    /** ユーザIDロック */
    private String userIdLocked;

    /** システムアカウントテーブルの情報 */
    private SystemAccountEntity systemAccount;

    /**
     * コンストラクタ
     * @param params パラメータ
     */
    public W11AC01SearchForm(Map<String, Object> params) {
        // 【説明】検索条件の設定
        loginId = (String) params.get("loginId");
        kanjiName = (String) params.get("kanjiName");
        kanaName = (String) params.get("kanaName");
        ugroupId = (String) params.get("ugroupId");
        userIdLocked = (String) params.get("userIdLocked");
        systemAccount = (SystemAccountEntity) params.get("systemAccount");

        // 【説明】ListSearchInfoのプロパティへの設定
        setPageNumber((Integer) params.get("pageNumber"));
        setSortId((String) params.get("sortId"));
    }

    /**
     * デフォルトコンストラクタ
     */
    public W11AC01SearchForm() {

    }

    // 【説明】検索条件のセッター/ゲッターは省略

    /* 【説明】
        ListSearchInfoのpageNumberのセッターを追加。
        想定するページの範囲を@NumberRangeで設定。 */
    /**
     * ページ番号を設定する。
     * @param pageNumber ページ番号
     */
    @PropertyName("開始ページ")
    @Required
    @NumberRange(max = 10, min = 1)
    @Digits(integer = 2)
    public void setPageNumber(Integer pageNumber) {
        super.setPageNumber(pageNumber);
    }

    /* 【説明】
        ListSearchInfoのsortIdのセッターを追加。
        検索結果の並び替えで使用する。 */
    /**
     * ソートIDを設定する。
     * @param sortId ソートID
     */
    @PropertyName("ソートID")
    @Required
    public void setSortId(String sortId) {
        super.setSortId(sortId);
    }

    // 【説明】精査対象のプロパティに、ListSearchInfoのプロパティを設定
    /** 精査対象プロパティ */
    private static final String[] SEARCH_COND_PROPS =
        new String[] {"loginId", "kanjiName", "kanaName", "ugroupId", "userIdLocked", "pageNumber", "sortId"};

    // 【説明】精査対象プロパティのゲッターを追加
    /**
     * 検索条件の精査対象プロパティを返す。
     * @return 検索条件の精査対象プロパティ
     */
    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }

    /**
     * 検索条件を精査する。
     * @param context ValidationContext
     */
    @ValidateFor("search")
    public static void validateForSearch(ValidationContext<W11AC01SearchForm> context) {

        // 【説明】検索条件の精査処理はListSearchInfoによって変わらない

        // 単項目精査
        ValidationUtil.validate(context, SEARCH_COND_PROPS);
        if (!context.isValid()) {
            return;
        }

        // 項目間精査
        String loginId = (String) context.getConvertedValue("loginId");        // ログインID
        String kanjiName = (String) context.getConvertedValue("kanjiName");    // 漢字氏名
        String kanaName = (String) context.getConvertedValue("kanaName");      // カナ氏名
        String ugroupId = (String) context.getConvertedValue("ugroupId");      // グループID
        String userIdLocked = (String) context.getConvertedValue("userIdLocked");   // ユーザIDロック
        if (!isValidSearchCondition(loginId, kanjiName, kanaName, ugroupId, userIdLocked)) {
            context.addMessage("MSG00006");
        }
    }

    // ～中略～

}
```

### ビジネスロジック(Action)の作成

本処理では、アプリケーションフレームワークが持つデータベースアクセス機能の中から、以下のものを使用している。

* [Javaオブジェクトのフィールドの値をバインド変数に設定する機能](../../guide/web-application/web-application-03-listSearch.md#03-field)
* [条件が可変のSQL文を組み立てる機能](../../guide/web-application/web-application-03-listSearch.md#03-sql)
* [LIKE検索を簡易的に実装できる機能](../../guide/web-application/web-application-03-listSearch.md#03-like)
* [ORDER BY句を動的に変更する機能](../../guide/web-application/web-application-03-listSearch.md#03-orderby)

> **Note:**
> 本処理で使用するビジネスロジックは他の処理では使用しない。
> そのため、ComponentクラスではなくActionクラスに作成する。

#### Javaオブジェクトのフィールドの値をバインド変数に設定する機能

Javaオブジェクトのフィールドの値をバインド変数に設定する機能とは、SQL文のバインド変数ごとに一つ一つ値を設定するのではなく、オブジェクトを指定して、
そのフィールドの値をバインド変数に設定できる機能である。本機能は以下のように使用する。

プリペアドステートメントを作成する際に、SqlPStatementクラスではなく、ParameterizedSqlPStatementクラスを使用する(DbAccessSupport#getParameterizedSqlStatementを使用する)。

バインド変数は"?"ではなく、":フィールド名"とする。

ParameterizedSqlPStatement#retrieveの引数に、バインド変数に指定したフィールドを持つJavaオブジェクトのインスタンスを渡す。バインド変数には、対応するフィールドの値が設定される。

> **Note:**
> サンプルでは、本機能を含んだ [一覧検索用の検索処理](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#webview-listsearchresultdbaccesssupport) を用いて検索を行っている。
> 実例は [メソッドの実装](../../guide/web-application/web-application-03-listSearch.md#03-methodcreate) を参照。

#### 条件が可変のSQL文を組み立てる機能

条件が可変のSQL文を組み立てる機能とは、Webアプリケーションで多く見られる可変条件(画面で入力された場合のみ、検索条件に含める)のSQL文を、自動で生成できる機能である。
指定したフィールドの値がnullか空文字("")でない場合、検索条件に組み込み、nullか空文字の場合、検索条件から除外する。例えば、下記のソースコードは *"loginId"が
nullもしくは空文字でない* 場合に *LOGIN_ID = (入力された値)* という検索条件が組み込まれる。

loginIdがnullもしくは空文字かどうかの判断は、SQL文を組み立てる際(DbAccessSupport#getParameterizedSqlStatement実行時)の引数のオブジェクトに設定されているloginId
フィールドの値による。

```sql
-- 【説明】
--  SQL文を組み立てる際に渡されるオブジェクトのloginIdフィールドの値から
--  検索条件に組み込まれるかどうか判断される
--  (nullもしくは空文字でない場合に、{}内が検索条件に組み込まれる)
WHERE $if (loginId)   {LOGIN_ID = :loginId}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

実際に検索条件として:loginIdに設定される値は、検索実行(ParameterizedSqlPStatement#retrieve実行)時に引き渡すオブジェクトの、フィールドの値である(この例では、loginIdフィールドの値)。
実例は [メソッドの実装](../../guide/web-application/web-application-03-listSearch.md#03-methodcreate) を参照。

#### LIKE検索を簡易的に実装できる機能

LIKE検索を簡易的に実装できる機能とは、LIKE検索を実装する際に、下記のメリットを提供する機能である。
* アプリケーションプログラマは、LIKE条件に設定する文字列のエスケープ処理を実装する必要がない。
* Javaコードで条件に"%"を付加する必要がない("%"はSQL文に記述する)。

下記のソースコードは、検索実行(ParameterizedSqlPStatement#retrieve実行)時に引き渡すオブジェクトの、kanjiNameフィールドの値で中間一致検索を行っている。
エスケープ処理や、入力された検索条件に対する"%"を付加するJavaの処理は不要である。実例は [メソッドの実装](../../guide/web-application/web-application-03-listSearch.md#03-methodcreate) を参照。

```sql
-- 【説明】SQL文を実行する際に渡されるオブジェクトの"kanjiName"フィールドの値で中間一致検索
WHERE USR.KANJI_NAME LIKE :%kanjiName%
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

#### ORDER BY句を動的に変更する機能

ORDER BY句を動的に変更する機能とは、検索結果リストの列見出しによる並び替えを行う場合などに、SQL文を自動で生成できる機能である。
ORDER BY句の条件を指定するフィールドを *$sort (フィールド名)* で指定し、組み込みたい条件を *(値 条件)* の組み合わせで定義する。

本機能を使用したSQL文の実行時に、フィールド名に設定した値に対応する条件が自動的に組み込まれる。

```sql
-- 【説明】
--  SQL文を実行する際に渡されるオブジェクトの"sortId"フィールドの値で、実行するORDER BY句を切り替える。
--  例えば、sortId = 2 の場合、ORDER BY 句に SA.LOGIN_ID DESC が指定される。
$sort (sortId) {
    (1 SA.LOGIN_ID)
    (2 SA.LOGIN_ID DESC)
    (3 USR.KANJI_NAME, SA.LOGIN_ID)
    (4 USR.KANJI_NAME DESC, SA.LOGIN_ID)
    (5 USR.KANA_NAME, SA.LOGIN_ID)
    (6 USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

実例は [メソッドの実装](../../guide/web-application/web-application-03-listSearch.md#03-methodcreate) を参照。

#### メソッドの実装

[Javaオブジェクトのフィールドの値をバインド変数に設定する機能](../../guide/web-application/web-application-03-listSearch.md#03-field) 、 [条件が可変のSQL文を組み立てる機能](../../guide/web-application/web-application-03-listSearch.md#03-sql) 、 [LIKE検索を簡易的に実装できる機能](../../guide/web-application/web-application-03-listSearch.md#03-like) 、 [ORDER BY句を動的に変更する機能](../../guide/web-application/web-application-03-listSearch.md#03-orderby) を参考に、 *W11AC01Actionクラス* を作成し以下のメソッドを追加する。このメソッドの目的は、指定された検索条件に一致する情報を
データベースから取得することである。

このメソッドでは、条件が可変のSQL文を組み立てる機能、LIKE検索を簡易的に実装できる機能、ORDER BY句を動的に変更する機能を組み合わせて使っている。

* W11AC01Action.sqlの内容

```sql
--
-- 条件指定によるユーザ情報照会
--
SELECT_USER_BY_CONDITION =
SELECT
  SA.LOGIN_ID,
  SA.USER_ID,
  SA.USER_ID_LOCKED,
  USR.KANJI_NAME,
  USR.KANA_NAME,
  USR.MAIL_ADDRESS,
  USR.EXTENSION_NUMBER_BUILDING,
  USR.EXTENSION_NUMBER_PERSONAL,
  UGRP.UGROUP_ID,
  UGRP.UGROUP_NAME
FROM
    USERS USR
INNER JOIN
    UGROUP_SYSTEM_ACCOUNT USA
ON
    USR.USER_ID = USA.USER_ID
INNER JOIN
    SYSTEM_ACCOUNT SA
ON
    USR.USER_ID = SA.USER_ID
INNER JOIN
    UGROUP UGRP
ON
    UGRP.UGROUP_ID = USA.UGROUP_ID
WHERE
    -- 【説明】
    --  条件が可変のSQL文を組み立てる機能を利用。search実行時に引き渡されるオブジェクトに
    --  該当フィールドがあり、その値がnullでも空文字でなければ、({}内が)検索条件に組み込まれる。
    --  また、LIKE検索を簡易的に実装出来る機能も使用。LIKE検索時のエスケープ処理は不要
    $if (loginId) {SA.LOGIN_ID = :loginId}
    AND $if (kanjiName) {USR.KANJI_NAME LIKE :%kanjiName%}
    AND $if (kanaName) {USR.KANA_NAME  LIKE :%kanaName%}
    AND $if (ugroupId) {UGRP.UGROUP_ID = :ugroupId}
    AND $if (userIdLocked) {SA.USER_ID_LOCKED = :userIdLocked}
-- 【説明】
--  ORDER BY句を動的に変更する機能を利用。prepareParameterizedSqlStatement実行時に引き渡され
--  るオブジェクトに該当フィールドがあり、その値に応じた条件がORDER BY句に組み込まれる。
$sort (sortId) {
    (1 SA.LOGIN_ID)
    (2 SA.LOGIN_ID DESC)
    (3 USR.KANJI_NAME, SA.LOGIN_ID)
    (4 USR.KANJI_NAME DESC, SA.LOGIN_ID)
    (5 USR.KANA_NAME, SA.LOGIN_ID)
    (6 USR.KANA_NAME DESC, SA.LOGIN_ID)
}
```

* W11AC01Action.javaの内容

```java
// 【説明】
// DbAccessSupportクラスを継承する。
public class W11AC01Action extends DbAccessSupport {

    /**
     * 条件検索を行う。<br/>
     * 引数で検索条件を指定することにより条件検索ができる。<br/>
     * 検索条件を指定しない場合は、引数にnullまたは空文字を渡すようにする。<br/>
     * これにより、その引数に関する検索条件を外すことができる。<br/>
     *
     * @param condition 検索条件
     * @return 検索結果
     */
    private SqlResultSet selectByCondition(W11AC01SearchForm condition) {

        // 【説明】
        //  一覧検索の検索処理を行う。
        //  引数のconditionに設定されているフィールドの値に従って組み立てたSQL文を用いて検索を行う。
        //  SQL_IDには、上記のW11AC01Action.sqlで定義している「SELECT_USER_BY_CONDITION」を指定する。
        //  LIKE検索に対するエスケープや%を付加するJavaコードは不要
        return search("SELECT_USER_BY_CONDITION", condition);
    }
}

// ～後略～
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> [Javaオブジェクトのフィールドの値をバインド変数に設定する機能](../../guide/web-application/web-application-03-listSearch.md#03-field) を明示的に使用する場合、getParameterizedSqlStatementの第2引数(上記のサンプルではcondition)とretrieveの引数(同じくcondition)は、両方に同じインスタンスを渡すこと。
> そうしないと意図した条件で検索が行われない。その場合の実装例は、以下を参照。

> ```java
> public SqlResultSet selectWithCondition(SearchCondition condition) {
> 
>     // 【説明】引数のcondに設定されているフィールドの値に従ってSQL文を組み立て
>     // SQL_IDには、上記のW11AC01Action.sqlで定義している「SELECT_USER_BY_CONDITION」を指定する。
>     ParameterizedSqlPStatement statement = getParameterizedSqlStatement(
>             "SELECT_USER_BY_CONDITION", condition);
> 
>     // 【説明】
>     //  引数のcondのフィールドの値をSQLの条件の対応する場所(:フィールド名)に
>     //  設定して検索実行。LIKE検索に対するエスケープや%を付加するJavaコードは不要
>     return statement.retrieve(condition);
> }
> ```

### リクエストに対応するメソッドの作成

*W11AC01Actionクラス* に以下のメソッドを追加する。検索条件入力チェックは [入力内容の精査](../../guide/web-application/web-application-04-validation.md#how-to-validate) を参照。

```java
/**
 * ユーザ一覧照会結果を表示する。<br/>
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
@OnError(type = ApplicationException.class,
         path = "/ss11AC/W11AC0101.jsp")
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {

    // ～中略～

    // 検索条件入力チェック                                           // 【説明】検索条件入力チェックは後述
    ValidationContext<W11AC01SearchForm> searchConditionCtx =
        ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
    searchConditionCtx.abortIfInvalid();

    // ～中略～

    W11AC01SearchForm condition = searchConditionCtx.createObject();
    ctx.setRequestScopedVar("11AC_W11AC01", condition);

    // 検索実行
    SqlResultSet searchResult;
    try {
        searchResult = selectByCondition(condition);
    } catch (TooManyResultException e) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00035", e.getMaxResultCount()));
    }

    // 検索結果をリクエストスコープに設定
    ctx.setRequestScopedVar("searchResult", searchResult);
    ctx.setRequestScopedVar("resultCount", condition.getResultCount());

    // ～中略～

    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### View(JSP)の作成

以下の内容で *W11AC0101.jsp* を作成する。

検索結果はリスト-マップ(検索結果の1レコードを表すMapを要素とするList)で取得できるが、検索結果一覧表示用のカスタムタグを使用しているためJSP内でループ処理を行わない。

```./_source/03/W11AC0101.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

> **Note:**
> 本画面で使用している一覧表示用のカスタムタグも含め、検索結果の一覧表示を行う方法は、 [使用例集](../../guide/web-application/web-application-function.md#custom-tag-paging) を参照。

## 次に読むもの

* [データベースアクセス処理を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.html)
* [データベースアクセス処理の実例を知りたい時](./DB/01_DbAccessSpec_Example.html)
* [カスタムタグの使用方法を詳しく知りたい時](../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07_WebView.html)
