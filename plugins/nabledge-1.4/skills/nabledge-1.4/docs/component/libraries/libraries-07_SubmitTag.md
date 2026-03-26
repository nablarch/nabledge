# ボタン又はリンクによるフォームのサブミット

## カスタムタグ一覧

ボタン・リンクによるフォームサブミット用カスタムタグ一覧。name属性はフォーム内で一意な名前を指定。uri属性の指定方法は :ref:`WebView_SpecifyUri` を参照。

タグ名が `popup` から始まるタグは新しいウィンドウを開いてサブミット、`download` から始まるタグはダウンロード用サブミットを行う。

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| :ref:`WebView_SubmitTag` | inputタグ(type=submit,button,image) |
| :ref:`WebView_ButtonTag` | buttonタグ |
| :ref:`WebView_SubmitLinkTag` | aタグ |
| :ref:`WebView_PopupSubmitTag` | inputタグ(type=submit,button,image) |
| :ref:`WebView_PopupButtonTag` | buttonタグ |
| :ref:`WebView_PopupLinkTag` | aタグ |
| :ref:`WebView_DownloadSubmitTag` | inputタグ(type=submit,button,image) |
| :ref:`WebView_DownloadButtonTag` | buttonタグ |
| :ref:`WebView_DownloadLinkTag` | aタグ |

ポップアップタグ（複数ウィンドウ起動専用）：:ref:`WebView_PopupSubmitTag`、:ref:`WebView_PopupButtonTag`、:ref:`WebView_PopupLinkTag`

通常のsubmit/button/submitLinkタグとの違い：
- 新しいウィンドウをオープンし、そのウィンドウに対してサブミットを行う
- 入力項目のパラメータ名を変更できる

ポップアップはJavaScriptの`window.open`関数で実現する。

| 属性 | 説明 |
|---|---|
| popupWindowName | ポップアップのウィンドウ名。`window.open`の第2引数に指定。省略時は :ref:`WebView_CustomTagConfig` のデフォルト値を使用。デフォルト値未設定の場合はDate関数の現在時刻(ms)をウィンドウ名に使用。 |
| popupOption | ポップアップのオプション情報。`window.open`の第3引数に指定。省略時は :ref:`WebView_CustomTagConfig` のデフォルト値を使用（デフォルト値未設定の場合は何も指定しない）。 |

`popupWindowName`のデフォルト値設定による動作の違い：
- デフォルト値あり：常に同じウィンドウ名を使用 → ウィンドウが1つに固定される
- デフォルト値なし：常に異なるウィンドウ名を使用 → 常に新しいウィンドウをオープン

**changeParamNameタグ**

ポップアップタグは元画面フォームの全input要素を動的追加してサブミットするため、パラメータ名が一致しない場合に :ref:`WebView_ChangeParamNameTag` でパラメータ名を変更する。

| 属性 | 必須 | 説明 |
|---|---|---|
| paramName | ○ | サブミット時に使用するパラメータの名前 |
| inputName | ○ | 変更元となる元画面のinput要素のname属性 |

使用例（郵便番号から住所検索の別ウィンドウを開く）：

![住所検索ポップアップのサンプル画面](../../../knowledge/component/libraries/assets/libraries-07_SubmitTag/WebView_MultiWindowSample.jpg)

```jsp
<n:popupButton name="searchAddress" uri="/action/SearchAction/RW11AB0101">
    検索
    <n:changeParamName inputName="users.postalCode" paramName="condition.postalCode" />
    <n:param paramName="condition.max" value="10" />
</n:popupButton>
```

上記でサブミットされるリクエスト（新しいウィンドウに対して送信）：
- URI: `<コンテキストパス>/action/SearchAction/RW11AB0101`
- `condition.postalCode=1234567`（changeParamNameにより`users.postalCode`はパラメータ名が変更され、元のパラメータは除外）
- `condition.max=10`（paramタグで追加したパラメータ）
- 元画面フォームの他のinput要素（`users.xxxxx`等）

