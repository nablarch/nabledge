# ファイルダウンロードの実現方法

## ファイルのダウンロード方法

ファイルダウンロードに使用するタグとユーティリティクラス:

**タグ**: `downloadSubmit`, `downloadButton`, `downloadLink`

**クラス**: `StreamResponse`, `DataRecordResponse`

## ファイルのダウンロード方法

- JSP: `downloadButton`タグを使用
- Action: `StreamResponse`クラスを使用

```jsp
<n:downloadButton uri="/action/ss11AC/W11AC02Action/TempFile" name="tempFile">ダウンロード</n:downloadButton>
```

```java
StreamResponse response = new StreamResponse(file, true);
response.setContentType("text/plain; charset=UTF-8");
response.setContentDisposition(file.getName());
return response;
```

`StreamResponse(File file, boolean deleteOnClose)`: 第2引数`true`=ダウンロード後にファイルを削除（フレームワークが削除）、`false`=削除しない。

ファイルアップロードを行うには `file` タグと `PartInfo`, `UploadHelper` クラスを使用する。

> **警告**: ファイルアップロードを行う場合、`<n:form>` タグの `enctype` 属性に `"multipart/form-data"` を必ず指定すること。

```jsp
<n:form enctype="multipart/form-data">
  <n:file name="userList" cssClass="input" size="50"/>
  <n:submit name="submit" type="submit" value="アップロード" uri="RW11AC0602"/>
</n:form>
```

ページングを実現するための実装:
1. `ListSearchInfo`を継承した検索条件クラスの実装
2. `nbs:listSearchResult`タグを使用したJSPの実装
3. 検索処理アクションの実装

**検索条件クラス** (`ListSearchInfo`継承):
- `setPageNumber()`をオーバーライドして`pageNumber`プロパティにバリデーションアノテーションを付加する（例: 最大件数200件・1ページ20件の場合は`@NumberRange(max = 10, min = 1)`, `@Digits(integer = 2)`）
- `getSearchConditionProps()`をオーバーライドして`"pageNumber"`を含む検索条件プロパティ配列を返す

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

**JSP実装**: 検索条件フォームと検索結果フォームを分け、`windowScopePrefixes`でウィンドウスコープを使用して前回検索条件を維持する。検索ボタンには`<n:param>`で`pageNumber=1`（1ページ目）を変更パラメータとして指定する。

`nbs:listSearchResult`タグの属性:

| 属性名 | 説明 |
|---|---|
| `listSearchInfoName` | リクエストスコープに設定した`ListSearchInfo`継承クラスの変数名 |
| `searchUri` | 検索を行うパス（通常は検索ボタンと同じパス） |
| `resultSetName` | リクエストスコープに設定した検索結果の変数名 |

`bodyRowFragment`内で使用可能な変数:

| 変数名 | 説明 |
|---|---|
| `row` | 行データ |
| `oddEvenCss` | 奇数行・偶数行ごとのCSSクラス名（奇数行: `"odd"`、偶数行: `"even"`） |
| `count` | ループ内カウント（1始まり） |
| `rowCount` | 全検索結果件数内カウント（取得開始位置＋ループインデックス(0始まり)） |

**アクション実装**:
- `DbAccessSupport`の`search(SQL_ID, condition)`メソッドで検索実行
- 検索実行前に`ListSearchInfo`継承クラスをリクエストスコープに設定: `ctx.setRequestScopedVar("変数名", condition)`
- 検索結果件数が上限超過時は`TooManyResultException`がスローされる。`e.getMaxResultCount()`で上限件数を取得可能
- アクションメソッドに`@OnError(type = ApplicationException.class, path = "...")`を付加することで、`ApplicationException`発生時のフォワード先JSPを指定できる

