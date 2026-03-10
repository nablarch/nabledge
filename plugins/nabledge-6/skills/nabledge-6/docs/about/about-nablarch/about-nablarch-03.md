# 検索結果の一覧表示

## 提供パッケージ

提供パッケージ: `resources/META-INF/tags/listSearchResult`

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-list-search-result)

## 概要

:ref:`universal_dao` の検索機能と連携する一覧表示タグファイルが提供する機能:

1. 検索結果件数の表示
2. 検索結果を指定件数毎に表示するページング機能

![一覧画面の出力例](../../knowledge/about/about-nablarch/assets/about-nablarch-03/ListSearchResult_Example.jpg)

## 構成

ページングの実現に必要なクラスとタグファイルの構成。アプリケーションプログラマはページングを作り込みせずに実現できる。

**フレームワーク提供クラス**:

| クラス名 | 概要 |
|---|---|
| UniversalDao | 汎用的なDAO機能を提供するクラス。基本的な使い方は :ref:`universal_dao` を参照。 |
| ListSearchInfo | 一覧検索用の情報を保持する抽象クラス。 |
| Pagination | ListSearchInfoを継承した具象クラス。 |
| EntityList | ユニバーサルDAOから返される結果リストの保持クラス。 |

**タグファイル**:

| タグ名 | 概要 |
|---|---|
| listSearchResult | 検索結果の一覧表示を行うタグ。 |
| listSearchPaging | ページングを出力するタグ。 |
| listSearchSubmit | ページングのサブミット要素を出力するタグ。 |
| table | テーブルを出力するタグ。 |

## UniversalDaoクラス

`UniversalDao` は複数件の検索結果をEntityListとして返すAPIを持つ。ページング機能の使用は :ref:`universal_dao-paging` を参照。

## ListSearchInfoクラス

`ListSearchInfo` は一覧検索用情報を保持する抽象クラス。ページネーションのページ数・検索条件一致件数などのフィールドおよびアクセッサメソッドを定義。

## Paginationクラス

**クラス**: `Pagination` はListSearchInfoを継承し、ページネーション情報の参照に使用される。

## EntityListクラス

**クラス**: `EntityList` はUniversalDaoから返される結果リストの保持クラス。`java.util.ArrayList` を継承し、`Pagination` インスタンスをフィールドに持つ。

## listSearchResultタグ

:ref:`ListSearchResult_Tag` は検索結果リストを表示するタグ。

> **注意**: `resultSetName` 属性で指定された検索結果がリクエストスコープに存在しない場合、listSearchResultタグは何も出力しない（検索画面の初期表示が何も出力されないケースに該当）。

![listSearchResultタグの出力画面要素](../../knowledge/about/about-nablarch/assets/about-nablarch-03/ListSearchResult_PagingTableFull.jpg)

全属性の詳細は :ref:`ListSearchResult_Tag` を参照。

## 全体

| 属性 | 説明 |
|---|---|
| searchFormName | 検索フォームをリクエストスコープから取得する際の名前。検索条件とページング用ページ番号を保持。一覧表示のみの場合（一括削除確認画面等）は指定不要。 |

## 検索結果件数

| 属性 | デフォルト値 | 説明 |
|---|---|---|
| useResultCount | true | 検索結果件数を表示するか否か |

検索結果件数はuseResultCount=true（デフォルト）かつリクエストスコープに検索結果が存在する場合に表示される。

デフォルト書式: `検索結果 <paginationのresultCountプロパティ>件`

デフォルト書式を変更する場合はresultCountFragment属性にJSPフラグメントを指定する：

```jsp
<app:listSearchResult resultSetName="searchResult" useResultCount="true">
    <jsp:attribute name="resultCountFragment">
      [サーチ結果 <n:write name="searchResult.pagination.resultCount" />件]
    </jsp:attribute>
</app:listSearchResult>
```

上記指定後の書式: `[サーチ結果 <paginationのresultCountプロパティ>件]`

