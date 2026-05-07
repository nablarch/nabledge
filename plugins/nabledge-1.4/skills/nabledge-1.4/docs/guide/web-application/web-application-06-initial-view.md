# 登録画面初期表示の実装

登録画面の初期表示は、以下のステップで実装する。

* Actionクラスの実装

  * リクエスト単体テストクラスの作成
  * リクエスト単体テストデータシートの作成
  * リクエスト単体テスト実施
  * Actionクラスの新規作成
  * リクエスト単体テスト実施
* JSPの実装

  * JSPの修正
  * JSP静的チェックツールの実行

## Actionクラスの実装

### リクエスト単体テストクラスの作成

| テストクラス作成フォルダ | テストクラス名 | リクエスト単体テスト親クラス名 |
|---|---|---|
| test/java/nablarch/sample/ss11AC | W11AC02ActionRequestTest | BasicHttpRequestTestTemplate |

リクエスト単体テストを作成するに当たり、テスト対象クラスへアクセスされる際のURLを指定する必要がある。

チュートリアルアプリケーションでは、Nablarchの機能によりURIは以下の形式で解釈される。

```
/action/`パッケージ名`/`アクションクラス名`/`メソッド名からdoを除いた文字列`
```

なお、パッケージ名は、 nablarch.sample.までは無視され、それ以降の . が / に置換されてURIとなる。

| テスト対象クラス | ベースURI |
|---|---|
| nablarch.sample.ss11AC.W11AC02Action | /action/ss11AC/W11AC02Action/ |

リクエスト単体テストは、 `AbstractHttpRequestTestTemplate#execute(String)` に、テストデータの記載されているシート名を指定して実行する。

```java
/**
 * {@link W11AC02Action}のテスト
 *
 * @author Nablarch Taro
 * @since 1.0
 */
public class W11AC02ActionRequestTest extends BasicHttpRequestTestTemplate {

    // 【説明】①ターゲットクラスのベースURIを返却する
    @Override
    protected String getBaseUri() {
        return "/action/ss11AC/W11AC02Action/";
    }

    // 【説明】②リクエスト単体テストを実行

    /**
     * {@link W11AC02Action#doRW11AC0201(nablarch.fw.web.HttpRequest, nablarch.fw.ExecutionContext)} のテスト
     */
    @Test
    public void testRW11AC0201() {
        execute("testRW11AC0201");
    }

}
```

### リクエスト単体テストデータシートの作成