JavaScriptを使用して二重サブミットを防止する。対応カスタムタグ: :ref:`WebView_SubmitTag`、:ref:`WebView_DownloadSubmitTag`、:ref:`WebView_ButtonTag`、:ref:`WebView_DownloadButtonTag`、:ref:`WebView_SubmitLinkTag`、:ref:`WebView_DownloadLinkTag`。

## allowDoubleSubmission属性

| 属性 | デフォルト | 説明 |
|---|---|---|
| allowDoubleSubmission | true | 二重サブミットを許可するか否か。falseで防止。 |

防止の仕組み: 1回目のサブミット時に対象要素のonclick属性を書き換え、2回目以降のサーバ送信をブロック。ボタンの場合はdisabled属性も設定。

```jsp
<n:submit cssClass="buttons" type="button" name="back" value="戻る"
          uri="./USERS00301" />
<n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="./USERS00302" allowDoubleSubmission="false" />
```

> **注意**: 1回目のサブミット後にブラウザの中止ボタンを押した場合、ボタンはdisabled状態のまま再サブミット不可。ユーザーはサブミットに使用したボタン以外のボタン/リンクで処理を継続できる。

## 二重サブミット発生時のコールバック関数

2回目以降のサブミット発生時にコールバック関数が存在すれば呼び出される。以下のシグネチャで実装する:

```javascript
/**
 * @param element 二重サブミットが行われた対象要素(ボタン又はリンク)
 */
function nablarch_handleDoubleSubmission(element) {
  // ここに処理を記述する。
}
```

<details>
<summary>keywords</summary>

カスタムタグ一覧, フォームサブミット, ボタン・リンクサブミット, n:submit, n:button, n:submitLink, popupタグ, downloadタグ, WebView_PopupSubmitTag, WebView_PopupButtonTag, WebView_PopupLinkTag, WebView_ChangeParamNameTag, WebView_CustomTagConfig, popupWindowName, popupOption, changeParamName, 複数ウィンドウ, ポップアップ, パラメータ名変更, allowDoubleSubmission, nablarch_handleDoubleSubmission, 二重サブミット防止, JavaScriptコールバック, WebView_SubmitTag, WebView_DownloadSubmitTag, WebView_ButtonTag, WebView_DownloadButtonTag, WebView_SubmitLinkTag, WebView_DownloadLinkTag

</details>

## サブミット先の指定方法

uri属性にはコンテキストからの相対パスを指定する。サブミット先URIはコンテキストパスが付加されたパスとなる。

```jsp
<n:submit cssClass="buttons" type="button" name="back" value="戻る"
          uri="/action/management/user/UserAction/USERS00301" />
<n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="/action/management/user/UserAction/USERS00302" />
```

> **警告**: 現在のURIからの相対パスを指定した場合、想定外の画面遷移により不正なURIを組み立ててしまうことがある。URIは必ずコンテキストからの相対パスを指定すること。

フレームワークはオープンしたウィンドウへの参照をJavaScriptグローバル変数 `nablarch_opened_windows` に保持する（keyはウィンドウ名）。

```javascript
// keyはウィンドウ名
var nablarch_opened_windows = {};
```

元画面遷移時（`onunload`）に別ウィンドウを全て閉じる実装例：

```javascript
onunload = function() {
  for (var key in nablarch_opened_windows) {
    var openedWindow = nablarch_opened_windows[key];
    if (openedWindow && !openedWindow.closed) {
      openedWindow.close();
    }
  }
  return true;
};
```

サーバ側で発行した一意なトークンをサーバ側(セッション)とクライアント側(hiddenタグ)に保持し、サーバ側で突合することで実現する。トークンは1回のチェックのみ有効。

> **注意**: 同一業務を複数ウィンドウで並行操作した場合、後に確認画面に遷移したウィンドウのみ処理継続可能。先に遷移したウィンドウのトークンは古くなり、処理実行すると二重サブミットと判定される。別々の業務を複数ウィンドウで並行操作する場合は問題にならない。

## トークンの設定（JSP）

### useToken属性（n:form）

