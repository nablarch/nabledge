# ファイルダウンロードの実現方法

## ファイルのダウンロード方法

## ファイルのダウンロード方法

ファイルダウンロードには以下のタグとユーティリティクラスを使用する。

**タグ**: `downloadSubmit`, `downloadButton`, `downloadLink`

**ユーティリティクラス**: `StreamResponse`, `DataRecordResponse`

`downloadButton`タグでダウンロードボタンを実装し、アクションで`StreamResponse`を返す。

`StreamResponse`コンストラクタ引数:
- 第1引数: ダウンロード対象の`File`
- 第2引数: リクエスト処理終了時にファイルを削除する場合は`true`、削除しない場合は`false`（ファイル削除はフレームワークが行う。通常は`true`を指定する）

```java
StreamResponse response = new StreamResponse(file, true);
response.setContentType("text/plain; charset=UTF-8");
response.setContentDisposition(file.getName());
return response;
```

ファイルアップロードに使用するタグとクラス:
- **タグ**: `file`
- **クラス**: `PartInfo`, `UploadHelper`

## JSP実装

```jsp
<n:form enctype="multipart/form-data">
  登録対象ユーザ情報ファイル
  <n:file name="userList" cssClass="input" size="50"/>
  <n:submit name="submit" type="submit" value="アップロード" uri="RW11AC0602"/>
</n:form>
```

> **警告**: ファイルアップロードを行う場合、`<n:form>` タグの `enctype` 属性に `"multipart/form-data"` を必ず指定すること。

## ページングを使用した一覧表示

ページング実現に必要な実装:
1. `ListSearchInfo`クラスを継承して検索条件を保持するクラスを実装する
2. `listSearchResult`タグを使用したJSPを実装する
3. 検索処理のアクションを実装する

**検索条件クラス（`ListSearchInfo`継承）の実装要点**:
- コンストラクタで`setPageNumber((Integer) params.get("pageNumber"))`を呼び出す
- `setPageNumber()`をオーバーライドしてバリデーションアノテーション（`@PropertyName`, `@Required`, `@NumberRange`, `@Digits`）を付加する
- `getSearchConditionProps()`をオーバーライドし、`SEARCH_COND_PROPS`に`"pageNumber"`を含める

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

**JSP実装要点**:
- ページング時の検索条件維持のため、ウィンドウスコープを使用し、検索条件フォームと検索結果フォームを分離する
- 検索ボタンには`<n:param paramName="xxx.pageNumber" value="1" />`で取得開始ページを指定する（検索ボタン押下時は1ページ目から表示するため`value="1"`とする）

`nbs:listSearchResult`タグの主要属性:
- `listSearchInfoName`: `ListSearchInfo`継承クラスをリクエストスコープに設定した変数名
- `searchUri`: 検索を行うパス（通常は検索ボタンと同じパス）
- `resultSetName`: 検索結果をリクエストスコープに設定した変数名

ボディ行（`bodyRowFragment`）で使用可能な変数:
- `row`: 行データ
- `oddEvenCss`: 奇数行/偶数行のCSSクラス名
- `count`: ループ内カウント（1始まり）
- `rowCount`: 全検索結果内のカウント（取得開始位置＋ループインデックス(0始まり)）

