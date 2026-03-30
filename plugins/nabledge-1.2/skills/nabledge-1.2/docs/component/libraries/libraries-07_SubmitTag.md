# ボタン又はリンクによるフォームのサブミット

**公式ドキュメント**: [ボタン又はリンクによるフォームのサブミット]()

## ボタン又はリンクによるフォームのサブミット

フォームのサブミットをボタン・リンクで行うためのカスタムタグ。各タグは `name` 属性（フォーム内で一意な名前）と `uri` 属性（:ref:`WebView_SpecifyUri` 参照）を指定する。

- `popup` で始まるタグ：新しいウィンドウをオープンし、そのウィンドウに対してサブミットを行う
- `download` で始まるタグ：ダウンロード用のサブミットを行う

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

ポップアップタグを使用して複数ウィンドウを開き、入力補助を実現する。

**ポップアップタグ**:
- :ref:`WebView_PopupSubmitTag`
- :ref:`WebView_PopupButtonTag`
- :ref:`WebView_PopupLinkTag`

通常のsubmitタグ/buttonタグ/submitLinkタグとの違い:
- 新しいウィンドウをオープンし、オープンしたウィンドウに対してサブミットを行う
- 入力項目のパラメータ名を変更できる

`window.open`関数で実現。属性:

| 属性 | 説明 |
|---|---|
| popupWindowName | ポップアップのウィンドウ名。`window.open`の第2引数。未指定時は:ref:`WebView_CustomTagConfig`のデフォルト値を使用（デフォルト値未設定時はDate関数から取得した現在時刻ミリ秒をウィンドウ名に使用）。 |
| popupOption | ポップアップのオプション。`window.open`の第3引数。未指定時は:ref:`WebView_CustomTagConfig`のデフォルト値を使用（デフォルト値未設定時は何も指定しない）。 |

popupWindowNameのデフォルト値設定による動作の違い:
- **デフォルト値あり**: 常に同じウィンドウ名 → 常に同一ウィンドウを再利用（1ウィンドウのみ開く）
- **デフォルト値なし**: 毎回異なるウィンドウ名 → 常に新しいウィンドウをオープン

**changeParamNameタグ** (:ref:`WebView_ChangeParamNameTag`): ポップアップタグは元画面の全input要素を動的に追加してサブミットするため、アクション間でパラメータ名が一致しない場合に使用する。

| 属性 | 説明 |
|---|---|
| paramName（必須） | サブミット時に使用するパラメータの名前 |
| inputName（必須） | 変更元となる元画面のinput要素のname属性 |

使用例（郵便番号`users.postalCode`を`condition.postalCode`に変更して検索ポップアップを開く）:

```jsp
<n:popupButton name="searchAddress" uri="/action/SearchAction/RW11AB0101">
    検索
    <n:changeParamName inputName="users.postalCode" paramName="condition.postalCode" />
    <n:param paramName="condition.max" value="10" />
</n:popupButton>
```

送信されるリクエスト（`condition.postalCode=1234567`, `condition.max=10`）。`users.postalCode`はchangeParamNameにより変換済みのため元のパラメータ名では含まれない。

JavaScriptを使用して二重送信を防止する機能。以下のカスタムタグが対応している。

- :ref:`WebView_SubmitTag` (input type=submit/button/image対応)
- :ref:`WebView_DownloadSubmitTag` (input type=submit/button/image対応)
- :ref:`WebView_ButtonTag`
- :ref:`WebView_DownloadButtonTag`
- :ref:`WebView_SubmitLinkTag`
- :ref:`WebView_DownloadLinkTag`

## allowDoubleSubmission属性

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| allowDoubleSubmission | 二重サブミットを許可するか否か。true=許可、false=不許可 | true |

二重サブミット防止の仕組み: 1回目のサブミット時に対象要素のonclick属性を書き換え2回目以降はサーバに送信しない。ボタンの場合はdisabled属性も設定する。

```jsp
<n:submit cssClass="buttons" type="button" name="back" value="戻る" uri="./USERS00301" />
<n:submit cssClass="buttons" type="button" name="register" value="登録" uri="./USERS00302" allowDoubleSubmission="false" />
```

> **注意**: 1回目のサブミット後にユーザがブラウザの中止ボタンを押した場合、ボタンはdisabled状態のままとなり再送信できなくなる。この場合、サブミットに使用したボタン以外のボタン/リンクで処理を継続できる。