:ref:`WebView_FormTag` の `useToken` 属性でトークンの発行・サーバ/クライアントへの設定を行う。

| 属性 | デフォルト | 説明 |
|---|---|---|
| useToken | false | トークンを設定するか否か。trueで設定。`confirmationPage`タグ指定時はデフォルトtrue（:ref:`WebView_InputConfirmationCommon` 参照）。 |

```jsp
<n:form useToken="true">
```

1画面内で複数のformタグにuseToken="true"を指定した場合、最初に発行されたトークンをすべてのformタグで使用する。

### カスタムトークン生成

`TokenGenerator`インタフェースを実装し、リポジトリに`tokenGenerator`という名前で登録することでトークン発行処理を変更できる。デフォルト実装: `RandomTokenGeneratorクラス`（16文字のランダム文字列を生成）。リポジトリに未登録の場合、フレームワークが`RandomTokenGenerator`を生成して使用する。

## トークンのチェック（アクション）

### @OnDoubleSubmissionアノテーション

アクションメソッドに`@OnDoubleSubmission`アノテーションを指定してサーバ側でトークンをチェックする。

```java
@OnDoubleSubmission(path = "forward://MENUS00103", messageId = "MSG00022")
public HttpResponse doUSERS00302(HttpRequest req, ExecutionContext ctx) {
    // 省略
}
```

| 属性 | 説明 |
|---|---|
| path | 二重サブミットと判定した場合の遷移先リソースパス |
| messageId | 遷移先画面に表示するエラーメッセージのメッセージID |
| statusCode | レスポンスステータス（デフォルト: 400） |

### BasicDoubleSubmissionHandler

`DoubleSubmissionHandler`インタフェースを実装してリポジトリに`doubleSubmissionHandler`という名前で登録することで振る舞いを変更できる。基本実装: `nablarch.common.web.token.BasicDoubleSubmissionHandler`。アノテーションで個別指定しない場合のデフォルト値はBasicDoubleSubmissionHandlerのプロパティで設定する。

```xml
<component name="doubleSubmissionHandler"
           class="nablarch.common.web.token.BasicDoubleSubmissionHandler">
    <property name="messageId" value="MSG00022" />
    <property name="statusCode" value="200" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| path | 二重サブミットと判定した場合の遷移先リソースパス（アノテーションで未指定時に使用） |
| messageId | エラーメッセージのメッセージID（アノテーションで未指定時に使用） |
| statusCode | レスポンスステータス（アノテーションで未指定時に使用、デフォルト: 400） |

> **警告**: アノテーション・BasicDoubleSubmissionHandlerのいずれにもpath属性の指定がない場合、二重サブミット判定時に遷移先不明でシステムエラーになる。トークンを使用する場合、必ずどちらか一方にpath属性を指定すること。

<details>
<summary>keywords</summary>

サブミット先URI指定, コンテキストからの相対パス, uri属性, サブミット先URI, nablarch_opened_windows, ポップアップウィンドウ管理, ウィンドウクローズ, onunload, OnDoubleSubmission, BasicDoubleSubmissionHandler, TokenGenerator, RandomTokenGenerator, useToken, 処理済みリクエスト防止, トークンチェック, DoubleSubmissionHandler, doubleSubmissionHandler, tokenGenerator, path, messageId, statusCode

</details>

## サブミットを制御するJavaScript関数

フォームのサブミットはJavaScriptでURIを組み立てることで実現する。カスタムタグは画面内で1回だけサブミット制御JavaScript関数を出力する。

```javascript
/**
 * @param event イベントオブジェクト
 * @param element イベント元の要素(ボタン又はリンク)
 * @return イベントを伝搬させないため常にfalse
 */
