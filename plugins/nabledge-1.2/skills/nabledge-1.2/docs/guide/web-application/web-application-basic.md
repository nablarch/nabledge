## taglibディレクティブの指定方法

JSPでカスタムタグを使用する場合、taglibディレクティブを指定する。

taglibを使用するJSPの先頭で、prefixを指定して宣言を行う。
指定したprefixを用いてカスタムタグを使用する。

* JSPの実装例

  ```jsp
  <?xml version="1.0" encoding="UTF-8" ?>
  <%-- 【説明】taglibディレクティブの宣言 --%>
  <%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
  
  <%-- 【説明】
        taglibディレクティブの宣言とカスタムタグの使用例以外は省略
        prefixを用いてカスタムタグを使用 --%>
  <n:form>
    <%-- 【説明】フォーム内の処理は省略 --%>
  </n:form>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## URIの指定方法

カスタムタグでURIを指定する方法を示す。
また、相対パス指定時にURIのプロトコルを切り替える方法を示す。

カスタムタグでURIを指定する方法は次の2種類がある。

* 絶対URLによる指定
* コンテキストルートからの相対パスによる指定

実装例では、以下のフォルダ構成を想定する。

```
web（コンテキストルート）
 +-img
 |  +-header_bar.jpg
 |  +-sample.jpg
 +-app_header.jsp
 +-sample
    +-sample001.jsp
    +-sample002.jsp
```

### 絶対URLによる指定

http又はhttpsから始まるパスが **絶対URL** である。
この指定方法では、パスがそのままURIとして使用される。

* JSPの実装例

  ```jsp
  <%-- 【説明】URIの指定以外は省略 --%>
  <n:a href="http://www.tis.co.jp/" >tis</n:a>
  ```

  上の実装で指定されるURIは以下になる。

  ```none
  http://www.tis.co.jp
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### コンテキストルートからの相対パスによる指定

/（スラッシュ）から始まるパスが **コンテキストルートからの相対パス** である。
この指定方法では、先頭にコンテキストルートのパスが付加されてURIとして使用される。

* JSPの実装例

  header_bar.jpgへのパスを指定する場合

  ```jsp
  <%-- 【説明】URIの指定以外は省略 --%>
  <n:img src="/img/header_bar.jpg" alt="header" />
  ```

  上の実装で指定されるURIは以下になる。

  ```none
  <コンテキストルートのパス>/img/header_bar.jpg
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### HTTPとHTTPSの切り替え

コンテキストルートからの相対パスでURIを指定しながらプロトコルを **切り替える** 場合、カスタムタグのsecure属性を指定する。
また、httpからhttpsへの切り替えで使用するURIを指定するため、ポート番号(http用とhttps用)とホストを設定する必要がある。
（ポート番号とホストの設定は、 [カスタムタグのデフォルト値の設定](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_HowToSettingCustomTag.html#webview-customtagconfig) 参照）

> **Note:**
> secure属性は、 http→https 又は https→http とプロトコルを切り替える場合に指定する。
> http→http 又は https→https とプロトコルを切り替えない場合にはsecure属性を指定しない。

JSPから、画像ファイルにアクセスする例を示す。
（カスタムタグの設定値は、ホスト名：localhost、http用のポート番号：8080、https用のポート番号：443とする。）

* JSPの実装例

  ```jsp
  <%-- 【説明】
        URIの指定以外は省略。
        secure="true"でhttp→https。
        secure="false"でhttps→http。 --%>
  <n:img src="/img/sample.jpg" alt="sample" secure="true" />
  ```
* HTML出力例

  上の実装で指定されるURIは以下になる。

  ```none
  # secure="true"の場合
  https://localhost:443/img/sample.jpg
  
  # secure="false"の場合
  http://localhost:8080/img/sample.jpg
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## JSPとActionクラスの間でデータを受け渡す方法

JSPとActionクラスの間でデータを受け渡す場合、以下の方法でname属性を指定すればよい。
この指定法により、データがどのスコープ又はパラメータに設定されているかを意識せずに使用できる。