属性：

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| useResultCount | true | 検索結果件数を表示するか否か |
| resultCountCss | "nablarch_resultCount" | 検索結果件数をラップするdivタグのclass属性 |
| resultCountFragment | | 検索結果件数を出力するJSPフラグメント |

検索結果件数は、useResultCount属性にtrue（デフォルトはtrue）が指定され、検索結果がリクエストスコープに存在する場合に表示される。

デフォルトの書式:

```jsp
検索結果 <%-- paginationのresultCountプロパティ --%>件
```

デフォルトの書式を変更する場合は、resultCountFragment属性にJSPフラグメントを指定する:

```jsp
<app:listSearchResult resultSetName="searchResult" useResultCount="true">

   <%-- resultCountFragment属性にJSPフラグメントを指定する。 --%>
   <jsp:attribute name="resultCountFragment">
     [サーチ結果 <n:write name="searchResult.pagination.resultCount" />件]
   </jsp:attribute>

</app:listSearchResult>
```

上記指定後の書式:

```jsp
[サーチ結果 <%-- paginationのresultCountプロパティ --%>件]
```

## ページング

| 属性 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| usePaging |  | true | ページングを表示するか否か |
| searchUri | ○ |  | ページングのサブミット要素に使用するURI。ページングを表示する場合は必ず指定すること。 |

ページングはusePaging=true（デフォルト）の場合に表示される。

searchFormNameで指定するフォームは `pageNumber` という名前でページ番号を受け取るよう実装すること：

```java
public class ProjectSearchForm {
    @Required
    @Domain("pageNumber")
    private String pageNumber;
    public String getPageNumber(){ return this.pageNumber; }
    public void setPageNumber(String pageNumber){ this.pageNumber = pageNumber; }
}
```

ページング全体は検索結果件数が1件以上の場合に表示される。ページングの画面要素：

| 画面要素 | 表示条件 |
|---|---|
| 現在のページ番号 | useCurrentPageNumber=trueの場合 |
| 最初・前へ・次へ・最後 | 遷移可能な場合はサブミット、不可の場合はラベルで表示 |
| ページ番号（1..n） | 総ページ数が2以上の場合のみ表示 |

**ページング時の検索条件**: 検索条件をパラメータにセットしたURIをsearchUri属性に渡す：

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags/listSearchResult" %>
<c:url value="/action/project/list" var="uri" context="/">
    <c:param name="searchForm.projectName" value="${searchForm.projectName}"/>
</c:url>
<app:listSearchResult resultSetName="searchResult" searchUri="${uri}" ...>
```

**ページング中に検索結果が減少した場合**: 指定されたページ番号に基づき検索を実施し各画面要素を表示する。現在のページ番号とサブミット要素の対応が取れており操作不能な状態にならない。

属性：

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| usePaging | true | ページングを表示するか否か |
| pagingPosition | top | ページングの表示位置。top（上側のみ）/ bottom（下側のみ）/ both（両方）/ none（表示なし） |
| pagingCss | "nablarch_paging" | ページングのサブミット要素全体をラップするdivタグのclass属性 |
| searchUri | | ページングのサブミット要素に使用するURI。ページングを表示する場合は必ず指定すること |

ページングは、usePaging属性にtrue（デフォルトはtrue）が指定された場合に表示される。

ページング機能を使用する場合、searchFormNameで指定するフォームが **pageNumber** という名前でページ番号を受け取るよう実装すること:

```java
public class ProjectSearchForm {

  @Required
  @Domain("pageNumber")
  private String pageNumber;

  public String getPageNumber() {
    return this.pageNumber;
  }

  public void setPageNumber(String pageNumber) {
    this.pageNumber = pageNumber;
  }

