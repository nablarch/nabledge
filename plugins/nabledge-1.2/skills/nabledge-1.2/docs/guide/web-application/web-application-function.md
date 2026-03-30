# ファイルダウンロードの実現方法

## ファイルのダウンロード方法

ファイルダウンロードで使用するタグとユーティリティクラス:

**タグ**: `downloadSubmit`, `downloadButton`, `downloadLink`

**クラス**: `StreamResponse`, `DataRecordResponse`

`downloadButton` タグと `StreamResponse` クラスを使用する。

JSP:
```jsp
<n:downloadButton uri="/action/ss11AC/W11AC02Action/TempFile" name="tempFile">ダウンロード</n:downloadButton>
```

アクション:
```java
StreamResponse response = new StreamResponse(file, true);
// 第2引数: リクエスト処理終了時にファイルを削除する場合はtrue、削除しない場合はfalse (フレームワークが削除)
response.setContentType("text/plain; charset=UTF-8");
response.setContentDisposition(file.getName());
return response;
```

ファイルアップロードに使用するタグとクラス:
- **タグ**: `file`
- **クラス**: `PartInfo`, `UploadHelper`

## JSP実装

> **警告**: `<n:form>` タグに `enctype="multipart/form-data"` を必ず指定すること。

```jsp
<n:form enctype="multipart/form-data">
  <n:file name="userList" cssClass="input" size="50"/>
  <n:submit name="submit" type="submit" value="アップロード" uri="RW11AC0602"/>
</n:form>
```

## アップロードファイルの取得

```java
List<PartInfo> partInfoList = req.getPart("userList");

// ファイルがアップロードされていることを確認
if (partInfoList.isEmpty()) {
    throw new ApplicationException(
            MessageUtil.createMessage(MessageLevel.ERROR, "MSG00039"));
}
PartInfo partInfo = partInfoList.get(0);
```

> **注意**: 同一 `n:form` タグ内に同一 `name` 属性の `n:file` タグが複数ある場合、`partInfoList` には複数の `PartInfo` が含まれる。

## ファイルの保存

```java
UploadHelper helper = new UploadHelper(partInfo);
helper.moveFileTo("uploadFileSaveDir", fileName);  // 第1引数: 移動先論理パス名, 第2引数: 移動後ファイル名
```

## バイナリファイルの読み込み

```java
InputStream in = partInfo.getInputStream();
```

## DBへの一括登録

**前提条件**:
- 単一レイアウト（全レコードが同じレイアウト）
- 登録先テーブルが1つ（1レコードから複数テーブルへの登録は不可）

処理: `applyFormat()` → `setUpMessageIdOnError()` → `validateWith()` → `importWith()` をメソッドチェーンで呼び出す。

```java
UploadHelper helper = new UploadHelper(partInfo);
int cnt = helper.applyFormat("N11AC002")
                .setUpMessageIdOnError("MSG00037", "MSG00038", "MSG00040")
                .validateWith(UserInfoTempEntity.class, "validateRegister")
                .importWith(this, "INSERT_SQL");
```