function nablarch_submit(event, element)
```

ダウンロード専用タグ：:ref:`WebView_DownloadSubmitTag`、:ref:`WebView_DownloadButtonTag`、:ref:`WebView_DownloadLinkTag`

> **重要**: フレームワークはフォームのサブミット制御にJavaScriptを使用するため、通常のsubmitタグでダウンロードを行うと同じフォーム内の他のサブミットが機能しなくなる。ダウンロードを行うボタンやリンクには必ずダウンロードタグを使用すること。

ダウンロードタグの特徴（通常のsubmit/button/submitLinkタグとの違い）：
- 新しいフォームを作成し、新規フォームに対してサブミットを行う
- 入力項目のパラメータ名を変更できる（:ref:`WebView_ChangeParamNameTag` を使用）

**ダウンロードユーティリティ**

| クラス名 | 説明 |
|---|---|
| `StreamResponse` | ストリームからHTTPレスポンスを生成。`java.io.File`または`java.sql.Blob`のダウンロードをサポート。 |
| `DataRecordResponse` | データレコードからHTTPレスポンスを生成。フォーマット定義ファイルを使用してフォーマット。`Map<String, ?>`型データ（SqlRowなど）をサポート。 |

**Fileのダウンロード（StreamResponse使用例）**

JSPの実装：

```jsp
<%-- downloadButtonタグを使用してダウンロードボタンを実装する。 --%>
<n:downloadButton uri="./TempFile" name="tempFile">ダウンロード</n:downloadButton>
```

アクションの実装：

```java
// FileのダウンロードにはStreamResponseクラスを使用する。
// 第2引数: リクエスト処理終了時にファイルを削除する場合はtrue、削除しない場合はfalse。
// ファイルの削除はフレームワークが行う。
// 通常ダウンロード用のファイルはダウンロード後に不要となるためtrueを指定する。
StreamResponse response = new StreamResponse(file, true);
response.setContentType("text/plain; charset=UTF-8");
response.setContentDisposition(file.getName());
return response;
```

**BLOBカラムのダウンロード（StreamResponse使用例）**

JSPの実装（`records`という名前で行データのリストがリクエストスコープに設定されているものとする）：

```jsp
<c:forEach var="record" items="${records}" varStatus="status">
    <n:set var="fileId" name="record.fileId" />
    <div>
        <%-- downloadLinkタグを使用してリンクを実装する。 --%>
        <n:downloadLink uri="./BlobColumn" name="blobColumn_${status.index}">
            <n:write name="record.fileName" />(<n:write name="fileId" />)
            <%-- 選択されたリンクを判別するためにfileIdパラメータをparamタグで設定する。 --%>
            <n:param paramName="fileId" name="fileId" />
        </n:downloadLink>
    </div>
</c:forEach>
```

アクションの実装：

```java
// fileIdパラメータを使用して選択されたリンクに対応する行データを取得する。
SqlRow record = getRecord(request);
// BlobのダウンロードにはStreamResponseクラスを使用する。
StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
response.setContentType("image/jpeg");
response.setContentDisposition(record.getString("FILE_NAME"));
return response;
```

**データレコード（CSV）のダウンロード（DataRecordResponse使用例）**

フォーマット定義の実装（N11AA001.fmt）：

```
#-------------------------------------------------------------------------------
# メッセージ一覧のCSVファイルフォーマット
# N11AA001.fmtというファイル名でプロジェクトで規定された場所に配置する。
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

JSPの実装：

```jsp
<%-- downloadSubmitタグを使用してダウンロードボタンを実装する。 --%>
<n:downloadSubmit type="button" uri="./CsvDataRecord"
                  name="csvDataRecord" value="ダウンロード" />
```

アクションの実装：

```java
// コンストラクタ引数: フォーマット定義のベースパス論理名, フォーマット定義のファイル名
DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
response.write("header", Collections.<String, Object>emptyMap()); // デフォルトヘッダー情報を使用
for (SqlRow record : records) {
    response.write("data", record);
}
response.setContentType("text/csv; charset=Shift_JIS");
response.setContentDisposition("メッセージ一覧.csv");
return response;
```

ブラウザの戻るボタン押下時に前画面を表示させないため、:ref:`WebView_NoCacheTag` (`<n:noCache/>`) をJSPのheadタグ内に記述する。

```jsp
<%-- headタグ内にnoCacheタグを指定する。 --%>
<head>
  <n:noCache/>
</head>
```