  // その他の属性は省略。
}
```

**ページングの画面要素**

ページングは、現在のページ番号とページを移動するためのサブミット要素から構成される。
ページング全体は、検索結果件数が **1件以上** の場合に表示される。

| ページングの画面要素 | 説明 |
|---|---|
| 現在のページ番号 | useCurrentPageNumber属性にtrueを指定した場合に表示される |
| 最初、前へ、次へ、最後 | 現在のページ番号から各画面要素が示すページに遷移可能な場合はサブミット可能な状態で表示される。遷移不可の場合はラベルで表示される |
| ページ番号 | ページ番号全体（1..n）は、総ページ数が2以上の場合のみ表示される |

**ページング時の検索条件**

ページング時の検索条件は、検索条件をパラメータにセットしたURIを組み立て、searchUri属性に渡すことで実現できる:

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags/listSearchResult" %>

<%-- 現在の検索結果の表示に使用した検索条件をパラメータとして持つURIを登録する。 --%>
<c:url value="/action/project/list" var="uri" context="/">
   <%-- 検索フォームから取得したプロジェクト名をセットする。 --%>
   <c:param name="searchForm.projectName" value="${searchForm.projectName}"/>
</c:url>

<%-- searchUri属性に渡す。 --%>
<app:listSearchResult resultSetName="searchResult" searchUri="${uri}" ... />
```

**ページング使用時に検索結果が減少した場合の動作**

本フレームワークでは、指定されたページ番号に基づき検索を実施し、ページングの各画面要素を表示する。
例: 検索結果が44件で3ページ目を選択中に、検索結果が10件に減少した状態で「前へ」を選択した場合（1ページの表示件数20件）:

| ページングの画面要素 | 表示内容の説明 |
|---|---|
| 現在のページ番号 | 2ページ目が指定され、検索結果が20件以下のため、2/1ページとなる |
| 最初、前へ | 現在2ページ目で検索結果が10件のため、前のページに遷移可能となりリンクで表示される |
| 次へ、最後 | 現在2ページ目で検索結果が10件のため、次のページに遷移不可となりラベルで表示される |
| ページ番号 | 検索結果が10件で総ページ数が1のため、ページ番号は表示されない |

現在のページ番号とサブミット要素の対応が取れているため操作不能な状態にならず、サブミット要素を選択することで検索結果のページに遷移可能である。

## 検索結果

検索結果タグの主要属性：

| 属性名 | 必須 | 説明 |
|---|---|---|
| resultSetName | ○ | `EntityList` をリクエストスコープから取得する名前。ページネーション情報（ページ数・件数等）も含む |
| headerRowFragment | | ヘッダ行のJSPフラグメント（:ref:`ListSearchResult_TableElement` 参照） |
| bodyRowFragment | | ボディ行のJSPフラグメント（:ref:`ListSearchResult_TableElement` 参照） |

検索結果はヘッダ行（headerRowFragment）とボディ行（bodyRowFragment）で構成される。検索結果が0件の場合はヘッダ行のみ表示される。ボディ行フラグメントはJSTLの `c:forEach` タグのループ内で呼び出される。

ボディ行フラグメントで行データ・ステータスにアクセスするための属性：

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| varRowName | "row" | 行データ（c:forEachのvar属性）を参照する変数名 |
| varStatusName | "status" | ステータス（c:forEachのstatus属性）を参照する変数名 |
| varCountName | "count" | ステータスのcountプロパティを参照する変数名 |
| varRowCountName | "rowCount" | 検索結果のカウント（取得開始位置＋ステータスのcount）を参照する変数名 |

> **補足**: n:writeタグでステータスにアクセスするとn:writeとEL式のアクセス方法の違いによりエラーが発生する。n:setタグを使用してステータスにアクセスすること。例: `<n:set var="rowCount" value="${status.count}" /><n:write name="rowCount" />`

1行おきの背景色変更用属性：

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| varOddEvenName | "oddEvenCss" | ボディ行のclass属性を参照する変数名 |
| oddValue | "nablarch_odd" | 奇数行のclass属性値 |
| evenValue | "nablarch_even" | 偶数行のclass属性値 |

JSP指定例（プロジェクト検索、タグファイルプレフィックスは `app`）：