### Map型/フォームのプロパティを受け渡す場合

JSPとActionクラスの間でMap型又はフォームのプロパティを受け渡す場合、
カスタムタグのname属性に次の形式で値を指定する。

```none
<リクエストスコープ上に設定したオブジェクトの変数名>.<プロパティ名>
```

* Actionクラスの実装例

  Actionクラス→更新画面→Actionクラスの例を示す。

  JSPにデータを受け渡すActionクラス。

  ```java
  public class W11AC03Action {
      // 【説明】データの受け渡し以外は省略 。
      public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
          /* 【説明】
              リクエストにプライマリキー（W11AC03.userId）が設定されているとする。
              プライマリキーの精査。 */
          ValidationContext<W11AC03Form> formCtx =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
          /* 【説明】
              エラー処理は省略。
              プライマリキーをプロパティとするW11AC03Formの生成。 */
          W11AC03Form form = formCtx.createObject();
  
          /* 【説明】
              プライマリキーで検索を行い、更新対象のデータを取得。
              取得したデータを、リクエストスコープに設定。
              SqlResultSetはListのサブクラスである。 */
          CM311AC1Component component = new CM311AC1Component();
          SqlResultSet userInfo = component.selectUsers(form);
          ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
  
          return new HttpResponse("/ss11AC/W11AC0301.jsp");
      }
  }
  ```
* JSPの実装例

  ```jsp
  <%-- 【説明】データの受け渡し以外は省略 --%>
  <n:form>
    <%-- 【説明】テキストボックスから、サブミット先のActionクラスでW11AC03.kanjiNameとして扱うデータを入力する。 --%>
    <n:text name="W11AC03.kanjiName" />
    <n:submit cssClass="mainBtn" type="button" name="confirm" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
  </n:form>
  ```
* Actionクラスの実装例

  JSPからデータを受け取るActionクラス。

  ```java
  public class W11AC03Action {
      // 【説明】データの受け渡し以外は省略 。
      public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
          // 【説明】更新画面で入力したデータに対するバリデーション
          ValidationContext<W11AC03Form> formCtx =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
          // 【説明】エラーがあれば、ApplicationException例外を投げる。
          if (!formCtx.isValid()) {
              throw new ApplicationException(formCtx.getMessages());
          }
  
          // 【説明】フォームを生成して使用する。
          W11AC03Form form = formCtx.createObject();
  
          // 【説明】以下の処理は省略。
      }
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### List型/配列の要素のプロパティを受け渡す場合

JSPとActionクラスの間でList型又は配列の要素のプロパティを受け渡す場合、
カスタムタグのname属性に次の形式で値を指定する。

```none
<リクエストスコープ上に設定したオブジェクトの変数名>[index].<プロパティ名>
```

* Actionクラスの実装例

  JSPにデータを受け渡すActionクラス。

  ```java
  public class W11AC03Action {
      // 【説明】データの受け渡し以外は省略 。
      public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
          /* 【説明】
              リクエストにプライマリキー（W11AC03.userId）が設定されているとする。
              プライマリキーの精査。 */
          ValidationContext<W11AC03Form> formCtx =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
          /* 【説明】
              エラー処理は省略。
              プライマリキーをプロパティとするW11AC03Formの生成。 */
          W11AC03Form condition = formCtx.createObject();
  
          /* 【説明】
              プライマリキーで検索を行い、検索結果をエンティティの配列に変換してW11AC03Formに設定。
              その後、検索結果を設定したフォームをリクエストスコープに設定。 */
          CM311AC1Component component = new CM311AC1Component();
          SqlResultSet emailAddressList = component.selecemailAddressList(condition);
  
          UserEmailAddressEntity[] emailAddressArray = new UserEmailAddressEntity[emailAddressList.size()];
          for (int i = 0; i < emailAddressList.size(); i++) {
              emailAddressArray[i].setEmailAddress(emailAddressList.get(i).getString("emailAddress"));
          }
  
          W11AC03Form form = new W11AC03Form();
          form.setUserEmailAddressArraySize(emailAddressArray.length);
          form.setUserEmailAddressArray(emailAddressArray);
          ctx.setRequestScopedVar("W11AC03", form);
  
          return new HttpResponse("/ss11AC/W11AC0301.jsp");
      }
  }
  ```
* JSPの実装例

  ```jsp
  <%-- 【説明】入力フォーム以外は省略 --%>
  <n:form>
    <%-- 【説明】
          リクエストスコープに、W11AC03.userEmailAddressArraySizeをキーとしてメールアドレス件数が設定されているとする。
          また、indexにループの回数が設定される。 --%>
    <c:forEach begin="0" end="${W11AC03.userEmailAddressArraySize}" var="index">
      <%-- 【説明】テキストボックスから、ActionクラスでW11AC03.userEmailAddressArray[index].emailAddressとして扱うデータを入力する。 --%>
      <n:text name="W11AC03.userEmailAddressArray[${index}].emailAddress" />
    </c:forEach>
    <%-- 【説明】フォームのプロパティが任意長配列の場合、入力画面で配列長をサブミットする必要がある。 --%>
    <n:hidden name="W11AC03.userEmailAddressArraySize" />
    <n:submit cssClass="buttons" type="button" name="update" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
  </n:form>
  ```
* Actionクラスの実装例

  JSPからデータを受け取るActionクラス。

  ```java
  public class W11AC03Action {
      // 【説明】受け取ったデータの取り扱い以外は省略。
      public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
  
          // 【説明】 入力データの単項目精査。
          ValidationContext<W11AC03Form> formCtx =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
  
          // 【説明】 エラーがあれば、ApplicationException例外を投げる。
          if (!formCtx.isValid()) {
              throw new ApplicationException(formCtx.getMessages());
          }
  
          // 【説明】フォームを生成して使用する。
          W11AC03Form form = formCtx.createObject();
  
          // 【説明】以降の処理は省略。
      }
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## ウィンドウスコープの使用法

