# 検索結果の一覧表示

## 提供パッケージ

提供パッケージ: `resources/META-INF/tags/listSearchResult`

## 検索結果件数

`useResultCount`属性がtrue（デフォルト: true）かつ検索結果がリクエストスコープに存在する場合に表示される。

**デフォルト書式**:
```jsp
検索結果 <%-- ListSearchInfoのresultCountプロパティ --%>件
```

`resultCountFragment`属性にJSPフラグメントを指定することでカスタマイズ可能。JSPフラグメント内では`listSearchInfoName`属性で指定した名前でListSearchInfoオブジェクトにアクセスできる。

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                    resultSetName="searchResult">
    <jsp:attribute name="resultCountFragment">
       [サーチ結果 <n:write name="searchCondition.resultCount" />頁]
    </jsp:attribute>
</nbs:listSearchResult>
```

## 検索結果の並び替え

検索結果の並び替えは、:ref:`ListSearchResult_ListSearchSortSubmitTag` と可変ORDER BY構文（ORDER BY句を動的に変更する構文）を組み合わせて実現する。

### 検索処理の実装

SQL文に可変ORDER BY構文を定義する。`$sort (sortId)` により、検索条件オブジェクトの `sortId` フィールドの値でORDER BY句が決定される（例: sortIdが `kanaName_asc` の場合、`ORDER BY USR.KANA_NAME, SA.LOGIN_ID` に変換）。

```sql
SELECT -- 省略
FROM   -- 省略
WHERE  -- 省略
$sort (sortId) {
   (kanjiName_asc  USR.KANJI_NAME, SA.LOGIN_ID)
   (kanjiName_desc USR.KANJI_NAME DESC, SA.LOGIN_ID)
   (kanaName_asc   USR.KANA_NAME, SA.LOGIN_ID)
   (kanaName_desc  USR.KANA_NAME DESC, SA.LOGIN_ID) }
```

**クラス**: `ListSearchInfo` はsortIdプロパティを持つ。並び替えを使用する場合、`sortId` を入力精査対象に含めること。

```java
public class W11AC01SearchForm extends ListSearchInfo {
    public W11AC01SearchForm(Map<String, Object> params) {
        // 検索条件プロパティ設定省略
        setSortId((String) params.get("sortId"));
    }

    @PropertyName("ソートID")
    @Required
    public void setSortId(String sortId) {
        super.setSortId(sortId);
    }

    private static final String[] SEARCH_COND_PROPS = new String[] { ..., "sortId" };

    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }
}
```

### listSearchSortSubmitタグ

並び替え用サブミット要素を出力するタグ。全属性については :ref:`ListSearchResult_ListSearchSortSubmitTag` を参照。

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| sortCss | | nablarch_sort | サブミットのclass属性（常に出力） |
| ascCss | | nablarch_asc | 昇順時に付加するclass属性（出力例: class="nablarch_sort nablarch_asc"） |
| descCss | | nablarch_desc | 降順時に付加するclass属性（出力例: class="nablarch_sort nablarch_desc"） |
| ascSortId | ○ | | 昇順ソートID |
| descSortId | ○ | | 降順ソートID |
| defaultSort | | asc | デフォルトのソート方向（asc/desc） |
| label | ○ | | サブミットのラベル |
| name | ○ | | タグのname属性（画面内で一意にすること） |
| listSearchInfoName | ○ | | リクエストスコープからListSearchInfoを取得する名前 |

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                    resultSetName="searchResult"
                    usePageNumberSubmit="true"
                    useLastSubmit="true">
    <jsp:attribute name="headerRowFragment">
        <tr>
            <th>
                <nbs:listSearchSortSubmit ascSortId="kanjiName_asc" descSortId="kanjiName_desc"
                                        label="漢字氏名" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                                        name="kanjiNameSort" listSearchInfoName="11AC_W11AC01" />
            </th>
        </tr>
    </jsp:attribute>
</nbs:listSearchResult>
```

