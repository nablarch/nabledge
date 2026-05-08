## 命名ルール

フレームワークでは、CSSのクラス名やJavaScriptの関数名など、フレームワークが規定する名前については、
個別アプリケーションと重複しないようにプレフィックス「nablarch_」を使用する。
このため、個別アプリケーションでは、「nablarch_」から始まる名前を使用しないこと。
この命名ルールの対象を下記に示す。

* HTMLの属性値
* CSSのクラス名
* JavaScriptの関数名とグローバル変数名
* ページスコープ、リクエストスコープ、セッションスコープの属性名

## taglibディレクティブの指定方法

カスタムタグを使用するJSPでは、taglibディレクティブの指定が必須となる。
本機能のカスタムタグを使用する場合のtaglibディレクティブの指定例を下記に示す。

```jsp
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
```

以降の実装例では、上記のtaglibディレクティブが指定されているものとする。

## URIの指定方法

カスタムタグにおいてURIを指定する属性は、下記のいずれかの方法で指定する。

| 指定方法 | 指定するパス | 説明 |
|---|---|---|
| 絶対URL | http又はhttpsから始まるパス | 他システム連携などでアプリケーションとホストが異なるURIを指定する場合に使用する。 カスタムタグは、指定されたパスをそのまま使用する。 |
| コンテキストからの相対パス | /(スラッシュ)から始まるパス | アプリケーション内のパスを指定する場合に使用する。 カスタムタグは、指定されたパスの先頭にコンテキストパスを付加して使用する。 |
| 現在のパスからの相対パス | /(スラッシュ)から始まらないパス (絶対URLを除く) | アプリケーション内のパスを指定する場合に使用する。 カスタムタグは、指定されたパスをそのまま使用する。 |