生成されるレスポンスヘッダ:

```
Expires Thu, 01 Jan 1970 00:00:00 GMT
Cache-Control no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma no-cache
```

生成されるHTMLメタタグ:

```html
<head>
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="cache-control" content="no-cache">
  <meta http-equiv="expires" content="0">
</head>
```

> **警告**: `noCacheタグ`は`<n:include>(<jsp:include>)`でincludeされるJSPには指定不可。必ずforwardされるJSPで指定すること。システム全体でキャッシュ防止機能を使用する場合は、各JSPへの実装漏れを防ぐためハンドラで一律設定すること（ハンドラではレスポンスヘッダに上記内容を設定する）。

> **注意**: IE6、IE7、IE8においてHTTP/1.0かつSSL(https)が適用されない通信では有効にならない。本機能を使用する画面は必ずSSL通信を適用すること。

<details>
<summary>keywords</summary>

nablarch_submit, JavaScriptサブミット制御, サブミット制御関数, StreamResponse, DataRecordResponse, WebView_DownloadSubmitTag, WebView_DownloadButtonTag, WebView_DownloadLinkTag, ファイルダウンロード, BLOBダウンロード, CSVダウンロード, downloadButton, downloadLink, downloadSubmit, noCache, WebView_NoCacheTag, ブラウザキャッシュ防止, 戻るボタン防止, Cache-Control, noCacheタグ

</details>

## アプリケーションでonclick属性を指定する場合の制約

- onclick属性未指定の場合: カスタムタグが出力するタグのonclick属性に `nablarch_submit` を自動設定する。
- onclick属性指定の場合: カスタムタグはJavaScript関数を自動設定しない。アプリケーション側で `nablarch_submit(event, element)` を明示的に呼び出す必要がある。

```javascript
function popUpConfirmation(event, element) {
    if (window.confirm("登録します。よろしいですか？")) {
        // フレームワークが出力するJavaScript関数を明示的に呼び出す。
        return nablarch_submit(event, element);
    } else {
        return false;
    }
}
```

```jsp
<n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="./USERS00302" onclick="return popUpConfirmation(event, this);" />
```

DBコミットを伴う処理を要求する画面で使用する。クライアント側とサーバ側の2種類があり、**両方を併用することを推奨**。

- **リクエストの二重送信防止（クライアント側）**: ダブルクリックやレスポンス待ちの再クリックによる2回以上のリクエスト送信を防止
- **処理済みリクエストの受信防止（サーバ側）**: ブラウザの戻るボタンで確認画面に戻り再サブミットした場合など、処理済みリクエストの重複処理を防止

片方のみ使用した場合のリスク：
- クライアント側のみ使用した場合：処理済みリクエストを重複して処理する恐れがある
- サーバ側のみ使用した場合：ダブルクリックで2回リクエストが送信されると、ユーザに2回目のリクエストに対するエラーが返され、1回目の処理結果が返されない

<details>
<summary>keywords</summary>

onclick属性, nablarch_submit呼び出し, カスタムonclick, サブミット前確認ダイアログ, 二重サブミット防止, リクエスト二重送信防止, 処理済みリクエスト受信防止, ダブルクリック防止, prevent_double_submission

</details>

## アプリケーションでformタグのname属性を指定する場合の制約

カスタムタグのJavaScript関数はformタグのname属性を使用してサブミット対象フォームを特定する。

- name属性指定の場合: 画面内で一意な名前を指定すること。
- name属性未指定の場合: `nablarch_form<連番>` 形式で自動生成（連番はformタグの出現順に1から付与）。

> **警告**: formタグのname属性にはJavaScriptの変数名の構文に則った値を指定すること。
> - 値の先頭は英字始まり
> - 先頭以降の値は英数字またはアンダーバー

<details>
<summary>keywords</summary>

formタグname属性, nablarch_form連番, JavaScript変数名規則, フォーム名自動生成

</details>

## ボタン又はリンク毎にパラメータを変更する方法

