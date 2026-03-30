# Webフロントコントローラ (サーブレットフィルタ)

## 概要

**クラス名**: `nablarch.fw.web.servlet.WebFrontController`

[../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) においてサーブレットコンテナから直接コールバックされ、ハンドラキューの実行の起点となるクラス。サーブレットコンテキスト上にサーブレットフィルタとしてデプロイされる。

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [NablarchServletContextListener](handlers-NablarchServletContextListener.md) | 本クラスを初期化する |

<details>
<summary>keywords</summary>

WebFrontController, nablarch.fw.web.servlet.WebFrontController, NablarchServletContextListener, サーブレットフィルタ, ハンドラキュー起点

</details>

## 処理フロー

**[往路処理]**

1. `HttpServletRequest`/`HttpServletResponse` をラップしたHTTPリクエストオブジェクトおよび実行コンテキストを生成する。
2. ハンドラキュー内の先頭ハンドラをHTTPリクエストオブジェクトおよび実行コンテキストを引数として実行する。

**[往路処理]**

3. ハンドラキューでの処理が正常に終了した時点で、サーブレットコンテナ側に制御を戻す。

**[例外処理]**

3a. ハンドラキュー処理中に例外が送出された場合、特段の例外制御は行わず発生した例外をそのまま送出する。標準ハンドラ構成では直後に [GlobalErrorHandler](handlers-GlobalErrorHandler.md) が配置されるため、サーバプロセスの継続に影響するような特定の致命的エラーを除けばここで例外を捕捉することはない。

<details>
<summary>keywords</summary>

処理フロー, HTTPリクエストオブジェクト生成, ハンドラキュー実行, GlobalErrorHandler, 例外処理, HttpServletRequest, HttpServletResponse

</details>

## 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ハンドラキュー | handlerQueue | List\<Handler\> | 必須指定 |

**標準設定**:

```xml
<component
  name  ="webFrontController"
  class ="nablarch.fw.web.servlet.WebFrontController">

  <!-- ハンドラキュー構成 -->
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

handlerQueue, ハンドラキュー設定, WebFrontController設定, GlobalErrorHandler, HttpCharacterEncodingHandler

</details>