## コールバック関数による振る舞いの追加

2回目以降のサブミット要求発生時にコールバック関数が存在すれば呼び出される。

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

n:submit, n:submitLink, n:button, popup, download, カスタムタグ一覧, フォームサブミット, name属性, uri属性, WebView_SubmitTag, WebView_ButtonTag, WebView_SubmitLinkTag, WebView_PopupSubmitTag, WebView_PopupButtonTag, WebView_PopupLinkTag, WebView_DownloadSubmitTag, WebView_DownloadButtonTag, WebView_DownloadLinkTag, ポップアップタグ, 複数ウィンドウ, popupWindowName, popupOption, changeParamName, WebView_ChangeParamNameTag, n:popupButton, allowDoubleSubmission, nablarch_handleDoubleSubmission, 二重サブミット防止, 二重送信防止, disabled属性

</details>

## サブミット先の指定方法

`uri` 属性にはコンテキストからの相対パスを指定する。

```jsp
<n:submit cssClass="buttons" type="button" name="back" value="戻る"
          uri="/action/management/user/UserAction/USERS00301" />
<n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="/action/management/user/UserAction/USERS00302" />
```

サブミット先URIはコンテキストパスが付加されたパスとなる。

> **警告**: 現在のURIからの相対パスを指定した場合、想定していない画面遷移により不正なURIを組み立ててしまうことがある。ボタン又はリンクによるフォームのサブミットでURIを指定する場合は、必ずコンテキストからの相対パスを指定すること。

フレームワークは、ポップアップタグでオープンしたウィンドウへの参照をJavaScriptのグローバル変数に保持する。

```javascript
// keyはウィンドウ名
var nablarch_opened_windows = {};
```

元画面遷移時に不要な別ウィンドウを全て閉じる実装例（onunloadイベントにバインド）:

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

サーバ側で発行した一意なトークンをサーバ側(セッション)とクライアント側(hiddenタグ)に保持し、サーバ側で突合することで実現する。このトークンは1回のチェックに限り有効。

> **注意**: 同じ業務を複数ウィンドウで並行操作した場合、後に確認画面に遷移したウィンドウのみ処理継続可能。先に確認画面に遷移したウィンドウはトークンが古くなり二重サブミットと判定される。別々の業務を複数ウィンドウで並行操作することは問題とならない。

![トークン制約の画面遷移](../../../knowledge/component/libraries/assets/libraries-07_SubmitTag/WebView_TokenConstraint.jpg)

## a) トークンの設定

### useToken属性

:ref:`WebView_FormTag` の `useToken` 属性でトークンを設定する。

```jsp
<n:form useToken="true">
```

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| useToken | トークンを設定するか否か。true=設定、false=未設定 | false (confirmationPageタグ指定時はtrue) |

1つの画面内で複数のformタグにuseToken="true"を指定した場合、最初に発行されたトークンを全formタグで使用する。

### トークン発行処理の変更

`TokenGenerator` インタフェースを実装し、リポジトリに `"tokenGenerator"` という名前で登録することで変更可能。

デフォルト実装: **クラス**: `RandomTokenGenerator` (16文字のランダム文字列を生成)

## b) トークンのチェック

### @OnDoubleSubmissionアノテーション

**アノテーション**: `@OnDoubleSubmission`

アクションのメソッドに指定してサーバ側でトークンをチェックする。

```java
@OnDoubleSubmission(path = "forward://MENUS00103", messageId = "MSG00022")
public HttpResponse doUSERS00302(HttpRequest req, ExecutionContext ctx) {
    // 省略。
}
```

| 属性 | 説明 | デフォルト値 |
|---|---|---|
| path | 二重サブミット判定時の遷移先リソースパス | |
| messageId | 二重サブミット判定時のエラーメッセージID | |
| statusCode | 二重サブミット判定時のレスポンスステータス | 400 (Bad Request) |

### OnDoubleSubmissionアノテーションの振る舞いの変更

`DoubleSubmissionHandler` インタフェースを実装し、リポジトリに `"doubleSubmissionHandler"` という名前で登録することで変更可能。

デフォルト実装: **クラス**: `BasicDoubleSubmissionHandler`

アプリケーション全体のデフォルト値を設定する場合は `BasicDoubleSubmissionHandler` をリポジトリに登録する。