> **注意**: 表示項目（ページングの最初へリンクなど）を変更したい場合は、[ListSearchResultタグのリファレンス](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_TagReference.html#listsearchresult) を参照。

ページングを実現するには以下の実装を行う。

1. `ListSearchInfo`クラスを継承して検索条件を保持するクラスを実装する
2. `listSearchResult`タグを使用して検索結果を表示するJSPを実装する
3. 検索処理のアクションを実装する

### 検索条件クラスの実装

**クラス**: `ListSearchInfo`（継承）

- コンストラクタで`params.get("pageNumber")`を`setPageNumber()`に渡す
- `setPageNumber()`をオーバーライドしてバリデーションアノテーション（`@Required`、`@NumberRange`、`@Digits`等）を付加する
- `getSearchConditionProps()`をオーバーライドし、`"pageNumber"`を含む検索条件プロパティ名の配列を返す

```java
public class W11AC01SearchForm extends ListSearchInfo {
    public W11AC01SearchForm(Map<String, Object> params) {
        setPageNumber((Integer) params.get("pageNumber"));
    }

    @PropertyName("開始ページ")
    @Required
    @NumberRange(max = 10, min = 1)
    @Digits(integer = 2)
    public void setPageNumber(Integer pageNumber) {
        super.setPageNumber(pageNumber);
    }

    private static final String[] SEARCH_COND_PROPS = new String[] { ..., "pageNumber"};

    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }
}
```

### JSPの実装

検索条件とページングを1つの`n:form`タグ内に実装する。

- 検索ボタン（`n:submit`）に`n:param`で`pageNumber=1`を設定する（検索時は1ページ目から表示）
- `n:listSearchResult`タグに以下の属性を設定する:

| 属性名 | 説明 |
|---|---|
| `listSearchInfoName` | リクエストスコープに設定した`ListSearchInfo`継承クラスの変数名 |
| `searchUri` | 検索パス（通常は検索ボタンと同じパス） |
| `resultSetName` | リクエストスコープに設定した検索結果の変数名 |

- `headerRowFragment`にヘッダ行のJSPフラグメントを指定する
- `bodyRowFragment`にボディ行のJSPフラグメントを指定する

ボディ行で使用可能な変数:

| 変数名 | 説明 |
|---|---|
| `row` | 行データ |
| `oddEvenCss` | 奇数・偶数行ごとのCSSクラス名 |
| `count` | ループ内カウント（1始まり） |
| `rowCount` | 全検索結果内カウント（取得開始位置＋ループインデックス（0始まり）） |

### アクションの実装

**クラス**: `DbAccessSupport`（継承）

1. 入力精査（`ValidationContext`）後、`ListSearchInfo`継承クラスをリクエストスコープに設定する（`ctx.setRequestScopedVar()`）
2. 精査失敗時は`ApplicationException`をスローする（`@OnError`でエラー画面へ遷移）
3. `search("SQL_ID", condition)`で検索実行する
4. `TooManyResultException`発生時は`e.getMaxResultCount()`で上限件数を取得し、`MessageUtil.createMessage(MessageLevel.ERROR, ...)`でエラーメッセージを生成して`ApplicationException`をスローする
5. 検索結果（`SqlResultSet`）をリクエストスコープに設定する

```java
public class W11AC01Action extends DbAccessSupport {
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
        if (!searchConditionCtx.isValid()) {
            throw new ApplicationException(searchConditionCtx.getMessages());
        }
        W11AC01SearchForm condition = searchConditionCtx.createObject();
        ctx.setRequestScopedVar("searchCondition", condition);

        SqlResultSet searchResult;
        try {
            searchResult = search("SELECT_USER_BY_CONDITION", condition);
        } catch (TooManyResultException e) {
            throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "MSG00024", e.getMaxResultCount()));
        }
        ctx.setRequestScopedVar("11AC_W11AC01", searchResult);
        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }
}
```

**前提**: この実装例はページング機能(`custom_tag_paging_paging`)がすでに実現されていることを前提とする。ページング実装との差分についてのみ示す。

検索結果の並び替えを実現するには以下の3つを実装する:
1. 可変ORDER BY構文を使用したSQL文
2. 検索条件クラスに`ListSearchInfo`の`sortId`プロパティの入力精査を含める
3. `n:listSearchSortSubmit`タグを使用した並び替えリンクのJSP

**クラス**: `ListSearchInfo`, `W11AC01SearchForm`
**アノテーション**: `@PropertyName`, `@Required`

**SQL実装例** (`$sort`構文):
```sql
$sort (sortId) {
   (1 SA.LOGIN_ID)
   (2 SA.LOGIN_ID DESC)
   (3 USR.MAIL_ADDRESS)
   (4 USR.MAIL_ADDRESS DESC) }
```
`$sort (sortId)` により`sortId`フィールドの値に対応するORDER BY句が選択される。例: `sortId=3`の場合`ORDER BY USR.MAIL_ADDRESS`に変換される。

**検索条件クラス実装例** (`W11AC01SearchForm extends ListSearchInfo`):
```java
public class W11AC01SearchForm extends ListSearchInfo {
    public W11AC01SearchForm(Map<String, Object> params) {
        setSortId((String) params.get("sortId"));
    }

    @PropertyName("ソートID")
    @Required
    public void setSortId(String sortId) {
        super.setSortId(sortId);
    }

    private static final String[] SEARCH_COND_PROPS = new String[] { ..., "sortId"};

    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }
}
```
`setSortId()`をオーバーライドして入力精査用アノテーション(`@Required`)を付加。`SEARCH_COND_PROPS`に`sortId`を含め、`getSearchConditionProps()`をオーバーライドすること。

**JSP実装例** (`n:listSearchSortSubmit`タグ):
```jsp
<n:listSearchSortSubmit ascSortId="1" descSortId="2"
                        label="ログインID" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                        name="loginIdSort" listSearchInfoName="11AC_W11AC01" />
<n:listSearchSortSubmit ascSortId="3" descSortId="4"
                        label="メールアドレス" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                        name="kanaNameSort" listSearchInfoName="11AC_W11AC01" />
```
`ascSortId`/`descSortId`はSQL文の`$sort`構文の番号と一致させる。`name`属性は画面で一意になるように指定する。

## 複合キーを用いたUIの実装

複合キーを使用する場合の考慮点:
- FormではCompositeKeyクラスのプロパティを一つ用意する（複数選択はCompositeKey[]配列、単一選択はCompositeKey）
- JSPでは`n:checkbox`/`n:radioButton`の代わりに`n:compositeKeyCheckbox`または`n:compositeKeyRadioButton`を使用する

**Form実装例**:
```java
public class UsersBulkDeleteForm {
    // 複数選択(checkbox)はCompositeKey[]配列、単一選択(radio)はCompositeKey
    private CompositeKey[] userCompositeKeys;
}
```

**JSP実装例** (`n:compositeKeyCheckbox`):
- `keyNames`属性: `n:listSearchResult`の各行(row)にあるキー属性をカンマ区切りで指定

```jsp
<n:compositeKeyCheckbox namePrefix="form"
   valueObject="${row}"
   keyNames="userId,pk2,pk3"
   name="form.userCompositeKeys"
   />
<n:hidden name="form.users[${count -1}].userId" />
<n:hidden name="form.users[${count -1}].pk2" />
<n:hidden name="form.users[${count -1}].pk3" />
```

<details>
<summary>keywords</summary>

StreamResponse, downloadButton, ファイルダウンロード, PartInfo, UploadHelper, ファイルアップロード, multipart/form-data, n:file, getPart, moveFileTo, getInputStream, DB一括登録, ApplicationException, isEmpty, MessageUtil, MessageLevel, 空ファイルチェック, ListSearchInfo, W11AC01SearchForm, W11AC01Action, listSearchResult, n:listSearchResult, DbAccessSupport, TooManyResultException, @Required, @NumberRange, @Digits, @PropertyName, @OnError, pageNumber, SqlResultSet, getSearchConditionProps, ページング, 一覧表示, 検索結果表示, bodyRowFragment, headerRowFragment, listSearchInfoName, searchUri, resultSetName, row, oddEvenCss, count, rowCount, ValidationContext, sortId, listSearchSortSubmit, 可変ORDER BY, $sort, 並び替え, ソート, ascSortId, descSortId, CompositeKey, n:compositeKeyCheckbox, n:compositeKeyRadioButton, n:checkbox, n:radioButton, 複合キーUI実装, チェックボックス選択, ラジオボタン選択, 一覧画面, UsersBulkDeleteForm, keyNames

</details>

## BLOB型カラムのダウンロード方法

`downloadLink` タグと `StreamResponse(Blob)` を使用する。行データのパラメータ受け渡しに `n:param` タグを使用。

JSP:
```jsp
<c:forEach var="record" items="${records}" varStatus="status">
    <n:set var="fileId" name="record.fileId" />
    <n:downloadLink uri="/action/ss11AC/W11AC02Action/BlobColumn" name="blobColumn_${status.index}">
        <n:write name="record.fileName" />(<n:write name="fileId" />)
        <n:param paramName="fileId" name="fileId" />
    </n:downloadLink>
</c:forEach>
```

アクション:
```java
SqlRow record = getRecord(request);
StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
response.setContentType("image/jpeg");
response.setContentDisposition(record.getString("FILE_NAME"));
return response;
```

`applyFormat()` でアップロードファイルに適用するフォーマット定義を指定する。

- `applyFormat(String layoutFileName)` — デフォルトパスからフォーマット定義ファイルを読み込む
- `applyFormat(String basePathName, String layoutFileName)` — フォーマット定義ファイルの読み込み先をデフォルトから変更する場合、第1引数に論理パス名を指定する

「ページングを使用した一覧表示」（s1）が実現されていることを前提として、デフォルト値とは異なる表示件数・検索結果件数（上限）を特定の一覧表示に設定するには、アクションのメソッドで`ListSearchInfo`継承クラスに以下のプロパティを設定する。

| プロパティ名 | 説明 |
|---|---|
| `max` | 1ページの表示件数（デフォルト値と異なる場合に設定） |
| `maxResultCount` | 検索結果件数の上限（デフォルト値と異なる場合に設定） |

```java
private static final int MAX_ROWS = 10;
private static final int MAX_RESULT_COUNT = 100;

// アクションのメソッド内
condition.setMax(MAX_ROWS);
condition.setMaxResultCount(MAX_RESULT_COUNT);
ctx.setRequestScopedVar("searchCondition", condition);
```

ページングを使用しない一覧表示の基本実装はページングを使用する場合と同じ。検索処理や並び替えの処理もページングを使用する場合と同じ実装方法。

**クラス**: `ListSearchInfo`, `W11AC01SearchForm`, `DbAccessSupport`
**例外**: `TooManyResultException`, `ApplicationException`
**アノテーション**: `@OnError`

**検索条件クラス**: `ListSearchInfo`を継承するが、`pageNumber`プロパティの設定は不要（初期値1のため常に1ページ目となる）。

**アクション実装例**:
```java
public class W11AC01Action extends DbAccessSupport {
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
        W11AC01SearchForm condition = searchConditionCtx.createObject();

        condition.setMax(condition.getMaxResultCount());  // ページングを使用しない場合必須

        ctx.setRequestScopedVar("11AC_W11AC01", searchResult);
        return new HttpResponse("/ss11AC/W11AC0101.jsp");
    }
}
```
> **重要**: `condition.setMax(condition.getMaxResultCount())` はページングを使用しない場合に必須。この設定により検索結果の取得件数に最大件数(上限)が設定される。

**JSP実装例**:
```jsp
<n:listSearchResult listSearchInfoName="11AC_W11AC01"
                    usePaging="false"
                    resultSetName="searchResult">
</n:listSearchResult>
```
`usePaging="false"` を指定する。ページングを使用しないため`searchUri`属性の指定は不要。

## 複合キーを用いた排他制御の実装

複合キーを用いた排他制御では、主キークラスを引数に取る`HttpExclusiveControlUtil`のメソッドを選択された行ごとに呼び出す。

**Form実装例** (`getDeletedUsers`でチェックされたオブジェクトを取得):
```java
public User[] getDeletedUsers() {
    List<User> deletedUsers = new ArrayList<User>();
    List<CompositeKey> deletedCompositeKeys = Arrays.asList(userCompositeKeys);
    for (int i = 0; i < users.length; i++) {
        User user = users[i];
        CompositeKey compositeKey = new CompositeKey(user.getUserId(), user.getPk2(), user.getPk3());
        if (deletedCompositeKeys.contains(compositeKey)) {
            deletedUsers.add(user);
        }
    }
    return deletedUsers.toArray(new User[deletedUsers.size()]);
}
```

**検索結果表示Action** (`ExclusiveControlContext`リストを生成し`prepareVersions`の第3引数に指定):
```java
SqlResultSet result = searchUser(request, context);
List<ExclusiveControlContext> exclusiveControlContexts = new ArrayList<ExclusiveControlContext>();
for (int i = 0; i < result.size(); i++) {
    SqlRow row = result.get(i);
    exclusiveControlContexts.add(new ExclusiveUserCondition(row.getString("USER_ID"), row.getString("PK2"), row.getString("PK3")));
    users[i] = new User(row);
}
HttpExclusiveControlUtil.prepareVersions(context, exclusiveControlContexts);
```

**確認画面表示Action** (選択行ごとに`checkVersion`を呼び出す):
```java
User[] deletedUsers = form.getDeletedUsers();
for (int i = 0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.checkVersion(request, context, new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

**完了画面表示Action** (選択行ごとに`updateVersionWithCheck`を呼び出す):
```java
User[] deletedUsers = form.getDeletedUsers();
for (int i = 0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.updateVersionWithCheck(request, new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

<details>
<summary>keywords</summary>

StreamResponse, downloadLink, SqlRow, BLOBダウンロード, n:param, Blob, applyFormat, フォーマット定義, layoutFileName, basePathName, 論理パス名, ListSearchInfo, max, maxResultCount, setMax, setMaxResultCount, 表示件数個別設定, 検索結果件数上限, ページング個別設定, W11AC01SearchForm, W11AC01Action, DbAccessSupport, HttpResponse, HttpRequest, ExecutionContext, ValidationContext, TooManyResultException, ApplicationException, @OnError, getMaxResultCount, usePaging, pageNumber, ページングなし, 全件表示, HttpExclusiveControlUtil, ExclusiveControlContext, ExclusiveUserCondition, CompositeKey, 複合キー排他制御, prepareVersions, checkVersion, updateVersionWithCheck, getDeletedUsers, SqlResultSet

</details>

## データレコードのダウンロード方法

`DataRecordResponse` クラスを使用する。フォーマット定義ファイルの作成が必要。フォーマット定義ファイルの配置場所はプロジェクトの実装方針に従う。

フォーマット定義例 (N11AA001.fmt):
```
file-type:        "Variable"
text-encoding:    "Shift_JIS"
record-separator: "\n"
field-separator:  ","

[header]
1   messageId    N "メッセージID"
2   lang         N "言語"
3   message      N "メッセージ"

[data]
1   messageId    X
2   lang         X
3   message      N
```

JSP (`downloadSubmit` タグ):
```jsp
<n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/CsvDataRecord"
                  name="csvDataRecord" value="ダウンロード" />
```

アクション:
```java
SqlResultSet records = getRecords(request);
// コンストラクタ引数: フォーマット定義のベースパス論理名, フォーマット定義のファイル名
DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
response.write("header", Collections.<String, Object>emptyMap()); // 空のマップでデフォルトヘッダー使用
for (SqlRow record : records) {
    response.write("data", record);
}
response.setContentType("text/csv; charset=Shift_JIS");
response.setContentDisposition("メッセージ一覧.csv");
return response;
```

`setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)` でエラー発生時のメッセージIDを指定する。

| 引数 | 設定内容 |
|---|---|
| 第1引数 | 形式エラー時のメッセージID |
| 第2引数 | 精査エラー時のメッセージID |
| 第3引数 | ファイルが空の場合のメッセージID |

形式エラー時のメッセージに渡される値:
- `{0}`: 形式エラーが発生したレコード行数

精査エラー時のメッセージに渡される値:
- `{0}`: 精査エラーが発生したレコード行数
- `{1}`: 精査エラーメッセージ文言

JavascriptはNablarch専用の`n:script`タグを必ず使用すること。参照: [スクリプトタグ](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_TagReference.html#webview-scripttag)

```jsp
<%-- 外部スクリプトファイルを読み込む場合 --%>
<n:script type="text/javascript" src="/js/common.js" />

<%-- ページ内にスクリプトを直接記述する場合 --%>
<n:script type="text/javascript">
function common_validate() {
    <%--内容は省略--%>
}
</n:script>
```

`n:script`タグ内にスクリプトを直接記述した場合、スクリプト内容は自動的にHTMLコメントで囲われて出力される。タグ内に直接記述すること。

<details>
<summary>keywords</summary>

DataRecordResponse, downloadSubmit, SqlResultSet, SqlRow, CSVダウンロード, データレコードダウンロード, フォーマット定義, setUpMessageIdOnError, 形式エラー, 精査エラー, 空ファイル, メッセージID, エラーメッセージ, n:script, スクリプトタグ, Javascript使用, HTMLコメント自動出力

</details>

## 別ウィンドウを開きダウンロードを開始したい場合

別ウィンドウを開いてダウンロードを開始する実装。別ウィンドウを開くには `howto_open_multi_window` の実装方法を使用。

親ウィンドウJSP:
```jsp
<n:popupButton uri="/action/ss11AC/W11AC02Action/ShowSub" name="showSub">ダウンロード</n:popupButton>
```

別ウィンドウJSP (onloadでダウンロードをサブミット):
```jsp
<body onload="doOnclick('submit');">
    <n:form name="downloadForm">
        <%-- ダウンロードボタンを表示したくない場合は、style="display: none;" などCSSを使用する。 --%>
        <n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/TempFile"
                          name="submit" value="ダウンロード"
                          allowDoubleSubmission="false" />
        <n:button uri="#" name="close" onclick="window.close();" displayMethod="NORMAL">閉じる</n:button>
    </n:form>
</body>
```

JavaScript (doOnclick関数):
```javascript
function doOnclick(name) {
    var element = document.getElementsByName(name)[0];
    if (element.fireEvent) { element.fireEvent("onclick"); }
    else if (document.createEvent) {
        var evt = document.createEvent("MouseEvents");
        evt.initEvent("click", false, true);
        element.dispatchEvent(evt);
    } else { element.onclick(); }
}
```

`validateWith(Class<F> formClass, String validateFor)` で精査に使用するフォームクラスと精査メソッド名を指定する。

通常の業務Actionと同様の実装を行うことができるため、以下の精査処理を実装できる:
- ドメインベースの単項目精査
- DB精査
- ビジネスロジックを伴う複雑な精査処理

精査エラーのメッセージは蓄積され、`importWith()` 呼び出しまで例外は送出されない。

<details>
<summary>keywords</summary>

downloadSubmit, popupButton, 別ウィンドウダウンロード, allowDoubleSubmission, validateWith, 精査処理, フォームクラス, 精査メソッド, バリデーション

</details>

## データベース一括登録

`importWith(DbAccessSupport dbAccessSupport, String insertSqlId)` で精査済みのレコードをDBに一括登録する。

- 第1引数: `DbAccessSupport` のインスタンス（ActionクラスはDbAccessSupportを継承しているので `this` を指定）
- 第2引数: レコード1件を登録するINSERT文のSQLID

形式エラーまたは精査エラーが1件でも存在する場合は `ApplicationException` が送出される。この例外には、これまでに蓄積されたすべてのエラーメッセージ（形式エラー・精査エラー）が含まれる。

<details>
<summary>keywords</summary>

importWith, DbAccessSupport, 一括登録, ApplicationException, INSERT SQL, SQLID

</details>