並び替えサブミット要素の動作:
- ウィンドウスコープで検索条件を維持する
- 常に先頭ページ（ページ番号:1）で検索する（並び替え変更後は旧ページ番号が意味を持たないため）

**現在の並び替え状態に応じたタグの動作**（実装例: ascSortId="kanjiName_asc", descSortId="kanjiName_desc"）:

| 現在のソートID | リクエスト送信するソートID | 使用されるCSSクラス |
|---|---|---|
| kanjiName_asc | kanjiName_desc（descSortId属性値を使用） | nablarch_asc（ascCss属性値） |
| kanjiName_desc | kanjiName_asc（ascSortId属性値を使用） | nablarch_desc（descCss属性値） |
| 上記以外 | kanjiName_asc（defaultSort=ascのためascSortId属性値） | なし |

**昇順/降順に応じたCSSの実装例**（CSSクラス名はデフォルト値で定義）:

```css
/* sortCss: 常に出力 */
a.nablarch_sort {
    padding-right: 15px;
    background-position: 100% 0%;
    background-repeat: no-repeat;
}
/* ascCss: サブミット要素が選択され昇順の場合のみ出力 */
a.nablarch_asc {
    background-image: url("../img/asc.jpg");
}
/* descCss: サブミット要素が選択され降順の場合のみ出力 */
a.nablarch_desc {
    background-image: url("../img/desc.jpg");
}
```

検索処理の設定はリポジトリ機能の環境設定ファイルに指定する。

| プロパティ名 | 説明 | デフォルト値 |
|---|---|---|
| nablarch.listSearch.maxResultCount | 検索結果の最大件数(上限) | 200 |
| nablarch.listSearch.max | 検索結果の取得最大件数(1ページの表示件数) | 20 |

ListSearchInfo生成時にリポジトリから設定値を取得する。リポジトリ未設定の場合は上記デフォルト値が使用される。

個別機能のみ設定値を変更する場合:
- 画面表示: JSP上で:ref:`ListSearchResult_Tag`の属性を指定
- ページング検索処理: ActionメソッドでListSearchInfoを継承したクラスに値を設定

```java
public class W11AC01Action extends DbAccessSupport {
    private static final int MAX_ROWS = 10;
    private static final int MAX_RESULT_COUNT = 50;

    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        W11AC01SearchForm condition = ...;
        condition.setMax(MAX_ROWS);
        condition.setMaxResultCount(MAX_RESULT_COUNT);
    }
}
```

<details>
<summary>keywords</summary>

listSearchResult, タグファイル, 提供パッケージ, resources/META-INF/tags, useResultCount, resultCountFragment, listSearchInfoName, ListSearchInfo, 検索結果件数, nbs:listSearchResult, sortId, listSearchSortSubmit, listSearchSortSubmitTag, 可変ORDER BY構文, 検索結果並び替え, ascSortId, descSortId, defaultSort, W11AC01SearchForm, nablarch_sort, nablarch_asc, nablarch_desc, @Required, @PropertyName, nablarch.listSearch.maxResultCount, nablarch.listSearch.max, 検索結果最大件数, ページング表示件数, デフォルト値設定, 一覧検索設定, DbAccessSupport, @OnError

</details>

## 概要

listSearchResultタグファイルは以下の機能を提供する:

- 検索結果件数の表示
- 全件一覧表示（1画面）
- ページング（指定件数毎に表示）
- 検索結果の並び替え

## ページング

`usePaging`属性がtrue（デフォルト: true）の場合に表示される。ページング全体は検索結果件数が1件以上の場合に表示される。

**ページング画面要素の表示条件**:

| 画面要素 | 表示条件 |
|---|---|
| 現在のページ番号 | 常に表示 |
| 最初・前へ・次へ・最後 | 遷移可能な場合はサブミット可能状態で表示、遷移不可の場合はラベル（リンク）または使用不可（ボタン）で表示 |
| ページ番号 | 総ページ数が2以上の場合のみ表示 |

**ページング時の検索条件**: ページング時は前回検索時の条件（現在表示中の検索結果を取得した時の条件）を使用する。検索条件を変更後にページングを行っても、変更した検索条件は破棄される。

