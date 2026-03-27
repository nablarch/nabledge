# 登録画面初期表示の実装

## Actionクラスの実装

## Actionクラスの実装

### URI形式

NablarchのURIは以下の形式で解釈される:

```
/action/{パッケージ名}/{アクションクラス名}/{メソッド名からdoを除いた文字列}
```

パッケージ名は `nablarch.sample.` までは無視され、それ以降の `.` が `/` に置換される。

例: `nablarch.sample.ss11AC.W11AC02Action` → ベースURI: `/action/ss11AC/W11AC02Action/`

### リクエスト単体テストクラス

| 項目 | 値 |
|---|---|
| テストクラス格納フォルダ | test/java/nablarch/sample/ss11AC |
| テストクラス名 | W11AC02ActionRequestTest |
| 親クラス | BasicHttpRequestTestTemplate |

`getBaseUri()` でベースURIを返却し、`AbstractHttpRequestTestTemplate#execute(String)` にシート名を指定してテスト実行する。

```java
public class W11AC02ActionRequestTest extends BasicHttpRequestTestTemplate {
    @Override
    protected String getBaseUri() {
        return "/action/ss11AC/W11AC02Action/";
    }

    @Test
    public void testRW11AC0201() {
        execute("testRW11AC0201");
    }
}
```

### リクエスト単体テストデータシート

テストデータ: `W11AC02ActionRequestTest.xlsx` の `testRW11AC0201` シート（:ref:`request_test_testcases` 参照）

`testRW11AC0201` シートでは以下を検証する:
- 登録画面の初期表示に必要なパラメータがリクエストに格納されていること
- 表示するJSPが登録画面のものであること
- レスポンスのステータスが `OK` であること

> **警告**: テスト共通データシート（シート名: `setUpDb`）は必須。データのセットアップが不要な場合でも空シートを作成すること。

### リクエスト単体テスト実施（Actionクラス作成前）

Actionクラスを作成していない段階でリクエスト単体テストを実施し、テストが失敗することを確認する。

ステータスコード404の箇所で処理がENDしていること:

```
2011-09-28 18:25:28.041 -INFO- root [201109281825279950001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] @@@@ END @@@@ rid = [RW11AC0201] uid = [0000000001] sid = [15dbmk0lzycbo1ajvrs2pqesk1] url = [http://127.0.0.1/action/ss11AC/W11AC02Action/RW11AC0201] status_code = [404] content_path = [/PAGE_NOT_FOUND_ERROR.jsp]
```

### Actionクラスの新規作成

| 項目 | 値 |
|---|---|
| ソース格納フォルダ | main/java/nablarch/sample/ss11AC |
| クラス名 | W11AC02Action |
| メソッド名 | doRW11AC0201（「do」＋リクエストID） |

```java
public class W11AC02Action extends DbAccessSupport {
    public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
        return new HttpResponse("/ss11AC/W11AC0201.jsp");
    }
}
```

### リクエスト単体テスト実施（Actionクラス作成後）

Actionクラス作成後にリクエスト単体テストを実施し、Actionクラスまで処理が到達していることを確認する。

- **Actionクラスまで処理到達の確認**: ログ中の「@@@@ DISPATCHING CLASS @@@@」の次に「BEFORE ACTION」が出力されていれば、Actionまで処理が到達している。

```
2011-09-28 18:26:39.163 -INFO- root [201109281826391630001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] @@@@ DISPATCHING CLASS @@@@ class = [nablarch.sample.ss11AC.W11AC02Action]
2011-09-28 18:26:39.179 -DEBUG- root [201109281826391630001] boot_proc = [] proc_sys = [] req_id = [RW11AC0201] usr_id = [0000000001] **** BEFORE ACTION ****
```

- **JSP記載内容不正時のエラー**:

```
javax.servlet.jsp.JspException: java.lang.IllegalArgumentException: uri is null.
```

> **ノート**: テストを繰り返しながらActionクラスを徐々に完成させる。

<details>
<summary>keywords</summary>

W11AC02Action, W11AC02ActionRequestTest, BasicHttpRequestTestTemplate, DbAccessSupport, HttpResponse, HttpRequest, ExecutionContext, AbstractHttpRequestTestTemplate, URI形式, Actionクラス実装, リクエスト単体テスト, テストクラス作成, setUpDb

</details>

## JSPの実装

## JSPの実装

### URI属性の指定

ボタン・リンク項目の `uri` 属性の指定形式:

```
/{ベースURI}/{リクエストID}
```

ベースURIは [03_06_action_request_test](#s1) で説明した形式を使用する。

修正後の例:

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

### JSP修正後の確認

リクエスト単体テストを実行し、以下を確認する:
- HTML(JSP)が出力されること
- HTTPステータスコード200が返却されること

出力されたHTMLをWebブラウザで開き、登録画面であることとレイアウトが崩れていないことを確認する。

HTMLの出力先フォルダ: `tmp/html_dump/W11AC02ActionRequestTest` 配下

### JSP静的チェックツール

[jsp_static_analysis_tool](../../development-tools/java-static-analysis/java-static-analysis-01_JspStaticAnalysis.md) をEclipseのAntビューに追加して実行する。

| Antビルドファイル | 実行ターゲット |
|---|---|
| tool/jspanalysis/jsp-analysis-build.xml | JSP解析(HTMLレポート出力) |

> **注意**: 静的チェックエラーのある実装はXSS脆弱性を含む可能性があるため必ず対処すること。どうしても回避できない場合はプロジェクトのアーキテクトに確認し対処方法を検討すること。

<details>
<summary>keywords</summary>

uri属性, JSP静的チェック, jsp_static_analysis_tool, XSS脆弱性, ボタンリンクURI設定, JSP修正, 静的解析ツール

</details>
