## ファイルダウンロードの実現方法

ファイルダウンロードは、下記のタグとHttpResponseを継承したユーティリティクラスを使用する。

**タグ**

* downloadSubmit
* downloadButton
* downloadLink

**ユーティリティクラス**

* StreamResponse
* DataRecordResponse

### ファイルのダウンロード方法

ボタンが押されたらサーバ上のファイルをダウンロードする場合の実装例を示す。

* JSPの実装例

  ```jsp
  <%-- 【説明】
        downloadButtonタグを使用してダウンロードボタンを実装する。 --%>
  <n:downloadButton uri="/action/ss11AC/W11AC02Action/TempFile" name="tempFile">ダウンロード</n:downloadButton>
  ```
* アクションの実装例

  ```java
  /* 【説明】JavaDocは省略。 */
  public HttpResponse doTempFile(HttpRequest request, ExecutionContext context) {
  
      /* 【説明】
          ファイルを取得する処理はプロジェクトの実装方式に従う。*/
      File file = getTempFile();
  
      /* 【説明】
          FileのダウンロードにはStreamResponseクラスを使用する。
          コンストラクタ引数にダウンロード対象のファイルと
          リクエスト処理の終了時にファイルを削除する場合はtrue、削除しない場合はfalseを指定する。
          ファイルの削除はフレームワークが行う。
          通常ダウンロード用のファイルはダウンロード後に不要となるためtrueを指定する。*/
      StreamResponse response = new StreamResponse(file, true);
  
      /* 【説明】
          Content-Typeヘッダ、Content-Dispositionヘッダを設定する。*/
      response.setContentType("text/plain; charset=UTF-8");
      response.setContentDisposition(file.getName());
  
      return response;
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### BLOB型カラムのダウンロード方法

下記テーブル定義に対して、行データ毎にリンクを表示し、
選択されたリンクに対応するデータをダウンロードする場合の実装例を示す。

| カラム(論理名) | カラム(物理名) | データ型 | 補足 |
|---|---|---|---|
| ファイルID | FILE_ID | CHAR(3) | PK |
| ファイル名 | FILE_NAME | NVARCHAR2(100) |  |
| ファイルデータ | FILE_DATA | BLOB |  |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        recordsという名前で行データのリストが
        リクエストスコープに設定されているものとする。 --%>
  <c:forEach var="record" items="${records}" varStatus="status">
      <n:set var="fileId" name="record.fileId" />
      <div>
          <%-- downloadLinkタグを使用してリンクを実装する。 --%>
          <n:downloadLink uri="/action/ss11AC/W11AC02Action/BlobColumn" name="blobColumn_${status.index}">
              <n:write name="record.fileName" />(<n:write name="fileId" />)
              <%-- 選択されたリンクを判別するためにfileIdパラメータをparamタグで設定する。 --%>
              <n:param paramName="fileId" name="fileId" />
          </n:downloadLink>
      </div>
  </c:forEach>
  ```