**アクション実装要点**:
- `@OnError(type = ApplicationException.class, path = ...)`アノテーションでエラー時の遷移先を指定する
- `ValidationContext<W11AC01SearchForm>`で入力精査し、`ListSearchInfo`継承クラスをリクエストスコープに設定する（`listSearchResult`タグで使用）
- `DbAccessSupport`の`search`メソッドで`SqlResultSet`として検索結果を取得する
- `TooManyResultException`発生時は`e.getMaxResultCount()`でエラーメッセージを生成し`ApplicationException`をスローする（`MessageUtil.createMessage(MessageLevel.ERROR, ...)`を使用）

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    // ...
    ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
    searchConditionCtx.abortIfInvalid();
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
}
```

## 複合キーを用いたUIの実装

単純なキーと比較して以下の考慮が必要:
- Formでは、キー項目用に`CompositeKey`の配列(checkbox複数選択)または`CompositeKey`(radio単一選択)のプロパティを一つ用意する。
- JSPでの複合キー項目の入力に`n:checkbox`/`n:radioButton`の代わりに`n:compositeKeyCheckbox`または`n:compositeKeyRadioButton`を使用する。

**Form実装例**:
```java
public class UsersBulkDeleteForm {
    // checkboxで複数選択の場合はCompositeKey[]、radioで単一選択の場合はCompositeKey
    private CompositeKey[] userCompositeKeys;
}
```

**JSP実装例** (`n:compositeKeyCheckbox`と`n:hidden`の組み合わせ):
```jsp
<n:compositeKeyCheckbox namePrefix="form"
   valueObject="${row}"
   keyNames="userId,pk2,pk3"
   name="form.userCompositeKeys"
   />
<n:hidden name="form.users[${count -1}].userId" />
<n:hidden name="form.users[${count -1}].pk2" />
<n:hidden name="form.users[${count -1}].pk3" />
<n:hidden name="form.users[${count -1}].name" />
<n:hidden name="form.users[${count -1}].profile" />
<n:hidden name="form.users[${count -1}].version" />
```
`keyNames`属性には、各行(row)のキー属性名をカンマ区切りで指定する。`n:hidden`フィールドで各行のプロパティ(userId, pk2, pk3, name, profile, version)をフォーム送信時に保持する。

<details>
<summary>keywords</summary>

StreamResponse, downloadButton, ファイルダウンロード, downloadSubmit, downloadLink, PartInfo, UploadHelper, ファイルアップロード, n:file, enctype multipart/form-data, JSP, multipart, ListSearchInfo, listSearchResult, pageNumber, DbAccessSupport, TooManyResultException, ApplicationException, @Required, @NumberRange, @Digits, @PropertyName, @OnError, windowScopePrefixes, bodyRowFragment, headerRowFragment, ページング, 検索結果一覧表示, setPageNumber, getSearchConditionProps, MessageUtil, MessageLevel, SqlResultSet, ValidationContext, CompositeKey, n:compositeKeyCheckbox, n:compositeKeyRadioButton, UsersBulkDeleteForm, 複合キー, チェックボックス選択, ラジオボタン選択, 一覧画面, n:hidden, keyNames

</details>

## BLOB型カラムのダウンロード方法

## BLOB型カラムのダウンロード方法

`downloadLink`タグでリンクを実装し、アクションでBlobを`StreamResponse`に渡す。

行データのリストをループして各行にリンクを表示する場合、`c:forEach`の`varStatus.index`でユニークな`name`属性を付与し、`param`タグで選択された行を識別するパラメータを設定する。

JSP実装例:
```jsp
<c:forEach var="record" items="${records}" varStatus="status">
    <n:set var="fileId" name="record.fileId" />
    <div>
        <n:downloadLink uri="/action/.../BlobColumn" name="blobColumn_${status.index}">
            <n:write name="record.fileName" />(<n:write name="fileId" />)
            <n:param paramName="fileId" name="fileId" />
        </n:downloadLink>
    </div>