検索条件の維持はウィンドウスコープで実現する。**検索条件と検索結果一覧を一つの画面に配置する場合、検索条件フォームと検索結果一覧フォームを分けて実装する必要がある。**

**検索結果減少時の動作**: 指定されたページ番号に基づき検索を実施し、ページングの各画面要素を表示する。例: 3ページ目表示中に検索結果が10件に減少し2ページ目を選択した場合、「2/1ページ」と表示されるが、サブミット要素は遷移可否に応じた状態（「最初」「前へ」はリンク、「次へ」「最後」はラベル）で表示され、操作不能にはならない。その後「前へ」を選択すると、現在のページ番号と総ページ数の対応が正常な状態に戻る。

設定可能な主な属性（詳細は :ref:`ListSearchResult_Tag` を参照）:
- 各画面要素の使用有無
- 各画面要素のラベル（最初・前へ・次へ・最後など）
  - 現在のページ番号はJSPフラグメントによる変更
  - ページ番号はページ番号をラベルに使用するため変更不可
- 各サブミット要素のタグ種別（`n:submitLink`、`n:submit`、`n:button`のいずれか）

## 1画面にすべての検索結果を一覧表示する場合の実装方法

ページングなしで全件表示する場合、基本的な実装はページングを使用する場合と同じ。検索処理や並び替えの実装も同様。

**ページングとの相違点**:
- `pageNumber` プロパティの設定不要（初期値は1のため常に1ページ目）
- `SEARCH_COND_PROPS` に `pageNumber` を含めない（検索条件プロパティのみ）
- Actionクラスで `setMax(getMaxResultCount())` の設定が必須

```java
// Actionクラス
W11AC01SearchForm condition = searchConditionCtx.createObject();
// ページングを使用しないため、検索取得件数(1ページの表示件数)に最大件数(上限)を設定する（必須）
condition.setMax(condition.getMaxResultCount());
```

```java
public class W11AC01Action extends DbAccessSupport {

    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        // 業務処理は省略。
        W11AC01SearchForm condition = searchConditionCtx.createObject();
        condition.setMax(condition.getMaxResultCount());
        // 検索処理省略
    }
}
```

```jsp
<%-- ページングを使用しない: usePaging="false" を指定、searchUri属性は不要 --%>
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    usePaging="false"
                    resultSetName="searchResult">
    <%-- その他の属性は省略 --%>
</nbs:listSearchResult>
```

業務アプリケーションへサンプル実装(タグファイル)を取り込む手順:

1. 業務アプリケーションへタグファイルの配置
2. タグファイル内のプレフィックスの修正

<details>
<summary>keywords</summary>

検索結果一覧表示, ページング, 検索結果件数表示, 並び替え, listSearchResult, usePaging, ページ番号, ウィンドウスコープ, 検索条件, nbs:listSearchResult, n:submitLink, n:submit, n:button, ListSearchInfo, setMax, getMaxResultCount, ページングなし, 全件表示, W11AC01SearchForm, W11AC01Action, DbAccessSupport, ApplicationException, @OnError, HttpResponse, HttpRequest, ExecutionContext, タグファイル取り込み, サンプル実装, 業務アプリケーション, プレフィックス設定手順

</details>

## 構成

ページングを実現したい場合、フレームワークが提供するクラスとサンプル提供のタグファイルがページングに必要な処理を行うため、アプリケーションプログラマはページングを作り込みせずに実現できる。

フレームワーク提供クラス:

| クラス名 | 概要 |
|---|---|
| `DBAccessSupport` | 一覧検索用のsearchメソッドを提供するサポートクラス |
| `ListSearchInfo` | 一覧検索用の情報を保持するクラス |
| `TooManyResultException` | 検索結果件数が最大件数（上限）を超えた場合の例外 |

タグファイル:

