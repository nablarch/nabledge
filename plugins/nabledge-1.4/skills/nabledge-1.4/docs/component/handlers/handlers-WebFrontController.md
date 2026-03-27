# Webフロントコントローラ (サーブレットフィルタ)

## 概要

**クラス名**: `nablarch.fw.web.servlet.WebFrontController`

[../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) において、サーブレットコンテナから直接コールバックされ、ハンドラキューの実行の起点となるクラス。サーブレットコンテキスト上にサーブレットフィルタとしてデプロイされる。

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [NablarchServletContextListener](handlers-NablarchServletContextListener.md) | NablarchServletContextListener によって初期化される。 |

<details>
<summary>keywords</summary>

WebFrontController, nablarch.fw.web.servlet.WebFrontController, NablarchServletContextListener, サーブレットフィルタ, ハンドラキュー起点, Webフロントコントローラ

</details>

## 処理フロー

**[往路処理]**

1. HTTPリクエストオブジェクト・実行コンテキストの生成: `HttpServletRequest`/`HttpServletResponse` をラップしたHTTPリクエストオブジェクトおよび実行コンテキストを生成する。
2. ハンドラキューへの処理委譲: 設定されたハンドラキュー内の先頭ハンドラを、生成したHTTPリクエストオブジェクトおよび実行コンテキストを引数として実行する。

**[往路処理]**

3. ハンドラキューでの処理が正常に終了した時点で、サーブレットコンテナ側に制御を戻す。

**[例外処理]**

3a. 後続ハンドラ処理中のエラー: 例外が送出された場合、特段の例外制御は行なわず発生した例外をそのまま送出する。標準ハンドラ構成では [GlobalErrorHandler](handlers-GlobalErrorHandler.md) が直後に配置されるため、致命的エラーを除けばここで例外を捕捉することは無い。

<details>
<summary>keywords</summary>

処理フロー, HTTPリクエストオブジェクト生成, ハンドラキュー処理委譲, 例外処理, GlobalErrorHandler, HttpServletRequest, HttpServletResponse

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| handlerQueue | List\<Handler\> | ○ | | ハンドラキュー |

```xml
<component
  name="webFrontController"
  class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.handler.GlobalErrorHandler" />
      <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler" />
      <component-ref name="sessionConcurrentAccessHandler" />
      <component-ref name="httpResponseHandler" />
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

handlerQueue, ハンドラキュー設定, WebFrontController設定, コンポーネント設定, HttpCharacterEncodingHandler, sessionConcurrentAccessHandler, httpResponseHandler

</details>