```java
public class W11AC01Action extends DbAccessSupport {
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        W11AC01SearchForm condition = ...;
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

検索結果の並び替えを実現するには以下の3つの実装が必要。

1. 可変ORDER BY構文を使用したSQL文
2. 検索条件クラスに`ListSearchInfo`の`sortId`プロパティの入力精査を含める
3. `listSearchSortSubmit`タグを使用して並び替え用のリンクを表示するJSP

**SQL文（可変ORDER BY構文）**:

`$sort (sortId)` 構文で、検索条件オブジェクトの`sortId`フィールドの値に対応するORDER BY句が使用される。例: `sortId=3` の場合は `ORDER BY USR.MAIL_ADDRESS` に変換される。

```sql
SELECT_USER_BY_CONDITION =
SELECT ...
FROM ...
WHERE ...
$sort (sortId) {
   (1 SA.LOGIN_ID)
   (2 SA.LOGIN_ID DESC)
   (3 USR.MAIL_ADDRESS)
   (4 USR.MAIL_ADDRESS DESC) }
```

**検索条件クラスの実装**:

`ListSearchInfo`を継承し、`setSortId()`をオーバーライドして`@Required`等のバリデーションアノテーションを付加する。`SEARCH_COND_PROPS`に`"sortId"`を含める。

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

**JSPの実装（`listSearchSortSubmit`タグ）**:

`ascSortId`・`descSortId`にはSQL文の`$sort`定義に対応するsortId値を指定する。`name`属性は画面で一意になるように指定する。

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                    resultSetName="searchResult"
                    usePageNumberSubmit="true"
                    useLastSubmit="true">
    <jsp:attribute name="headerRowFragment">
        <tr>
            <th>
                <nbs:listSearchSortSubmit ascSortId="1" descSortId="2"
                    label="ログインID" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                    name="loginIdSort" listSearchInfoName="11AC_W11AC01" />
            </th>
            <th>
                <nbs:listSearchSortSubmit ascSortId="3" descSortId="4"
                    label="メールアドレス" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                    name="kanaNameSort" listSearchInfoName="11AC_W11AC01" />
            </th>
        </tr>
    </jsp:attribute>
</nbs:listSearchResult>
```

複合キーを用いたUIを実装する際は、以下の考慮が必要:

- 画面入力用FormのキーはCompositeKeyクラスのプロパティで保持する（チェックボックスで複数選択の場合は`CompositeKey[]`配列、ラジオボタンで単一選択の場合は`CompositeKey`単体）
- JSPでの複合キー入力には`n:checkbox`/`n:radioButton`の代わりに`n:compositeKeyCheckbox`または`n:compositeKeyRadioButton`を使用する

**Form実装例**:
```java
public class UsersBulkDeleteForm {
    // checkbox複数選択: CompositeKey[]
    // radio単一選択: CompositeKey
    private CompositeKey[] userCompositeKeys;
}
```

**JSP実装例** (`nbs:listSearchResult`で一覧を囲み、`n:compositeKeyCheckbox`と`n:hidden`を使用):
```jsp
<nbs:listSearchResult listSearchInfoName="condition"
               searchUri="./EXCLUS30102"
               resultSetName="form.users"
               usePageNumberSubmit="true">
    <jsp:attribute name="bodyRowFragment">
    <tr class="<n:write name="oddEvenCss" />">
        <td>
            <%-- keyNames属性には各行のプロパティにあるキー属性をカンマ区切りで指定 --%>
            <n:compositeKeyCheckbox namePrefix="form"
               valueObject="${row}"
               keyNames="userId,pk2,pk3"
               name="form.userCompositeKeys"
               />
            <%-- n:hiddenでフォームデータを維持 --%>
            <n:hidden name="form.users[${count -1}].userId" />
            <n:hidden name="form.users[${count -1}].pk2" />
            <n:hidden name="form.users[${count -1}].pk3" />
            <n:hidden name="form.users[${count -1}].name" />
            <n:hidden name="form.users[${count -1}].profile" />
            <n:hidden name="form.users[${count -1}].version" />
        </td>
        <td><n:write name="row.userId" /></td>
        <td><n:write name="row.name" /></td>
        <td><n:write name="row.profile" /></td>
        <td><n:write name="row.version" /></td>
    </tr>
    </jsp:attribute>
</nbs:listSearchResult>
```
`nbs:listSearchResult`の`resultSetName`に一覧データのプロパティ名を、`searchUri`に検索URIを指定する。各行のユーザーデータは`n:hidden`フィールドで保持し、次画面へのフォームデータ送信を確保する。