| タグ名 | 概要 |
|---|---|
| `listSearchResult` | 検索結果の一覧表示 |
| `listSearchPaging` | ページングを出力 |
| `listSearchSubmit` | ページングのサブミット要素を出力 |
| `listSearchParams` | ページングのサブミット要素用の変更パラメータを出力 |
| `table` | テーブルを出力 |
| `listSearchSortSubmit` | ソート用のサブミット要素を出力 |

## 検索結果テーブル

**必須属性**:

| 属性名 | 説明 |
|---|---|
| resultSetName | 検索結果をリクエストスコープから取得する際に使用する名前 |
| headerRowFragment | ヘッダ行のJSPフラグメント |
| bodyRowFragment | ボディ行のJSPフラグメント |

ヘッダ行（`headerRowFragment`属性）とボディ行（`bodyRowFragment`属性）にJSPフラグメントで指定する。検索結果がリクエストスコープに存在する場合は常に表示される。検索結果が0件の場合はヘッダ行のみ表示される。

ボディ行のJSPフラグメントはJSTLの`c:forEach`ループ内で評価される。行データとステータスにアクセスするための属性:

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| varRowName | `row` | 行データ（c:forEachのvar属性）の変数名 |
| varStatusName | `status` | ステータス（c:forEachのstatus属性）の変数名 |
| varCountName | `count` | ステータスのcountプロパティの変数名 |
| varRowCountName | `rowCount` | 検索結果カウント（取得開始位置＋ステータスのカウント）の変数名 |

> **注意**: `n:write`タグでステータスにアクセスすると、`n:write`タグとEL式でアクセス方法が異なるためエラーが発生し値を取得できない。`n:set`タグを使用してステータスにアクセスすること。
>
> ```jsp
> <n:set var="rowCount" value="${status.count}" />
> <n:write name="rowCount" />
> ```

1行おきに背景色を変えるためのclass属性設定:

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| varOddEvenName | `oddEvenCss` | ボディ行のclass属性を参照する変数名 |
| oddValue | `nablarch_odd` | 奇数行に使用するclass属性値 |
| evenValue | `nablarch_even` | 偶数行に使用するclass属性値 |

**JSP指定例**:

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                      searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                      resultSetName="searchResult">
    <jsp:attribute name="headerRowFragment">
        <tr>
            <th>ログインID</th>
            <th>漢字氏名</th>
            <th>カナ氏名</th>
            <th>グループ</th>
            <th>内線番号</th>
            <th>メールアドレス</th>
        </tr>
    </jsp:attribute>
    <jsp:attribute name="bodyRowFragment">
        <tr class="<n:write name='oddEvenCss' />">
            <td>[<n:write name="count" />]<br/>[<n:write name="rowCount" />]<br/><n:write name="row.loginId" /></td>
            <td><n:write name="row.kanjiName" /></td>
            <td><n:write name="row.kanaName" /></td>
            <td><n:write name="row.ugroupId" />:<n:write name="row.ugroupName" /></td>
            <td><n:write name="row.extensionNumberBuilding" />-<n:write name="row.extensionNumberPersonal" /></td>
            <td><n:write name="row.mailAddress" /></td>
        </tr>
    </jsp:attribute>