```jsp
<app:listSearchResult resultSetName="searchResult">
    <jsp:attribute name="headerRowFragment">
        <tr>
            <th>プロジェクトID</th>
            <th>プロジェクト名</th>
            <th>プロジェクト種別</th>
            <th>開始日</th>
            <th>終了日</th>
        </tr>
    </jsp:attribute>
    <jsp:attribute name="bodyRowFragment">
        <tr class="info">
            <td>
                <n:a href="/action/project/show/${row.projectId}">
                    <n:write name="row.projectId"/>
                </n:a>
            </td>
            <td><n:write name="row.projectName" /></td>
            <td>
                <c:forEach var="projectType" items="<%= ProjectType.values() %>">
                    <c:if test="${projectType.code == row.projectType}">
                        <n:write name="projectType.label" />
                    </c:if>
                </c:forEach>
            </td>
            <td><n:write value="${n:formatByDefault('dateTime', row.projectStartDate)}" /></td>
            <td><n:write value="${n:formatByDefault('dateTime', row.projectEndDate)}" /></td>
        </tr>
    </jsp:attribute>
</app:listSearchResult>
```

## 全体ラッパーCSS

全体ラッパーCSSに関する属性：

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| listSearchResultWrapperCss | "nablarch_listSearchResultWrapper" | ページング付きテーブル全体（検索結果件数・ページング・検索結果）をラップするdivタグのclass属性 |

## 検索結果

検索結果は、検索結果がリクエストスコープに存在する場合は常に表示される。**検索結果が0件の場合は、ヘッダ行のみ表示される。**

ヘッダ行とボディ行はheaderRowFragment属性、bodyRowFragment属性にJSPフラグメントで指定する。ボディ行のJSPフラグメントは、検索結果のループ内（JSTLのc:forEachタグ）で呼び出され評価される。

ボディ行で行データ・ステータスにアクセスするための属性:

| 属性名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| resultSetName | ○ | | ユニバーサルDAOの検索結果（EntityList）をリクエストスコープから取得する際に使用する名前。ページネーション情報（ページ数・検索件数）も含む |
| headerRowFragment | | | ヘッダ行のJSPフラグメント |
| bodyRowFragment | | | ボディ行のJSPフラグメント |
| varRowName | | "row" | ボディ行のフラグメントで行データ（c:forEachのvar属性）を参照する変数名 |
| varStatusName | | "status" | ボディ行のフラグメントでステータス（c:forEachのstatus属性）を参照する変数名 |
| varCountName | | "count" | ステータスのcountプロパティを参照する変数名 |
| varRowCountName | | "rowCount" | 検索結果のカウント（取得開始位置＋ステータスのカウント）を参照する変数名 |
| varOddEvenName | | "oddEvenCss" | ボディ行のclass属性を参照する変数名（1行おきにclass属性を変更する際に使用） |
| oddValue | | "nablarch_odd" | ボディ行の奇数行に使用するclass属性 |
| evenValue | | "nablarch_even" | ボディ行の偶数行に使用するclass属性 |

> **補足**: varStatusNameで指定した変数にn:writeタグでアクセスすると、n:writeタグとEL式でアクセス方法が異なるためエラーが発生し値を取得できない。n:setタグを使用すること:
> ```jsp
> <n:set var="rowCount" value="${status.count}" />
> <n:write name="rowCount" />
> ```

プロジェクト検索の指定例（タグファイルのプレフィックスは app）:

```jsp
<app:listSearchResult resultSetName="searchResult">

   <%-- ヘッダ行のJSPフラグメント指定。 --%>
   <jsp:attribute name="headerRowFragment">
       <tr>
           <th>プロジェクトID</th>
           <th>プロジェクト名</th>
           <th>プロジェクト種別</th>
           <th>開始日</th>
           <th>終了日</th>
       </tr>
   </jsp:attribute>

   <%-- ボディ行のJSPフラグメント指定。 --%>
   <jsp:attribute name="bodyRowFragment">
       <tr class="info">
           <td>
               <%-- デフォルトの変数名"row"を使用して行データにアクセスする --%>
               <n:a href="/action/project/show/${row.projectId}">
                   <n:write name="row.projectId"/>
               </n:a>
           </td>
           <td><n:write name="row.projectName" /></td>
           <td>
               <c:forEach var="projectType" items="<%= ProjectType.values() %>">
                   <c:if test="${projectType.code == row.projectType}">
                       <n:write name="projectType.label" />
                   </c:if>
               </c:forEach>
           </td>
           <td><n:write value="${n:formatByDefault('dateTime', row.projectStartDate)}" /></td>
           <td><n:write value="${n:formatByDefault('dateTime', row.projectEndDate)}" /></td>
       </tr>
   </jsp:attribute>
</app:listSearchResult>
```