<details>
<summary>keywords</summary>

StreamResponse, downloadButton, ファイルダウンロード, setContentDisposition, setContentType, downloadSubmit, downloadLink, DataRecordResponse, file, ファイルアップロード, enctype, multipart/form-data, n:form, n:file, PartInfo, UploadHelper, ListSearchInfo, W11AC01SearchForm, DbAccessSupport, SqlResultSet, TooManyResultException, ApplicationException, MessageUtil, MessageLevel, @OnError, @PropertyName, @Required, @NumberRange, @Digits, pageNumber, getSearchConditionProps, nbs:listSearchResult, listSearchInfoName, searchUri, resultSetName, windowScopePrefixes, bodyRowFragment, headerRowFragment, ページング, 検索結果一覧表示, listSearchResultタグ, 検索条件保持, listSearchSortSubmit, sortId, 検索結果の並び替え, 可変ORDER BY, $sort構文, ソートID, CompositeKey, n:compositeKeyCheckbox, n:compositeKeyRadioButton, 複合キー選択, チェックボックス, ラジオボタン, 一覧画面, keyNames, UsersBulkDeleteForm, n:hidden, usePageNumberSubmit

</details>

## BLOB型カラムのダウンロード方法

BLOB型カラムのダウンロード方法:

- JSP: `downloadLink`タグを使用、`n:param`タグで行IDパラメータを渡す
- Action: `StreamResponse(Blob)`を使用

```jsp
<n:downloadLink uri="/action/ss11AC/W11AC02Action/BlobColumn" name="blobColumn_${status.index}">
    <n:write name="record.fileName" />(<n:write name="fileId" />)
    <n:param paramName="fileId" name="fileId" />
</n:downloadLink>
```

```java
SqlRow record = getRecord(request);
StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
response.setContentType("image/jpeg");
response.setContentDisposition(record.getString("FILE_NAME"));
return response;
```

`HttpRequest.getPart(name)` でアップロードファイルを `List<PartInfo>` として取得する。

```java
List<PartInfo> partInfoList = req.getPart("userList");
if (partInfoList.isEmpty()) {
    throw new ApplicationException(
            MessageUtil.createMessage(MessageLevel.ERROR, "MSG00039"));
}
PartInfo partInfo = partInfoList.get(0);
```

> **注意**: 同一フォーム内に同一name属性の `n:file` タグが複数ある場合、`partInfoList` には複数の `PartInfo` が含まれる。

:ref:`custom_tag_paging_paging` が実現されている前提で、特定の一覧表示にてシステムデフォルト値とは異なる表示件数・検索結果件数（上限）を設定する方法。

アクションメソッド内で`ListSearchInfo`継承クラスに設定する:
- 表示件数のオーバーライド: `condition.setMax(件数)` （`max`プロパティ）
- 検索結果件数上限のオーバーライド: `condition.setMaxResultCount(件数)` （`maxResultCount`プロパティ）

```java
private static final int MAX_ROWS = 10;
private static final int MAX_RESULT_COUNT = 100;

public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    W11AC01SearchForm condition = .....;
    condition.setMax(MAX_ROWS);
    condition.setMaxResultCount(MAX_RESULT_COUNT);
    ctx.setRequestScopedVar("searchCondition", condition);
    // 以降の処理は省略
}
```

ページングを使用せずに1画面にすべての検索結果を表示する場合、基本的な実装方法はページングを使用する場合と変わらない。検索処理や並び替えの処理もページングを使用する場合と同じ実装方法となる。

**ListSearchInfoを継承するクラス**:

- `pageNumber`プロパティの設定は不要。初期値が1のため常に1ページ目となる。
- `SEARCH_COND_PROPS`には検索条件プロパティのみ含める。

