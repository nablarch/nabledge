## ボタン又はリンクによるサブミット

ボタン又はリンクを使用して、フォームからサブミットを行う方法を示す。

使用できるカスタムタグと、カスタムタグから出力されるHTMLタグは以下の通り。
これらのタグを使用する場合、name属性とuri属性を指定する必要がある。
name属性はフォーム内で一意な名前を指定する。
uri属性の指定は [URIの指定方法](../../guide/web-application/web-application-basic.md#uriの指定方法) を参照。

タグ名が「popup」から始まるタグは、新しい画面をオープンし、オープンした画面に対してサブミットを行う。

| カスタムタグ | 対応するHTMLタグ |
|---|---|
| submitタグ | inputタグ（type=submit, button, image） |
| buttonタグ | buttonタグ |
| submitLinkタグ | aタグ |
| popupSubmitタグ | inputタグ（type=submit, button, image） |
| popupButtonタグ | buttonタグ |
| popupLinkタグ | aタグ |

### サブミット先の指定方法

サブミット先のURIを指定する場合、uri属性にコンテキストルートからの相対パスを指定する

次の遷移（遷移前後が共に同じActionクラス）を行う実装例を示す。

W11AC02Action.doRW11AC0201

→W11AC0201.jsp

→W11AC02Action.doRW11AC0202

* Actionクラスの実装例

  ```java
  public class W11AC02Action {
  
      // 【説明】JSPの実装例へフォワードするメソッド
      public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
          /* 【説明】
              フォワード以外の処理は省略。
              /から始まるパスは、コンテキストルートからの相対パス。 */
          return new HttpResponse("/ss11AC/W11AC0201.jsp");
      }
  
      // 【説明】JSPの実装例から遷移するメソッド
      public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
          // 【説明】処理は省略
      }
  
  }
  ```
* JSPの実装例

W11AC02Action.doRW11AC0201のフォワード先を以下とする。

ファイル名：W11AC0201.jsp

```jsp
<%-- 【説明】フォーム以外は省略 --%>
<n:form>
  <n:text name="W11AC02.systemAccount.loginId" size="22" maxlength="20" />
  <%-- 【説明】
        /から始まるパスは、コンテキストルートからの相対パス。 --%>
  <n:submit cssClass="buttons" type="button" name="confirm" value="確認" uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
</n:form>
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### アプリケーションでonclick属性を指定する場合

本フレームワークでは、HTMLの出力時に、サブミット処理を行うJavaScript関数を自動的に出力する。
この関数は、JSPでonclick属性を指定しなかった場合、HTMLの出力時に自動でonclick属性として指定される。
しかし、JSPでonclick属性を指定した場合には指定されない。
そのため、JSPでonclick属性を指定した場合には、アプリケーションで作成するJavaScript内で明示的にこの関数を呼び出す必要がある。

```javascript
/* 【説明】
    サブミット処理を行うJavaScript関数。
    フレームワークが自動的に出力する。 */
/**
 * @param event イベントオブジェクト
 * @param element イベント元の要素(ボタン又はリンク)
 * @return イベントを伝搬させないため常にfalse
 */
function nablarch_submit(event, element) {
    // 【説明】処理は省略
}
```

* JSPの実装例

  登録ボタンの押下時に確認ダイアログを表示する例を示す。

  ```jsp
  <%-- 【説明】JavaScript関数の定義とフォームのサブミット以外は省略。--%>
  
  <%-- 【説明】onclick属性に指定するJavaScript関数 --%>
  <script language="javascript">
      function popUpConfirmation(event, element) {
        if (window.confirm("登録します。よろしいですか？")) {
          <%-- OK --%>
          <%-- 【説明】サブミット処理を行うJavaScript関数を明示的に呼び出す。 --%>
          return nablarch_submit(event, element);
        } else {
          <%-- キャンセル --%>
          return false;
        }
      }
  </script>
  
  <n:form>
    <%-- 【説明】アプリケーションで定義したJavaScript関数をonclick属性に指定する。 --%>
    <n:submit cssClass="buttons" type="button" name="register" value="登録"
          uri="/action/ss11AC/W11AC02Action/RW11AC0204" onclick="return popUpConfirmation(event, this);" />
  </n:form>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## Enterキー押下時にデフォルトで動作するサブミットボタンを設定する方法

1つのフォーム内に複数ボタンが配置されている場合、何も設定しない状態ではEnterキー押下時に先頭のボタンがサブミットされる。
画面内のボタン配置順によっては、Enterキー押下時にデフォルトで動作させたいボタンを制御したい場合がある。
ここでは、Enterキー押下時にデフォルトで動作させたいボタンの設定方法を示す。

Enterキー押下時にデフォルトで動作させたいボタンはn:submitタグを使用し、type属性にsubmitを指定する。（n:buttonタグだとtype属性にsubmitを指定しても、Enterキー押下時にサブミットされない。）
デフォルトで動作させないボタンにはn:submitタグのtype属性にbuttonを指定する。

* JSP実装例

  ```jsp
  <n:form windowScopePrefixes="systemAccount">
  
      <%-- 【説明】ボタン以外は省略 --%>
  
      <n:submit type="button" name="back" value="登録画面へ"
                uri="/action/ss11AC/W11AC02Action/RW11AC0203"/>
  
      <%-- 【説明】
           このform中でEnterキーを押下した場合、
           この「確定」ボタンを押下した場合と同様に動作する。 --%>
      <n:submit type="submit" name="register" value="確定"
              uri="/action/ss11AC/W11AC02Action/RW11AC0204" />
  </n:form>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 一覧照会画面から詳細画面へ遷移する場合

一覧照会画面で検索結果の一覧を表示し一覧の各リンクからそれぞれの詳細画面に遷移するケースなど、
1つのフォームの複数のボタンやリンクから、異なるパラメータを送信したい場合がある。
その場合、paramタグを使用すればよい。

paramタグを使用する場合、リクエスト送信時に使用するパラメータ名はparamName属性で指定する。
また、送信データを指定する属性は、指定方法によって以下の2つがある。

| 属性名 | 指定方法 |
|---|---|
| value | データを直接指定 |
| name | リクエストスコープやウィンドウスコープ上のオブジェクトを参照して指定 |

* Actionクラスの実装

  ```java
  public class W11AC01Action {
      // 【説明】一覧表示する検索結果を取得する処理以外は省略
      public HttpResponse doRW11AC0102(HttpRequest req, ExecutionContext ctx) {
  
          // 【説明】reqに格納されたパラメータから、検索用のインスタンスを生成
          // 検索条件入力チェック
          ValidationContext<W11AC01SearchForm> formCtx =
              ValidationUtil.validateAndConvertRequest("11AC_W11AC01", W11AC01SearchForm.class, req, "search");
          formCtx.abortIfInvalid();
          W11AC01SearchForm searchCondition = formCtx.createObject();
  
          /* 【説明】
              JSPの実装例（W11AC0101.jsp）でリスト表示するための検索結果を取得し、リクエストスコープに格納する。
              loginIdというカラム名を持つテーブルから、loginIdの値を取得するとする。
              取得するデータは以下の3つを想定。
              (loginId) = ("U0001"), ("U0002"), ("U0003") */
          // 検索実行
          CM311AC1Component component = new CM311AC1Component();
          SqlResultSet searchResult = component.selectByCondition(searchCondition);
          // 検索結果をリクエストスコープに設定
          ctx.setRequestScopedVar("searchResult", searchResult);
          return new HttpResponse("/ss11AC/W11AC0101.jsp");
      }
  }
  ```
* JSPの実装例

  ファイル名：W11AC0101.jsp

  ```jsp
  <%-- 【説明】フォーム以外は省略 --%>
  <n:form>
    <table>
      <%-- 【説明】
            doRW11AC0102でリクエストスコープに設定したリストから、値を1つずつ取り出して使用。
            varStatus属性で指定したstatusには、ループに関する情報がセットされる。 --%>
      <c:forEach var="row" items="${searchResult}" varStatus="status">
      <tr>
  
        <%-- 【説明】HTMLに出力されるリンクのname属性の値を、リンク毎に変える。 --%>
        <n:submitLink uri="/action/ss11AC/W11AC01Action/RW11AC0103" name="showDetail_${status.index}">
          <n:write name="row.loginId"/><%-- リンクのラベル指定 --%>
          <%-- 【説明】
                送信するパラメータの設定。
                paramName属性でパラメータ名を指定する。
                name属性で指定した、スコープ上のオブジェクトを参照する。
                本例では、11AC_W11AC01.loginIdというパラメータ名で、row.loginIdの値を送信する。 --%>
          <n:param paramName="11AC_W11AC01.loginId" name="row.loginId" />
        </n:submitLink>
      </tr>
      </c:forEach>
    </table>
  </n:form>
  ```
* HTML出力例

  ```html
  <!-- 【説明】フォーム以外は省略 -->
  <form name="nablarch_form1">
    <table>
        <tr>
          <a name="showDetail_0" href="/action/ss11AC/W11AC01Action/RW11AC0103" onclick="return window.nablarch_submit(event, this);">
              U0001
          </a>
        </tr>
        <tr>
          <a name="showDetail_1" href="/action/ss11AC/W11AC01Action/RW11AC0103" onclick="return window.nablarch_submit(event, this);">
              U0002
          </a>
        </tr>
        <tr>
          <a name="showDetail_2" href="/action/ss11AC/W11AC01Action/RW11AC0103" onclick="return window.nablarch_submit(event, this);">
              U0003
          </a>
        </tr>
    </table>
    <!-- 【説明】nablarch_hiddenパラメータ
          説明のため改行して表示しているが、実際は1行で出力される。
          「nablarch_hidden_submit_<name属性>」というプレフィックスを付けて
          リンク毎の変更パラメータが出力される。
          選択されたリンクの変更パラメータはフレームワークのハンドラにより
          リクエストに設定される。 -->
    <input type="hidden" name="nablarch_hidden"
                         value="nablarch_hidden_submit_showDetail_0=11AC_W11AC01.loginId\=U0001|
                         nablarch_hidden_submit_showDetail_1=11AC_W11AC01.loginId\=U0002|
                         nablarch_hidden_submit_showDetail_2=11AC_W11AC01.loginId\=U0003" />
  </form>
  ```

  この例でU0002リンクをクリックした場合、以下のリクエストパラメータがリクエストに設定される。

  ```none
  11AC_W11AC01.loginId=U0002
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 複数ウィンドウを立ち上げたい場合

ユーザの操作性を向上させるために、複数ウィンドウを立ち上げたい場合がある。
例えば、検索画面を別ウィンドウで立ち上げ入力補助を行う場合などが挙げられる。
複数ウィンドウを立ち上げたい場合は、下記のタグを使用すればよい。
これらのタグを使用すると、新しいウィンドウをオープンし、オープンしたウィンドウに対してサブミットを行う。

* popupSubmit
* popupButton
* popupLink

新しいウィンドウのスタイルは、下記のpopupOption属性に指定する。

| 属性 | 説明 |
|---|---|
| popupOption | ポップアップのオプション情報。 新しいウィンドウを開く際にwindow.open関数の第3引数(JavaScript)に指定する。 |

オープンしたウィンドウに表示される画面の処理を行うアクションと、元画面のアクションでパラメータ名が異なる場合は、
changeParamNameタグを使用してパラメータ名を変更する。

### 別ウィンドウにサブミットする場合のJSPの実装例

ここでは、郵便番号から住所を検索する別ウィンドウにサブミットする場合の実装例を示す。

* JSPの実装例

  ```jsp
  <%-- 【説明】郵便番号の入力項目以外は省略 --%>
  <tr>
      <th>
          <span class="essential">*</span>郵便番号<span class="instruct">(半角数字)</span>
      </th>
      <td>
          <n:text name="W11AC01.postalCode" size="7" maxlength="9"/>
          <%-- 【説明】
                popupButtonタグを指定する。
                name属性やuri属性の指定は、画面内のフォームをサブミットするbuttonタグと同じ。 --%>
          <n:popupButton name="searchAddress" uri="/action/ss11AB/W11AB01Action/RW11AB0101">
              検索
              <%-- 【説明】
                    郵便番号のパラメータ名"W11AC01.postalCode"を"W11AB01.postalCode"に変更する。
                    別画面を表示するアクションで入力項目を使用する場合は、
                    別画面を表示するアクションに合わせてパラメータ名を変更する。 --%>
              <n:changeParamName inputName="W11AC01.postalCode" paramName="W11AB01.postalCode" />
              <%-- 【説明】
                    変更パラメータを追加する。
                    別画面を表示するアクションに合わせてパラメータを追加する。 --%>
              <n:param paramName="W11AB01.max" value="10" />
          </n:popupButton>
      </td>
  </tr>
  ```

### 別ウィンドウから元画面に値を設定する場合のJSPの実装例

別ウィンドウから元画面に値を設定したい場合はJavaScriptにより実現する。
郵便番号の検索結果をリンクで選択させる場合とボタンで選択させる場合の実装例を下記に示す。

* JavaScriptの実装例

JavaScriptは動的な値(入力データなど)の埋め込みを防ぐために外部ファイルに記述する。
下記の実装例では"/js/common.js"に配置したファイルに記述するものとする。

JavaScriptのコメントは保守性を向上させるために記述することを推奨する。
JavaScriptの記述ルールはプロジェクトの規約に従うこと。

```javascript
/**
 * 親ウィンドウのinput要素のvalue属性に値を設定しウィンドウをクローズする。
 *
 * 親ウィンドウのinput要素は指定されたname属性から取得する。
 * 本関数は単一入力項目への値設定のみサポートしており、
 * 指定されたname属性が親ウィンドウ内で重複していないことを前提に処理する。
 *
 * 親ウィンドウに設定する値は、指定された要素の属性から取得する。
 * デフォルトではname属性から値を取得する。
 * 通常の属性値と区別するため、値にはプレフィックスを付けることとし、
 * 指定されたプレフィックスを取り除いた結果を値とする。
 *
 * @param openerInputName 値を設定する親ウィンドウのinput要素のname属性
 * @param element 値の取得先の要素
 * @param prefix  値に付けたプレフィックス
 * @param attributeName 値の取得先となる要素の属性名。指定がない場合はname属性を使用する。
 */
function setInputValueToOpener(openerInputName, element, prefix, attributeName) {
    if (attributeName == null) {
        attributeName = "name";
    }
    var value = element[attributeName];
    value = value.substring(prefix.length, value.length);
    /* 【説明】
        window.openerを使用して元画面を参照する。*/
    var input = window.opener.document.getElementsByName(openerInputName)[0];
    input.value = value;
    window.close();
}
```

> **Warning:**
> JavaScriptに対するエスケープ処理は、フレームワークで未実装のため、 scriptタグのボディやonclick属性など、
> JavaScriptを記述する部分には、動的な値(入力データなど)を埋め込まないこと。

* JSPの実装例(郵便番号の検索結果をリンクで選択させる場合)

  ```jsp
  <%-- 【説明】
        外部ファイルに記述したJavaScriptを読み込む。
        n:scriptタグはhtmlのheadタグ内に記述する。 --%>
  <n:script type="text/javascript" src="/js/common.js"  />
  
  <%-- 【説明】
        リクエストスコープに"resultSet"という名前で郵便番号の検索結果が設定されているものとする。
        name属性にプレフィックス＋郵便番号、onclick属性にJavaScript関数を指定する。--%>
  <n:form>
  <c:forEach var="row" items="${resultSet}">
      <div>
          <n:a href="#" name="val_${row.postalCode}"
               onclick="setInputValueToOpener('W11AC01.postalCode', this, 'val_')">
              <n:write name="row.postalCode" />
          </n:a>
      </div>
  </c:forEach>
  </n:form>
  ```
* JSPの実装例(郵便番号の検索結果をボタンで選択させる場合)

  ```jsp
  <%-- 【説明】
        外部ファイルに記述したJavaScriptを読み込む。
        n:scriptタグはhtmlのheadタグ内に記述する。 --%>
  <n:script type="text/javascript" src="/js/common.js"  />
  
  <%-- 【説明】
        リクエストスコープに"resultSet"という名前で郵便番号の検索結果が設定されているものとする。
        name属性にプレフィックス＋郵便番号、onclick属性にJavaScript関数を指定する。--%>
  <n:form>
  <c:forEach var="row" items="${resultSet}">
      <div>
          <n:button uri="#" name="val_${row.postalCode}"
              onclick="setInputValueToOpener('W11AC01.postalCode', this, 'val_')">
              <n:write name="row.postalCode" />
          </n:button>
      </div>
  </c:forEach>
  </n:form>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 二重サブミットの防止

データベースへのコミットを伴う画面では、二重サブミットを防止する必要がある。

防止法は、クライアント側での対策（以下、「リクエストの二重送信防止」）と
サーバ側での対策（以下、「処理済リクエストの受信防止」）をそれぞれ行う必要がある。

詳細については、 Application Framework解説書の [二重サブミットの防止](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_SubmitTag.html#prevent-double-submission) を参照。

## 入力画面と確認画面の共通化をサポートするカスタムタグ

入力画面と確認画面が1対1に対応する場合、表示のためのJSPファイルを共通化できる。

詳細については、 Application Framework解説書の [入力画面と確認画面の共通化をサポートするカスタムタグ](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FacilitateTag.html#webview-inputconfirmationcommon) を参照。

## ブラウザのキャッシュ防止

ブラウザの戻るボタンが押されても前の画面を表示できないようにするには、noCacheタグを使用する。

詳細については、 Application Framework解説書の [ブラウザのキャッシュ防止](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_SubmitTag.html#prevent-history-back) を参照。
