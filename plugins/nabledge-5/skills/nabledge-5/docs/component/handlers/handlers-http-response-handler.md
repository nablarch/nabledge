# HTTPレスポンスハンドラ

**目次**

* ハンドラクラス名
* モジュール一覧
* 制約
* 応答の変換方法
* カスタムレスポンスライター
* HTTPステータスコードの変更
* 言語毎のコンテンツパスの切り替え
* 本ハンドラ内で発生した致命的エラーの対応

本ハンドラは、後続ハンドラが返す HttpResponse に従い、サーブレットAPIを
呼び出しクライアントへのレスポンスを行う。
応答の方法には、下記4通りが存在する。

サーブレットフォワード

サーブレットにフォワードを行い、レスポンスを描画する。主にJSPを使ったレスポンス時に使用する。

カスタムレスポンスライター

カスタムレスポンスライター（後述）を使用して、任意のレスポンス出力処理を行う。
主にテンプレートエンジン等の外部ライブラリを使ったレスポンス時に使用する。

リダイレクト

クライアントにリダイレクトを行う応答を返す。

直接レスポンス

ServletResponse の getOutputStream メソッドを使用して直接
レスポンスを行う。

処理の流れは以下のとおり。

![flow.png](../../../knowledge/assets/handlers-http-response-handler/flow.png)

## ハンドラクラス名

* nablarch.fw.web.handler.HttpResponseHandler

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

なし。

## 応答の変換方法

本ハンドラでは、後続のハンドラから返されるスキーム [1] と、ステータスコード  [2] によりクライアントに返すレスポンスの方法を変更する。

変換条件と応答方法は下記表の通り。

| 変換条件 | 応答の方法 |
|---|---|
| スキームが `servlet` の場合 | カスタムレスポンスライターが処理対象と判定した場合はカスタムレスポンスライターに処理を委譲する。それ以外の場合はコンテンツパス別サーブレットへ処理をフォワードする。 |
| スキームが `redirect` の場合 | 指定したURLへのリダイレクトを行う |
| スキームが `http` または `https` の場合 | 指定したURLへのリダイレクトを行う |
| スキームが上記以外で、 ステータスコードが400以上の場合 | ステータスコードに合うエラー画面の表示をおこなう。 |
| 上記以外の場合 | HttpResponse#getBodyStream()の結果を応答する。 |

ここで言う「スキーム」とは、後続ハンドラが返した
HttpResponse#getContentPath()
で取得した  ResourceLocator の
getScheme() メソッド の戻り値のことを指す。
明示的にスキームを指定しない場合のデフォルトスキームは `servlet` である。

ここで言う「ステータスコード」とは、後続ハンドラが返す
HttpResponse クラスの
getStatusCode() メソッドの戻り値のことを示す。

## カスタムレスポンスライター

本ハンドラのプロパティ `customResponseWriter` に
CustomResponseWriter
の実装クラスを設定することで、任意のレスポンス出力処理 [3] を実行できる。

具体例として、JSPではなくテンプレートエンジンを使用してレスポンスを出力するというケースが挙げられる。
Nablarchが提供している実装としては、[ウェブアプリケーション Thymeleafアダプタ](../../component/adapters/adapters-web-thymeleaf-adaptor.md#ウェブアプリケーション-thymeleafアダプタ) がある。

## HTTPステータスコードの変更

本ハンドラでは、ステータスコードを一部変更してクライアントへのレスポンスに設定する。

HTTPステータスコードを決定する変換条件と、応答のエラーコードは下記表のとおり。

| 変換条件 | エラーコード |
|---|---|
| Ajaxのリクエストの場合 | 元のステータスコードそのままを返す |
| 元のステータスコードが400の場合 | ステータスコード200を返す |
| 上記以外の場合 | ステータスコード の結果そのままを返す |

## 言語毎のコンテンツパスの切り替え

本ハンドラは、HTTPリクエストに含まれる言語設定をもとにして、フォワード先を動的に切り替える機能を持つ。
この機能を使用することで、利用者が選んだ言語に合わせてフォワードするJSPを切り替える機能が実現できる。

この機能を使用する際は、本ハンドラの `contentPathRule` プロパティに下記いずれかのクラスを設定する。

| クラス名 | 説明 |
|---|---|
| DirectoryBasedResourcePathRule | コンテキストルート直下のディレクトリを言語の切り替えに  使用するクラス。  ```bash # /management/user/search.jspを日本語(ja)と # 英語(en)に対応する場合の配置例 # コンテキストルート直下に言語ごとにディレクトリを作成する。 # ディレクトリ名は言語名とする。 コンテキストルート ├─en │  └─management │      └─user │           search.jsp └─ja     └─management         └─user              search.jsp ``` |
| FilenameBasedResourcePathRule | ファイル名を言語の切り替えに使用するクラス。  ```bash # /management/user/search.jspを日本語(ja)と # 英語(en)に対応する場合の配置例 # 言語毎にファイルを作成する。 # ファイル名にはサフィックス「"_"＋言語名」を付ける。 コンテキストルート └─management         └─user              search_en.jsp              search_ja.jsp ``` |

この際の設定例は下記の通り。

```xml
<!-- リソースパスルール -->
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />

<!-- HTTPレスポンスハンドラ -->
<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

上記以外の方法でコンテンツの切り替えを行いたい場合は、 ResourcePathRule
クラスを継承したクラスを作成し、作成したクラスを上記同様に `resourcePathRule` プロパティに設定すること。

> **Tip:**
> カスタムレスポンスライター でレスポンス出力を行う場合、本機能は使用できない。
> これは、テンプレートエンジン等が持っている多言語対応機能と混在させないためである。

## 本ハンドラ内で発生した致命的エラーの対応

本ハンドラ内の処理で、下記事象が発生した場合、正常な応答が返せないと判断して、クライアントに対しては
ステータスコード500で固定的なレスポンスを返す。

* サーブレットフォワード時に ServletException が発生した場合
* RuntimeException およびそのサブクラスの例外が発生した場合
* Error およびそのサブクラスの例外が発生した場合

この際のレスポンスは下記HTMLとなる。

```html
<html>
  <head>
    <title>A system error occurred.</title>
  </head>
  <body>
    <p>
      We are sorry not to be able to proceed your request.<br/>
      Please contact the system administrator of our system.
    </p>
  </body>
</html>
```

> **Important:**
> 上記HTMLのレスポンスは固定的になっており、設定による変更などはできない。

> このレスポンスは、本ハンドラ内で例外が発生するレアケースのみでしか使われることはない。
> このため、通常この仕様が問題になることはないが、どんなことがあってもこのレスポンスを
> 出してはいけないシステムにおいては、本ハンドラを参考にハンドラの自作を検討すること。