</c:forEach>
```

アクション実装例:
```java
StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
response.setContentType("image/jpeg");
response.setContentDisposition(record.getString("FILE_NAME"));
return response;
```

`HttpRequest.getPart(name)` でアップロードファイルを `List<PartInfo>` として取得する。

```java
public HttpResponse doMoveFile(HttpRequest req, ExecutionContext ctx) {
    // n:fileタグで指定したname属性を指定してアップロードファイルを取得
    List<PartInfo> partInfoList = req.getPart("userList");
    if (partInfoList.isEmpty()) {
        throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "MSG00039"));
    }
    PartInfo partInfo = partInfoList.get(0);
}
```

> **注意**: 同一の `n:form` タグ内に同一 `name` 属性の `n:file` タグが複数ある場合、`partInfoList` に複数の `PartInfo` が含まれる。

## 特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法

デフォルト値と異なる表示件数・検索結果件数上限を設定するには、アクションで`ListSearchInfo`継承クラスのプロパティを設定する:
- `condition.setMax(MAX_ROWS)`: 1ページの表示件数（`max`プロパティ）を設定する
- `condition.setMaxResultCount(MAX_RESULT_COUNT)`: 検索結果件数の上限（`maxResultCount`プロパティ）を設定する

```java
private static final int MAX_ROWS = 10;
private static final int MAX_RESULT_COUNT = 100;

@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    // ...
    W11AC01SearchForm condition = .....;
    condition.setMax(MAX_ROWS);
    condition.setMaxResultCount(MAX_RESULT_COUNT);
    ctx.setRequestScopedVar("searchCondition", condition);
    // ...
}
```

## 複合キーを用いた排他制御の実装

主キークラスを引数に取る`HttpExclusiveControlUtil`のメソッドを、排他制御ロックを画面で選択された行毎に呼び出す。

**Form実装例** (`getDeletedUsers`メソッドでチェック済み行のみ取得):
```java
public class UsersBulkDeleteForm {
    /** 複合主キー */
    private CompositeKey[] userCompositeKeys;