ここでは、以下を検証するためのテストデータを作成する。（ [リクエスト単体テストデータシートの書き方](../../development-tools/testing-framework/testing-framework-02-requestunittest-index.md#テストケース一覧) ）

* 登録画面の初期表示に必要なパラメータがリクエストに格納されていること。
* 表示するJSPが、登録画面のものであること。
* レスポンスのステータスが `OK` であること。

| ブック名 | シート名 |
|---|---|
| W11AC02ActionRequestTest.xlsx | testRW11AC0201 |

![action_test_early.png](../../../knowledge/assets/web-application-06-initial-view/action_test_early.png)

> **Warning:**
> 現在のリクエスト単体テストでは、テストデータとしてテスト共通データシート(シート名：setUpDb)が必須である為、データのセットアップが不要な場合でもシートを作成すること。シート内には何も書かなくてよい。

### リクエスト単体テスト実施

リクエスト単体テストを実施し、テストが失敗することを確認する。（Actionクラスを作成していない為）

コンソールログに以下の内容が出力されれば良い。

ステータスコード404の箇所で処理がENDしていること。

＜出力内容＞

```none
2011-09-28 18:25:28.041 -INFO- root [201109281825279950001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] @@@@ END @@@@ rid = [RW11AC0201] uid = [0000000001] sid = [15dbmk0lzycbo1ajvrs2pqesk1] url = [http://127.0.0.1/action/ss11AC/W11AC02Action/RW11AC0201] status_code = [404] content_path = [/PAGE_NOT_FOUND_ERROR.jsp]
```

### Actionクラスの新規作成

| ソース格納フォルダ | クラス名 | メソッド名 |
|---|---|---|
| main/java/nablarch/sample/ss11AC | W11AC02Action | "do" ＋ RW11AC0201（登録画面初期表示のリクエストID） |

ユーザ情報登録画面のJSP：W11AC0201.jspを指定して、 `HttpResponse` を作成し返却する。

```java
/**
 * ユーザー登録機能のアクションクラス。
 *
 * @author Nablarch Taro
 * @since 1.0
 */
public class W11AC02Action extends DbAccessSupport {

    /**
     * ユーザの新規登録フォームを表示する。
     *
     * @param req HTTPリクエスト
     * @param ctx 実行時コンテキスト
     * @return HTTPレスポンス
     */
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {

        // 【説明】①ユーザ情報登録画面へ遷移
        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }

}
```

### リクエスト単体テスト実施

リクエスト単体テストを実施し、Actionクラスまで処理が到達していることを確認する。

コンソールログに以下の内容が出力されれば良い。

* Actionクラスまで処理到達

  ログ中の「@@@@ DISPATCHING CLASS @@@@」の次に「BEFORE ACTION」が出力されていれば、Actionまで処理が到達している。

  ＜出力内容＞

  ```none
    2011-09-28 18:26:39.163 -INFO- root [201109281826391630001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] @@@@ DISPATCHING CLASS @@@@ class = [nablarch.sample.ss11AC.W11AC02Action]
  2011-09-28 18:26:39.179 -DEBUG- root [201109281826391630001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] **** BEFORE ACTION ****
  ```
* JSP記載内容不正

  ＜出力内容＞

  ```none
  javax.servlet.jsp.JspException: java.lang.IllegalArgumentException: uri is null.
  ```

> **Note:**
> テストを繰り返しながらActionクラスを徐々に完成させる。

## JSPの実装

### JSPの修正

ボタン項目・リンク項目のuri属性に値が設定されていないことが原因でテストが失敗しているので、uri属性を指定する。

/[リクエスト単体テストクラスの作成](../../guide/web-application/web-application-06-initial-view.md#リクエスト単体テストクラスの作成) で説明したベースURI/`リクエストID`

＜修正前＞

```jsp
<button:block>
  <n:forInputPage>
    <button:check uri="" dummyUri="W11AC0202.jsp">
    </button:check>
  </n:forInputPage>
  <n:forConfirmationPage>
    <button:cancel uri="" dummyUri="W11AC0201.jsp">
    </button:cancel>
    <button:confirm uri="" dummyUri="W11AC0203.jsp">
    </button:confirm>
  </n:forConfirmationPage>
</button:block>
```

＜修正後＞

```jsp
<button:block>
  <n:forInputPage>
    <button:check uri="/action/ss11AC/W11AC02Action/RW11AC0202" dummyUri="W11AC0202.jsp">
    </button:check>
  </n:forInputPage>
  <n:forConfirmationPage>
    <button:cancel uri="/action/ss11AC/W11AC02Action/RW11AC0203" dummyUri="W11AC0201.jsp">
    </button:cancel>
    <button:confirm uri="/action/ss11AC/W11AC02Action/RW11AC0204" dummyUri="W11AC0203.jsp">
    </button:confirm>
  </n:forConfirmationPage>
</button:block>
```

リクエスト単体テストを実行し、HTML(JSP)が出力されること、HTTPステータスコード：200が返却されることを確認する。

出力されたHTMLをWebブラウザで開き、登録画面であることと、レイアウトが崩れていないことを確認する。

HTMLの出力先フォルダ：tmp/html_dump/W11AC02ActionRequestTest 配下

### JSP静的チェックツールの実行

[JSP静的解析ツール](../../development-tools/java-static-analysis/java-static-analysis-01-JspStaticAnalysis.md#jsp静的解析ツール) を実行し、該当ファイルに静的チェックエラーがないことを確認する。

JSP静的解析ツールは、マスターデータセットアップツールと同様の方法でEclipseの
Antビューに追加して実行する。

| Antビルドファイル | 実行するターゲット |
|---|---|
| tool/jspanalysis/jsp-analysis-build.xml | JSP解析(HTMLレポート出力) |

> **Note:**
> 静的チェックでエラーが出る実装は、クロスサイトスクリプティングの脆弱性を含む可能性があるため、
> 必ず対処が必要になる。
> アプリケーションの機能制約などから、どうしても静的チェックのエラーが回避できない場合は、
> 必ずプロジェクトのアーキテクトに確認し、対処方法を検討すること。