```xml
<component name="doubleSubmissionHandler"
           class="nablarch.common.web.token.BasicDoubleSubmissionHandler">
    <property name="messageId" value="MSG00022" />
    <property name="statusCode" value="200" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| path | 二重サブミット判定時の遷移先リソースパス。アノテーションで個別指定がない場合に使用。 |
| messageId | 二重サブミット判定時のエラーメッセージID。アノテーションで個別指定がない場合に使用。 |
| statusCode | 二重サブミット判定時のレスポンスステータス。デフォルトは400(Bad Request)。アノテーションで個別指定がない場合に使用。 |

> **警告**: アノテーションとBasicDoubleSubmissionHandlerの両方でpath属性が未指定の場合、二重サブミット判定時に遷移先不明となりシステムエラーが発生する。トークンを使用した二重サブミット防止機能を使用する場合は、必ずどちらか一方でpath属性を指定すること。

<details>
<summary>keywords</summary>

サブミット先URI, コンテキスト相対パス, uri属性, フォームサブミット先指定, コンテキストパス, nablarch_opened_windows, ポップアップウィンドウ管理, window.open, onunload, ウィンドウクローズ, TokenGenerator, RandomTokenGenerator, BasicDoubleSubmissionHandler, DoubleSubmissionHandler, OnDoubleSubmission, @OnDoubleSubmission, useToken, tokenGenerator, doubleSubmissionHandler, 処理済みリクエストの受信防止, トークンチェック, WebView_FormTag

</details>

## サブミットを制御するJavaScript関数

カスタムタグは、画面内で1回だけ、サブミットを制御するJavaScript関数を出力する。

```javascript
/**
 * @param event イベントオブジェクト
 * @param element イベント元の要素(ボタン又はリンク)
 * @return イベントを伝搬させないため常にfalse
 */
function nablarch_submit(event, element)
```

**ダウンロードタグ**:
- :ref:`WebView_DownloadSubmitTag`
- :ref:`WebView_DownloadButtonTag`
- :ref:`WebView_DownloadLinkTag`

**ダウンロードユーティリティ**:

| クラス名 | 説明 |
|---|---|
| `StreamResponse` | ストリームからHTTPレスポンスを生成。`java.io.File`または`java.sql.Blob`のダウンロードをサポート。 |
| `DataRecordResponse` | データレコードからHTTPレスポンスを生成。フォーマット定義ファイルでフォーマット。`Map<String, ?>`型データ（SqlRowなど）をサポート。 |

> **重要**: フレームワークはサブミット制御にJavaScriptを使用しているため、通常のsubmitタグでダウンロードを実行すると同じフォーム内の他のサブミットが機能しなくなる。ダウンロードボタン/リンクには必ずダウンロードタグを使用すること。

通常のsubmitタグとの違い:
- 新しいフォームを作成し、新規フォームに対してサブミットを行う
- 入力項目のパラメータ名を変更できる（:ref:`WebView_ChangeParamNameTag`）

changeParamNameタグ属性: paramName（必須）、inputName（必須）

**ファイルのダウンロード** (StreamResponse使用):

```jsp
<n:downloadButton uri="./TempFile" name="tempFile">ダウンロード</n:downloadButton>
```

```java
public HttpResponse doTempFile(HttpRequest request, ExecutionContext context) {
    File file = getTempFile();
    // 第2引数: リクエスト終了時にファイルを削除する場合はtrue（フレームワークが削除を実行）
    StreamResponse response = new StreamResponse(file, true);
    response.setContentType("text/plain; charset=UTF-8");
    response.setContentDisposition(file.getName());
    return response;
}
```

**BLOB型カラムのダウンロード** (StreamResponse使用):

```java
public HttpResponse doBlobColumn(HttpRequest request, ExecutionContext context) {
    SqlRow record = getRecord(request);
    StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
    response.setContentType("image/jpeg");
    response.setContentDisposition(record.getString("FILE_NAME"));
    return response;
}
```

**データレコードのダウンロード（CSV形式）** (DataRecordResponse使用):

フォーマット定義例（`N11AA001.fmt`）:
```
file-type:        "Variable"
text-encoding:    "Shift_JIS"
record-separator: "\n"
field-separator:  ","

[header]
1  messageId  N "メッセージID"
2  lang       N "言語"
3  message    N "メッセージ"