</nbs:listSearchResult>
```

## デフォルトの検索条件で検索した結果を初期表示する場合の実装方法

初期表示でデフォルト条件による検索結果を表示する場合、検索条件がリクエストパラメータとして送信されないため、ウィンドウスコープに検索条件が存在しない状態となる。アクションの初期表示処理でデフォルト検索条件をウィンドウスコープに設定する実装が必要。JSPなどアクション以外の実装は通常のページングを使用する場合と変わらない。

ウィンドウスコープへの設定は共通処理として `ListSearchInfoUtil.setDefaultCondition()` ユーティリティを使用する。

```java
public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
    // デフォルト検索条件を設定
    W11AC01SearchForm condition = new W11AC01SearchForm();
    condition.setUserIdLocked("0");
    condition.setSortId("kanjiName_asc");
    condition.setDate("20130703");
    condition.setMoney(BigDecimal.valueOf(123456789.12d));

    // デフォルト検索条件を入力フォームに表示するためリクエストスコープに設定
    ctx.setRequestScopedVar("11AC_W11AC01", condition);

    // ページングでデフォルト検索条件を使用するためウィンドウスコープに設定（必須）
    ListSearchInfoUtil.setDefaultCondition(req, "11AC_W11AC01", condition);

    // 検索実行
    SqlResultSet searchResult;
    try {
        searchResult = selectByCondition(condition);
    } catch (TooManyResultException e) {
        throw new ApplicationException(MessageUtil.createMessage(MessageLevel.ERROR, "MSG00035", e.getMaxResultCount()));
    }

    ctx.setRequestScopedVar("searchResult", searchResult);
    ctx.setRequestScopedVar("resultCount", condition.getResultCount());

    return new HttpResponse("/ss11AC/W11AC0101.jsp");
}
```

`listSearchResult`パッケージを業務アプリケーションに配置する。

- コピー元: `META-INF/tags/listSearchResult`
- コピー先: 業務アプリケーションの `/WEB-INF/tags` ディレクトリ

<details>
<summary>keywords</summary>

DBAccessSupport, ListSearchInfo, TooManyResultException, listSearchResult, listSearchPaging, listSearchSubmit, listSearchParams, listSearchSortSubmit, table, クラス構成, resultSetName, headerRowFragment, bodyRowFragment, varRowName, varStatusName, varCountName, varRowCountName, varOddEvenName, oddValue, evenValue, nbs:listSearchResult, 検索結果一覧表示, ボディ行フラグメント, 奇数偶数行スタイル, n:write, n:set, ListSearchInfoUtil, setDefaultCondition, ウィンドウスコープ, デフォルト検索条件, 初期表示, W11AC01SearchForm, SqlResultSet, ApplicationException, MessageUtil, MessageLevel, HttpResponse, HttpRequest, ExecutionContext, META-INF/tags, WEB-INF/tags, タグファイル配置, サンプル実装取り込み

</details>

## 使用方法

**クラス**: `DbAccessSupport`

`search(SQL_ID, ListSearchInfo)` の動作:
1. SQL_IDとListSearchInfoから検索結果件数を取得
2. 件数が上限超過の場合は`TooManyResultException`を送出
3. 上限以下の場合は検索を実行し結果を返す。件数はListSearchInfoに設定

> **注意**: SQL_IDには通常の検索SELECT文を指定する。件数取得・開始位置・取得件数の指定はフレームワークが処理する。

`TooManyResultException`は最大件数と実際の取得件数を保持する。上限設定は :ref:`ListSearchResult_Setting` 参照。

```java
SqlResultSet searchResult = null;
try {
    searchResult = search("SELECT_USER_BY_CONDITION", condition);
} catch (TooManyResultException e) {
    throw new ApplicationException(
        MessageUtil.createMessage(MessageLevel.ERROR, "MSG00024", e.getMaxResultCount()));
}
```

サンプル実装のタグファイルはプレフィックスに「nbs」を使用している。`/WEB-INF/tags/listSearchResult`に配置した場合のプレフィックス修正内容:

修正前:
```jsp
<%@ taglib prefix="nbs" uri="http://tis.co.jp/nablarch-biz-sample" %>
```
プレフィックス: `nbs`

修正後:
```jsp
<%@ taglib prefix="listSearchResult" tagdir="/WEB-INF/tags/listSearchResult" %>
```
プレフィックス: `listSearchResult`

<details>
<summary>keywords</summary>

DbAccessSupport, search, TooManyResultException, SQL_ID, ページング検索, 検索処理実装, ApplicationException, SqlResultSet, MessageUtil, nbs, listSearchResult, taglib prefix, プレフィックス修正, tagdir, WEB-INF/tags/listSearchResult

</details>

## ListSearchInfoクラス

**クラス**: `ListSearchInfo`

業務アプリケーションの検索条件クラスはListSearchInfoを継承する。

ListSearchInfoを継承するクラスの必須実装:
- `pageNumber`（取得対象ページ番号）を入力精査に含める

アクションの必須実装:
- ListSearchInfoを継承したクラスのオブジェクトをリクエストスコープに設定する

```java
public class W11AC01SearchForm extends ListSearchInfo {
    // バリデーション機能に対応したコンストラクタ
    public W11AC01SearchForm(Map<String, Object> params) {
        setPageNumber((Integer) params.get("pageNumber"));
    }
    
