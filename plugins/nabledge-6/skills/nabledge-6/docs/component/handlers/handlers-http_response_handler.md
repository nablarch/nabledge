# HTTPレスポンスハンドラ

## ハンドラクラス名

**クラス**: `HttpResponseHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

本ハンドラを使用するにあたっての制約事項はなし。

## 応答の変換方法

応答方法は以下の4通り: サーブレットフォワード、カスタムレスポンスライター、リダイレクト、直接レスポンス（`ServletResponse` の `getOutputStream` を使用）。

スキームは `HttpResponse#getContentPath()` が返す `ResourceLocator` の `getScheme()` の値。明示的に指定しない場合のデフォルトスキームは `servlet`。ステータスコードは `HttpResponse#getStatusCode()` の値。

| 変換条件 | 応答の方法 |
|---|---|
| スキームが `servlet` の場合 | カスタムレスポンスライターが処理対象と判定した場合はカスタムレスポンスライターに委譲。それ以外はコンテンツパス別サーブレットへフォワード。 |
| スキームが `redirect` の場合 | 指定URLへリダイレクト |
| スキームが `http` または `https` の場合 | 指定URLへリダイレクト |
| スキームが上記以外でステータスコードが400以上の場合 | ステータスコードに合うエラー画面を表示 |
| 上記以外の場合 | `HttpResponse#getBodyStream()` の結果を応答 |

## カスタムレスポンスライター

`customResponseWriter` プロパティに `CustomResponseWriter` の実装クラスを設定することで、任意のレスポンス出力処理（テンプレートエンジン等による出力）を実行できる。Nablarchが提供する実装として :ref:`web_thymeleaf_adaptor` がある。

## HTTPステータスコードの変更

| 変換条件 | エラーコード |
|---|---|
| Ajaxのリクエストの場合 | 元のステータスコードをそのまま返す |
| 元のステータスコードが400の場合 | 200を返す |
| 上記以外の場合 | 元のステータスコードをそのまま返す |

## 言語毎のコンテンツパスの切り替え

`contentPathRule` プロパティに以下のクラスを設定することで、HTTPリクエストの言語設定に基づいてフォワード先（JSP等）を動的に切り替えられる。

| クラス名 | 説明 |
|---|---|
| `DirectoryBasedResourcePathRule` | コンテキストルート直下のディレクトリを言語切り替えに使用（ディレクトリ名=言語名） |
| `FilenameBasedResourcePathRule` | ファイル名のサフィックス「_言語名」を言語切り替えに使用 |

```xml
<component name="resourcePathRule" class="nablarch.fw.web.i18n.DirectoryBasedResourcePathRule" />

<component class="nablarch.fw.web.handler.HttpResponseHandler">
  <property name="contentPathRule" ref="resourcePathRule" />
</component>
```

上記以外の切り替え方法には `ResourcePathRule` を継承したクラスを作成して `contentPathRule` プロパティに設定する。

> **補足**: カスタムレスポンスライターでレスポンス出力を行う場合、本機能は使用できない。テンプレートエンジン等が持つ多言語対応機能と混在させないため。

## 本ハンドラ内で発生した致命的エラーの対応

以下の事象が発生した場合、ステータスコード500で固定的なHTMLレスポンスを返す。

- サーブレットフォワード時に `ServletException` が発生した場合
- `RuntimeException` およびそのサブクラスの例外が発生した場合
- `Error` およびそのサブクラスの例外が発生した場合

返却されるHTML:

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

> **重要**: 上記HTMLのレスポンスは固定的で設定変更不可。このレスポンスを出してはいけないシステムでは、本ハンドラを参考にハンドラの自作を検討すること。
