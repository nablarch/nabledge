# Webフロントコントローラ (サーブレットフィルタ)

## 概要

**クラス名**: `nablarch.fw.web.servlet.WebFrontController`

サーブレットコンテナからコールバックされ、ハンドラキューの実行の起点となるクラス。サーブレットコンテキスト上にサーブレットフィルタとしてデプロイされる。

**関連ハンドラ**:
- [NablarchServletContextListener](handlers-NablarchServletContextListener.md) によって初期化される

<details>
<summary>keywords</summary>

WebFrontController, nablarch.fw.web.servlet.WebFrontController, NablarchServletContextListener, サーブレットフィルタ, ハンドラキュー起点, Webフロントコントローラ

</details>

## 処理フロー

**[往路処理]**

1. `HttpServletRequest`/`HttpServletResponse` をラップしたHTTPリクエストオブジェクトおよび実行コンテキストを生成する
2. ハンドラキュー内の先頭ハンドラを、生成したHTTPリクエストオブジェクトおよび実行コンテキストを引数として実行する

**[往路処理]**

3. ハンドラキューでの処理が正常終了した時点でリクエスト処理を終了し、サーブレットコンテナに制御を戻す

**[例外処理]**

3a. ハンドラキューでの処理中に例外が送出された場合、特段の例外制御は行わず発生した例外をそのまま送出する。標準ハンドラ構成では直後に [GlobalErrorHandler](handlers-GlobalErrorHandler.md) が配置されるため、致命的エラーを除けばここで例外を捕捉することはない。

<details>
<summary>keywords</summary>

処理フロー, 往路処理, 例外処理, GlobalErrorHandler, HttpServletRequest, HttpServletResponse, ハンドラキュー実行

</details>

## 設定項目・拡張ポイント

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ハンドラキュー | handlerQueue | List<Handler> | 必須指定 |

**標準設定**:

```xml
<component
  name  ="webFrontController"
  class ="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
  <list>
    <component class="nablarch.fw.handler.GlobalErrorHandler" />
    <component class="nablarch.fw.web.handler.HttpCharacterEncodingHandler" />
    <component-ref name="sessionConcurrentAccessHandler" />
    <component-ref name="httpResponseHandler" />
    <!-- 以下ハンドラ定義(略) -->
  </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

handlerQueue, 設定項目, nablarch.fw.handler.GlobalErrorHandler, nablarch.fw.web.handler.HttpCharacterEncodingHandler, GlobalErrorHandler, HttpCharacterEncodingHandler, ハンドラキュー設定

</details>