一覧画面など1フォームに複数リンクで異なるパラメータを送信する場合は :ref:`WebView_ParamTag` を使用する。変更パラメータとはフォームのボタンやリンク毎に変更するパラメータのこと。

**paramタグ属性:**
- `paramName`: リクエストで送信するパラメータ名
- `value`: 直接値を指定する場合
- `name`: リクエストスコープなどスコープ上のオブジェクトを参照する場合

```jsp
<n:submitLink uri="./R0001" name="R0001_${status.index}">
    <n:write name="user.id"/>
    <n:param paramName="sampleId" name="user.id" />
</n:submitLink>
```

変更パラメータは `nablarch_hidden` パラメータに格納され、NablarchTagHandlerクラスがリクエストパラメータとして使用できるように設定する。変更パラメータを使用する場合はNablarchTagHandlerの設定が必須。設定方法は :ref:`WebView_NablarchTagHandler` を参照。

> **警告**: 変更パラメータの数に応じてリクエストのデータ量が増大する。一覧画面でリンク毎に変更パラメータを指定する場合は、プライマリキーのみなど必要最小限のパラメータに限定すること。

<details>
<summary>keywords</summary>

paramタグ, 変更パラメータ, nablarch_hidden, NablarchTagHandler, WebView_ParamTag, リンク毎パラメータ変更, paramName, value, name

</details>

## 認可判定と開閉局判定の結果に応じた表示切り替え

[認可](libraries-04_Permission.md) と :ref:`開閉局<serviceAvailable>` の判定結果に応じてサブミットボタン・リンクの表示を切り替える機能。それぞれに対応するハンドラがハンドラ構成に含まれている場合のみ有効。

**仕様:**
- タグに指定されたリクエストIDに対して認可判定と開閉局判定を実施する
- 認可失敗または閉局の場合に表示切り替えを行う

| 表示方法 | 説明 |
|---|---|
| NODISPLAY（非表示） | タグを表示しない |
| DISABLED（非活性） | ボタン: disabled属性を有効化。リンク: ラベルのみ表示（aタグ非出力）またはカスタムJSPをインクルード（:ref:`WebView_CustomTagConfig` の `submitLinkDisabledJsp` で指定した場合） |
| NORMAL（通常表示） | 表示方法の切り替えを行わない |

デフォルトは :ref:`WebView_CustomTagConfig` で指定した表示方法を使用。個別に変更する場合は各タグの `displayMethod` 属性に `NODISPLAY` / `DISABLED` / `NORMAL` のいずれかを指定。

```jsp
<%-- このタグは常に表示する。 --%>
<n:submit displayMethod="NORMAL" type="button" name="login"
          value="ログイン" uri="/LoginAction/LOGIN001" />
```

> **注意**: アプリケーション全体を非活性・非表示に設定した場合、ログインボタンなど認可されていない状態で使用するボタンも表示制御される。常に表示したいボタン・リンクには `displayMethod="NORMAL"` を個別指定すること。

判定処理は `nablarch.common.web.tag.DisplayControlChecker` インタフェースの実装クラスが行う。 :ref:`WebView_CustomTagConfig` の `displayControlCheckers` プロパティに指定することで変更可能。`displayControlCheckers` プロパティが指定されていない場合は、フレームワークがデフォルトでサポートしている判定処理を使用する。

```xml
<list name="displayControlCheckers">
    <component class="nablarch.common.web.tag.ServiceAvailabilityDisplayControlChecker" />
    <component class="nablarch.common.web.tag.PermissionDisplayControlChecker" />
</list>

<component name="customTagConfig"
           class="nablarch.common.web.tag.CustomTagConfig">
    <property name="displayControlCheckers" ref="displayControlCheckers" />
</component>
```

<details>
<summary>keywords</summary>

認可判定, 開閉局判定, displayMethod属性, NODISPLAY, DISABLED, NORMAL, DisplayControlChecker, ServiceAvailabilityDisplayControlChecker, PermissionDisplayControlChecker, 表示切り替え, submitLinkDisabledJsp, CustomTagConfig

</details>