```java
public class W11AC01SearchForm extends ListSearchInfo {
    public W11AC01SearchForm(Map<String, Object> params) {
        // pageNumberプロパティの設定は不要
    }

    private static final String[] SEARCH_COND_PROPS = new String[] { ... };

    public String[] getSearchConditionProps() {
        return SEARCH_COND_PROPS;
    }
}
```

**アクションの実装**:

実装例では`DbAccessSupport`クラスを継承して使用するが、プロジェクトの方針に合わせて実装する。`@OnError`アノテーションでエラー時のパスを指定する。入力精査には`ValidationContext`を使用する。ページングを使用しない場合、以下の設定が必須。検索結果の取得件数（1ページの表示件数）に検索結果の最大件数（上限）を設定する。検索実行時に`TooManyResultException`が発生する場合は適切に処理する。

```java
public class W11AC01Action extends DbAccessSupport {
    @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
    public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
        ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
        searchConditionCtx.abortIfInvalid();
        W11AC01SearchForm condition = searchConditionCtx.createObject();

        condition.setMax(condition.getMaxResultCount());

        try {
            // 検索処理
        } catch (TooManyResultException e) {
            // 例外処理
        }
    }
}
```

**JSPの実装**:

`usePaging="false"` を指定する。`searchUri`属性の指定は不要。

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    usePaging="false"
                    resultSetName="searchResult">