検索結果の表示に関する属性:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| showResult | | true | 検索結果を表示するか否か |
| resultSetName | 必須 | | ユニバーサルDAOの検索結果（nablarch.common.dao.EntityList）をリクエストスコープから取得する際に使用する名前。検索結果にはページネーションのためのページ数や検索条件に一致した件数なども含まれる |
| resultSetCss | | "nablarch_resultSet" | 検索結果テーブルのclass属性 |
| headerRowFragment | | | ヘッダ行のJSPフラグメント |
| bodyRowFragment | | | ボディ行のJSPフラグメント |
| varRowName | | "row" | ボディ行のフラグメントで行データ（c:forEachタグのvar属性）を参照する際に使用する変数名 |
| varStatusName | | "status" | ボディ行のフラグメントでステータス（c:forEachタグのstatus属性）を参照する際に使用する変数名 |
| varCountName | | "count" | ステータス（c:forEachタグのstatus属性）のcountプロパティを参照する際に使用する変数名 |
| varRowCountName | | "rowCount" | 検索結果のカウント（検索結果の取得開始位置＋ステータスのカウント）を参照する際に使用する変数名 |
| varOddEvenName | | "oddEvenCss" | ボディ行のclass属性を参照する際に使用する変数名。1行おきにclass属性の値を変更したい場合に使用する |
| oddValue | | "nablarch_odd" | ボディ行の奇数行に使用するclass属性 |
| evenValue | | "nablarch_even" | ボディ行の偶数行に使用するclass属性 |

**注意: varStatusName の使用について**

n:writeタグを使用してステータスにアクセスすると、n:writeタグとEL式でアクセス方法が異なるためにエラーが発生し値を取得できない。n:setタグを使用してステータスにアクセスすることで、このエラーを回避できる。

```jsp
<n:set var="rowCount" value="${status.count}" />
<n:write name="rowCount" />
```

## 業務アプリケーションへのサンプル実装(タグファイル)の取り込み方法

listSearchResultパッケージを業務アプリケーションに配置する：

- コピー元: `META-INF/tags/listSearchResult`
- コピー先: 業務アプリケーションの `/WEB-INF/tags` ディレクトリ

## タグリファレンス

listSearchResultタグは検索結果の一覧表示（検索結果件数、ページング、検索結果テーブル）を行う。

![ページング＋テーブル全体構成](../../knowledge/about/about-nablarch/assets/about-nablarch-03/ListSearchResult_PagingTableFull.jpg)

**全体属性**

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| listSearchResultWrapperCss | "nablarch_listSearchResultWrapper" | ページング付きテーブル全体（検索結果件数、ページング、検索結果）をラップするdivタグのclass属性 |
| searchFormName | | 検索フォームをリクエストスコープから取得する際に使用する名前。検索フォームは検索条件とページングのためのページ番号を保持する。一括削除確認画面など一覧表示のみを行う場合は指定しない |

**検索結果件数属性**

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| useResultCount | true | 検索結果件数を表示するか否か |
| resultCountCss | "nablarch_resultCount" | 検索結果件数をラップするdivタグのclass属性 |
| resultCountFragment | | 検索結果件数を出力するJSPフラグメント。デフォルトは「検索結果 <paginationのresultCountプロパティ>件」 |