* アクションの実装例

  ```java
  /* 【説明】JavaDocは省略。 */
  public HttpResponse doBlobColumn(HttpRequest request, ExecutionContext context) {
  
      /* 【説明】
          fileIdパラメータを使用して選択されたリンクに対応する行データを取得する。 */
      SqlRow record = getRecord(request);
  
      /* 【説明】
          BlobのダウンロードにはStreamResponseクラスを使用する。*/
      StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
  
      /* 【説明】
          Content-Typeヘッダ、Content-Dispositionヘッダを設定する。*/
      response.setContentType("image/jpeg");
      response.setContentDisposition(record.getString("FILE_NAME"));
  
      return response;
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### データレコードのダウンロード方法

下記テーブル定義に対して、全データをCSV形式でダウンロードする場合の使用例を示す。

| カラム(論理名) | カラム(物理名) | データ型 | 補足 |
|---|---|---|---|
| メッセージID | MESSAGE_ID | CHAR(8) | PK |
| 言語 | LANG | CHAR(2) | PK |
| メッセージ | MESSAGE | NVARCHAR2(200) |  |

データレコードのダウンロードでは、データレコードをフォーマットした上でダウンロードを行うため、
フォーマットに使用するフォーマット定義ファイルを作成する必要がある。
フォーマット定義ファイルの配置場所はプロジェクトの実装方針に従う。

* フォーマット定義の実装例

  ```bash
  # 【説明】
  #  N11AA001.fmtというファイル名でプロジェクトで規定された場所に配置する。
  
  #-------------------------------------------------------------------------------
  # メッセージ一覧のCSVファイルフォーマット
  #-------------------------------------------------------------------------------
  file-type:        "Variable"
  text-encoding:    "Shift_JIS" # 文字列型フィールドの文字エンコーディング
  record-separator: "\n"        # レコード区切り文字
  field-separator:  ","         # フィールド区切り文字
  
  [header]
  1   messageId    N "メッセージID"
  2   lang         N "言語"
  3   message      N "メッセージ"
  
  [data]
  1   messageId    X # メッセージID
  2   lang         X # 言語
  3   message      N # メッセージ
  ```
* JSPの実装例

  ```jsp
  <%-- 【説明】
        downloadSubmitタグを使用してダウンロードボタンを実装する。 --%>
  <n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/CsvDataRecord"
                    name="csvDataRecord" value="ダウンロード" />
  ```
* アクションの実装例

  ```java
  /* 【説明】JavaDocは省略。 */
  public HttpResponse doCsvDataRecord(HttpRequest request, ExecutionContext context) {
  
      /* 【説明】
          レコードを取得する。*/
      SqlResultSet records = getRecords(request);
  
      /* 【説明】
          データレコードのダウンロードにはDataRecordResponseクラスを使用する。
          コンストラクタ引数にフォーマット定義のベースパス論理名と
          フォーマット定義のファイル名を指定する。*/
      DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
  
      /* 【説明】
          DataRecordResponseのwrite(String recordType, Map<String, ?> record)メソッド
          を使用してヘッダーを書き込む。
          フォーマット定義に指定したデフォルトのヘッダー情報を使用するため、
          空のマップを指定する。*/
      response.write("header", Collections.<String, Object>emptyMap());
  
      /* 【説明】
          DataRecordResponseのwrite(String recordType, Map<String, ?> record)メソッド
          を使用してレコードを書き込む。*/
      for (SqlRow record : records) {
          /* 【説明】レコードを編集する場合はここで行う。 */
          response.write("data", record);
      }
  
      /* 【説明】
          Content-Typeヘッダ、Content-Dispositionヘッダを設定する。*/
      response.setContentType("text/csv; charset=Shift_JIS");
      response.setContentDisposition("メッセージ一覧.csv");
  
      return response;
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### 別ウィンドウを開きダウンロードを開始したい場合

リクエストを受け付けてからダウンロードが開始するまでに処理時間がかかってしまう場合など、
ユーザにダウンロードのサブミットを送信したことを視覚的に伝達するために、
ダウンロードボタンを押すと別ウィンドウが開きダウンロードを開始したい場合がある。

ここでは、別ウィンドウを開きダウンロードを開始したい場合の実装例を示す。

* 別ウィンドウを開くためのJSPの実装例

  別ウィンドウを開くための実装は、 [複数ウィンドウを立ち上げたい場合](../../guide/web-application/web-application-screenTransition.md#複数ウィンドウを立ち上げたい場合) で説明した実装方法で行う。

  ```jsp
  <%-- 【説明】
        ポップアップタグを使用して別ウィンドウを開く。--%>
  <n:popupButton uri="/action/ss11AC/W11AC02Action/ShowSub" name="showSub">
      ダウンロード
  </n:popupButton>
  ```
* ダウンロードを開始する別ウィンドウのJSPの実装例

  画面表示後にすぐにダウンロードを開始するため、
  ダウンロード用のフォームを実装し、onloadイベントでサブミットを行う。

  ```jsp
  <%-- 【説明】
        指定されたname属性を持つ要素のonclickイベントを発生させる
        doOnclick関数を指定する。--%>
  <body onload="doOnclick('submit');">
      <h1><n:write name="title" /></h1>
      <p>ダウンロードを開始します。</p>
      <n:errors filter="global" />
      <n:form name="downloadForm">
          <%-- 【説明】
                ダウンロードボタンを表示したくない場合は、
                「style="display: none;"」などCSSを使用する。 --%>
          <n:downloadSubmit type="button" uri="/action/ss11AC/W11AC02Action/TempFile"
                            name="submit" value="ダウンロード"
                            allowDoubleSubmission="false" />
          <n:button uri="#" name="close" onclick="window.close();"
                    displayMethod="NORMAL">閉じる</n:button>
      </n:form>
  </body>
  ```
* JavaScriptの実装例

  ```javascript
  /**
   * 指定されたname属性を持つ要素のonclickイベントを発生させる。
   * @param name onclickイベントを発生させる要素のname属性
   */
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

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## ファイルアップロードの実現方法

ファイルアップロードを行うには下記のタグとクラスを使用する。

**タグ**

* file

**クラス**

* PartInfo
* UploadHelper

### ファイルアップロード画面の作成方法（JSP）

ユーザが指定したファイルをアップロードする画面の実装例を示す。

* JSPの実装例

```jsp
<n:form enctype="multipart/form-data">

  登録対象ユーザ情報ファイル
  <n:file name="userList" cssClass="input" size="50"/>
  <n:submit name="submit" type="submit" value="アップロード" uri="RW11AC0602"/>
</n:form>
```

> **Warning:**
> ファイルアップロードを行う場合、<n:form>タグに `enctype` 属性に `"multipart/form-data"` を必ず指定すること。
> （通常のHTMLでのformタグと同様）

### アップロードファイルの取得方法（サーバサイド）

サーバ側では、HttpRequestオブジェクトからアップロードファイルを取得することができる。

* アクションの実装例

```java
public HttpResponse doMoveFile(HttpRequest req, ExecutionContext ctx) {

    // n:fileタグで指定したname属性を指定して、アップロードファイルを取得
    List<PartInfo> partInfoList = req.getPart("userList");

    // ファイルがアップロードされていることを確認
    if (partInfoList.isEmpty()) {
        // ファイルがアップロードされていない
        throw new ApplicationException(
                MessageUtil.createMessage(MessageLevel.ERROR, "MSG00039"));
    }
    // アップロードファイル１つ分の情報を取得
    PartInfo partInfo = partInfoList.get(0);
```

> **Note:**
> 同一のn:formタグ内に、同一name属性のn:fileタグが複数ある場合
> 上記ソースコードのpartInfoListには複数のPartInfoが含まれる。

取得したPartInfoオブジェクトをどのように使用するかは、
以下の項を参照。

### アップロードファイルの保存方法

アップロードされたファイルを、所定のディレクトリに移動する実装例を以下に示す。

* アクションの実装例

```java
UploadHelper helper = new UploadHelper(partInfo);

// 【説明】ユニークなファイル名を生成
String fileName = generateUniqueFileName();

// 【説明】ユーティリティクラスを使用しファイルを移動する。
helper.moveFileTo("uploadFileSaveDir",      // 【説明】移動先ディレクトリを論理パス名で指定
                  fileName);                // 【説明】移動後のファイル名を指定
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### アップロードファイルを読み込む方法

画像ファイルなどのバイナリファイルをアップロードする場合、
アップロードファイルを入力ストリームとして扱う必要がある。
その場合の実装例を以下に示す。

```java
public HttpResponse doHandleImageFile(HttpRequest req, ExecutionContext ctx) {

    PartInfo partInfo = req.getPart("imageFile").get(0);

    // 【説明】アップロードファイルの入力ストリームを取得
    InputStream in = partInfo.getInputStream();

    // 【説明】以下、入力ストリームを使用した処理
    //                  :
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### アップロードファイルをDBに登録する方法

データを一括登録する用途でファイルアップロードを行う場合、
アップロードファイルを一時テーブルに登録することが多い。

このような処理を行う場合、UploadHelperクラスを使用してファイル精査および登録を簡易的に行うことができる。

> **Note:**
> 本機能を使用する際、以下の前提事項がある。

> * >   単一レイアウトであること（全レコードが同じレイアウトである）
> * >   登録先テーブルがひとつであること（１レコードから複数テーブルへの登録は不可）

> **Note:**
> UploadHelperクラスの詳細使用については、
> file_upload_utility を参照。

本処理の概要は以下のようになる。

| 処理 | 説明 | 業務処理側で必要な実装内容 |
|---|---|---|
| フォーマット定義のロード | アップロードされるファイルのデータフォーマットを定義した ファイルを決定し読み込む。 | フォーマット定義ファイルパスの指定 |
| レコード内容チェック | アップロードされたファイル中の各レコードに対して以下の検査を 行う。  **形式チェック**  アップロードされたファイル中の各レコードを フレームワークが読み込む際に、自動的に行う検証。 ファイル内のデータが、 フォーマット定義ファイルに記述されている 1レコードあたりの項目数、各項目のデータ形式などの定義に合致 していることを検証する。 形式チェックを通過したレコードはMap型のオブジェクトに 変換される。  **精査処理**  形式チェックを通過した各レコードに対して行われる検証。 通常の業務Actionと同様の実装を行うことができるので、 ドメインベースの単項目精査やDB精査、ビジネスロジックを伴う 複雑な精査処理を実装することができる。  **空ファイルチェック**  アップロードされたファイルが空でないこと （ レコードが１件以上存在すること）をチェックする。 | エラー発生時のメッセージID指定 精査処理を実装したクラス、メソッドの指定 |
| レコードの登録 | アップロードされたファイル中の全てのレコードが上記の検査を 通過したした場合は、それらをDBに登録する。 | データベース一括登録 |

実装例を以下に示す。

```java
// 【説明】ファイルをDBに投入する
@OnError(type = ApplicationException.class, path = "forward://RW11AC0601")
public HttpResponse doRW11AC0602(HttpRequest req, ExecutionContext ctx) {

    PartInfo partInfo = req.getPart("fileToSave").get(0);

   // 全件一括登録
    UploadHelper helper = new UploadHelper(partInfo);
    int cnt = helper.applyFormat("N11AC002")                     // 【説明】フォーマットを適用する
                    .setUpMessageIdOnError("MSG00037",           // 【説明】形式エラー時のメッセージIDを指定する
                                           "MSG00038",           // 【説明】精査エラー時のメッセージIDを指定する
                                           "MSG00040")           // 【説明】ファイルが空の場合のメッセージIDを指定する
                    .validateWith(UserInfoTempEntity.class,      // 【説明】精査メソッドを指定する
                                  "validateRegister")
                    .importWith(this, "INSERT_SQL");             // 【説明】INSERT文のSQLIDを指定する

}
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

#### フォーマット定義ファイルパスの指定

以下のメソッドを使用し、アップロードファイルに適用するフォーマットを指定する。

* applyFormat(String layoutFileName)

フォーマット定義ファイルの読み込み先をデフォルト値から変更したい場合、
論理パス名を指定することもできる。この場合は、以下のメソッドを使用する。

* applyFormat(String basePathName, String layoutFileName)

#### エラー発生時のメッセージID指定

以下のメソッドを使用し、エラー発生時のメッセージIDを指定する。

* setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)

引数には以下の値を設定する。

| 引数 | 設定内容 |
|---|---|
| 第１引数 | 形式エラー時のメッセージID |
| 第２引数 | 精査エラー時のメッセージID |
| 第３引数 | ファイルが空の場合のメッセージID |

形式エラーが発生した場合、第１引数で指定したメッセージが生成され蓄積される。
その際、メッセージには以下の値が渡される。

1. 形式エラーが発生したレコード行数

例えば、以下のメッセージを指定した場合、

```text
{0}行目に形式エラーがあります。
```

実際には、以下のようなメッセージ文言となる。(12行目がエラーの場合)

```text
12行目に形式エラーがあります。
```

精査エラーが発生した場合、第２引数で指定したメッセージが生成され蓄積される。
その際、メッセージには以下の値が渡される。

1. 精査エラーが発生したレコード行数
2. 精査エラーメッセージ文言

例えば、以下のメッセージを指定した場合、

```text
{0}行目に精査エラーがあります。 [1]
```

実際には、以下のようなメッセージ文言となる。(8行目で精査エラーが発生した場合)

```text
8行目に精査エラーがあります。 [カナ氏名は全角カナで入力してください。]
```

#### 精査処理を実装したクラス、メソッドの指定

以下のメソッドを起動し、精査に使用するフォームクラスと精査メソッド名を指定する。

* validateWith(Class<F> formClass, String validateFor)

指定された精査メソッドで精査が実行される。
そのエラーメッセージは蓄積され、 データベース一括登録 まで例外は送出されない。

#### データベース一括登録

以下のメソッドを起動し、精査済みのフォームを一括登録する。

* importWith(DbAccessSupport dbAccessSupport, String insertSqlId)

第１引数にはDbAccessSupportクラスのインスタンスを指定する。
通常ActionクラスはDbAccessSupportクラスを継承しているので、自分自身の参照(this参照)を使用すれば良い。
第２引数には、レコード１件を登録するINSERT文のSQLIDを指定する。

形式エラー、精査エラーが１件でも存在する場合には、ApplicationExceptionが送出される。
エラーが発生した場合、 エラー発生時のメッセージID指定 で指定した精査エラー時のメッセージが生成される。
この例外には、これまでに蓄積されたメッセージ（形式エラー、精査エラー）が全て設定される。

## 検索結果の一覧表示

本フレームワークの検索結果の一覧表示機能を使用した下記の実装例を解説する。

* [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示)
* [特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法](../../guide/web-application/web-application-function.md#特定の一覧表示で表示件数と検索結果件数上限を個別に設定する方法)
* [検索結果の並び替え](../../guide/web-application/web-application-function.md#検索結果の並び替え)
* [ページングを使用しない一覧表示](../../guide/web-application/web-application-function.md#ページングを使用しない一覧表示)

ページングの基本的な実装は、 [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) において解説する。
[特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法](../../guide/web-application/web-application-function.md#特定の一覧表示で表示件数と検索結果件数上限を個別に設定する方法) では、ページングが実現されていることを前提に、特定の一覧表示にて表示件数と検索結果件数(上限)を個別に設定する方法を解説する。
[検索結果の並び替え](../../guide/web-application/web-application-function.md#検索結果の並び替え) では、ページングが実現されていることを前提に、検索結果の並び替えを行う方法を解説する。

> **Note:**
> 検索結果の一覧表示において表示項目（ページングの最初へリンクなど）を変更したい場合は、 [ListSearchResultタグのリファレンス](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_TagReference.html#listsearchresult) を参照。

### ページングを使用した一覧表示

ここでは、基本的なページング機能の実装方法を述べる。

ページングを実現するには下記の実装を行う。

* ListSearchInfoクラスを使用して検索条件を保持するクラスを実装する。
* listSearchResultタグを使用して検索結果を表示するJSPを実装する。
* 検索処理のアクションを実装する。

ユーザ検索処理の実装例を以下に示す。

* 検索条件を保持するクラスの実装例

  ```java
  /* 【説明】
      ユーザ検索の検索条件を保持するクラス。
      ListSearchInfoクラスを継承し、
      ListSearchInfoクラスのpageNumberプロパティ(取得対象のページ番号)を入力精査に含める。 */
  public class W11AC01SearchForm extends ListSearchInfo {
  
      //  検索条件のプロパティ定義は省略。
  
      /*  【説明】
           バリデーション機能に対応したコンストラクタ。 */
      public W11AC01SearchForm(Map<String, Object> params) {
  
          //  検索条件のプロパティ設定は省略。
  
          /* 【説明】
              ListSearchInfoのプロパティを設定する。 */
          setPageNumber((Integer) params.get("pageNumber"));
      }
  
  
      /* 【説明】
          オーバーライドして入力精査用のアノテーションを付加する。
          検索結果の最大件数(上限):200件、1ページの表示件数:20件の場合。 */
      @PropertyName("開始ページ")
      @Required
      @NumberRange(max = 10, min = 1)
      @Digits(integer = 2)
      public void setPageNumber(Integer pageNumber) {
          super.setPageNumber(pageNumber);
      }
  
      /* 【説明】
          精査対象プロパティにListSearchInfoのプロパティを指定する。
          検索条件のプロパティは省略。 */
      private static final String[] SEARCH_COND_PROPS = new String[] { ..., "pageNumber"};
  
      /* 【説明】
          オーバーライドして検索条件のプロパティ名を返す。
          通常は精査対象プロパティと同じとなる。 */
      public String[] getSearchConditionProps() {
          return SEARCH_COND_PROPS;
      }
  }
  ```
* JSPの実装例

  ```jsp
  <%-- 【説明】
        ユーザ検索画面。
        検索条件、ページングを含めて1つのn:formタグで作成する。 --%>
  <n:form>
  
      <%-- 【説明】
            検索条件。
            検索ボタンに変更パラメータを指定する。 --%>
      <div class="search">
          <table class="data conditionArea" width="100%">
  
              <%-- 検索条件の入力項目は省略。 --%>
  
          </table>
          <div id="buttons" class="placeButton">
  
              <input class="cbuttons" type="reset" value="リセット" />
  
              <%-- 【説明】
                    検索ボタン。
                    検索ボタンが押された場合の検索結果の取得開始ページを変更パラメータで指定する。
                    検索ボタンが押された場合は1ページ目から表示するので、通常は1を指定する。 --%>
              <n:submit cssClass="cbuttons" type="button" name="search"
                        uri="/action/ss11AC/W11AC01Action/RW11AC0102" value="検索">
                  <n:param paramName="11AC_W11AC01.pageNumber" value="1" />
              </n:submit>
  
          </div>
      </div>
  
      <%-- 【説明】
            ページング付きの検索結果。
            listSearchInfoName属性:
                アクションでListSearchInfoを継承したクラス(W11AC01SearchForm)を
                リクエストスコープに設定する際に使用した変数名を指定する。
            searchUri属性:
                検索を行うパスを指定する。
                通常は検索ボタンと同じパスを指定する。
            resultSetName属性:
                アクションで検索結果を
                リクエストスコープに設定する際に使用した変数名を指定する。 --%>
      <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                          searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                          resultSetName="searchResult">
  
          <%-- 【説明】
                headerRowFragment属性には、ヘッダ行のJSPフラグメントを指定する。 --%>
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
  
          <%-- 【説明】
                bodyRowFragment属性には、ボディ行のJSPフラグメントを指定する。
                ここで指定したJSPフラグメントは、
                下記の「ボディ行のJSPフラグメントが評価されるタイミング」
                に示したタイミングで評価される。 --%>
          <jsp:attribute name="bodyRowFragment">
  
              <%-- 【説明】
                    ボディ行で使用可能な変数は、下記の通り。
                    row:        行データ
                    oddEvenCss: 奇数行と偶数行ごとのクラス名
                    count:      ループ内のカウント(1はじまり)
                    rowCount:   全ての検索結果件数内のカウント
                                (取得開始位置＋ループ内のインデックス(0はじまり)) --%>
              <tr class="<n:write name="oddEvenCss" />">
                  <td><n:write name="row.loginId" /></td>
                  <td><n:write name="row.kanjiName" /></td>
                  <td><n:write name="row.kanaName" /></td>
                  <td><n:write name="row.ugroupId" />:<n:write name="row.ugroupName" /></td>
                  <td><n:write name="row.extensionNumberBuilding" />-<n:write name="row.extensionNumberPersonal" /></td>
                  <td><n:write name="row.mailAddress" /></td>
              </tr>
  
          </jsp:attribute>
  
      </n:listSearchResult>
  
  </n:form>
  ```

  **ボディ行のJSPフラグメントが評価されるタイミング**

  ```jsp
  <c:forEach var="row" items="${searchResult}" varStatus="status">
  
      <c:if test="${status.count % 2 != 0}">
          <n:set var="oddEvenCss" value="odd" />
      </c:if>
      <c:if test="${status.count % 2 == 0}">
          <n:set var="oddEvenCss" value="even" />
      </c:if>
  
      <n:set var="count" value="${status.count}" />
      <n:set var="rowCount" value="${startPosition + status.index}" />
  
      (bodyRowFragment属性で指定した内容がここにくる)
  
  </c:forEach>
  ```
* アクションの実装例

  ```java
  /* 【説明】
      ユーザ検索処理のアクション。
      実装例ではDbAccessSupportクラスを継承して使用するが、
      プロジェクトの方針に合わせて実装する。 */
  public class W11AC01Action extends DbAccessSupport {
  
      /* 【説明】
          ユーザ検索画面の初期表示で呼ばれるメソッド。 */
      public HttpResponse doRW11AC0101(HttpRequest req, ExecutionContext ctx) {
          // 初期表示は、業務処理のみのため省略。
      }
  
      /* 【説明】
          ユーザ検索画面の検索で呼ばれるメソッド。 */
      @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
      public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
  
          // 業務処理は省略。
  
          // 入力精査
          ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
          if (!searchConditionCtx.isValid()) {
              throw new ApplicationException(searchConditionCtx.getMessages());
          }
          W11AC01SearchForm condition = searchConditionCtx.createObject();
  
          /* 【説明】
              検索結果表示(listSearchResultタグ)で使用するため、
              ListSearchInfoを継承したクラス(W11AC01SearchForm)をリクエストスコープに設定する。 */
          ctx.setRequestScopedVar("searchCondition", condition);
  
          // 検索実行
          SqlResultSet searchResult;
          try {
              /* 【説明】
                  ユーザ検索処理。
                  DbAccessSupportクラスのsearchメソッドを使用する。
                  "SELECT_USER_BY_CONDITION"は、ユーザ検索を行うSELECT文に対するSQL_ID。 */
              searchResult = search("SELECT_USER_BY_CONDITION", condition);
          } catch (TooManyResultException e) {
              /* 【説明】
                  検索結果件数が上限を超えた場合のエラー処理。
                  TooManyResultExceptionは、検索結果の最大件数(上限)、実際の検索結果件数を提供する。
                  "MSG00024"は「検索結果が上限件数({0}件)を超えました。」というメッセージに対するメッセージID。 */
              throw new ApplicationException(
                  MessageUtil.createMessage(MessageLevel.ERROR, "MSG00024", e.getMaxResultCount()));
          }
  
          // 検索結果をリクエストスコープに設定
          ctx.setRequestScopedVar("11AC_W11AC01", searchResult);
  
          return new HttpResponse("/ss11AC/W11AC0101.jsp");
      }
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### 特定の一覧表示で表示件数と検索結果件数(上限)を個別に設定する方法

ここでは特定の一覧表示にて、システムのデフォルト値とは異なる表示件数と検索結果件数（上限）を設定する実装例を示す。

尚、ここでは、 [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) が実現されているものとして、
[ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) との差分についてのみ実装例を示す。

特定の一覧表示にて個別の表示件数と検索結果件数（上限）を設定するには、下記の実装を行う。

* 一覧表示画面を表示するアクションのメソッドにて、ListSearchInfoを継承したクラスに表示件数と検索結果件数(上限)を設定する。

ユーザ検索画面にてデフォルト値とは異なる表示件数と検索結果件数（上限）を設定する実装例を以下に示す。

* アクションの実装例

  ```java
  // 一覧表示の最大表示件数
  private static final int MAX_ROWS = 10;
  
  // 一覧表示の検索結果件数（上限）
  private static final int MAX_RESULT_COUNT = 100;
  
  /* 【説明】
      ユーザ検索画面の検索で呼ばれるメソッド。 */
  @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
  public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
  
      // 業務処理は省略。
  
      // 入力精査は省略。
      W11AC01SearchForm condition = .....;
  
      /* 【説明】
          一覧表示の表示件数がデフォルト値と異なる場合は、
          ListSearchInfoを継承したクラス(W11AC01SearchForm)のmaxプロパティに設定する。 */
      condition.setMax(MAX_ROWS);
  
      /* 【説明】
          検索結果件数（上限）がデフォルト値と異なる場合は、
          ListSearchInfoを継承したクラス(W11AC01SearchForm)のmaxResultCountプロパティに設定する。 */
      condition.setMaxResultCount(MAX_RESULT_COUNT);
  
      /* 【説明】
          検索結果表示(listSearchResultタグ)で使用するため、
          ListSearchInfoを継承したクラス(W11AC01SearchForm)をリクエストスコープに設定する。 */
      ctx.setRequestScopedVar("searchCondition", condition);
  
      // 検索処理は省略
  
      // 以降の処理は省略。
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### 検索結果の並び替え

ここでは検索結果の一覧画面の並べ替えの実装例を示す。

尚、ここでは、 [ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) が実現されているものとして、
[ページングを使用した一覧表示](../../guide/web-application/web-application-function.md#ページングを使用した一覧表示) との差分についてのみ実装例を示す。

検索結果の並び替えを実現するには下記の実装を行う。

* 可変ORDER BY構文を使用したSQL文を実装する。
* 検索条件を保持するクラスにListSearchInfoクラスのsortIdプロパティの入力精査を含める。
* listSearchSortSubmitタグを使用して並べ替え用のリンクを表示するJSPを実装する。

ユーザ検索画面の実装例を以下に示す。

* SQL文の実装例

  ```sql
  -- 【説明】
  -- 可変ORDER BY構文を使用したSQL文。
  -- ログインIDとメールアドレスを並び替える場合の実装例。
  -- どのORDER BYを使用するかは、$sort (sortId)の記述により、
  -- 検索条件オブジェクトのsortIdフィールドから取得した値が使用される。
  -- 例えば、検索条件オブジェクトのsortIdフィールドが3の場合、
  -- ORDER BY句は"ORDER BY USR.MAIL_ADDRESS"に変換される。
  
  SELECT_USER_BY_CONDITION =
  SELECT
    -- 省略
  FROM
      -- 省略
  WHERE
      -- 省略
  $sort (sortId) {
     (1 SA.LOGIN_ID)
     (2 SA.LOGIN_ID DESC)
     (3 USR.MAIL_ADDRESS)
     (4 USR.MAIL_ADDRESS DESC) }
  ```
* 検索条件を保持するクラスの実装例

  ```java
  /* 【説明】
      ユーザ検索の検索条件を保持するクラス。 */
  public class W11AC01SearchForm extends ListSearchInfo {
  
      //  検索条件のプロパティ定義は省略。
  
      /*  バリデーション機能に対応したコンストラクタ。 */
      public W11AC01SearchForm(Map<String, Object> params) {
  
          //  検索条件のプロパティ設定は省略。
  
          /* 【説明】
              ListSearchInfoのsortIdプロパティを設定する。 */
          setSortId((String) params.get("sortId"));
      }
  
  
      /* 【説明】
          オーバーライドして入力精査用のアノテーションを付加する。 */
      @PropertyName("ソートID")
      @Required
      public void setSortId(String sortId) {
          super.setSortId(sortId);
      }
  
      /* 【説明】
          精査対象プロパティにListSearchInfoのsortIdプロパティを指定する。
          検索条件のプロパティは省略。 */
      private static final String[] SEARCH_COND_PROPS = new String[] { ..., "sortId"};
  
      /* 【説明】
          オーバーライドして検索条件のプロパティ名を返す。
          通常は精査対象プロパティと同じとなる。 */
      public String[] getSearchConditionProps() {
          return SEARCH_COND_PROPS;
      }
  }
  ```
* JSPの実装例

  ```jsp
  <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                      searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                      resultSetName="searchResult"
                      usePageNumberSubmit="true"
                      useLastSubmit="true">
      <%-- 【説明】
            ヘッダ行にlistSearchSortSubmitタグを使用して並び替え用のリンクを追加する。--%>
      <jsp:attribute name="headerRowFragment">
          <tr>
              <th>
                  <%-- 【説明】
                        ログインIDを並び替え用のリンクにする。
                        SQL文に合わせて昇順(1)と降順(2)のソートIDを指定する。
                        name属性は画面で一意になるように指定する。 --%>
                  <n:listSearchSortSubmit ascSortId="1" descSortId="2"
                                          label="ログインID" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                                          name="loginIdSort" listSearchInfoName="11AC_W11AC01" />
              </th>
              <th>漢字氏名</th>
              <th>カナ氏名</th>
              <th>グループ</th>
              <th>内線番号</th>
              <th>
                  <%-- 【説明】
                        メールアドレスを並び替え用のリンクにする。
                        SQL文に合わせて昇順(3)と降順(4)のソートIDを指定する。
                        name属性は画面で一意になるように指定する。 --%>
                  <n:listSearchSortSubmit ascSortId="3" descSortId="4"
                                      label="メールアドレス" uri="/action/ss11AC/W11AC01Action/RW11AC0102"
                                      name="kanaNameSort" listSearchInfoName="11AC_W11AC01" />
              </th>
          </tr>
      </jsp:attribute>
      <jsp:attribute name="bodyRowFragment">
          <%-- 省略 --%>
      </jsp:attribute>
  </n:listSearchResult>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### ページングを使用しない一覧表示

ここでは検索結果の一覧画面においてページングを使用せずに1画面にすべての検索結果を表示する場合の実装例を示す。

1画面にすべての検索結果を一覧表示する場合、基本的な実装方法はページングを使用する場合と変わらない。
検索処理や並び替えの処理もページングを使用する場合と同じ実装方法となる。

ユーザ検索処理の実装例を以下に示す。

* ListSearchInfoを継承するクラスの実装例

  ```java
  /* 【説明】
      ユーザ検索の検索条件を保持するクラス。
      ListSearchInfoを継承する。 */
  public class W11AC01SearchForm extends ListSearchInfo {
  
      // 検索条件のプロパティ定義は省略。
  
      /* 【説明】
          バリデーション機能に対応したコンストラクタ。 */
      public W11AC01SearchForm(Map<String, Object> params) {
  
          // 検索条件のプロパティ設定は省略。
  
          /* 【説明】
              ページングを使用する場合と異なり、ListSearchInfoのpageNumberプロパティの設定は不要。
              pageNumberプロパティの初期値は1のため常に1ページ目となる。 */
      }
  
      /* 【説明】
          精査対象プロパティ。
          検索条件のプロパティのみとなる。 */
      private static final String[] SEARCH_COND_PROPS = new String[] { ... };
  
      /* 【説明】
          オーバーライドして検索条件のプロパティ名を返す。
          通常は精査対象プロパティと同じとなる。 */
      public String[] getSearchConditionProps() {
          return SEARCH_COND_PROPS;
      }
  }
  ```
* アクションの実装例

  ```java
  /* 【説明】
      ユーザ検索処理のアクション。
      実装例ではDbAccessSupportクラスを継承して使用するが、
      プロジェクトの方針に合わせて実装する。 */
  public class W11AC01Action extends DbAccessSupport {
  
      /* 【説明】
          ユーザ検索画面の検索で呼ばれるメソッド。 */
      @OnError(type = ApplicationException.class, path = "/ss11AC/W11AC0101.jsp")
      public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
  
          // 業務処理は省略。
  
          // 入力精査
          ValidationContext<W11AC01SearchForm> searchConditionCtx = ...;
          if (!searchConditionCtx.isValid()) {
              throw new ApplicationException(searchConditionCtx.getMessages());
          }
          W11AC01SearchForm condition = searchConditionCtx.createObject();
  
          /* 【説明】
              検索結果の取得件数(1ページの表示件数)に検索結果の最大件数(上限)を設定する。
              ページングを使用しないため下記の設定が必須となる。 */
          condition.setMax(condition.getMaxResultCount());
  
          ctx.setRequestScopedVar("searchCondition", condition);
  
          // 検索実行
          SqlResultSet searchResult;
          try {
              // 検索処理は省略。
          } catch (TooManyResultException e) {
              // 例外処理は省略。
          }
  
          // 検索結果をリクエストスコープに設定
          ctx.setRequestScopedVar("11AC_W11AC01", searchResult);
  
          return new HttpResponse("/ss11AC/W11AC0101.jsp");
      }
  }
  ```
* JSPの実装例

  ```jsp
  <%-- 【説明】
        ページングを使用しないのでusePaging属性にfalseを指定する。
        ページングを使用しないのでsearchUri属性の指定は不要。 --%>
  <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                      usePaging="false"
                      resultSetName="searchResult">
  
      <%-- その他の属性は省略。 --%>
  
  </n:listSearchResult>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 複合キーを使用したデータの一覧画面から、ラジオボタン・チェックボックスでデータを選択する

[検索結果の一覧表示](../../guide/web-application/web-application-function.md#検索結果の一覧表示) で作成する一覧画面では、一括削除処理などのように一覧の中から一部の
データをチェックボックスあるいはラジオボタンで選択させて処理を行うUIがしばしば作られる。
このようなUIを複合キーで実現する際の実装方法を以下に示す。

### 複合キーを用いたUIの実装

複合キーを用いた場合、単純なキーを使用する場合と比較して下記の考慮が必要となる。

* 画面入力用 Form では、キー項目用に CompositeKeyクラスのプロパティを一つ用意する。
* JSP で複合キー項目の入力に n:checkbox、n:radioButton の代わりに n:compositeKeyCheckbox または n:compositeKeyRadioButton を使用する。

以下に実装例を示す。

* Form の実装例

```java
/* 【説明】JavaDocは省略。 */
    public class UsersBulkDeleteForm {

        /*
          【説明】
          複合キーはCompositeKeyの配列(checkboxで複数選択の場合)、
          またはCompositeKey (radioで単一選択の場合)で保持する。
          */
        private CompositeKey[] userCompositeKeys;

        /* 【説明】setter,getter, コンストラクタは省略。 */
    }
```

* JSPの実装例

  ```jsp
  <n:listSearchResult listSearchInfoName="condition"
                 searchUri="./EXCLUS30102"
                 resultSetName="form.users"
                 usePageNumberSubmit="true">
      <jsp:attribute name="headerRowFragment">
  
        <%-- 【説明】ヘッダ部分は省略 --%>
  
      </jsp:attribute>
      <jsp:attribute name="bodyRowFragment">
      <tr class="<n:write name="oddEvenCss" />">
          <td>
              <%--
                【説明】
                 keyNames 属性には、 n:listSearchResult の各行 (row) のプロパティにある
                 キー属性をカンマ区切りで指定する。
              --%>
              <n:compositeKeyCheckbox namePrefix="form"
                 valueObject="${row}"
                 keyNames="userId,pk2,pk3"
                 name="form.userCompositeKeys"
                 />
              <n:hidden name  = "form.users[${count -1}].userId"  />
              <n:hidden name  = "form.users[${count -1}].pk2"  />
              <n:hidden name  = "form.users[${count -1}].pk3"  />
              <n:hidden name  = "form.users[${count -1}].name"  />
              <n:hidden name  = "form.users[${count -1}].profile"  />
              <n:hidden name  = "form.users[${count -1}].version"  />
          </td>
          <td>
              <n:write name="row.userId" />
              (所持カード一覧)
          </td>
          <td><n:write name="row.name" /></td>
          <td><n:write name="row.profile" /></td>
          <td><n:write name="row.version" /></td>
      </tr>
      </jsp:attribute>
  </n:listSearchResult>
  ```

### 複合キーを用いた排他制御の実装

複合キーを用いた排他制御では、主キークラスを引数に取る HttpExclusiveControlUtil の
メソッドを、排他制御ロックを画面で選択された行毎に呼び出すよう実装する。

複合キーを用いた排他制御の実装例を以下に示す。

* Action で使用する Form の実装例

```java
public class UsersBulkDeleteForm {

    /** 複合主キー */
    private CompositeKey[] userCompositeKeys;

    /* 【説明】setter, getter, コンストラクタ、バリデートメソッドは省略 */

    /**
     * 一括削除対象を取得する。
     * @return 一括削除対象
     */
    public User[] getDeletedUsers() {
        /* 【説明】チェックされたオブジェクトのみを取得する処理 */
        List<User> deletedUsers = new ArrayList<User>();
        List<CompositeKey> deletedCompositeKeys = Arrays.asList(userCompositeKeys);
        int numOfDeletedUsers = users.length;
        StringBuilder sb = new StringBuilder();
        CompositeKey compositeKey;

        for (int i = 0; i < numOfDeletedUsers; i++) {
            User user = users[i];
            sb.delete(0, sb.length());
            compositeKey = new CompositeKey(user.getUserId(), user.getPk2(), user.getPk3());
            if (deletedCompositeKeys.contains(compositeKey)) {
                deletedUsers.add(user);
            }
        }
        return deletedUsers.toArray(new User[deletedUsers.size()]);
    }
}
```

* 検索結果表示を行う Action の実装例

```java
/*
  【説明】
  検索処理は一覧表示と同様に行う。
  */

SqlResultSet result = searchUser(request, context);

/*
  【説明】
  ExclusiveControlContext のリストを生成し、HttpExclusiveControlUtil.prepareVersions の
  第3引数に指定する。
  */
List<ExclusiveControlContext> exclusiveControlContexts = new ArrayList<ExclusiveControlContext>();
User[] users = new User[result.size()];
for (int i = 0; i < result.size(); i++) {
    SqlRow row = result.get(i);
    exclusiveControlContexts.add(new ExclusiveUserCondition(row.getString("USER_ID"), row.getString("PK2"), row.getString("PK3")));
    users[i] = new User(row);
}
HttpExclusiveControlUtil.prepareVersions(context, exclusiveControlContexts);
```

* 確認画面表示処理での排他制御チェックを行う Action の実装例

```java
/*
  【説明】
  精査処理は一覧表示と同様に行う。
  */
UsersBulkDeleteForm form = validate("form", UsersBulkDeleteForm.class, request, "usersBulkDelete");
/*
  【説明】
  チェックされた複合キーのオブジェクトを取得する。
  ※form.getDeletedUsers メソッドの中では、チェックされた User エンティティのみを取り出す処理を行っている。
  */
User[] deletedUsers = form.getDeletedUsers();

/*
  【説明】
  チェックされたオブジェクトのキーを使用して排他制御キークラスのオブジェクトを生成し、
  HttpExclusiveControlUtil.checkVersion メソッドを呼び出す。
  */
for( int i=0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.checkVersion(request, context, new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}

/* 【説明】以降の処理は省略*/
```

* 完了画面表示処理での排他制御チェックを行う Action の実装例

```java
/*
  【説明】
  精査処理は一覧表示と同様に行う。
  */
UsersBulkDeleteForm form = validate("form", UsersBulkDeleteForm.class, request, "usersBulkDelete");
User[] deletedUsers = form.getDeletedUsers();

/*
  【説明】
  チェックされたオブジェクトのキーを使用して排他制御キークラスのオブジェクトを生成し、
  HttpExclusiveControlUtil.updateVersionWithCheck メソッドを呼び出す。
  */
for( int i=0; i < deletedUsers.length; i++) {
    User deletedUser = deletedUsers[i];
    HttpExclusiveControlUtil.updateVersionWithCheck(request, new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}

/* 【説明】以降の処理(DBの更新処理)は省略*/
```

## Javascriptの使用

Javascriptを使用する場合は、下記の記述例の様に必ず専用の
[スクリプトタグ](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_TagReference.html#webview-scripttag)
を使用すること。

**JSPの記述例**

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

なお、scriptタグ内にスクリプトを記述した場合は、スクリプトの内容が自動的にHTMLコメントで囲われて出力される。
そのため、上記例のようにタグ内にスクリプトを直接記述すること。