本フレームワークでは、複数画面で引き継ぐデータをhiddenタグでクライアント側に保持する。
例えば、入力データや更新対象データのプライマリキーなどである。
その際に、ウィンドウスコープと呼ぶ変数スコープにデータを保持する。

> **Note:**
> ログイン情報など、全ての取引で使用される情報はセッションで保持する。

### windowScopePrefixes属性の使用方法

ウィンドウスコープを使用するには、formタグのwindowScopePrefixes属性にプレフィックスを指定すればよい。
入力項目のname属性で使用したプレフィックスを指定すれば、ウィンドウスコープに入力データを設定できる。
ウィンドウスコープに設定したデータは、画面をHTML出力する際にhiddenで出力される。

ウィンドウスコープを使用して、登録画面から登録確認画面にデータを引き継ぐ例を示す。

* JSPの実装例

  登録画面の実装例（ファイル名：W11AC0201.jsp）

  ```jsp
  <%-- 【説明】
        windowScopePrefixes属性の使用箇所以外は省略。
        windowScopePrefixesの指定。
        この例では、登録確認画面から登録画面へフォワードした際に、
        W11AC02をプレフィックスに持つ入力項目がウィンドウスコープに設定される。
        プレフィックスを複数指定する場合、,（カンマ）で区切ればよい。 --%>
  <n:form name="insert" windowScopePrefixes="W11AC02">
      <%-- 【説明】
            ウィンドウスコープにデータを設定する入力項目。
            name属性に、プレフィックス（W11AC02）を付けた値を指定する。
            1つのプレフィックスを指定すると、そのプレフィックスを持つ複数の入力項目
            （W11AC02.systemAccount.userId, W11AC02.systemUser.kanjiName）を設定可能。 --%>
      <n:text name="W11AC02.systemAccount.userId" size="15" maxlength="10" />
      <n:text name="W11AC02.systemUser.kanjiName" size="65" maxlength="25" />
      <%-- 【説明】登録確認画面へ遷移するサブミットボタン --%>
      <n:submit cssClass="buttons" type="button" name="confirm" value="確認"
                uri="/action/ss11AC/W11AC02Action/RW11AC0202" />
  </n:form>
  ```

  登録確認画面の実装例（ファイル名：W11AC0202.jsp）

  ```jsp
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        confirmationPageタグを指定して、登録画面のjspへフォワードする。 --%>
  <%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
  <n:confirmationPage path="./W11AC0201.jsp" />
  ```