**ページング属性**

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| usePaging | true | ページングを表示するか否か |
| pagingPosition | top | ページングの表示位置。top（上側のみ）/ bottom（下側のみ）/ both（両方）/ none（表示なし）のいずれかを指定する |
| pagingCss | "nablarch_paging" | ページングのサブミット要素全体をラップするdivタグのclass属性 |
| searchUri | | ページングのサブミット要素に使用するURI。**ページングを表示する場合は必ず指定すること** |

## 現在のページ番号

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| useCurrentPageNumber | true | 現在のページ番号を使用するか否か |
| currentPageNumberCss | "nablarch_currentPageNumber" | 現在のページ番号をラップするdivタグのclass属性 |
| currentPageNumberFragment | | 現在のページ番号を出力するJSPフラグメント。デフォルト: "[paginationのpageNumberプロパティ/paginationのpageCountプロパティ ページ]" |

## 最初

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| useFirstSubmit | false | 最初のページに遷移するサブミットを使用するか否か |
| firstSubmitCss | "nablarch_firstSubmit" | 最初のページに遷移するサブミットをラップするdivタグのclass属性 |
| firstSubmitLabel | "最初" | 最初のページに遷移するサブミットのラベル |
| firstSubmitName | "firstSubmit" | 最初のページに遷移するサブミットのname属性。表示位置サフィックス（上側は"_top"、下側は"_bottom"）が付与される。例: デフォルトかつ上側の場合は"firstSubmit_top" |

## 前へ

| 属性名 | デフォルト値 | 説明 |
|---|---|---|
| usePrevSubmit | true | 前のページに遷移するサブミットを使用するか否か |
| prevSubmitCss | "nablarch_prevSubmit" | 前のページに遷移するサブミットをラップするdivタグのclass属性 |
| prevSubmitLabel | "前へ" | 前のページに遷移するサブミットのラベル |
| prevSubmitName | "prevSubmit" | 前のページに遷移するサブミットのname属性。表示位置サフィックス（上側は"_top"、下側は"_bottom"）が付与される。例: デフォルトかつ上側の場合は"prevSubmit_top" |

## ページ番号(ページ番号をラベルとして使用するためラベル指定がない)

ページング（ページ番号）の属性:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| usePageNumberSubmit | | false | ページ番号のページに遷移するサブミットを使用するか否か |
| pageNumberSubmitCss | | "nablarch_pageNumberSubmit" | ページ番号のページに遷移するサブミットをラップするdivタグのclass属性 |
| pageNumberSubmitName | | "pageNumberSubmit" | ページ番号のページに遷移するサブミットに使用するタグのname属性。ページ番号とページングの表示位置を表すサフィックス（上側は"_top"、下側は"_bottom"）を付けて出力する。例：表示位置が上側でページ番号が3の場合は"pageNumberSubmit3_top" |

## 次へ

ページング（次へ）の属性:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useNextSubmit | | true | 次のページに遷移するサブミットを使用するか否か |
| nextSubmitCss | | "nablarch_nextSubmit" | 次のページに遷移するサブミットをラップするdivタグのclass属性 |
| nextSubmitLabel | | "次へ" | 次のページに遷移するサブミットに使用するラベル |
| nextSubmitName | | "nextSubmit" | 次のページに遷移するサブミットに使用するタグのname属性。ページングの表示位置を表すサフィックス（上側は"_top"、下側は"_bottom"）を付けて出力する。例：表示位置が上側の場合は"nextSubmit_top" |

## 最後

ページング（最後）の属性:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| useLastSubmit | | false | 最後のページに遷移するサブミットを使用するか否か |
| lastSubmitCss | | "nablarch_lastSubmit" | 最後のページに遷移するサブミットをラップするdivタグのclass属性 |
| lastSubmitLabel | | "最後" | 最後のページに遷移するサブミットに使用するラベル |
| lastSubmitName | | "lastSubmit" | 最後のページに遷移するサブミットに使用するタグのname属性。ページングの表示位置を表すサフィックス（上側は"_top"、下側は"_bottom"）を付けて出力する。例：表示位置が上側の場合は"lastSubmit_top" |