    @PropertyName("ページ番号")
    @Required
    @NumberRange(max = 10, min = 1)
    @Digits(integer = 2)
    public void setPageNumber(Integer pageNumber) {
        super.setPageNumber(pageNumber);
    }
    
    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS; // pageNumberを含む
    }
}
```

アクション側:
```java
ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
searchConditionCtx.abortIfInvalid();

UserSearchCondition condition = searchConditionCtx.createObject();
ctx.setRequestScopedVar("11AC_W11AC01", condition); // ListSearchInfoを継承したオブジェクトをリクエストスコープに設定

SqlResultSet searchResult = null;
try {
    searchResult = search("SELECT_USER_BY_CONDITION", condition);
} catch (TooManyResultException e) {
    throw new ApplicationException(
        MessageUtil.createMessage(MessageLevel.ERROR, "MSG00024", e.getMaxResultCount()));
}
ctx.setRequestScopedVar("searchResult", searchResult); // 検索結果をリクエストスコープに設定
```

| タグ | 機能 |
|---|---|
| :ref:`ListSearchResult_Tag` (listSearchResultタグ) | 検索結果の一覧表示 |
| :ref:`ListSearchResult_ListSearchSortSubmitTag` (listSearchSortSubmitタグ) | 検索結果の一覧表示で並び替え対応の列見出し出力 |

## listSearchSortSubmitタグ属性

| 属性 | 必須 | 説明 | デフォルト値 |
|---|---|---|---|
| tag | | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| type | | type属性。submit/button（submitLinkの場合は使用しない） | |
| sortCss | | サブミットのclass属性（常に出力） | nablarch_sort |
| ascCss | | 昇順時に付加するclass属性（例: class="nablarch_sort nablarch_asc"） | nablarch_asc |
| descCss | | 降順時に付加するclass属性（例: class="nablarch_sort nablarch_desc"） | nablarch_desc |
| ascSortId | ○ | 昇順ソートID | |
| descSortId | ○ | 降順ソートID | |
| defaultSort | | デフォルトのソート。asc(昇順)/desc(降順) | asc |
| label | ○ | ラベル | |
| name | ○ | name属性（画面内で一意にすること） | |
| listSearchInfoName | ○ | ListSearchInfoをリクエストスコープから取得する際に使用する名前 | |

<details>
<summary>keywords</summary>

ListSearchInfo, pageNumber, 検索条件クラス, リクエストスコープ, ページング, @PropertyName, @Required, @NumberRange, @Digits, SqlResultSet, ValidationContext, UserSearchCondition, listSearchResultタグ, listSearchSortSubmitタグ, ascSortId, descSortId, sortCss, ascCss, descCss, 並び替え, 列見出し, listSearchInfoName

</details>

## listSearchResultタグ

`listSearchResult`タグは検索結果のリスト表示を行うタグ（:ref:`ListSearchResult_Tag` 参照）。

> **注意**: `resultSetName`属性で指定された検索結果がリクエストスコープに存在しない場合、listSearchResultタグは何も出力しない（検索画面の初期表示ケースに該当）。

listSearchResultタグの全体属性:

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| listSearchInfoName | ListSearchInfoをリクエストスコープから取得する際に使用する名前。指定がない場合は「検索結果件数」および「ページング」を表示しない。一括削除確認画面など一覧表示のみの場合は指定しない。 | |
| listSearchResultWrapperCss | ページング付きテーブル全体(検索結果件数、ページング、検索結果)をラップするdivタグのclass属性 | nablarch_listSearchResultWrapper |

<details>
<summary>keywords</summary>

listSearchResult, resultSetName, 一覧表示タグ, 検索結果, listSearchInfoName, listSearchResultWrapperCss, ListSearchInfo, リクエストスコープ, ページング付きテーブル全体

</details>

## 全体

| 属性 | 説明 |
|---|---|
| `listSearchInfoName` | ListSearchInfoをリクエストスコープから取得する名前。未指定の場合は「検索結果件数」と「ページング」を表示しない。一括削除確認画面など一覧表示のみの場合は指定しない。 |

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useResultCount | 検索結果件数を表示するか否か | true |
| resultCountCss | 検索結果件数をラップするdivタグのclass属性 | nablarch_resultCount |
| resultCountFragment | 検索結果件数を出力するJSPフラグメント | "検索結果 <PagingInfoのresultCountプロパティ>件" |

<details>
<summary>keywords</summary>

listSearchInfoName, ListSearchInfo, 検索結果件数表示, ページング表示制御, useResultCount, resultCountCss, resultCountFragment, PagingInfo

</details>

## 検索結果件数

| 属性 | デフォルト | 説明 |
|---|---|---|
| `useResultCount` | true | 検索結果件数を表示するか否か |

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| usePaging | ページングを表示するか否か | true |
| searchUri | ページングのサブミット要素に使用するURI。ページング表示時は必須。 | |
| pagingPosition | ページングの表示位置。top(上側のみ)/bottom(下側のみ)/both(両方)/none(表示なし) | top |
| pagingCss | ページングのサブミット要素全体をラップするdivタグのclass属性 | nablarch_paging |

<details>
<summary>keywords</summary>

useResultCount, 検索結果件数, listSearchResult属性, usePaging, searchUri, pagingPosition, pagingCss, ページング表示, top, bottom, both, none

</details>

## ページング

| 属性 | 必須 | デフォルト | 説明 |
|---|---|---|---|
| `usePaging` | | true | ページングを表示するか否か |
| `searchUri` | ○ | | ページングのサブミット要素に使用するURI。ページングを表示する場合は必須。 |

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useCurrentPageNumber | 現在のページ番号を使用するか否か | true |
| currentPageNumberCss | 現在のページ番号をラップするdivタグのclass属性 | nablarch_currentPageNumber |
| currentPageNumberFragment | 現在のページ番号を出力するJSPフラグメント | "[<PagingInfoのcurrentPageNumberプロパティ>/<PagingInfoのpageCountプロパティ>ページ]" |

<details>
<summary>keywords</summary>

usePaging, searchUri, ページング表示, サブミットURI, useCurrentPageNumber, currentPageNumberCss, currentPageNumberFragment, PagingInfo, ページ番号表示

</details>

## 最初

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useFirstSubmit | 最初のページに遷移するサブミットを使用するか否か | false |
| firstSubmitTag | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| firstSubmitType | type属性。submit/button（submitLinkの場合は使用しない） | |
| firstSubmitCss | ラップするdivタグのclass属性 | nablarch_firstSubmit |
| firstSubmitLabel | ラベル | 最初 |
| firstSubmitName | name属性。ページング表示位置サフィックス付き（上側: _top、下側: _bottom）。例: firstSubmit_top | firstSubmit |

<details>
<summary>keywords</summary>

useFirstSubmit, firstSubmitTag, firstSubmitType, firstSubmitCss, firstSubmitLabel, firstSubmitName, 最初のページ遷移

</details>

## 前へ

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| usePrevSubmit | 前のページに遷移するサブミットを使用するか否か | true |
| prevSubmitTag | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| prevSubmitType | type属性。submit/button（submitLinkの場合は使用しない） | |
| prevSubmitCss | ラップするdivタグのclass属性 | nablarch_prevSubmit |
| prevSubmitLabel | ラベル | 前へ |
| prevSubmitName | name属性。ページング表示位置サフィックス付き。例: prevSubmit_top | prevSubmit |

<details>
<summary>keywords</summary>

usePrevSubmit, prevSubmitTag, prevSubmitType, prevSubmitCss, prevSubmitLabel, prevSubmitName, 前のページ遷移

</details>

## ページ番号(ページ番号をラベルとして使用するためラベル指定がない)

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| usePageNumberSubmit | ページ番号のページに遷移するサブミットを使用するか否か | false |
| pageNumberSubmitTag | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| pageNumberSubmitType | type属性。submit/button（submitLinkの場合は使用しない） | |
| pageNumberSubmitCss | ラップするdivタグのclass属性 | nablarch_pageNumberSubmit |
| pageNumberSubmitName | name属性。ページ番号と表示位置サフィックス付き。例: pageNumberSubmit3_top | pageNumberSubmit |

<details>
<summary>keywords</summary>

usePageNumberSubmit, pageNumberSubmitTag, pageNumberSubmitType, pageNumberSubmitCss, pageNumberSubmitName, ページ番号遷移

</details>

## 次へ

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useNextSubmit | 次のページに遷移するサブミットを使用するか否か | true |
| nextSubmitTag | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| nextSubmitType | type属性。submit/button（submitLinkの場合は使用しない） | |
| nextSubmitCss | ラップするdivタグのclass属性 | nablarch_nextSubmit |
| nextSubmitLabel | ラベル | 次へ |
| nextSubmitName | name属性。ページング表示位置サフィックス付き。例: nextSubmit_top | nextSubmit |

<details>
<summary>keywords</summary>

useNextSubmit, nextSubmitTag, nextSubmitType, nextSubmitCss, nextSubmitLabel, nextSubmitName, 次のページ遷移

</details>

## 最後

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useLastSubmit | 最後のページに遷移するサブミットを使用するか否か | false |
| lastSubmitTag | Nablarchタグ。submitLink(aタグ)/submit(inputタグ)/button(buttonタグ) | submitLink |
| lastSubmitType | type属性。submit/button（submitLinkの場合は使用しない） | |
| lastSubmitCss | ラップするdivタグのclass属性 | nablarch_lastSubmit |
| lastSubmitLabel | ラベル | 最後 |
| lastSubmitName | name属性。ページング表示位置サフィックス付き。例: lastSubmit_top | lastSubmit |

<details>
<summary>keywords</summary>

useLastSubmit, lastSubmitTag, lastSubmitType, lastSubmitCss, lastSubmitLabel, lastSubmitName, 最後のページ遷移

</details>

## 検索結果

| 属性 | 必須 | 説明 | デフォルト値 |
|---|---|---|---|
| resultSetName | ○ | 検索結果をリクエストスコープから取得する際に使用する名前 | |
| resultSetCss | | 検索結果テーブルのclass属性 | nablarch_resultSet |
| headerRowFragment | ○ | ヘッダ行のJSPフラグメント | |
| bodyRowFragment | ○ | ボディ行のJSPフラグメント | |
| varRowName | | ボディ行フラグメントで行データ(c:forEachタグのvar属性)を参照する変数名 | row |
| varStatusName | | ボディ行フラグメントでステータス(c:forEachタグのstatus属性)を参照する変数名 | status |
| varCountName | | ステータスのcountプロパティを参照する変数名 | count |
| varRowCountName | | 検索結果のカウント(取得開始位置＋ステータスのカウント)を参照する変数名 | rowCount |
| varOddEvenName | | ボディ行のclass属性を参照する変数名（奇数/偶数行でclass変更する場合に使用） | oddEvenCss |
| oddValue | | ボディ行の奇数行に使用するclass属性 | nablarch_odd |
| evenValue | | ボディ行の偶数行に使用するclass属性 | nablarch_even |

> **注意**: `n:write`タグでステータスにアクセスするとEL式とのアクセス方法の違いによりエラーが発生する。`n:set`タグを使用すること。
> ```jsp
> <n:set var="rowCount" value="${status.count}" />
> <n:write name="rowCount" />
> ```

<details>
<summary>keywords</summary>

resultSetName, resultSetCss, headerRowFragment, bodyRowFragment, varRowName, varStatusName, varCountName, varRowCountName, varOddEvenName, oddValue, evenValue, n:set, n:write

</details>