* Actionクラスの実装例

  ```java
  public class W11AC02Action {
    /* 【説明】
        登録確認画面へフォワードするメソッド。
        ウィンドウスコープの処理以外は省略 */
    public HttpResponse doRW11AC0202(HttpRequest req, ExecutionContext ctx) {
      /* 【説明】
          入力データのバリデーションとエラー発生時の処理は省略。
          本メソッドの中で、入力データのリクエストへの設定は行っていない */
  
      // 【説明】登録確認画面へフォワードする。
      return new HttpResponse("/ss11AC/W11AC0202.jsp");
    }
  }
  ```

登録画面で以下のデータを入力した時の、確認画面のHTML出力例を示す。

| 変数名 | データ |
|---|---|
| W11AC02.systemAccount.userId | nablarch02 |
| W11AC02.systemUser.kanjiName | 名部良次郎 |

* HTMLの出力例

  ```html
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        ウィンドウスコープのデータが、hiddenで出力される。
        暗号化機能が使用される。 --%>
  <input type="hidden" name="nablarch_hidden" value="QkyNL4ld+4izNDC5" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### 複数画面に跨る画面遷移時のwindowScopePrefixes属性の指定方法

windowScopePrefixes属性に指定した複数のプレフィックスを使い分けることで、
特定のデータだけを複数画面で引き継ぐことが出来る。

以下の遷移を例に、JSPの実装例を示す。

一覧照会画面（照会後）→更新画面→更新確認画面→更新完了画面

* 一覧照会画面（照会後）のJSP

  更新画面に、検索条件（プレフィックスが11AC_W11AC01）と更新対象のプライマリキー（プレフィックスがW11AC03）が引き継がれる。

  ```jsp
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        検索処理ではウィンドウスコープは使用しない。 --%>
  <n:form>
      <div class="search">
          <table class="data conditionArea" width="100%">
              <%-- 【説明】
                    更新画面に引継がれる検索条件。
                    更新完了画面からの遷移では、以前に入力した検索条件が初期値として設定される。 --%>
              <tr>
                  <th>ログインID</th>
                  <td>
                      <n:text name="11AC_W11AC01.loginId" size="25" maxlength="20" />
                      <n:error name="11AC_W11AC01.loginId"/>
                  </td>
              </tr>
              <tr>
                  <th>漢字氏名</th>
                  <td>
                      <n:text name="11AC_W11AC01.kanjiName" size="25" maxlength="20" />
                      <n:error name="11AC_W11AC01.kanjiName"/>
                  </td>
              </tr>
              <%-- 【説明】ログインID、漢字氏名以外の検索条件は省略 --%>
          </table>
          <%-- 【説明】「検索」ボタンは省略 --%>
      </div>
      <div class="hrArea">
      <hr />
      </div>
  
      <div class="resultArea">
      <%-- 【説明】
            一覧表示用のカスタムタグ
            検索結果の行データは"row"という変数名で扱える。 --%>
      <n:listSearchResult listSearchInfoName="11AC_W11AC01"
                          searchUri="/action/ss11AC/W11AC01Action/RW11AC0102"
                          resultSetName="searchResult"
                          resultSetCss="resultList" >
          <%-- 【説明】一覧表示のヘッダ行は省略 --%>
          <jsp:attribute name="bodyRowFragment">
              <tr>
                  <%-- 【説明】
                        更新画面へ遷移するサブミットリンク
                        「更新」リンクが、そのユーザの更新画面へのリンクとなっている。
                        paramタグを使用して、更新情報の検索で使うプライマリキー（W11AC03.systemAccount.userId）をサブミットする。 --%>
                  <td><n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
                                  更新
                                  <%-- 【説明】
                                        更新画面に引継がれる更新対象のプライマリキー
                                        検索結果の行データからユーザID(row.userId)を設定する。 --%>
                                  <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
                              </n:submitLink></td>
              </tr>
          </jsp:attribute>
      </n:listSearchResult>
      </div>
  </n:form>
  ```
* Actionクラスの実装例

  一覧照会画面（照会後）から更新画面への遷移を行う。

  ```java
  public class W11AC03Action {
      /* 【説明】
          データの引継ぎ以外は省略 。
          Actionクラスで、検索条件に対する処理は行っていない。 */
      public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
          // 【説明】プライマリキーの精査
          ValidationContext<W11AC03Form> userSearchFormContext =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
          /* 【説明】
              エラー処理は省略。
              プライマリキーの取得。 */
          String userId = userSearchFormContext.createObject().getSystemAccount().getUserId();
  
          // 【説明】プライマリキーで検索を行い、更新対象のデータを取得。
          CM311AC1Component comp = new CM311AC1Component();
          SqlResultSet sysAcct = comp.selectSystemAccount(userId);
          SqlResultSet users = comp.selectUsers(userId);
          SqlResultSet permissionUnit = comp.selectPermissionUnit(userId);
          SqlResultSet ugroup = comp.selectUgroup(userId);
  
          /* 【説明】
              検索結果からFormを生成する。
              生成したFormを"W11AC03"という名前でリクエストスコープに設定し、更新画面へ遷移する。 */
          W11AC03Form form = getWindowScopeObject(sysAcct, users, permissionUnit, ugroup);
          ctx.setRequestScopedVar("W11AC03", form);
          return new HttpResponse("/ss11AC/W11AC0301.jsp");
      }
  }
  ```
* 更新画面のJSP

  一覧照会画面から、検索条件（プレフィックスが11AC_W11AC01）と更新対象のプライマリキー（プレフィックスがW11AC03）を引き継ぐ。
  更新確認画面に、検索条件（プレフィックスが11AC_W11AC01）、更新対象のプライマリキーと更新データ（ともにプレフィックスがW11AC03）が引き継がれる。

  ```jsp
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        windowScopePrefixes属性で11AC_W11AC01とW11AC03を指定しているので、
        一覧照会画面から検索条件と更新対象のプライマリキーを引き継ぐ。 --%>
  <n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
      <%-- 【説明】
            ログインIDは更新できないので、表示だけ行う。
            この場合、hiddenタグを使用してサブミットするパラメータを指定する。 --%>
      <n:write  name="W11AC03.systemAccount.loginId" />
      <n:hidden name="W11AC03.systemAccount.loginId" />
      <%-- 【説明】一覧照会画面のW11AC03.systemAccount.userIdを元に検索した漢字氏名の表示。 --%>
      <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
      <%-- 【説明】確認画面へのサブミットボタン --%>
      <n:submit cssClass="buttons" type="button" name="update" value="確認" uri="/action/ss11AC/W11AC03Action/RW11AC0302" />
  </n:form>
  ```
* Actionクラスの実装例

  更新画面から更新確認画面への遷移を行う。

  ```java
  public class W11AC03Action {
      /* 【説明】
          データの引継ぎ以外は省略 。
          Actionクラスで、検索条件に対する処理は行っていない。 */
      public HttpResponse doRW11AC0302(HttpRequest req, ExecutionContext ctx) {
          // 【説明】更新画面で入力したデータに対するバリデーション
          ValidationContext<W11AC03Form> formContext =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
          /* 【説明】
              エラー処理は省略。
              更新対象のプライマリキーと更新データ（ともにプレフィックスがW11AC03）は、ウィンドウスコープにより自動的に更新確認画面へ引き継がれる。
              明示的にリクエストにデータを設定する必要は無い。 */
          return new HttpResponse("/ss11AC/W11AC0302.jsp");
      }
  }
  ```
* 更新確認画面のJSP

  更新画面から、検索条件（プレフィックスが11AC_W11AC01）、更新対象のプライマリキーと更新データ（ともにプレフィックスがW11AC03）を引き継ぐ。
  更新完了画面に、検索条件（プレフィックスが11AC_W11AC01）が引き継がれる。

  ```jsp
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        confirmationPageタグを指定すると、入力画面（更新画面）と同じ記述で確認項目の出力が出来る。 --%>
  <n:confirmationPage />
  <%-- 【説明】
        更新画面からウィンドウスコープのデータ（プレフィックスが11AC_W11AC01,W11AC03）を引き継ぐ。
        windowScopePrefixes属性で11AC_W11AC01とW11AC03を指定しているので、
        検索条件、更新対象のプライマリキー、更新データを更新確認画面に引き継ぐ。 --%>
  <n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
      <%-- 【説明】更新対象データ --%>
      <n:write  name="W11AC03.systemAccount.loginId"/>
      <n:hidden name="W11AC03.systemAccount.loginId" />
      <n:text name="W11AC03.users.kanjiName" size="52" maxlength="50" />
      <%-- 【説明】完了画面へのサブミットボタン --%>
      <n:submit cssClass="buttons" type="button" name="confirm" value="確定"
                uri="/action/ss11AC/W11AC03Action/RW11AC0304" allowDoubleSubmission="false" />
  </n:form>
  ```
* Actionクラスの実装例

  更新確認画面から更新完了画面への遷移を行う

  ```java
  public class W11AC03Action {
  
      /* 【説明】
          データの引継ぎ以外は省略。
          Actionクラスで、検索条件に対する処理は行っていない。 */
      public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
          /* 【説明】更新データのバリデーション */
          ValidationContext<W11AC03Form> formContext =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
          /* 【説明】
              エラー処理は省略。
              更新データをプロパティとするW11AC03Formの生成。 */
          W11AC03Form form = formContext.createObject();
  
          // 【説明】更新処理は省略
  
          return new HttpResponse("/ss11AC/W11AC0303.jsp");
      }
  }
  ```
* 更新完了画面のJSP

  更新確認画面から、検索条件（プレフィックスが11AC_W11AC01）を引き継ぐ。
  一覧照会画面へ遷移する際に、引き継いだ検索条件で検索を行う。

  ```jsp
   <%-- 【説明】
         ウィンドウスコープの説明箇所以外は省略。
         一覧照会画面へ遷移した時に以前の条件で検索を行うため、11AC_W11AC01の値をウィンドウスコープに設定 --%>
  <n:form windowScopePrefixes="11AC_W11AC01">
      <%-- 【説明】
            更新データの表示。
            更新確認画面でウィンドウスコープに設定した値を参照。 --%>
      <n:write name="W11AC03.systemAccount.loginId"/>
      <n:write name="W11AC03.user.kanjiName"/>
      <%-- 【説明】一覧検索を行うリクエストへのサブミット --%>
      <n:submit cssClass="buttons" type="button" name="search" value="一覧照会画面へ"
                uri="/action/ss11AC/W11AC01Action/RW11AC0102"/>
  </n:form>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