[data]
1  messageId  X
2  lang       X
3  message    N
```

```java
public HttpResponse doCsvDataRecord(HttpRequest request, ExecutionContext context) {
    SqlResultSet records = getRecords(request);
    // コンストラクタ引数: フォーマット定義のベースパス論理名とファイル名
    DataRecordResponse response = new DataRecordResponse("format", "N11AA001");
    response.write("header", Collections.<String, Object>emptyMap());
    for (SqlRow record : records) {
        response.write("data", record);
    }
    response.setContentType("text/csv; charset=Shift_JIS");
    response.setContentDisposition("メッセージ一覧.csv");
    return response;
}
```

ブラウザの戻るボタンを押した際に前画面を表示できないようにする機能。:ref:`WebView_NoCacheTag` を使用する。キャッシュを防止したい画面のJSPのheadタグ内にnoCacheタグを指定する。

```jsp
<head>
  <n:noCache/>
</head>
```

以下のレスポンスヘッダを返す:

```
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma: no-cache
```

以下のHTMLメタタグも生成する:

```html
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
```

> **警告**: noCacheタグは `<n:include>(<jsp:include>)` でincludeされるJSPでは指定できない。必ずforwardされるJSPで指定すること。システム全体でキャッシュ防止機能を使用する場合は、実装漏れを防ぐためハンドラで一律設定すること。

> **注意**: IE6/IE7/IE8ではHTTP/1.0かつSSL(https)非適用の通信では有効にならない。本機能を使用する画面は必ずSSL通信を適用するように設計すること。

<details>
<summary>keywords</summary>

nablarch_submit, JavaScriptサブミット関数, onclick, フォームサブミット制御, ダウンロードタグ, StreamResponse, DataRecordResponse, WebView_DownloadSubmitTag, WebView_DownloadButtonTag, WebView_DownloadLinkTag, ファイルダウンロード, BLOBダウンロード, CSVダウンロード, n:downloadButton, n:downloadLink, WebView_NoCacheTag, noCache, ブラウザキャッシュ防止, 戻るボタン防止, Cache-Control, prevent_history_back

</details>

## アプリケーションでonclick属性を指定する場合の制約

onclick属性の指定有無による動作の違い：

- **onclick属性未指定**: カスタムタグが出力するタグのonclick属性に `nablarch_submit` を自動設定する
- **onclick属性指定**: カスタムタグはJavaScript関数を設定しない。アプリケーション側のJavaScript内で `nablarch_submit` を明示的に呼び出す必要がある

```javascript
// アプリケーションで作成するJavaScript関数
function popUpConfirmation(event, element) {
    if (window.confirm("登録します。よろしいですか？")) {
        // OK
        // フレームワークが出力するJavaScript関数を明示的に呼び出す。
        return nablarch_submit(event, element);
    } else {
        // キャンセル
        return false;
    }
}
```

```jsp
<n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="./USERS00302" onclick="return popUpConfirmation(event, this);" />
```

データベースコミットを伴う処理を要求する画面で使用する。2つの防止方法があり、**両方の併用を推奨**。

**リクエストの二重送信防止（クライアント側）**: ダブルクリックや再クリックによる2回以上のリクエスト送信を防止する。

**処理済みリクエストの受信防止（サーバ側）**: ブラウザの戻るボタンなどで処理済みリクエストが再送信された場合、重複処理しないよう受け付けを防止する。

> **重要**: 片方のみ使用した場合のリスク:
> - クライアント側のみ: ブラウザ戻るボタン等で処理済みリクエストが再送信され、重複処理される恐れがある
> - サーバ側のみ: ダブルクリックで2件のリクエストが送信された場合、ユーザには2件目のリクエストに対するエラーレスポンスのみ返され、1件目の処理結果を確認できない

<details>
<summary>keywords</summary>

onclick属性, nablarch_submit呼び出し, JavaScript関数, 確認ダイアログ, popUpConfirmation, 二重サブミット防止, リクエストの二重送信防止, 処理済みリクエストの受信防止, prevent_double_submission

</details>

## アプリケーションでformタグのname属性を指定する場合の制約

カスタムタグが出力するJavaScript関数は、サブミット対象フォームの特定にformタグの `name` 属性を使用する。

- **name属性指定時**: 画面内で一意な名前を指定すること
- **name属性未指定時**: 「`nablarch_form<連番>`」形式で自動生成（画面内でformタグの出現順に1から採番）

> **警告**: formタグのname属性にはJavaScriptの変数名の構文に則った値を指定すること。
> - 値の先頭は英字始まり
> - 先頭以降の値は英数字またはアンダーバー

<details>
<summary>keywords</summary>

formタグname属性, nablarch_form連番, JavaScript変数名, フォーム識別, 自動生成

</details>

## ボタン又はリンク毎にパラメータを変更する方法

1つのフォームに複数のボタン・リンクから異なるパラメータを送信したい場合は :ref:`WebView_ParamTag` を使用する。変更パラメータを使用する場合は :ref:`WebView_NablarchTagHandler` の設定が必須。

**paramタグの属性**:

| 属性 | 説明 |
|---|---|
| paramName | リクエストで送信するパラメータ名 |
| value | 直接値を指定する場合 |
| name | スコープ上のオブジェクトを参照する場合 |

```jsp
<n:submitLink uri="./R0001" name="R0001_${status.index}">
    <n:write name="user.id"/>
    <n:param paramName="sampleId" name="user.id" />