    /**
     * 一括削除対象を取得する。
     * @return 一括削除対象
     */
    public User[] getDeletedUsers() {
        List<User> deletedUsers = new ArrayList<User>();
        List<CompositeKey> deletedCompositeKeys = Arrays.asList(userCompositeKeys);
        int numOfDeletedUsers = users.length;
        CompositeKey compositeKey;

        for (int i = 0; i < numOfDeletedUsers; i++) {
            User user = users[i];
            compositeKey = new CompositeKey(user.getUserId(), user.getPk2(), user.getPk3());
            if (deletedCompositeKeys.contains(compositeKey)) {
                deletedUsers.add(user);
            }
        }
        return deletedUsers.toArray(new User[deletedUsers.size()]);
    }
}
```
`Arrays.asList(userCompositeKeys)`でチェックされたキーのリストを作り、全ユーザーをループして`deletedCompositeKeys.contains(compositeKey)`で選択行のみを抽出する。

**検索結果表示Action** - `ExclusiveControlContext`のリストを生成して`HttpExclusiveControlUtil.prepareVersions`の第3引数に指定する:
```java
List<ExclusiveControlContext> exclusiveControlContexts = new ArrayList<ExclusiveControlContext>();
User[] users = new User[result.size()];
for (int i = 0; i < result.size(); i++) {
    SqlRow row = result.get(i);
    exclusiveControlContexts.add(new ExclusiveUserCondition(row.getString("USER_ID"), row.getString("PK2"), row.getString("PK3")));
    users[i] = new User(row);
}
HttpExclusiveControlUtil.prepareVersions(context, exclusiveControlContexts);
```

**確認画面表示Action** - チェックされた複合キーを使用して`HttpExclusiveControlUtil.checkVersion`を呼び出す:
```java
User[] deletedUsers = form.getDeletedUsers();
for (int i = 0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.checkVersion(request, context,
        new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

**完了画面表示Action** - チェックされた複合キーを使用して`HttpExclusiveControlUtil.updateVersionWithCheck`を呼び出す:
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

StreamResponse, downloadLink, BLOBダウンロード, Blob, getPart, PartInfo, HttpRequest, ApplicationException, ファイル取得, アップロードファイル取得, List<PartInfo>, ListSearchInfo, max, maxResultCount, setMax, setMaxResultCount, @OnError, 表示件数, 検索結果件数上限, MAX_ROWS, MAX_RESULT_COUNT, HttpExclusiveControlUtil, ExclusiveControlContext, ExclusiveUserCondition, UsersBulkDeleteForm, getDeletedUsers, CompositeKey, prepareVersions, checkVersion, updateVersionWithCheck, 排他制御, 複合キー

</details>

## データレコードのダウンロード方法

## データレコードのダウンロード方法

データレコードをフォーマット済みでダウンロードするには`DataRecordResponse`を使用する。フォーマット定義ファイル（プロジェクト規定の場所に配置）が必要。

`DataRecordResponse`コンストラクタ引数: フォーマット定義のベースパス論理名、フォーマット定義ファイル名

`write(recordType, record)`メソッドでヘッダーとデータを書き込む。ヘッダーにデフォルト値を使用する場合、空のマップを渡す。

フォーマット定義例（`N11AA001.fmt`）:
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

アクション実装例:
```java
DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
response.write("header", Collections.<String, Object>emptyMap());
for (SqlRow record : records) {
    response.write("data", record);
}
response.setContentType("text/csv; charset=Shift_JIS");
response.setContentDisposition("メッセージ一覧.csv");
return response;
```

`UploadHelper.moveFileTo(logicalDirPath, fileName)` でファイルを所定ディレクトリに移動する。第1引数は移動先ディレクトリの論理パス名、第2引数は移動後のファイル名。

```java
UploadHelper helper = new UploadHelper(partInfo);
String fileName = generateUniqueFileName();
helper.moveFileTo("uploadFileSaveDir", fileName);
```

## 検索結果の並び替え

並び替え実現に必要な実装:
1. 可変ORDER BY構文を使用したSQL文を実装する
2. 検索条件クラスに`ListSearchInfo`の`sortId`プロパティのバリデーションを含める
3. `listSearchSortSubmit`タグを使用したJSPを実装する

**SQL文（可変ORDER BY構文）**: `$sort (sortId)`に続けてソートIDと対応するORDER BY列を定義する。検索条件オブジェクトの`sortId`フィールドの値に対応するORDER BY句が使用される。

```sql
$sort (sortId) {
   (1 SA.LOGIN_ID)
   (2 SA.LOGIN_ID DESC)
   (3 USR.MAIL_ADDRESS)
   (4 USR.MAIL_ADDRESS DESC) }
```

**検索条件クラス**:
- コンストラクタで`setSortId((String) params.get("sortId"))`を呼び出す
- `setSortId()`をオーバーライドして`@PropertyName`, `@Required`等のバリデーションアノテーションを付加する
- `SEARCH_COND_PROPS`に`"sortId"`を含める

```java
@PropertyName("ソートID")
@Required
public void setSortId(String sortId) {
    super.setSortId(sortId);
}
```

**JSP（`nbs:listSearchResult`タグ）**: 並び替えを実現するJSPでは、基本的なページングのJSP（s1）に加えて`usePageNumberSubmit="true"`と`useLastSubmit="true"`属性を指定する。

**JSP（`nbs:listSearchSortSubmit`タグの属性）**:

| 属性 | 説明 |
|---|---|
| `ascSortId` | 昇順ソートID（SQL文の昇順ソートIDと合わせる） |
| `descSortId` | 降順ソートID（SQL文の降順ソートIDと合わせる） |
| `label` | リンク表示テキスト |
| `uri` | 検索を行うパス |
| `name` | 画面で一意な名前 |
| `listSearchInfoName` | `ListSearchInfo`継承クラスの変数名 |

JavaScriptを使用する場合は、専用のスクリプトタグ`n:script`を必ず使用すること。

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

scriptタグ内にスクリプトを記述した場合は、スクリプトの内容が自動的にHTMLコメントで囲われて出力される。そのため、タグ内にスクリプトを直接記述すること。

<details>
<summary>keywords</summary>

DataRecordResponse, downloadSubmit, データレコードダウンロード, CSVダウンロード, フォーマット定義, UploadHelper, moveFileTo, ファイル保存, 論理パス名, ListSearchInfo, listSearchSortSubmit, sortId, @Required, @PropertyName, 可変ORDER BY, 並び替え, $sort, ascSortId, descSortId, setSortId, usePageNumberSubmit, useLastSubmit, n:script, JavaScript, スクリプトタグ, HTMLコメント

</details>

## 別ウィンドウを開いてダウンロードを開始する場合

## 別ウィンドウを開いてダウンロードを開始する場合

`popupButton`タグで別ウィンドウを開き（`howto_open_multi_window` 参照）、そのウィンドウのJSPでダウンロード用フォームを実装し、`onload`イベントでサブミットする。

別ウィンドウを開くJSP実装例:
```jsp
<n:popupButton uri="/action/.../ShowSub" name="showSub">
    ダウンロード
</n:popupButton>
```

別ウィンドウJSP実装例（`onload`でサブミット）:
```jsp
<body onload="doOnclick('submit');">
    <h1><n:write name="title" /></h1>
    <p>ダウンロードを開始します。</p>
    <n:errors filter="global" />
    <n:form name="downloadForm">
        <n:downloadSubmit type="button" uri="/action/.../TempFile"
                          name="submit" value="ダウンロード"
                          allowDoubleSubmission="false" />
        <n:button uri="#" name="close" onclick="window.close();">閉じる</n:button>
    </n:form>
</body>
```

`doOnclick`関数: 指定したname属性の要素のonclickイベントを発生させる。IE、標準ブラウザ、フォールバックの3分岐で対応する。

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

画像ファイルなどのバイナリファイルは `PartInfo.getInputStream()` で入力ストリームとして取得する。

```java
PartInfo partInfo = req.getPart("imageFile").get(0);
InputStream in = partInfo.getInputStream();
// 以下、入力ストリームを使用した処理
```

## ページングを使用しない一覧表示

全検索結果を1画面に表示する場合の実装（基本的な実装はページングあり時と同じ）。

**ListSearchInfo継承クラス**: `pageNumber`プロパティの設定不要（初期値が1のため常に1ページ目となる）

**アクション**: `condition.setMax(condition.getMaxResultCount())`の設定が必須（ページングを使用しないため、1ページの表示件数`max`に検索結果上限`maxResultCount`と同じ値を設定する必要がある）。`TooManyResultException`のキャッチ処理も実装する。

```java
@OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
    // ...
    ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
    searchConditionCtx.abortIfInvalid();
    W11AC01SearchForm condition = searchConditionCtx.createObject();
    condition.setMax(condition.getMaxResultCount());
    ctx.setRequestScopedVar("searchCondition", condition);
    SqlResultSet searchResult;
    try {
        // 検索処理は省略。
    } catch (TooManyResultException e) {
        // 例外処理は省略。
    }
    ctx.setRequestScopedVar("11AC_W11AC01", searchResult);
}
```

**JSP**: `usePaging="false"`を指定する。`searchUri`属性の指定は不要。

```jsp
<nbs:listSearchResult listSearchInfoName="11AC_W11AC01"
                    usePaging="false"
                    resultSetName="searchResult">
</nbs:listSearchResult>
```

<details>
<summary>keywords</summary>

popupButton, 別ウィンドウダウンロード, downloadSubmit, onload, doOnclick, getInputStream, InputStream, PartInfo, バイナリファイル, 入力ストリーム, ListSearchInfo, usePaging, setMax, setMaxResultCount, max, maxResultCount, ApplicationException, @OnError, ページングなし, getMaxResultCount, DbAccessSupport, TooManyResultException, SqlResultSet, ValidationContext

</details>

## アップロードファイルをDBに登録する方法

データを一括登録する用途でファイルアップロードを行う場合、`UploadHelper` クラスを使用してファイル精査および登録を簡易的に行える。

> **注意**: 以下の前提事項がある: (1) 単一レイアウトであること（全レコードが同じレイアウト） (2) 登録先テーブルが1つであること（1レコードから複数テーブルへの登録は不可）

処理フロー:
1. **フォーマット定義のロード**: アップロードファイルのデータフォーマット定義ファイルを読み込む
2. **レコード内容チェック**:
   - **形式チェック**: フォーマット定義の項目数・データ形式との照合（フレームワーク自動実行）。通過したレコードはMap型に変換される
   - **精査処理**: 形式チェック通過後の各レコードへのバリデーション。ドメインベースの単項目精査・DB精査・複雑な精査処理を実装可能
   - **空ファイルチェック**: レコードが1件以上存在することを確認
3. **レコードの登録**: 全レコードが検査を通過した場合にDBに登録

実装例（メソッドチェーン）:
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

@OnError, ApplicationException, UploadHelper, アップロードファイルDB登録, applyFormat, setUpMessageIdOnError, validateWith, importWith, 一括登録

</details>

## フォーマット定義ファイルパスの指定

以下のメソッドを使用してアップロードファイルに適用するフォーマットを指定する。

- `applyFormat(String layoutFileName)`: デフォルトの読み込み先を使用する場合
- `applyFormat(String basePathName, String layoutFileName)`: フォーマット定義ファイルの読み込み先をデフォルト値から変更したい場合、論理パス名を指定する

<details>
<summary>keywords</summary>

UploadHelper, applyFormat, フォーマット定義, レイアウトファイル, 論理パス名

</details>

## エラー発生時のメッセージID指定

以下のメソッドを使用してエラー発生時のメッセージIDを指定する。

`setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)`

| 引数 | 設定内容 |
|---|---|
| 第１引数 | 形式エラー時のメッセージID |
| 第２引数 | 精査エラー時のメッセージID |
| 第３引数 | ファイルが空の場合のメッセージID |

形式エラー発生時: 第1引数のメッセージが生成・蓄積される。メッセージに渡される値:
- `{0}`: 形式エラーが発生したレコード行数

例: `{0}行目に形式エラーがあります。` → `12行目に形式エラーがあります。`

精査エラー発生時: 第2引数のメッセージが生成・蓄積される。メッセージに渡される値:
- `{0}`: 精査エラーが発生したレコード行数
- `{1}`: 精査エラーメッセージ文言

例: `{0}行目に精査エラーがあります。 [{1}]` → `8行目に精査エラーがあります。 [カナ氏名は全角カナで入力してください。]`

<details>
<summary>keywords</summary>

setUpMessageIdOnError, 形式エラー, 精査エラー, 空ファイルチェック, エラーメッセージID, UploadHelper

</details>

## 精査処理を実装したクラス、メソッドの指定

`validateWith(Class<F> formClass, String validateFor)` を使用して、精査に使用するフォームクラスと精査メソッド名を指定する。

指定された精査メソッドで精査が実行される。エラーメッセージは蓄積され、データベース一括登録まで例外は送出されない。

<details>
<summary>keywords</summary>

validateWith, 精査メソッド, フォームクラス, バリデーション, UploadHelper

</details>

## データベース一括登録

`importWith(DbAccessSupport dbAccessSupport, String insertSqlId)` を使用して精査済みレコードを一括登録する。

- 第1引数: `DbAccessSupport` のインスタンス。通常 ActionクラスはDbAccessSupportを継承しているため `this` を渡す
- 第2引数: レコード1件を登録するINSERT文のSQLID

形式エラーまたは精査エラーが1件でも存在する場合、`ApplicationException` が送出される。この例外にはそれまでに蓄積されたメッセージ（形式エラー・精査エラー）が全て設定される。

<details>
<summary>keywords</summary>

importWith, DbAccessSupport, 一括登録, INSERT, ApplicationException, 精査エラー, UploadHelper

</details>