コンテキストからの相対パスを指定している場合は、カスタムタグのsecure属性を指定することでURIのhttpsとhttpを切り替えることができる。
secure属性が指定された場合は、カスタムタグの設定値(http用のポート番号、https用のポート番号、ホスト)とコンテキストパスを使用してURIを組み立てる。
このためsecure属性を使用するアプリケーションでは、カスタムタグの設定を行う必要がある。
カスタムタグの設定については、 [カスタムタグのデフォルト値の設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#カスタムタグのデフォルト値の設定) を参照。

| 属性 | 説明 |
|---|---|
| secure | URIをhttpsにするか否か。 httpsにする場合はtrue、しない場合はfalse。 |

> **Note:**
> secure属性は、遷移先のプロトコルを切り替えるボタンやリンクのみで使用する。
> 遷移先のプロトコルが同じ場合(httpからhttp、httpsからhttps)は、secure属性を指定せずに相対パスを指定する。

secure属性の使用例を下記に示す。下記のポート番号とホストが設定されているものとする。

* http用のポート番号: 8080
* https用のポート番号: 443
* ホスト: sample.co.jp

httpからhttpsに切り替える場合

```jsp
<%-- secure属性にtrueを指定する。 --%>
<n:submit type="button" name="login" value="ログイン" uri="/LoginAction/LOGIN001" secure="true" />
```

```bash
# 組み立てられるURI
https://sample.co.jp:443/<コンテキストパス>/LoginAction/LOGIN001
```

httpsからhttpに切り替える場合

```jsp
<%-- secure属性にfalseを指定する。 --%>
<n:submitLink name="logout" uri="/LogoutAction/LOGOUT01" secure="false">ログアウト</n:submitLink>
```

```bash
# 組み立てられるURI
http://sample.co.jp:8080/<コンテキストパス>/LogoutAction/LOGOUT01

# 組み立てられるURI(カスタムタグの設定でhttp用のポート番号を指定しなかった場合)
# ポート番号が出力されない。
http://sample.co.jp/<コンテキストパス>/LogoutAction/LOGOUT01
```

なお、本機能では、URIを指定するHTMLタグについて、コンテキストパスの付加とURLリライトに対応する下記のカスタムタグを提供する。

* [aタグ](../../component/libraries/libraries-07-TagReference.md#aタグ) (リンク)
* [imgタグ](../../component/libraries/libraries-07-TagReference.md#imgタグ) (画像ファイル)
* [scriptタグ](../../component/libraries/libraries-07-TagReference.md#scriptタグ) (JavaScriptファイル)
* [linkタグ](../../component/libraries/libraries-07-TagReference.md#linkタグ) (CSSファイル)

## HTMLエスケープと改行、半角スペース変換

### HTMLエスケープ

本フレームワークが提供する全てのカスタムタグでは、原則として出力する際に全てのHTMLの属性についてHTMLエスケープを行う。
HTMLエスケープ処理では、下記の文字変換を行う。

| 変換前 | 変換後 |
|---|---|
| & | &amp; |
| < | &lt; |
| > | &gt; |
| " | &#034; |
| ' | &#039; |

> **Warning:**
> EL式はHTMLエスケープ処理を実施しないため、EL式を使用して値を出力しないこと。
> 値を出力する場合は、writeタグなど本機能が提供するカスタムタグを使用する。
> ただし、JSTLのforEachタグやカスタムタグの属性にオブジェクトを設定する場合など、直接出力しない箇所ではEL式を使用しても問題ない。

> **Warning:**
> JavaScriptに対するエスケープ処理は、まだ未実装のため、 scriptタグのボディやonclick属性など、JavaScriptを記述する部分には、動的な値(入力データなど)を埋め込まないこと。
> JavaScriptを記述する部分に動的な値(入力データなど)を埋め込む場合は、プロジェクトの責任でエスケープ処理を実施すること。

### 改行、半角スペース変換

確認画面などに入力データを出力する際には、HTMLエスケープに加えて、改行と半角スペースの変換を行う。
下記に変換内容を示す。

| 変換前 | 変換後 |
|---|---|
| 改行コード(\\n、\\r、\\r\\n) | <br /> |
| 半角スペース | &nbsp; |

### HTMLエスケープせずに値を出力する方法

業務アクションなどで設定された値をページ上に出力する場合は、 Webview_WriteTag を使用するが、
HTMLエスケープを行わず、変数内のHTMLタグを直接出力したい場合は、以下のタグを使用する。

* [prettyPrintタグ](../../component/libraries/libraries-07-TagReference.md#prettyprintタグ)

  変数中の **<b>** や **<del>** のような装飾系のHTMLタグをエスケープせずに出力するカスタムタグ。
  使用可能なHTMLタグ及び属性は、 [カスタムタグのデフォルト値の設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#カスタムタグのデフォルト値の設定) で任意に設定することができる。
  デフォルトで使用可能なタグ、属性は以下の通り。

  **使用可能タグ**

  b big blockquote br caption center dd del dl dt em font h1 h2 h3 hr i ins li ol p small strong sub sup table td th tr u ul

  **使用可能属性**

  color size border colspan rowspan bgcolor

  > **Warning:**
> [prettyPrintタグ](../../component/libraries/libraries-07-TagReference.md#prettyprintタグ) で出力する変数の内容が、不特定のユーザによって任意に設定できるものであった場合、
  > 脆弱性の要因となる可能性があるため、使用可能なHTMLタグ及び属性を設定する場合は、その選択に十分に留意すること。
  > 例えば、 **<script>** タグや **onclick** 属性を使用可能とした場合、クロスサイトスクリプティング(XSS)脆弱性の
  > 直接要因となる。
* [rawWriteタグ](../../component/libraries/libraries-07-TagReference.md#rawwriteタグ)

  変数中の文字列の内容をエスケープせずにそのまま出力するカスタムタグ。

  > **Warning:**
> [rawWriteタグ](../../component/libraries/libraries-07-TagReference.md#rawwriteタグ) で出力する変数の内容が、不特定のユーザによって任意に設定できるものであった場合、
  > クロスサイトスクリプティング(XSS)脆弱性の直接の要因となる。

  > この為、本タグの使用には十分な考慮が必要である。
  > なお、別添のJSPチェックツールでは、本タグを使用禁止タグとして分類しており、使用している箇所はエラーとして検出される。

## 言語毎のリソースパスの切り替え

リソースパスを扱うタグは、言語設定をもとにリソースパスを動的に切り替える機能をもつ。
下記のタグが言語毎のリソースパスの切り替えに対応している。

* [aタグ](../../component/libraries/libraries-07-TagReference.md#aタグ)
* [imgタグ](../../component/libraries/libraries-07-TagReference.md#imgタグ)
* [scriptタグ](../../component/libraries/libraries-07-TagReference.md#scriptタグ)
* [linkタグ](../../component/libraries/libraries-07-TagReference.md#linkタグ)
* [confirmationPageタグ](../../component/libraries/libraries-07-TagReference.md#confirmationpageタグ)
* [includeタグ](../../component/libraries/libraries-07-TagReference.md#includeタグ)

includeタグは動的なJSPインクルードを言語毎のリソースパスの切り替えに対応させるために提供している。
[includeParamタグ](../../component/libraries/libraries-07-TagReference.md#includeparamタグ) を使用してインクルード時に追加するパラメータを指定する。

```jsp
<%-- path属性にインクルード先のパスを指定する。 --%>
<n:include path="/app_header.jsp">
    <%-- paramName属性にパラメータ名、value属性に値を指定する。
         スコープ上に設定された値を使用する場合はname属性を指定する。
         name属性とvalue属性のどちらか一方を指定する。 --%>
    <n:includeParam paramName="title" value="ユーザ情報詳細" />
</n:include>
```

ResourcePathRule抽象クラスのサブクラスを使用して言語毎のリソースパスを取得することで、
カスタムタグは言語毎のリソースパスの切り替えを行う。
ResourcePathRuleおよび本フレームワークがデフォルトで提供するサブクラスについては、
[言語毎のコンテンツパスの切り替え](../../component/handlers/handlers-HttpResponseHandler.md#言語毎のコンテンツパスの切り替え) を参照。

カスタムタグは [カスタムタグのデフォルト値の設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#カスタムタグのデフォルト値の設定) に指定されたResourcePathRule抽象クラスのサブクラスを使用する。
ResourcePathRule抽象クラスのサブクラスの設定については、 [カスタムタグのデフォルト値の設定](../../component/libraries/libraries-07-HowToSettingCustomTag.md#カスタムタグのデフォルト値の設定) を参照。

## 静的コンテンツのクライアント側でのキャッシュについて

クライアントサイド(ブランザ)でキャッシュを有効化している場合、サーバ上に配置した静的コンテンツを置き換えても、
クライアント側では最新のコンテンツではなくキャッシュされた古いコンテンツが表示される可能性がある。
この問題を回避するため、本機能では静的コンテンツのURIにGETパラメータで静的コンテンツのバージョンを付加し、
静的コンテンツ置き換え時にクライアント側のキャッシュを強制的に破棄する機能を提供する。

GETパラメータに付加する静的コンテンツのバージョンは、設定ファイル（configファイル）に設定する。
設定ファイルに静的コンテンツのバージョンが設定されていない場合には、本機能は無効化される。

設定値は、以下のルールで記載する。

| キー | 値 |
|---|---|
| static_content_version | 静的コンテンツのバージョン |

以下に設定例を示す。

```bash
# 静的コンテンツのバージョン
static_content_version=1.0
```

対応する属性は以下の通り。

* [imgタグ](../../component/libraries/libraries-07-TagReference.md#imgタグ) のsrc属性
* [scriptタグ](../../component/libraries/libraries-07-TagReference.md#scriptタグ) のsrc属性
* [linkタグ](../../component/libraries/libraries-07-TagReference.md#linkタグ) のhref属性
* [submitタグ](../../component/libraries/libraries-07-TagReference.md#submitタグ) のsrc属性
* [popupSubmitタグ](../../component/libraries/libraries-07-TagReference.md#popupsubmitタグ) のsrc属性
* [downloadSubmitタグ](../../component/libraries/libraries-07-TagReference.md#downloadsubmitタグ) のsrc属性