</nbs:listSearchResult>
```

## 複合キーを用いた排他制御の実装

複合キーを用いた排他制御では、主キークラスを引数に取る`HttpExclusiveControlUtil`のメソッドを、画面で選択された行ごとに呼び出す。

**Form** (`getDeletedUsers`でチェック済みオブジェクトを取得):
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

**検索結果表示Action** (`HttpExclusiveControlUtil.prepareVersions`でバージョン取得):
```java
List<ExclusiveControlContext> exclusiveControlContexts = new ArrayList<ExclusiveControlContext>();
for (int i = 0; i < result.size(); i++) {
    SqlRow row = result.get(i);
    exclusiveControlContexts.add(new ExclusiveUserCondition(
        row.getString("USER_ID"), row.getString("PK2"), row.getString("PK3")));
}
HttpExclusiveControlUtil.prepareVersions(context, exclusiveControlContexts);
```

**確認画面表示Action** (`HttpExclusiveControlUtil.checkVersion`で排他チェック):
```java
User[] deletedUsers = form.getDeletedUsers();
for (int i = 0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.checkVersion(request, context,
        new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

**完了画面表示Action** (`HttpExclusiveControlUtil.updateVersionWithCheck`で排他更新):
```java
User[] deletedUsers = form.getDeletedUsers();
for (int i = 0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.updateVersionWithCheck(request,
        new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

<details>
<summary>keywords</summary>

StreamResponse, downloadLink, BLOBダウンロード, BLOB, setContentDisposition, n:param, SqlRow, Blob, PartInfo, getPart, HttpRequest, ApplicationException, MessageUtil, MessageLevel, ファイルアップロード, ListSearchInfo, setMax, setMaxResultCount, max, maxResultCount, 表示件数設定, 検索結果件数上限設定, ページング個別設定, getMaxResultCount, usePaging, listSearchResult, ページングなし一覧表示, 全件表示, pageNumber, DbAccessSupport, TooManyResultException, ValidationContext, @OnError, CompositeKey, HttpExclusiveControlUtil, ExclusiveControlContext, ExclusiveUserCondition, prepareVersions, checkVersion, updateVersionWithCheck, UsersBulkDeleteForm, getDeletedUsers, 複合キー排他制御, 排他制御

</details>

## データレコードのダウンロード方法

データレコードをフォーマットしてダウンロードするには、フォーマット定義ファイルが必要（配置場所はプロジェクトの実装方針に従う）。

### フォーマット定義ファイルの例 (N11AA001.fmt)

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

- JSP: `downloadSubmit`タグを使用
- Action: `DataRecordResponse("format", "N11AA001")`を使用

```jsp
<n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/CsvDataRecord"
                  name="csvDataRecord" value="ダウンロード" />
```

```java
SqlResultSet records = getRecords(request);
DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
response.write("header", Collections.<String, Object>emptyMap());
for (SqlRow record : records) {
    response.write("data", record);
}
response.setContentType("text/csv; charset=Shift_JIS");
response.setContentDisposition("メッセージ一覧.csv");
return response;
```

`DataRecordResponse.write(String recordType, Map<String, ?> record)`: ヘッダーのデフォルト値を使用する場合は空マップ`Collections.emptyMap()`を指定。

`UploadHelper.moveFileTo(論理パス名, ファイル名)` でファイルを指定ディレクトリへ移動する。

```java
UploadHelper helper = new UploadHelper(partInfo);
String fileName = generateUniqueFileName();
helper.moveFileTo("uploadFileSaveDir", fileName);
```

Javascriptを使用する場合は、専用の`n:script`タグを使用すること。

> **注意**: タグ内に直接スクリプトを記述した場合、スクリプトの内容が自動的にHTMLコメントで囲われて出力される。そのため、タグ内にスクリプトを直接記述すること。

**JSP記述例**:
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

<details>
<summary>keywords</summary>

DataRecordResponse, downloadSubmit, CSVダウンロード, データレコードダウンロード, フォーマット定義ファイル, Variable, Shift_JIS, N11AA001, field-separator, record-separator, SqlResultSet, UploadHelper, moveFileTo, ファイル保存, PartInfo, n:script, JavaScript, スクリプトタグ, JSP, HTMLコメント

</details>

## 別ウィンドウを開きダウンロードを開始したい場合

リクエストからダウンロード開始まで時間がかかる場合など、ユーザに視覚的に伝達するために別ウィンドウを開いてダウンロードを開始する。

1. 親画面: `n:popupButton`タグで別ウィンドウを開く
2. 別ウィンドウ: `onload`イベントでダウンロードフォームを自動サブミット
3. `downloadSubmit`の`allowDoubleSubmission="false"`を指定
4. `doOnclick(name)`: 指定された`name`属性の要素のonclickイベントを発生させるJavaScript関数（IE対応含むクロスブラウザ実装）

```jsp
<%-- 親画面 --%>
<n:popupButton uri="/action/ss11AC/W11AC02Action/ShowSub" name="showSub">ダウンロード</n:popupButton>
```

```jsp
<%-- 別ウィンドウ --%>
<body onload="doOnclick('submit');">
    <n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/TempFile"
                      name="submit" value="ダウンロード" allowDoubleSubmission="false" />
    <n:button uri="#" name="close" onclick="window.close();" displayMethod="NORMAL">閉じる</n:button>
</body>
```

```javascript
function doOnclick(name) {
    var element = document.getElementsByName(name)[0];
    if (element.fireEvent) { // for IE
        element.fireEvent("onclick");
    } else if (document.createEvent) { // for not IE
        var evt = document.createEvent("MouseEvents");
        var bubbles = false;
        var cancelable = true;
        evt.initEvent("click", bubbles, cancelable);
        element.dispatchEvent(evt);
    } else { // just in case
        element.onclick();
    }
}
```

画像などのバイナリファイルは `PartInfo.getInputStream()` で入力ストリームとして取得する。

```java
PartInfo partInfo = req.getPart("imageFile").get(0);
InputStream in = partInfo.getInputStream();
```

<details>
<summary>keywords</summary>

別ウィンドウダウンロード, popupButton, doOnclick, allowDoubleSubmission, onload, downloadSubmit, fireEvent, dispatchEvent, PartInfo, getInputStream, InputStream, バイナリファイル, UploadHelper

</details>

## アップロードファイルをDBに登録する方法

`UploadHelper` クラスを使用してファイル精査およびDB登録を簡易的に行うことができる。

> **注意**: 前提事項: (1) 単一レイアウト（全レコードが同一レイアウト）、(2) 登録先テーブルが1つ（1レコードから複数テーブルへの登録不可）

処理フロー:
1. フォーマット定義のロード — アップロードファイルのデータフォーマット定義ファイルを読み込む
2. 形式チェック — フォーマット定義に基づき各レコードを自動検証。通過したレコードはMap型に変換
3. 精査処理 — 通常の業務Actionと同様にドメイン精査・DB精査・複雑なビジネスロジック精査が実装可能
4. 空ファイルチェック — レコードが1件以上存在することを確認
5. DB登録 — 全レコードが検査を通過した場合に一括登録

実装例:

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0601")
public HttpResponse doRW11AC0602(HttpRequest req, ExecutionContext ctx) {
    PartInfo partInfo = req.getPart("fileToSave").get(0);
    UploadHelper helper = new UploadHelper(partInfo);
    int cnt = helper.applyFormat("N11AC002")
                    .setUpMessageIdOnError("MSG00037", "MSG00038", "MSG00040")
                    .validateWith(UserInfoTempEntity.class, "validateRegister")
                    .importWith(this, "INSERT_SQL");
}
```

<details>
<summary>keywords</summary>

UploadHelper, DB一括登録, applyFormat, validateWith, importWith, UserInfoTempEntity, @OnError, ApplicationException, 形式チェック, 精査処理, 空ファイルチェック

</details>

## フォーマット定義ファイルパスの指定

`applyFormat(String layoutFileName)` でアップロードファイルに適用するフォーマットを指定する。

フォーマット定義ファイルの読み込み先をデフォルト値から変更する場合は論理パス名を指定する:

`applyFormat(String basePathName, String layoutFileName)`

<details>
<summary>keywords</summary>

applyFormat, フォーマット定義, UploadHelper, basePathName, layoutFileName

</details>

## エラー発生時のメッセージID指定

`setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)` でエラー発生時のメッセージIDを指定する。

| 引数 | 設定内容 |
|---|---|
| 第1引数 | 形式エラー時のメッセージID |
| 第2引数 | 精査エラー時のメッセージID |
| 第3引数 | ファイルが空の場合のメッセージID |

形式エラー時のメッセージプレースホルダー:
- `{0}`: 形式エラーが発生したレコード行数

例: `{0}行目に形式エラーがあります。` → `12行目に形式エラーがあります。`

精査エラー時のメッセージプレースホルダー:
- `{0}`: 精査エラーが発生したレコード行数
- `{1}`: 精査エラーメッセージ文言

例: `{0}行目に精査エラーがあります。 [{1}]` → `8行目に精査エラーがあります。 [カナ氏名は全角カナで入力してください。]`

<details>
<summary>keywords</summary>

setUpMessageIdOnError, エラーメッセージ, 形式エラー, 精査エラー, 空ファイルチェック, メッセージID, UploadHelper

</details>

## 精査処理を実装したクラス、メソッドの指定

`validateWith(Class<F> formClass, String validateFor)` で精査に使用するフォームクラスと精査メソッド名を指定する。

精査エラーのメッセージは蓄積され、`importWith` が実行されるまで例外は送出されない。

<details>
<summary>keywords</summary>

validateWith, 精査処理, UploadHelper, フォームクラス, バリデーション, validateFor

</details>

## データベース一括登録

`importWith(DbAccessSupport dbAccessSupport, String insertSqlId)` で精査済みのフォームを一括登録する。

- 第1引数: `DbAccessSupport` のインスタンス（ActionクラスはDbAccessSupportを継承しているため通常は `this`）
- 第2引数: レコード1件を登録するINSERT文のSQLID

形式エラー・精査エラーが1件でも存在する場合は `ApplicationException` が送出される。この例外には蓄積された全エラーメッセージ（形式エラー・精査エラー）が含まれる。

<details>
<summary>keywords</summary>

importWith, データベース一括登録, DbAccessSupport, ApplicationException, SQLID, UploadHelper

</details>
