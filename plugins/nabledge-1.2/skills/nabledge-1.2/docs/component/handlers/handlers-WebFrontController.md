## Webフロントコントローラ (サーブレットフィルタ)

**クラス名:** `nablarch.fw.web.servlet.WebFrontController`

-----

-----

### 概要

[画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) において、サーブレットコンテナから直接コールバックされ、
ハンドラキューの実行の起点となるクラスである。

サーブレットコンテキスト上にサーブレットフィルタとしてデプロイされる。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| Nablarchサーブレットコンテキスト初期化リスナ | nablarch.fw.web.servlet.NablarchServletContextListener | - | - | サーブレットコンテキスト初期化時に、リポジトリおよびハンドラキューの初期化処理を行う。 | - | Fatalログを出力した上で再送出する。(デプロイエラーになる。) |
| Webフロントコントローラ (サーブレットフィルタ) | nablarch.fw.web.servlet.WebFrontController | ServletRequest/Response | - | HttpServletRequest/HttpServletResponseからHTTPリクエストオブジェクトを作成し、ハンドラキューに処理を委譲する。 | (Webコンテナ側に制御を戻す。) | このハンドラでは例外およびエラーの捕捉は行なわず、そのまま送出する。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Nablarchサーブレットコンテキスト初期化リスナ](../../component/handlers/handlers-NablarchServletContextListener.md) | 本クラスは **NablarchServletContextListener** によって初期化される。 |

### 処理フロー

**[往路処理]**

**1. (HTTPリクエストオブジェクト、実行コンテキストの生成)**

`HttpServletRequest`/`HttpServletResponse` をラップした
HTTPリクエストオブジェクトおよび実行コンテキストを生成する。

**2. (ハンドラキューに対する処理委譲)**

このサーブレットフィルタに設定されたハンドラキュー内の先頭ハンドラを、
**2.** で作成したHTTPリクエストオブジェクトおよび実行コンテキストを引数として
実行する。

**[往路処理]**

**3. (正常終了)**

ハンドラキューでの処理が正常に終了した時点で、当該リクエストに対する処理を終了し、
サーブレットコンテナ側に制御を戻す。

**[例外処理]**

**3a. (後続ハンドラ処理中のエラー)**

ハンドラキューでの処理中に例外が送出された場合、特段の例外制御は行なわず
発生した例外をそのまま送出する。

ただし、標準ハンドラ構成では、このハンドラの直後に [グローバルエラーハンドラ](../../component/handlers/handlers-GlobalErrorHandler.md) が配置されるため、
サーバプロセスの継続に影響するような特定の致命的エラーを除けば、ここで例外を捕捉することは無い。

### 設定項目・拡張ポイント

本クラスの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ハンドラキュー | handlerQueue | List<Handler> | 必須指定 |

**標準設定**

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

    <!-- 以下ハンドラ定義(略) -->

  </list>
  </property>
</component>
```