### アクションの実装方法

ウィンドウスコープを使用する場合、以下のことに注意してActionクラスを実装すること。

* 遷移先の画面に入力データを引き継ぐための処理を、Actionクラスで明示的に行わない。

  データを引き継ぐためにセッションを利用する方式では、
  入力画面から遷移したActionクラスで、入力データを明示的にセッションに設定する必要がある。
  一方、ウィンドウスコープを使用する方式では、入力データを引き継ぐための処理をフレームワークが自動的に行う。
* Actionクラスでウィンドウスコープのデータを使用する場合、バリデーションを行う。

  リクエストから直接取得したデータはString型であり、データの型変換が必要となることがある。
  しかし、バリデーションを実行し、フォームのプロパティの設定値としてデータを取得した場合、
  そのプロパティのデータは自動で型変換が行われる。

以下の遷移を例に、ウィンドウスコープを用いてデータを引き継ぐ際のActionクラスの実装例を示す。

更新確認画面→更新完了画面

* JSPの実装例

  更新確認画面

  ```jsp
  <%-- 【説明】
        ウィンドウスコープの説明箇所以外は省略。
        confirmationPageタグを指定すると、入力画面（更新画面）と同じ記述で確認項目の出力が出来る。 --%>
  <n:confirmationPage />
  <%-- 【説明】完了画面で表示するために、検索条件だけでなく、更新情報のプレフィックス（W11AC03）も指定 --%>
  <n:form windowScopePrefixes="11AC_W11AC01,W11AC03">
      <%-- 【説明】更新対象データ --%>
      <n:write name="W11AC03.user.userId"/>
      <n:text name="W11AC03.user.kanjiName" size="65" maxlength="25" />
      <%-- 【説明】完了画面へのサブミットボタン --%>
      <n:submit cssClass="mainBtn" type="button" name="confirm" value="確定" uri="/action/ss11AC/W11AC03Action/RW11AC0304" />
  </n:form>
  ```

  更新完了画面

  ```jsp
   <%-- 【説明】
         ウィンドウスコープの説明箇所以外は省略。
         一覧照会画面で検索条件を表示するために、11AC_W11AC01の値をウィンドウスコープに設定 --%>
  <n:form windowScopePrefixes="11AC_W11AC01">
      <%-- 【説明】更新確認画面から渡されたウィンドウスコープの値出力は省略 --%>
      <n:submit cssClass="mainBtn" type="submit" name="refer" uri="/action/ss11AC/W11AC01Action/RW11AC0102" value="一覧照会画面へ" />
  </n:form>
  ```