</n:submitLink>
```

HTMLの出力イメージ。変更パラメータは `nablarch_hidden` パラメータに格納され、`NablarchTagHandler` がリクエストパラメータとして使用できるよう処理する。

```html
<a name="R0001_0" href="./R0001" onclick="return window.nablarch_submit(event, this);">
    ユーザ1
</a>
<a name="R0001_1" href="./R0001" onclick="return window.nablarch_submit(event, this);">
    ユーザ2
</a>
<a name="R0001_2" href="./R0001" onclick="return window.nablarch_submit(event, this);">
    ユーザ3
</a>
<!-- nablarch_hiddenパラメータ -->
<input type="hidden" name="nablarch_hidden" value="・・・省略・・・" />
```

> **警告**: 変更パラメータの数に応じてリクエストのデータ量が増大する。一覧画面でのリンク毎の変更パラメータはプライマリキーのみなど、必要最小限のパラメータのみ指定すること。

<details>
<summary>keywords</summary>

n:param, paramName, 変更パラメータ, nablarch_hidden, NablarchTagHandler, WebView_ParamTag, n:submitLink, WebView_ChangeableParams, WebView_NablarchTagHandler

</details>

## 認可判定と開閉局判定の結果に応じた表示切り替え

認可（[認可](libraries-04_Permission.md)）・開閉局（:ref:`開閉局<serviceAvailable>`）のハンドラがハンドラ構成に含まれている場合のみ有効。サブミットタグに指定されたリクエストIDに対して判定を行い、認可失敗または閉局の場合に表示切り替えを行う。

**切り替え時の表示方法（3パターン）**:

| 表示方法 | 説明 |
|---|---|
| 非表示（NODISPLAY） | タグを表示しない |
| 非活性（DISABLED） | ボタン: disabled属性を有効。リンク: デフォルトはラベルのみ表示（aタグ出力しない）。:ref:`WebView_CustomTagConfig` の `submitLinkDisabledJsp` 指定時は非活性リンク描画JSPをインクルード |
| 通常表示（NORMAL） | 表示方法の切り替えを行わない |

デフォルトの表示方法は :ref:`WebView_CustomTagConfig` で指定。個別に変更する場合は各タグの `displayMethod` 属性を指定。

```jsp
<%-- このタグは常に表示する --%>
<n:submit displayMethod="NORMAL" type="button" name="login"
          value="ログイン" uri="/LoginAction/LOGIN001" />
```

> **注意**: アプリ全体を非活性・非表示に設定した場合、ログインボタンなど認可されていない状態で使用するボタン・リンクも表示制御され使用できなくなる。常に表示したいボタン・リンクには個別に `displayMethod="NORMAL"` を指定すること。

判定処理は `nablarch.common.web.tag.DisplayControlChecker` インタフェース実装クラスで行い、:ref:`WebView_CustomTagConfig` の `displayControlCheckers` プロパティで変更可能。未指定時はフレームワークのデフォルト判定処理（`ServiceAvailabilityDisplayControlChecker`・`PermissionDisplayControlChecker`）を使用。

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

displayMethod, NODISPLAY, DISABLED, NORMAL, 認可判定, 開閉局判定, displayControlCheckers, ServiceAvailabilityDisplayControlChecker, PermissionDisplayControlChecker, CustomTagConfig, DisplayControlChecker, submitLinkDisabledJsp

</details>