* Actionクラスの実装例

  ```java
  public class W11AC03Action {
    /* 【説明】
        更新処理を行うメソッド。
        ウィンドウスコープの処理以外は省略 */
    public HttpResponse doRW11AC0304(HttpRequest req, ExecutionContext ctx) {
      /* 【説明】
          以下で検索条件(11AC_W11AC01)に関する処理を記述していないが、
          検索条件の入力データは更新完了画面に引き継がれる。 */
  
      /* 【説明】更新情報のバリデーション */
      ValidationContext<W11AC03Form> formCtx =
          ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "updateUser");
  
      // 【説明】バリデーションエラーがあれば、例外を返す。
      if (!formContext.isValid()) {
          throw new ApplicationException(formContext.getMessages());
      }
  
      /* 【説明】
          Actionクラスで使用するW11AC03Formインスタンスの生成
          自動で型変換された更新情報がプロパティに設定されている。 */
      W11AC03Form form = formCtx.createObject();
  
      /* 【説明】以下、W11AC03Formインスタンスを使用した更新処理は省略 */
    }
  }
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## JSP上で変数に値を設定する方法

画面タイトルや検索結果などの値を、JSP上で変数に設定して使用する方法を示す。

* JSPの実装例

  ```html
  <%-- 【説明】変数の使用部分以外は省略 --%>
  <head>
      <%-- 【説明】
            リクエストスコープ上の変数"title"に、value属性で値を直接設定。
            値を直接設定する場合、value属性を使用する。 --%>
      <n:set var="title" value="ユーザ情報登録" />
      <jsp:include page="/html_header.jsp">
          <%-- 【説明】
                ページの埋め込み時に変数を使ってパラメータを指定。
                値の出力ではないので、EL式を使用しても問題ない。 --%>
          <jsp:param name="title" value="${title}"/>
      </jsp:include>
  </head>
  <body>
      <%-- 【説明】レイアウトやその他の入力項目は省略 --%>
      <n:form>
          <%-- 【説明】
                リクエストスコープ上の変数"officeLocation"に、name属性で指定したオブジェクトを参照して値を設定。
                スコープ上のオブジェクトを参照して値を設定する場合、name属性でスコープ上のキーを指定する。 --%>
          <n:set var="officeLocation" name="W11AC02.systemUser.officeLocation"/>
              <c:if test="${officeLocation == ''}">
                  <%-- 【説明】W11AC02.systemUser.officeLocationの値が空文字の場合の処理は省略 --%>
              </c:if>
      </n:form>
  </body>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)
